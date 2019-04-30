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

#import "EZMControlEventsProxy.h"

@implementation EZMControlEventsProxy {
    UIControlEvents _events;
}

- (instancetype)initWithControlEvents:(UIControlEvents)events {
    if (self = [super init]) {
        _events = events;
        _node = EZRNode.new;
    }
    return self;
}

- (void)ezm_sendAction:(UIControl *)control {
    EZMControlWithEvents *result = [[EZMControlWithEvents alloc] initWithControl:control events:_events];
    _node.mutablify.value = result;
}

@end
