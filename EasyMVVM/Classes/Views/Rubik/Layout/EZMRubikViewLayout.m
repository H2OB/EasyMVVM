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

#import "EZMRubikViewLayout.h"
#import "EZMContentView.h"
#import "EZMListView.h"
#import "EZMGridView.h"
#import "EZMRubikView.h"
#import <EasySequence/EasySequence.h>

@interface EZMRubikViewLayout () {
    CGFloat _contentViewHeight;
}

@property (nonatomic, weak) EZMRubikView *rubikView;
@property (nonatomic, strong) NSMutableDictionary<NSIndexPath *, UICollectionViewLayoutAttributes *> *itemAttributes;
@property (nonatomic, strong) NSMutableDictionary<NSIndexPath *, UICollectionViewLayoutAttributes *> *headerAttributes;
@property (nonatomic, strong) NSMutableDictionary<NSIndexPath *, UICollectionViewLayoutAttributes *> *footerAttributes;

@end

@implementation EZMRubikViewLayout

- (instancetype)initWithRubikView:(EZMRubikView *)rubikView {
    if (self = [super init]) {
        _rubikView = rubikView;
        
        _itemAttributes = [[NSMutableDictionary alloc] init];
        _headerAttributes = [[NSMutableDictionary alloc] init];
        _footerAttributes = [[NSMutableDictionary alloc] init];
        
        _contentViewHeight = 0;
        
        //TODO: listen presentations
        [[rubikView.cubePresentations listenedBy:self] withBlock:^(EZMContainer<id<EZMCubePresentation>> * _Nullable container) {
            
        }];
    }
    return self;
}

- (void)prepareLayout {
    [super prepareLayout];
    
    // cleanup
    _contentViewHeight = 0;
    [self.itemAttributes removeAllObjects];
    [self.footerAttributes removeAllObjects];
    [self.headerAttributes removeAllObjects];

    CGFloat collectionViewWidth = self.collectionView.frame.size.width;
    __block CGFloat height = 0.f;
    [EZS_Sequence(self.rubikView.cubePresentations.value.array) forEachWithIndex:^(id<EZMCubePresentation>  _Nonnull presentation, NSUInteger sectionIndex) {
        NSIndexPath *supplementaryViewIndexPath = [NSIndexPath indexPathForRow:0 inSection:sectionIndex];
        // 1 计算 headView attribute
        CGFloat headerHeight = 0;
        if (!presentation.headerViewNode.isEmpty) {
            headerHeight = presentation.headerViewNode.value.frame.size.height;
        }
        if (headerHeight > 0) {
            UICollectionViewLayoutAttributes *attribute = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionHeader
                                                                                                                         withIndexPath:supplementaryViewIndexPath];
            attribute.frame = CGRectMake(0, height, collectionViewWidth, headerHeight);
            self.headerAttributes[supplementaryViewIndexPath] = attribute;
        }
        
        // 2 计算 item attribute
        for (int row = 0; row < [presentation numberOfItems]; ++row) {
            NSIndexPath *cellIndexPath = [NSIndexPath indexPathForItem:row inSection:sectionIndex];
            UICollectionViewLayoutAttributes *attribute = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:cellIndexPath];
            CGRect itemFrame = [presentation rubikView:self.rubikView frameForItemAtIndex:row];
            itemFrame.origin.y += height;
            attribute.frame = itemFrame;
            self.itemAttributes[cellIndexPath] = attribute;
        }
        // 3 计算 footer attribute
        CGFloat footerHeight = 0;
    
        if (!presentation.footerViewNode.isEmpty) {
            footerHeight = presentation.footerViewNode.value.frame.size.height;
        }
        if (footerHeight > 0) {
            UICollectionViewLayoutAttributes *attribute = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionFooter
                                                                                                                         withIndexPath:supplementaryViewIndexPath];
            attribute.frame = CGRectMake(0, height + presentation.contentHeight.value.floatValue - footerHeight, collectionViewWidth, footerHeight);
            self.footerAttributes[supplementaryViewIndexPath] = attribute;
        }
        height += presentation.contentHeight.value.floatValue;
    }];
    _contentViewHeight = height;
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
    CGRect oldBounds = self.collectionView.bounds;
    if (!CGSizeEqualToSize(oldBounds.size, newBounds.size)) {
        return YES;
    }
    return NO;
}

- (nullable NSArray<__kindof UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
    NSMutableArray *allAttributes = [NSMutableArray array];
    //添加当前屏幕可见的cell的布局
    [allAttributes addObjectsFromArray:[[EZS_Sequence(self.itemAttributes.allValues) select:^BOOL(UICollectionViewLayoutAttributes * _Nonnull attributes) {
        return CGRectIntersectsRect(rect, attributes.frame);
    }] as:NSArray.class]];
    
    //添加当前屏幕可见的头视图的布局
    [allAttributes addObjectsFromArray:[[EZS_Sequence(self.headerAttributes.allValues) select:^BOOL(UICollectionViewLayoutAttributes * _Nonnull attributes) {
        return CGRectIntersectsRect(rect, attributes.frame);
    }] as:NSArray.class]];

    //添加当前屏幕可见的尾部的布局
    [allAttributes addObjectsFromArray:[[EZS_Sequence(self.footerAttributes.allValues) select:^BOOL(UICollectionViewLayoutAttributes * _Nonnull attributes) {
        return CGRectIntersectsRect(rect, attributes.frame);
    }] as:NSArray.class]];
    return allAttributes;
}

#pragma mark -

- (nullable UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewLayoutAttributes *attribute = self.itemAttributes[indexPath];
    return attribute;
}

- (nullable UICollectionViewLayoutAttributes *)layoutAttributesForSupplementaryViewOfKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)indexPath {
        UICollectionViewLayoutAttributes *attribute = nil;
        if ([elementKind isEqualToString:UICollectionElementKindSectionHeader]) {
            attribute = self.headerAttributes[indexPath];
        } else if ([elementKind isEqualToString:UICollectionElementKindSectionFooter]){
            attribute = self.footerAttributes[indexPath];
        }
    return attribute;
}

- (CGSize)collectionViewContentSize {
    return CGSizeMake(self.collectionView.bounds.size.width, _contentViewHeight);
}

#pragma mark - updates

- (void)prepareForCollectionViewUpdates:(NSArray<UICollectionViewUpdateItem *> *)updateItems {
    [super prepareForCollectionViewUpdates:updateItems];
    [self prepareLayout];
}

@end
