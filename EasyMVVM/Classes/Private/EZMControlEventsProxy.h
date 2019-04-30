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

#import <EasyReact/EasyReact.h>
#import <EasyMVVM/UIControl+EZM_Extension.h>

@class EZMControlWithEvents, EZRNode;

NS_ASSUME_NONNULL_BEGIN

@interface EZMControlEventsProxy : NSObject

@property (nonatomic, strong, readonly) EZRNode<EZMControlWithEvents *> *node;

- (instancetype)initWithControlEvents:(UIControlEvents)events;

- (void)ezm_sendAction:(UIControl *)control;

@end

NS_ASSUME_NONNULL_END
