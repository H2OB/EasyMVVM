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
#import <EasyMVVM/EZMContainer.h>

NS_ASSUME_NONNULL_BEGIN

typedef Class _Nullable(^ERListClassPattern)(id);
extern ERListClassPattern EZMListViewMatchAllWithClass(Class clazz);
@class EZMListCell, EZMHandler, EZMBinder;

@interface EZMListView<__covariant VM: id> : UIView

@property (nonatomic, readonly, strong) EZRMutableNode<EZMContainer<VM> *> *data;
@property (nonatomic, readonly, strong) EZMHandler *reloadHandler;

/**
 模式匹配和绑定，同UIKit其他方法一样，该方法为线程不安全方法，请在主线程使用。
 模式匹配方法的执行是有序的，排在前面的模式会先被进行模式匹配，如果匹配成功，后面的匹配就不会进行。

 @param patternBlock 模式匹配Block，返回Class表示匹配成功，返回nil表示失败，Class必须为EZMListCell的子类
 @param bindingBlock 模式匹配成功时，该block被调用，可以在该block中进行绑定
 */
- (void)cellPattern:(Class _Nullable(^)(VM viewModel))patternBlock binding:(void(^)(EZMBinder *binder, __kindof EZMListCell *cell, VM viewModel))bindingBlock;

@end

NS_ASSUME_NONNULL_END
