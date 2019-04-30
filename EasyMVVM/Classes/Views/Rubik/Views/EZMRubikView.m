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

#import "EZMRubikView.h"
#import "EZMRubikViewLayout.h"
#import "EZMCubePresentation.h"
#import "EZMCollectionViewCell.h"
#import "EZMContainer.h"
#import "EZMCell+ProjectPrivate.h"
#import "EZMBinder.h"
#import "EZMCollectionReusableView.h"
#import "UICollectionView+EZMContainerChange.h"

@interface EZMRubikView () <UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, weak) IBOutlet UICollectionView *collectionView;
@property (nonatomic, weak) IBOutlet NSArray<UIView *> *otherViews; //TODO
@property (nonatomic, strong) EZMRubikViewLayout *layout;

@property (nonatomic, strong) NSMutableDictionary<NSNumber *, EZMCollectionReusableView *> *headerShells;
@property (nonatomic, strong) NSMutableDictionary<NSNumber *, EZMCollectionReusableView *> *footerShells;

@end

@implementation EZMRubikView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        _cubePresentations = [EZRMutableNode new];
        _cubePresentations.value = [[EZMContainer alloc] initWithArray:@[]];
        _layout = [[EZMRubikViewLayout alloc] initWithRubikView:self];
        
        _headerShells = [NSMutableDictionary dictionary];
        _footerShells = [NSMutableDictionary dictionary];

        super.backgroundColor = [UIColor clearColor];
        CGRect collectionViewRect = frame;
        collectionViewRect.origin = CGPointZero;
        UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:collectionViewRect collectionViewLayout:_layout];
        collectionView.backgroundColor = [UIColor clearColor];
        collectionView.alwaysBounceVertical = YES;
        collectionView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        collectionView.dataSource = self;
        collectionView.delegate = self;
        _collectionView = collectionView;
        collectionView.backgroundView = nil;
        [self addSubview:collectionView];
        
        [self.collectionView registerClass:[EZMCollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:UICollectionElementKindSectionHeader];
        [self.collectionView registerClass:[EZMCollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:UICollectionElementKindSectionFooter];

#warning Merge无法满足需求 多层listen  暂时有内存泄露问题
        @ezr_weakify(self)
        [[[[_cubePresentations flattenMap:^EZRNode * _Nullable(EZMContainer<id<EZMCubePresentation>> * _Nullable next) {
            return [EZRNode merge:@[[EZRNode value:nil], next.changes]];
        }] map:^id _Nullable(id  _Nullable next) {
            @ezr_strongify(self)
            return self->_cubePresentations.value;
        }] listenedBy:self] withBlock:^(EZMContainer<id<EZMCubePresentation>> * _Nullable next) {
            @ezr_strongify(self)
            NSArray<EZRNode<NSArray<Class> *> *> *array = [[EZS_Sequence(next.array) map:^id _Nonnull(id<EZMCubePresentation>  _Nonnull value) {
                return value.cellClasses;
            }] as:NSArray.class];
            [EZS_Sequence(array) forEach:^(EZRNode<NSArray<Class> *> * _Nonnull value) {
                
                [[value listenedBy:self] withBlock:^(NSArray<Class> * _Nullable cellClasses) {
                    @ezr_strongify(self)
                    [EZS_Sequence(cellClasses) forEach:^(Class  _Nonnull clazz) {
                        [self.collectionView registerClass:[EZMCollectionViewCell class] forCellWithReuseIdentifier:NSStringFromClass(clazz)];
                    }];
                }];
            }];
            
            // item changes
            NSArray<EZRNode<EZMContainerChange *> *> *changes = [[EZS_Sequence(next.array) map:^id _Nonnull(id<EZMCubePresentation>  _Nonnull value) {
                //NSLog(@"presentation: %@, change: %@", value, value.change);
                return value.change;
            }] as:NSArray.class];
            [EZS_Sequence(changes) forEachWithIndex:^(EZRNode<EZMContainerChange *> * _Nonnull value, NSUInteger index) {
                [[value listenedBy:self] withBlock:^(EZMContainerChange * _Nullable next) {
                    @ezr_strongify(self)
                    [self.collectionView reloadWithChange:next section:index completion:^(BOOL finished) { }];
                }];
            }];
            
            // header / footer changes
            [EZS_Sequence(next.array) forEachWithIndex:^(id<EZMCubePresentation>  _Nonnull value, NSUInteger index) {
                [[value.headerViewNode listenedBy:self] withBlock:^(UIView * _Nullable next) {
                    @ezr_strongify(self)
                    [self.layout invalidateLayout];
                    EZMCollectionReusableView *shellView = [self.headerShells objectForKey:@(index)];
                    [shellView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
                    [shellView addSubview:next];
                }];
                [[value.footerViewNode listenedBy:self] withBlock:^(UIView * _Nullable next) {
                    @ezr_strongify(self)
                    [self.layout invalidateLayout];
                    EZMCollectionReusableView *shellView = [self.footerShells objectForKey:@(index)];
                    [shellView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
                    [shellView addSubview:next];
                }];
            }];

            [self.collectionView reloadData];
        }];
        
    }
    return self;
}

#pragma mark - collection view data source

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    if ([self.cubePresentations isEmpty]) {
        return 0;
    }
    return self.cubePresentations.value.count.value.unsignedIntegerValue;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    id<EZMCubePresentation> presentation = self.cubePresentations.value[section];
    return [presentation numberOfItems];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    id<EZMCubePresentation> presentation = self.cubePresentations.value[indexPath.section];
    Class cellClass = [presentation cellClassForItemAtIndex:indexPath.row];
    EZMCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass(cellClass) forIndexPath:indexPath];
    cell.clipsToBounds = YES;
    EZMCell *erCell = cell.contentCell;
    if (![(EZMCollectionViewCell *)cell hasContent]) {
        if ([presentation respondsToSelector:@selector(singletonCell)]) {
            erCell = [presentation singletonCell];
        } else {
            erCell = [[cellClass alloc] initWithFrame:cell.bounds];
        }
        [cell setContentCell:erCell];
    }
    [erCell.binder cancel];
    [presentation bindingCell:erCell atIndex:indexPath.row];
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    id<EZMCubePresentation> presentation = self.cubePresentations.value[indexPath.section];
    EZMCollectionReusableView *headerFooterView  = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:kind forIndexPath:indexPath];
    [headerFooterView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        [self.headerShells setObject:headerFooterView forKey:@(indexPath.section)];
        if (!presentation.headerViewNode.isEmpty) {
            [headerFooterView addSubview:presentation.headerViewNode.value];
        }
    } else if ([kind isEqualToString:UICollectionElementKindSectionFooter]) {
        [self.footerShells setObject:headerFooterView forKey:@(indexPath.section)];
        if (!presentation.footerViewNode.isEmpty) {
            [headerFooterView addSubview:presentation.footerViewNode.value];
        }
    }
    return headerFooterView;
}

#pragma mark - collection view delegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
}

- (void)registerCellClass:(Class)clazz {
    [self.collectionView registerClass:[EZMCollectionViewCell class] forCellWithReuseIdentifier:NSStringFromClass(clazz)];
}

- (void)dealloc {
    NSLog(@"%s", __FUNCTION__);
}

@end
