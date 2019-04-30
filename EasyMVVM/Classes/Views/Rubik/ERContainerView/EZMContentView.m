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

#import "EZMCell.h"
#import "EZMRubikViewLayout.h"
#import "EZMCellPattern.h"
#import "EZMCell+ProjectPrivate.h"
#import "EZMCubePresentationProxy.h"

NS_ASSUME_NONNULL_BEGIN

@interface EZMContentView : EZMCell <EZMCubePresentation>

@end

NS_ASSUME_NONNULL_END

@interface EZMContentView ()

#pragma mark - Presentation
@property (nonatomic, readwrite, strong) EZRMutableNode<NSArray<Class> *> *cellClasses;
@property (nonatomic, readwrite, strong) EZRMutableNode<UIView *> *headerViewNode;
@property (nonatomic, readwrite, strong) EZRMutableNode<UIView *> *footerViewNode;
@property (nonatomic, readwrite, strong) EZRMutableNode<NSNumber *> *contentHeight;
@property (nonatomic, readwrite, strong) EZRNode<EZMContainerChange *> *change;

@end

@implementation EZMContentView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _headerViewNode = [EZRMutableNode new];
        _footerViewNode = [EZRMutableNode new];
        _contentHeight = [EZRMutableNode value:@(0)];
        _change = [EZRNode new];
        
        _cellClasses = [EZRMutableNode value:@[[self class]]];
        self.clipsToBounds = YES;
    }
    return self;
}

- (id<EZMCubePresentation>)cubePresentation {
    return [[EZMCubePresentationProxy alloc] initWithCubePresentation:self];
}

#pragma mark - EZMCubePresentation

- (NSUInteger)numberOfItems {
    return 1;
}

- (CGRect)rubikView:(EZMRubikView *)rubikView frameForItemAtIndex:(NSUInteger)index {

    CGFloat headerHeight = !self.headerViewNode.isEmpty ? self.headerViewNode.value.bounds.size.height : 0.f;
    CGFloat footerHeight = !self.footerViewNode.isEmpty ? self.footerViewNode.value.bounds.size.height : 0.f;
    CGRect contentBounds = self.bounds;
    contentBounds.origin.y = headerHeight;
    CGFloat contentHeight = contentBounds.size.height;
    self.contentHeight.mutablify.value = @(headerHeight + contentHeight + footerHeight);
    return contentBounds;
}

- (Class)cellClassForItemAtIndex:(NSUInteger)index {
    return [self class];
}

- (void)bindingCell:(EZMCell *)cell atIndex:(NSUInteger)index {

}

- (EZMCell *)singletonCell {
    return self;
}

@end
