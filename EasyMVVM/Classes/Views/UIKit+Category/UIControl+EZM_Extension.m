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

#import "UIControl+EZM_Extension.h"
#import "EZMControlEventsProxy.h"
@import ObjectiveC.runtime;

@implementation EZMControlWithEvents

- (instancetype)initWithControl:(UIControl *)control events:(UIControlEvents)events {
    if (self = [super init]) {
        _control = control;
        _events = events;
    }
    return self;
}

@end

@interface UIControl (EZM_ExtensionPrivate)

@property (nonatomic, strong, readonly) NSMutableDictionary<NSNumber *, EZMControlEventsProxy *> *eventProxys;

@end

static void *EZMEventNodesKey = &EZMEventNodesKey;

@implementation UIControl (EZM_Extension)

- (NSMutableDictionary<NSNumber *, EZMControlEventsProxy *> *)eventProxys {
    NSMutableDictionary<NSNumber *, EZMControlEventsProxy *> *eventProxys = objc_getAssociatedObject(self, EZMEventNodesKey);
    if (!eventProxys) {
        @synchronized(self) {
            eventProxys = objc_getAssociatedObject(self, EZMEventNodesKey);
            if (!eventProxys) {
                eventProxys = [NSMutableDictionary dictionary];
                objc_setAssociatedObject(self, EZMEventNodesKey, eventProxys, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            }
        }
    }
    return eventProxys;
}

- (EZRNode<EZMControlWithEvents *> *)ezm_nodeForEvents:(UIControlEvents)events {
    EZRNode<EZMControlWithEvents *> *node = nil;
    
    @synchronized(self.eventProxys) {
        EZMControlEventsProxy *proxy = self.eventProxys[@(events)];
        if (!proxy) {
            proxy = [[EZMControlEventsProxy alloc] initWithControlEvents:events];
            self.eventProxys[@(events)] = proxy;
            [self addTarget:proxy action:@selector(ezm_sendAction:) forControlEvents:events];
        }
        node = proxy.node;
    }
    return node;
}

@end
