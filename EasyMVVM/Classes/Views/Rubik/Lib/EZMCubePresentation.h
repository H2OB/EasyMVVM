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

@class EZMRubikView, EZMCell, EZMContainerChange, EZRMutableNode<T>, EZRNode<T>;

@protocol EZMCubePresentation <NSObject>

@property (nonatomic, readonly, strong) EZRNode<EZMContainerChange *> *change;

/**
 contentHeight = items + header + footer
 */
@property (nonatomic, readonly, strong) EZRMutableNode<NSNumber *> *contentHeight;
@property (nonatomic, readonly, strong) EZRMutableNode<UIView *> *headerViewNode;
@property (nonatomic, readonly, strong) EZRMutableNode<UIView *> *footerViewNode;
@property (nonatomic, readonly, strong) EZRMutableNode<NSArray<Class> *> *cellClasses;

- (NSUInteger)numberOfItems;

- (CGRect)rubikView:(EZMRubikView *)rubikView frameForItemAtIndex:(NSUInteger)index;
- (Class)cellClassForItemAtIndex:(NSUInteger)index;
- (void)bindingCell:(EZMCell *)cell atIndex:(NSUInteger)index;

@optional
- (EZMCell *)singletonCell;

@end
