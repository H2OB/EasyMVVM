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

NS_ASSUME_NONNULL_BEGIN

@class EZMEvent, EZMHandler;

@interface EZMBinder : NSObject <EZRCancelable>

- (instancetype)initWithAssociateObject:(nullable NSObject *)object NS_DESIGNATED_INITIALIZER;
+ (instancetype)binderWithAssociateObject:(nullable NSObject *)object;

- (id<EZRCancelable>)bindNode:(EZRNode *)nodeA toNode:(EZRNode *)nodeB;
- (id<EZRCancelable>)twoWayBindNode:(EZRNode *)nodeA toNode:(EZRNode *)nodeB;
- (id<EZRCancelable>)bindEvent:(EZMEvent *)event toHandler:(EZMHandler *)handler;

@end

NS_ASSUME_NONNULL_END
