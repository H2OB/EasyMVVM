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

#import <Foundation/Foundation.h>

#define EZM_MODEL(_clazz_) (_clazz_ *)[EZModelCenter defaultCenter][[_clazz_ class]]

@class EZModel;
@interface EZModelCenter : NSObject

+ (instancetype)defaultCenter;

/**
 使用下标获取Model
 
 @param clazz Model 的类
 @return 该类唯一实例，如果 Center 中不存在实例，则会自动创建一个
 */
- (__kindof EZModel *)objectForKeyedSubscript:(Class)clazz;

- (void)removeModelForClass:(Class)clazz;

@end
