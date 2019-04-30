/**
 * Beijing Sankuai Online Technology Co.,Ltd (Meituan)
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 **/

#import "EZMBinder.h"
#import "EZMEvent+ProjectPrivate.h"
#import "EZMHandler.h"
#import "NSObject+EZM_Placeholder.h"
#import "EZRNode+MainThread.h"
#import "NSObject+EZM_Placeholder.h"

@import ObjectiveC.runtime;

@implementation EZMBinder {
    EZRCancelableBag *_cancelBag;
}

- (instancetype)initWithAssociateObject:(nullable NSObject *)object {
    if (self = [super init]) {
        if (object) {
            objc_objectptr_t key = (__bridge objc_objectptr_t)(self);
            objc_setAssociatedObject(object, key, self, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        }
        _cancelBag = [EZRCancelableBag bag];
    }
    return self;
}

- (instancetype)init {
    if (self = [self initWithAssociateObject:nil]) {
    }
    return self;
}

+ (instancetype)binderWithAssociateObject:(nullable NSObject *)object {
    return [[self alloc] initWithAssociateObject:object];
}

- (id<EZRCancelable>)bindNode:(EZRNode *)nodeA toNode:(EZRNode *)nodeB {
    id<EZRCancelable> linkCancelabe = [nodeA linkTo:[nodeB keepMainThread]];
    EZRBlockCancelable *cancelable = [[EZRBlockCancelable alloc] initWithBlock:^{
        [nodeA ezm_placeholder];
        [linkCancelabe cancel];
    }];
    [_cancelBag addCancelable:cancelable];
    @ezr_weakify(self)
    return [[EZRBlockCancelable alloc] initWithBlock:^{
        @ezr_strongify(self)
        if (self) {
            [cancelable cancel];
            [self->_cancelBag removeCancelable:cancelable];
        }
    }];
}

- (id<EZRCancelable>)twoWayBindNode:(EZRNode *)nodeA toNode:(EZRNode *)nodeB {
    EZRNode *keepMainThreadNode = [nodeB keepMainThread];
    [nodeB linkTo:keepMainThreadNode];
    
    id<EZRCancelable> linkCancelabe = [nodeA syncWith:keepMainThreadNode];
    
    @ezr_weakify(keepMainThreadNode, nodeB)
    EZRBlockCancelable *cancelable = [[EZRBlockCancelable alloc] initWithBlock:^{
        @ezr_strongify(keepMainThreadNode, nodeB);
        [EZS_Sequence([keepMainThreadNode upstreamTransformsFromNode:nodeB]) forEach:^(id<EZRTransformEdge>  _Nonnull upstreamTransform) {
            upstreamTransform.from = nil;
            upstreamTransform.to = nil;
        }];
        
        [nodeA ezm_placeholder];
        [linkCancelabe cancel];
    }];
    [_cancelBag addCancelable:cancelable];
    @ezr_weakify(self)
    return [[EZRBlockCancelable alloc] initWithBlock:^{
        @ezr_strongify(self)
        if (self) {
            [cancelable cancel];
            [self->_cancelBag removeCancelable:cancelable];
        }
    }];
}
- (id<EZRCancelable>)bindEvent:(EZMEvent *)event toHandler:(EZMHandler *)handler {
    id<EZRCancelable> linkCancelabe = [event bindHandler:handler];
    EZRBlockCancelable *cancelable = [[EZRBlockCancelable alloc] initWithBlock:^{
        [event ezm_placeholder];
        [handler ezm_placeholder];
        [linkCancelabe cancel];
    }];
    [_cancelBag addCancelable:cancelable];
    @ezr_weakify(self)
    return [[EZRBlockCancelable alloc] initWithBlock:^{
        @ezr_strongify(self)
        if (self) {
            [cancelable cancel];
            [self->_cancelBag removeCancelable:cancelable];
        }
    }];
}

- (void)cancel {
    [_cancelBag cancel];
}

- (void)dealloc {
    [_cancelBag cancel];
}

@end
