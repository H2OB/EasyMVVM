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

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class EZMListCell, EZMHandler, EZMBinder, EZMTableViewHeaderFooterView;
@class EZRNode<__covariant T: id>, EZMContainer<__covariant T: id>,EZTuple3<T, U, F> ;

typedef Class _Nullable(^ERTableCellClassPattern)(id, id);
typedef EZMContainer * _Nullable(^ERSectionDataPattern)(id);
extern ERTableCellClassPattern ERCellMatchAllWithClass(Class clazz);
extern ERSectionDataPattern ERSectionMatchAllWithProperty(NSString *propertyName);

@interface ERSectionPattern<__covariant SectionVM: id, __covariant CellVM: id> : NSObject

/**
 模式匹配和绑定，同UIKit其他方法一样，该方法为线程不安全方法，请在主线程使用。
 模式匹配方法的执行是有序的，排在前面的模式会先被进行模式匹配，如果匹配成功，后面的匹配就不会进行。
 @param cellPatternBlock 模式匹配Block，返回Class表示匹配成功，返回nil表示失败，Class必须为EZMListCell的子类
 @param cellBindingBlock 模式匹配成功时，该block被调用
 */
- (void)cellPattern:(Class _Nullable(^)(CellVM cellViewModel, SectionVM sectionVM))cellPatternBlock
            binding:(void(^)(EZMBinder *binder, __kindof EZMListCell *cell, CellVM cellViewModel, SectionVM sectionVM))cellBindingBlock;

@end


@interface EZMTableView<__covariant SectionVM: id, __covariant CellVM: id> : UITableView

@property (nonatomic, readonly, strong) EZRNode<EZMContainer<SectionVM> *> *data;
@property (nonatomic, readonly, strong) EZMHandler *reloadHandler;

/**
 section匹配和header/footer绑定
 */
- (ERSectionPattern<SectionVM, CellVM> *)sectionPattern:(EZTuple3<EZMContainer<CellVM> *, Class, Class> * (^)(SectionVM sectionVM))sectionPatternBlock
                                          headerBinding:(void (^ _Nullable)(EZMBinder *binder, SectionVM sectionVM, __kindof EZMTableViewHeaderFooterView * _Nullable headerView))headerBindingBlock
                                          footerBinding:(void (^ _Nullable)(EZMBinder *binder, SectionVM sectionVM, __kindof EZMTableViewHeaderFooterView * _Nullable footerView))footerBindingBlock;

/**
 没有header/footer时调用此方法
 */
- (ERSectionPattern<SectionVM, CellVM> *)sectionPattern:(EZMContainer<CellVM> * (^)(SectionVM sectionVM))patternBlock;

@end

NS_ASSUME_NONNULL_END

