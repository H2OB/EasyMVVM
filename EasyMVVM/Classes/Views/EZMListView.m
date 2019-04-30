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
#import <objc/runtime.h>
#import "EZMListCell+ProjectPrivate.h"
#import "EZMHandler.h"
#import "EZMEvent+ProjectPrivate.h"
#import "NSObject+EZMHandler.h"
#import "EZRNode+Event.h"
#import "EZMContainer.h"
#import "EZMContainerChange.h"
#import "EZMBinder.h"
#import "EZRNode+MainThread.h"

typedef Class (^ERERCellPatternBlock)(id);
typedef void (^ERCellBindingBlock)(EZMBinder *, __kindof EZMListCell *, id);
typedef EZTuple2<ERERCellPatternBlock, ERCellBindingBlock> ERCellPattern;

typedef Class (^EZMListCellClassPattern)(id);
EZMListCellClassPattern EZMListViewMatchAllWithClass(Class clazz) {
    return ^Class(id _) {
        return clazz;
    };
}

@interface EZMListView<__covariant VM: id> : UITableView

@property (nonatomic, readonly, strong) EZRNode<EZMContainer<VM> *> *data;
@property (nonatomic, readonly, strong) EZMHandler *reloadHandler;

@end

typedef void (^ERReactListDataChangeBlockType)(EZMContainerChange * _Nullable next);
static ERReactListDataChangeBlockType reactListDataChange(EZMListView *self) {
    @ezr_weakify(self)
    return ^(EZMContainerChange * _Nullable change) {
        @ezr_strongify(self)
        if (change == nil) {
            return ;
        }
        switch (change.state) {
            case EZMContainerChangeStateTransaction:
            {
                EZMContainerTransactionChange *transactionChange = (EZMContainerTransactionChange *)change;
                NSCAssert([transactionChange isKindOfClass:[EZMContainerTransactionChange class]], @"类型不匹配");
                [self beginUpdates];
                
                NSDictionary<NSNumber *, NSArray<EZMContainerIndexedChange *> *> *changesGroup = [transactionChange.changes.EZS_asSequence groupBy:^id<NSCopying> _Nonnull(EZMContainerIndexedChange * _Nonnull indexedChange) {
                    return @(indexedChange.state);
                }];
                
                [changesGroup enumerateKeysAndObjectsUsingBlock:^(NSNumber * _Nonnull key, NSArray<EZMContainerIndexedChange *> * _Nonnull obj, BOOL * _Nonnull stop) {
                    
                    NSArray<NSIndexPath *> *indexPaths = [[obj.EZS_asSequence map:^id _Nonnull(EZMContainerIndexedChange * _Nonnull value) {
                        return [NSIndexPath indexPathForRow:value.index inSection:0];
                    }] as:NSArray.class];
                    
                    switch ([key integerValue]) {
                        case EZMContainerChangeStateInsert:
                            [self insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationAutomatic];
                            break;
                        case EZMContainerChangeStateDelete:
                            [self deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationAutomatic];
                            break;
                        case EZMContainerChangeStateUpdate:
                            [self reloadRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationAutomatic];
                            break;
                        default:
                            break;
                    }
                }];
                [self endUpdates];
            }
                break;
            case EZMContainerChangeStateFlush:
                [self reloadData];
                break;
            case EZMContainerChangeStateInsert:
            case EZMContainerChangeStateDelete:
            case EZMContainerChangeStateUpdate:
            {
                EZMContainerIndexedChange *indexedChange = (EZMContainerIndexedChange *)change;
                NSCAssert([indexedChange isKindOfClass:[EZMContainerIndexedChange class]], @"类型不匹配");
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:indexedChange.index inSection:0];
                switch (indexedChange.state) {
                    case EZMContainerChangeStateInsert:
                        [self insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
                        break;
                    case EZMContainerChangeStateDelete:
                        [self deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
                        break;
                    case EZMContainerChangeStateUpdate:
                        [self reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
                        break;
                    default:
                        break;
                }
            }
                break;
            case EZMContainerChangeStateMove:
            {
                EZMContainerMoveChange *moveChange = (EZMContainerMoveChange *)change;
                NSCAssert([moveChange isKindOfClass:[EZMContainerMoveChange class]], @"类型不匹配");
                NSIndexPath *sourceIndexPath = [NSIndexPath indexPathForRow:moveChange.source inSection:0];
                NSIndexPath *toIndexPath = [NSIndexPath indexPathForRow:moveChange.destnation inSection:0];
                [self moveRowAtIndexPath:sourceIndexPath toIndexPath:toIndexPath];
            }
                break;
            default:
                break;
        }
    };
}

@interface EZMListView() <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, readwrite, strong) NSMutableArray<ERCellPattern *> *vmPatterns;
@property (nonatomic, readwrite, strong) NSMutableDictionary<NSString *, EZMListCell *> *reuseHeightCaleCellMap;
@property (nonatomic, readwrite, strong) UIView *reuseCalcView;

@end

@implementation EZMListView

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    if (self = [super initWithFrame:frame style:style]) {
        EZMBinder *binder = [[EZMBinder alloc] initWithAssociateObject:self];
        [super setDelegate:self];
        [super setDataSource:self];
        
        _vmPatterns = [NSMutableArray array];
        _reuseHeightCaleCellMap = [NSMutableDictionary dictionary];
        _data = [EZRMutableNode new];
        _reloadHandler = [super ezm_handlerForSelector:@selector(reloadData)];
        [binder bindEvent:[[_data keepMainThread] generatorEvent] toHandler:_reloadHandler];
        _reuseCalcView = [[UIView alloc] initWithFrame:frame];
        
//        [[super er_deallocCancelBag] addCancelable:[[[_data flattenMap:^EZRNode * _Nullable(EZMContainer * _Nullable next) {
//            return next.changes;
//        }] keepMainThread] listen:reactListDataChange(self)]];
        
        [[[[_data flattenMap:^EZRNode * _Nullable(EZMContainer<id> * _Nullable next) {
            return next.changes;
        }] keepMainThread] listenedBy:self] withBlock:reactListDataChange(self)];
        
        [super setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        [super setTableFooterView:[UIView new]];
        [super setTableHeaderView:[UIView new]];
    }
    return self;
}

- (void)cellPattern:(Class(^)(id viewModel))patternBlock binding:(void(^)(EZMBinder *, __kindof EZMListCell *cell, id viewModel))bindingBlock {
    NSParameterAssert(patternBlock);
    NSParameterAssert(bindingBlock);
    [self.vmPatterns addObject:EZTuple(patternBlock, bindingBlock)];
}

- (CGFloat)estimatedRowHeight {
    return self.rowHeight;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.data.isEmpty) {
        return 0;
    }
    
    EZMContainer *dataContainer = self.data.value;
    return dataContainer.count.value.integerValue;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    id data = [self dataAtIndexPath:indexPath];
   EZTuple2<Class, ERCellBindingBlock> *pattern = [self cellPatternForData:data];
    if (pattern.first == nil) {
        return [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:@"empty"];
    }
    EZMListCell *cell = (EZMListCell *)[self dequeueReusableCellWithIdentifier:NSStringFromClass(pattern.first)];
    if (cell == nil) {
        cell = [[pattern.first alloc] initWithStyle:UITableViewCellStyleDefault
                                    reuseIdentifier:NSStringFromClass(pattern.first)];
    }
    if (pattern.second) {
        pattern.second(cell.binder, cell, data);
    }
    return (UITableViewCell *)cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    id data = [self dataAtIndexPath:indexPath];
   EZTuple2<Class, ERCellBindingBlock> *pattern = [self cellPatternForData:data];

    EZMListCell *cell = [self reuseHeightCaleCellWithClass:pattern.first];
    [self.reuseCalcView addSubview:cell];
    pattern.second(cell.binder, cell, data);
    [cell layoutIfNeeded];
    [cell.binder cancel];
    [cell removeFromSuperview];
    return CGRectGetHeight(cell.frame);
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self deselectRowAtIndexPath:indexPath animated:YES];
}

- (EZTuple2<Class, ERCellBindingBlock> *)cellPatternForData:(id)data {
    NSEnumerator<ERCellPattern *> *enumerator = [[self.vmPatterns copy] objectEnumerator];
    ERCellPattern *enumeratedObject = nil;
    Class clazz = nil;
    while (clazz == nil && (enumeratedObject = enumerator.nextObject)) {
        clazz = enumeratedObject.first(data);
    }
    NSAssert(clazz, @"找不到对应的Cell类，请检查下- (void)cellClass:(Class)cellClass patternVM:(BOOL(^)(VM))patternBlock binding:(void(^)(__kindof EZMListCell *, VM))bindingBlock方法");
    return EZTuple(clazz, enumeratedObject.second);
}

- (EZMListCell *)reuseHeightCaleCellWithClass:(Class)clazz {
    NSString *clazzName = NSStringFromClass(clazz);
    EZMListCell *listViewCell = self.reuseHeightCaleCellMap[clazzName];
    if (listViewCell == nil) {
        listViewCell = [[clazz alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame), self.rowHeight)];
        self.reuseHeightCaleCellMap[clazzName] = listViewCell;
    }
    return listViewCell;
}

- (id)dataAtIndexPath:(NSIndexPath *)indexPath {
    EZMContainer *dataContainer = self.data.value;
    return dataContainer[indexPath.row];
}

+ (Class)superclass {
    return [UIView class];
}

@end
