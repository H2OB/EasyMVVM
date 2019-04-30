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

#import "EZMContainerChange.h"
#import "EZMacrosPrivate.h"
#import <EasyReact/EasyReact.h>

@implementation EZMContainerChange

- (instancetype)initWithState:(EZMContainerChangeState)state {
    if (self = [super init]) {
        _state = state;
    }
    return self;
}

- (BOOL)isEqual:(EZMContainerChange *)object {
    return self.state == object.state;
}

- (NSString *)debugDescription {
    switch (self.state) {
        case EZMContainerChangeStateTransaction:
            return @"事务";
            break;
        case EZMContainerChangeStateFlush:
            return @"刷新";
            break;
        case EZMContainerChangeStateInsert:
            return @"插入";
            break;
        case EZMContainerChangeStateUpdate:
            return @"更新";
            break;
        case EZMContainerChangeStateDelete:
            return @"删除";
            break;
        case EZMContainerChangeStateMove:
            return @"移动";
            break;
            
        default:
            return @"异常";
            break;
    }
}

@end

@implementation EZMContainerIndexedChange

- (instancetype)initWithState:(EZMContainerChangeState)state atIndex:(NSUInteger)index {
    if (self = [super initWithState:state]) {
        _index = index;

    }
    return self;
}

- (BOOL)isEqual:(EZMContainerIndexedChange *)object {
    return [self state] == [object state] && self.index == object.index;
}

- (NSString *)debugDescription {
    return [NSString stringWithFormat:@"在%@位置上进行了%@操作",@(self.index), [super description]];
}

@end


@implementation EZMContainerTransactionChange

- (instancetype)initWithChanges:(NSArray<EZMContainerIndexedChange *> *)changes {
    if (self = [super initWithState:EZMContainerChangeStateTransaction]) {
        _changes = [changes copy];
    }
    return self;
}

+ (instancetype)transactionChangeWithChanges:(NSArray *)changes  {
    return [[self alloc] initWithChanges:changes];
}


- (BOOL)isEqual:(EZMContainerTransactionChange *)object {
    return self.state == object.state && [self.changes isEqualToArray:object.changes];
}

- (NSString *)description {
    NSMutableString *result = [super debugDescription].mutableCopy;
    [result insertString:@"在" atIndex:0];
    [result appendString:@"中进行了如下操做: { \n"];
    [result appendString:[[[EZS_Sequence(self.changes) map:^id _Nonnull(EZMContainerIndexedChange * _Nonnull value) {
        return value.description;
    }] as:NSArray.class] componentsJoinedByString:@", \n"]];
    [result appendString:@"\n }"];
    return result;
}

@end

@implementation EZMContainerFlushChange

+ (instancetype)flushChange {
    return [[self alloc] initWithState:EZMContainerChangeStateFlush];
}

- (BOOL)isEqual:(EZMContainerFlushChange *)object {
    return [self state] == [object state];
}

@end

@implementation EZMContainerMoveChange

- (instancetype)initWithSource:(NSUInteger)source toDestnation:(NSUInteger)destnation {
    if (self = [super initWithState:EZMContainerChangeStateMove]) {
        _source = source;
        _destnation = destnation;
    }
    return self;
}

+ (instancetype)changeFromSource:(NSUInteger)source toDestnation:(NSUInteger)destnation {
    return [[self alloc] initWithSource:source toDestnation:destnation];
}

- (BOOL)isEqual:(EZMContainerMoveChange *)object {
    return [self state] == [object state] && self.source == object.source && self.destnation == object.destnation;
}

- (NSString *)debugDescription {
    return [NSString stringWithFormat:@"从%@位置上%@到了%@", @(self.source), [super description], @(self.destnation)];
}

@end

