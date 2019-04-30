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

#import "EZMCubePresentationProxy.h"

@implementation EZMCubePresentationProxy {
    __weak id<EZMCubePresentation> _presentation;
}

- (instancetype)initWithCubePresentation:(id<EZMCubePresentation>)presentation {
    _presentation = presentation;
    return self;
}

- (void)bindingCell:(EZMCell *)cell atIndex:(NSUInteger)index {
    [_presentation bindingCell:cell atIndex:index];
}

- (Class)cellClassForItemAtIndex:(NSUInteger)index {
    return [_presentation cellClassForItemAtIndex:index];
}

- (NSUInteger)numberOfItems {
    return [_presentation numberOfItems];
}

- (CGRect)rubikView:(EZMRubikView *)rubikView frameForItemAtIndex:(NSUInteger)index {
    return [_presentation rubikView:rubikView frameForItemAtIndex:index];
}

- (EZRNode<EZMContainerChange *> *)change {
    return _presentation.change;
}

- (EZRMutableNode<NSNumber *> *)contentHeight {
    return _presentation.contentHeight;
}

- (EZRMutableNode<UIView *> *)headerViewNode {
    return _presentation.headerViewNode;
}

- (EZRMutableNode<UIView *> *)footerViewNode {
    return _presentation.footerViewNode;
}

- (EZRMutableNode<NSArray<Class> *> *)cellClasses {
    return _presentation.cellClasses;
}

- (BOOL)respondsToSelector:(SEL)aSelector {
    return [_presentation respondsToSelector:aSelector];
}

@end
