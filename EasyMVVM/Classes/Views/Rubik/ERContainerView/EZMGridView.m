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

#import "EZMGridView.h"
#import "EZMRubikViewLayout.h"
#import "EZMCellPattern.h"
#import "EZMCell+ProjectPrivate.h"
#import "EZMCubePresentationProxy.h"
#import "EZRNode+MainThread.h"

@interface EZMGridView () 

@property (nonatomic, strong) EZMCellPattern *cellPattern;


@property (nonatomic, readwrite, strong) UIView *reuseCalcView;
@property (nonatomic, readwrite, strong) NSMutableDictionary<NSString *, EZMCell *> *layoutCell;

#pragma mark - Presentation
@property (nonatomic, readwrite, strong) EZRMutableNode<UIView *> *headerViewNode;
@property (nonatomic, readwrite, strong) EZRMutableNode<UIView *> *footerViewNode;
@property (nonatomic, readwrite, strong) EZRMutableNode<NSNumber *> *contentHeight;
@property (nonatomic, readwrite, strong) EZRNode<EZMContainerChange *> *change;

@end

@implementation EZMGridView


- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _itemHeight = [EZRMutableNode value:@44.f];
        _column = [EZRMutableNode value:@5];
        _cellPattern = [[EZMCellPattern alloc] init];
        
        _headerViewNode = [EZRMutableNode new];
        _footerViewNode = [EZRMutableNode new];
        _contentHeight = [EZRMutableNode value:@0];
        
        _data = [EZRMutableNode new];
        @ezr_weakify(self)
        _reloadHandler = [[EZMHandler alloc] initWithBlock:^{
        }];
        
        _layoutCell = [NSMutableDictionary dictionary];
        
        _change = [EZRNode new];
        [[[_data flattenMap:^EZRNode * _Nullable(EZMContainer * _Nullable container) {
            return container.changes;
        }] listenedBy:self] withBlock:^(EZMContainerChange * _Nullable change) {
            @ezr_strongify(self)
            if (change == nil) {
                return;
            }
            self->_change.mutablify.value = change;
        }];
        
        [[[EZRNode merge:@[_column, _itemHeight]] listenedBy:self] withBlock:^(NSNumber * _Nullable col) {
            @ezr_strongify(self)
            //fixme: how to get layout object without KVO ?
            UICollectionViewLayout *layout = [[self valueForKeyPath:@"rubikView"] valueForKeyPath:@"layout"];
            if ([layout isKindOfClass:[UICollectionViewLayout class]]) {
                [layout invalidateLayout];
            }
        }];
    }
    return self;
}

- (void)cellClass:(Class)clazz
          pattern:(BOOL (^)(id _Nonnull))patternBlock
          binding:(void (^)(EZMBinder * _Nonnull, __kindof EZMCell * _Nonnull, id _Nonnull))bindingBlock {
    [self.cellPattern cellClass:clazz pattern:patternBlock binding:bindingBlock];
}

- (id)_dataAtIndex:(NSUInteger)index {
    EZMContainer *dataContainer = self.data.value;
    return dataContainer[index];
}

- (id<EZMCubePresentation>)cubePresentation {
    return [[EZMCubePresentationProxy alloc] initWithCubePresentation:self];
}

#pragma mark - EZMCubePresentation

- (NSUInteger)numberOfItems {
    if ([self.data isEmpty]) {
        return 0;
    }
    EZMContainer *container = self.data.value;
    return container.count.value.unsignedIntegerValue;
}

- (CGRect)rubikView:(EZMRubikView *)rubikView frameForItemAtIndex:(NSUInteger)index {
    NSUInteger row = index / _column.value.unsignedIntegerValue;
    NSUInteger col = index % _column.value.unsignedIntegerValue;
    CGFloat width = self.bounds.size.width / _column.value.unsignedIntegerValue;
    CGFloat height = self.itemHeight.value.floatValue;
    CGFloat x = col * width;
    CGFloat y = row * height;
    CGRect cellFrame = CGRectMake(x, y, width, height);

    CGFloat headerHeight = !self.headerViewNode.isEmpty ? self.headerViewNode.value.bounds.size.height : 0.f;
    CGFloat footerHeight = !self.footerViewNode.isEmpty ? self.footerViewNode.value.bounds.size.height : 0.f;
    
    if (index == [self numberOfItems] - 1) {
        CGFloat itemsTotalHeight = cellFrame.origin.y + cellFrame.size.height;
        self.contentHeight.value = @(headerHeight + itemsTotalHeight + footerHeight);
    }
    
    cellFrame.origin.y += headerHeight;
    return cellFrame;
}

- (Class)cellClassForItemAtIndex:(NSUInteger)index {
    id itemVM = [self _dataAtIndex:index];
    EZMCellPatternMetaData *metaData = [self.cellPattern metaDataForVM:itemVM];
    if (metaData.class == nil) {
        NSAssert(NO, @"must has cell Class");
        return [EZMCell class];
    }
    return metaData.cellClass;
}

- (void)bindingCell:(EZMCell *)cell atIndex:(NSUInteger)index {
    id itemVM = [self _dataAtIndex:index];
    EZMCellPatternMetaData *metaData = [self.cellPattern metaDataForVM:itemVM];
    metaData.bindingBlock(cell.binder, cell, itemVM);
}

- (EZRNode<NSArray<Class> *> *)cellClasses {
    return self.cellPattern.cellClasses;
}

@end
