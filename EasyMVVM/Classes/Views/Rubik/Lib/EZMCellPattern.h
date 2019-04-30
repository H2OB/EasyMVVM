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

NS_ASSUME_NONNULL_BEGIN

typedef BOOL (^EZMCellPatternBlock)(id);
extern EZMCellPatternBlock EZMCellMatchAllData;

@class EZMCell, EZMBinder, EZRNode<T>;

@interface EZMCellPatternMetaData<__contravariant VM: id> : NSObject

@property (nonatomic, strong) Class cellClass;
@property (nonatomic, strong) EZMCellPatternBlock patternBlock;
@property (nonatomic, strong) void (^bindingBlock)(EZMBinder *binder, __kindof EZMCell *cell, VM viewModel);

@end

@interface EZMCellPattern<__contravariant VM: id> : NSObject

@property (nonatomic, readonly, strong) EZRNode<NSArray<Class> *> *cellClasses;

/**
 模式匹配和绑定，同UIKit其他方法一样，该方法为线程不安全方法，请在主线程使用。
 模式匹配方法的执行是有序的，排在前面的模式会先被进行模式匹配，如果匹配成功，后面的匹配就不会进行。
 
 @param clazz 模式匹配的CellClass，必须为EZMCell的子类
 @param patternBlock 模式匹配Block，返回YES表示匹配成功，返回NO表示失败
 @param bindingBlock 模式匹配成功时，该block被调用，可以在该block中进行绑定，EZMCell为第一个参数clazz的实例
 */
- (void)cellClass:(Class)clazz pattern:(BOOL (^)(VM viewModel))patternBlock binding:(void(^)(EZMBinder *binder, __kindof EZMCell *cell, VM viewModel))bindingBlock;

- (EZMCellPatternMetaData<VM> *)metaDataForVM:(VM)viewModel;

@end

NS_ASSUME_NONNULL_END
