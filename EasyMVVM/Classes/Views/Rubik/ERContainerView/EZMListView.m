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

#import "EZMListView.h"
#import <EasyTuple/EasyTuple.h>
#import "EZMCubePresentationProxy.h"
#import "EZMRubikViewLayout.h"
#import "EZMCellPattern.h"
#import "EZMCell+ProjectPrivate.h"
#import "EZMRubikView.h"
#import "EZMContainerChange.h"
#import "EZRNode+MainThread.h"

@interface EZMListView ()
{
    CGFloat _lastHeaderViewHeight;
    CGFloat _lastFooterViewHeight;
}

@property (nonatomic, strong) EZMCellPattern *cellPattern;


@property (nonatomic, readwrite, strong) UIView *reuseCalcView;
@property (nonatomic, readwrite, strong) NSMutableDictionary<NSString *, EZMCell *> *layoutCell;
@property (nonatomic, readwrite, strong) NSMutableDictionary<NSNumber *, NSValue *> *frameCache;

#pragma mark - Presentation
@property (nonatomic, readwrite, strong) EZRMutableNode<UIView *> *headerViewNode;
@property (nonatomic, readwrite, strong) EZRMutableNode<UIView *> *footerViewNode;
@property (nonatomic, readwrite, strong) EZRMutableNode<NSNumber *> *contentHeight;
@property (nonatomic, readwrite, strong) EZRNode<EZMContainerChange *> *change;

@end

@implementation EZMListView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _cellPattern = [[EZMCellPattern alloc] init];
        
        _headerViewNode = [EZRMutableNode new];
        _footerViewNode = [EZRMutableNode new];
        _contentHeight = [EZRMutableNode value:@0];

        _lastHeaderViewHeight = 0.f;
        _lastFooterViewHeight = 0.f;

        _data = [EZRMutableNode new];
        
        @ezr_weakify(self)
        _reloadHandler = [[EZMHandler alloc] initWithBlock:^{
            @ezr_strongify(self)
            // TODO: layout
            [self.frameCache removeAllObjects];
            self->_lastHeaderViewHeight = 0.f;
            self->_lastFooterViewHeight = 0.f;
        }];
        
        // update frame cache once headerView changed
        [[_headerViewNode listenedBy:self] withBlock:^(UIView * _Nullable headerView) {
            @ezr_strongify(self)
            CGFloat currentHeight = headerView.bounds.size.height;
            CGFloat offset = currentHeight - self->_lastHeaderViewHeight;
            for (int i = 0; i < self->_frameCache.allKeys.count; i++) {
                NSNumber *key = [self->_frameCache.allKeys objectAtIndex:i];
                NSValue *value = [self->_frameCache objectForKey:key];
                CGRect rect = value.CGRectValue;
                rect.origin.y += offset;
                [self->_frameCache setObject:[NSValue valueWithCGRect:rect] forKey:key];
            }
            self->_lastHeaderViewHeight = currentHeight;
        }];
        
        [[_footerViewNode listenedBy:self] withBlock:^(UIView * _Nullable footerView) {
            @ezr_strongify(self)
            self->_lastFooterViewHeight = footerView.bounds.size.height;
        }];

        _reuseCalcView = [[UIView alloc] initWithFrame:CGRectZero];
        _layoutCell = [NSMutableDictionary dictionary];
        _frameCache = [NSMutableDictionary dictionary];

        _change = [EZRNode new];

        [[[_data flattenMap:^EZRNode * _Nullable(EZMContainer * _Nullable container) {
            return container.changes;
        }] listenedBy:self] withBlock:^(__kindof EZMContainerChange * _Nullable change) {
            @ezr_strongify(self)
            if (change == nil) {
                return;
            }
            
            // invalidate self.frameCache by change
            if (change.state == EZMContainerChangeStateDelete
                || change.state == EZMContainerChangeStateInsert
                || change.state == EZMContainerChangeStateUpdate) {
                EZMContainerIndexedChange *c = change;
                [self.frameCache removeObjectForKey:@(c.index)];
                for (NSUInteger i = c.index+1; i < [self numberOfItems]; i++) {
                    [self.frameCache removeObjectForKey:@(i)];
                }
            } else if (change.state == EZMContainerChangeStateMove) {
                EZMContainerMoveChange *c = change;
                NSUInteger beginIndex = c.source > c.destnation? c.destnation : c.source;
                [self.frameCache removeObjectForKey:@(beginIndex)];
                for (NSUInteger i = beginIndex+1; i < [self numberOfItems]; i++) {
                    [self.frameCache removeObjectForKey:@(i)];
                }
            } else if (change.state == EZMContainerChangeStateFlush) {
                [self.frameCache removeAllObjects];
            } else if (change.state == EZMContainerChangeStateTransaction) {
                __block NSUInteger beginIndex = [self numberOfItems] - 1;
                [[(EZMContainerTransactionChange *)change changes] enumerateObjectsUsingBlock:^(__kindof EZMContainerChange * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    NSUInteger index = 0;
                    if ([obj isKindOfClass:[EZMContainerIndexedChange class]]) {
                        index = [(EZMContainerIndexedChange*)obj index];
                        if (index < beginIndex) {
                            beginIndex = index;
                        }
                    } else if ([obj isKindOfClass:[EZMContainerMoveChange class]]) {
                        EZMContainerMoveChange *c = obj;
                        index = c.source > c.destnation? c.destnation : c.source;
                        if (index < beginIndex) {
                            beginIndex = index;
                        }
                    }
                }];
                for (NSUInteger i = beginIndex; i < [self numberOfItems]; i++) {
                    [self.frameCache removeObjectForKey:@(i)];
                }
            }
            self->_change.mutablify.value = change;
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

- (EZMCell *)reuseHeightCaleCellWithClass:(Class)clazz {
    NSString *className = NSStringFromClass(clazz);
    EZMCell *cell = self.layoutCell[className];
    if (!cell) {
        cell = [[clazz alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, 44)];
        self.layoutCell[className] = cell;
    }
    return cell;
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

    NSValue *cachedValue = [self.frameCache objectForKey:@(index)];
    if (cachedValue) {
        return cachedValue.CGRectValue;
    } else {
        id itemVM = [self _dataAtIndex:index];
        EZMCellPatternMetaData *metaData = [self.cellPattern metaDataForVM:itemVM];
        EZMCell *cell = [self reuseHeightCaleCellWithClass:metaData.cellClass];
        [self.reuseCalcView addSubview:cell];
        if (metaData.bindingBlock) {
            metaData.bindingBlock(cell.binder, cell, itemVM);
        }
        [cell layoutIfNeeded];
        [cell.binder cancel];
        [cell removeFromSuperview];
        CGRect frame = cell.bounds;
        
        if (index == 0) {

            frame.origin.y = _lastHeaderViewHeight;
        } else {
            CGRect prevFrame = [self rubikView:rubikView frameForItemAtIndex:index-1];
            frame.origin.y = prevFrame.origin.y + prevFrame.size.height;
        }
        [self.frameCache setObject:[NSValue valueWithCGRect:frame] forKey:@(index)];
        return frame;
    }
}

- (EZRNode<NSNumber *> *)contentHeight {


    if ([self numberOfItems] == 0) {

        _contentHeight.value = @(_lastHeaderViewHeight + _lastFooterViewHeight);
    } else {
        CGRect lastItemFrame = [self rubikView:nil frameForItemAtIndex:([self numberOfItems] - 1)];

        _contentHeight.value = @(lastItemFrame.origin.y + lastItemFrame.size.height + _lastFooterViewHeight);
    }
    return _contentHeight;
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
