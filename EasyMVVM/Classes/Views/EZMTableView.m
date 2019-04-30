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

#import "EZMTableView+ProjectPrivate.h"
#import "EZMListCell+ProjectPrivate.h"
#import "EZMHandler.h"
#import "EZMEvent+ProjectPrivate.h"
#import "NSObject+EZMHandler.h"
#import "EZRNode+Event.h"
#import "EZMContainer.h"
#import "EZMContainerChange.h"
#import "EZMBinder.h"
#import "EZMTableViewHeaderFooterView+ProjectPrivate.h"
#import "EZRNode+MainThread.h"

typedef EZTuple3<EZMContainer *, Class, Class> ERSectionTuple;
typedef ERSectionTuple *(^ERSectionPatternBlock)(id);
typedef void (^ERSectionHeaderFooterBindingBlock)(EZMBinder *, id, __kindof EZMTableViewHeaderFooterView *);
typedef EZTuple4<ERSectionPatternBlock, ERSectionHeaderFooterBindingBlock, ERSectionHeaderFooterBindingBlock, ERSectionPattern *> ERSectionPatternTuple;

typedef Class(^ERTableCellPatternBlock)(id, id);
typedef void(^ERCellBindingBlock)(EZMBinder *, __kindof EZMListCell *, id, id);
typedef EZTuple2<ERTableCellPatternBlock, ERCellBindingBlock> ERTableCellPattern;
typedef EZTuple6<EZMContainer *, Class, Class, ERSectionHeaderFooterBindingBlock, ERSectionHeaderFooterBindingBlock, ERSectionPattern *> ERTableSectionPatternResult;

ERSectionDataPattern ERSectionMatchAllWithProperty(NSString *propertyName) {
    return ^EZMContainer *(id sectionVM) {
        id container = [sectionVM valueForKeyPath:propertyName];
        return container;
    };
}

typedef Class(^ERCellClassPattern)(id, id);
ERCellClassPattern ERCellMatchAllWithClass(Class clazz) {
    return ^Class(id _, id __) {
        return clazz;
    };
}

typedef void (^ERReactTableDataChangeBlockType)(EZMContainerChange * _Nullable next);
static ERReactTableDataChangeBlockType reactTableDataChange(EZMTableView *self) {
    @ezr_weakify(self)
    return ^(EZMContainerChange * _Nullable change) {
        @ezr_strongify(self)
        [self reloadData]; //TODO: 需要完善
    };
}

@interface ERSectionPattern ()

@property (nonatomic, strong) NSMutableArray<ERTableCellPattern *> *cellPatterns;

- (EZTuple2<Class, ERCellBindingBlock> *)cellPatternForData:(id)data sectionVM:(id)sectionVM;

@end

@implementation ERSectionPattern

#pragma mark - life cycle

- (instancetype)init {
    if (self = [super init]) {
        _cellPatterns = [NSMutableArray array];
    }
    return self;
}

#pragma mark - public methods

- (void)cellPattern:(Class  _Nullable (^)(id _Nonnull, id _Nonnull))cellPatternBlock binding:(void (^)(EZMBinder * _Nonnull, __kindof EZMListCell * _Nonnull, id _Nonnull, id _Nonnull))cellBindingBlock {
    NSParameterAssert(cellPatternBlock);
    NSParameterAssert(cellBindingBlock);
    [self.cellPatterns addObject:EZTuple(cellPatternBlock, cellBindingBlock)];
}

#pragma mark - internal methods

- (EZTuple2<Class, ERCellBindingBlock> *)cellPatternForData:(id)data sectionVM:(id)sectionVM {
    NSEnumerator<ERTableCellPattern *> *enumerator = [[self.cellPatterns copy] objectEnumerator];
    ERTableCellPattern *enumeratedObject = nil;
    Class clazz = nil;
    while (clazz == nil && (enumeratedObject = enumerator.nextObject)) {
        clazz = enumeratedObject.first(data, sectionVM);
    }
    NSAssert(clazz, @"找不到对应的Cell类，请检查下- (void)cellClass:(Class)cellClass patternVM:(BOOL(^)(VM))patternBlock binding:(void(^)(__kindof EZMListCell *, VM))bindingBlock方法");
    return EZTuple(clazz, enumeratedObject.second);
}

@end


@interface EZMTableView() <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSMutableArray<ERSectionPatternTuple *> *sectionPatternTuples;
@property (nonatomic, strong) NSMutableDictionary<NSString *, EZMListCell *> *reuseHeightCaleCellMap;
@property (nonatomic, strong) NSMutableDictionary<NSString *, EZMTableViewHeaderFooterView *> *reuseHeightCaleHeaderFooterViewlMap;
@property (nonatomic, strong) UIView *reuseCalcView;

@end

@implementation EZMTableView

#pragma mark - overrides

+ (Class)superclass {
    return [UIView class];
}

#pragma mark - life cycle

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    if (self = [super initWithFrame:frame style:style]) {
        EZMBinder *binder = [[EZMBinder alloc] initWithAssociateObject:self];
        [super setDelegate:self];
        [super setDataSource:self];
        
        _sectionPatternTuples = [NSMutableArray array];
        _reuseHeightCaleCellMap = [NSMutableDictionary dictionary];
        _reuseHeightCaleHeaderFooterViewlMap = [NSMutableDictionary dictionary];
        _data = [EZRMutableNode new];
        _reloadHandler = [self ezm_handlerForSelector:@selector(reloadData)];
        [binder bindEvent:[[_data keepMainThread] generatorEvent] toHandler:_reloadHandler];
        _reuseCalcView = [[UIView alloc] initWithFrame:frame];
        
        @ezr_weakify(self)
        // TODO: section row offset















        
        [[[[_data flattenMap:^EZRNode * _Nullable(EZMContainer<id> * _Nullable data) {
            EZRNode *sectionChanges = data.changes;
            @ezr_weakify(data)
            
            EZRNode *cellChanges = [data.changes flattenMap:^id _Nullable(__kindof EZMContainerChange * _Nullable _) {
                @ezr_strongify(data)
                





                
                NSArray<EZRNode *> *cellChangesOfSections = [[data.array.EZS_asSequence map:^id _Nonnull(id  _Nonnull sectionViewModel) {
                    @ezr_strongify(self)
                    ERTableSectionPatternResult *patternResult = [self sectionPatternTupleWithSectionVM:sectionViewModel];
                    return patternResult.first.changes;
                }] as:NSArray.class];
                
                return [EZRNode merge:cellChangesOfSections];
            }];
            return [EZRNode merge:@[sectionChanges, cellChanges]];
        }] keepMainThread] listenedBy:self] withBlock:reactTableDataChange(self)];
        
        
        [super setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        [super setTableFooterView:[UIView new]];
        [super setTableHeaderView:[UIView new]];
        [super setSectionHeaderHeight:22.f];
        [super setSectionFooterHeight:22.f];
    }
    return self;
}

#pragma mark - public methods

- (ERSectionPattern *)sectionPattern:(EZTuple3<EZMContainer<id> *,Class, Class> * _Nonnull (^)(id _Nonnull))sectionPatternBlock
                       headerBinding:(void (^)(EZMBinder * _Nonnull, id _Nonnull, __kindof EZMTableViewHeaderFooterView * _Nullable))headerBindingBlock
                       footerBinding:(void (^)(EZMBinder * _Nonnull, id _Nonnull, __kindof EZMTableViewHeaderFooterView * _Nullable))footerBindingBlock{
    NSParameterAssert(sectionPatternBlock);

    ERSectionPattern *sectionPattern = [ERSectionPattern new];
    ERSectionPatternTuple *sectionPatternTuple =EZTuple(sectionPatternBlock, headerBindingBlock, footerBindingBlock, sectionPattern);
    [self.sectionPatternTuples addObject:sectionPatternTuple];
    
    return sectionPattern;
}

- (ERSectionPattern *)sectionPattern:(EZMContainer<id> * _Nonnull (^)(id _Nonnull))patternBlock {
    NSParameterAssert(patternBlock);
    ERSectionPatternBlock sectionPatternBlock = ^ERSectionTuple *(id vm) {
        return EZTuple(patternBlock(vm), nil, nil);
    };
    return [self sectionPattern:sectionPatternBlock headerBinding:nil footerBinding:nil];
}

#pragma mark - table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (self.data.isEmpty) {
        return 0;
    }
    
    EZMContainer *sections = self.data.value;
    NSInteger sectionCount = sections.count.value.integerValue;
    return sectionCount;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    id sectionVM = [self.data.value objectAtIndexedSubscript:section];
    ERTableSectionPatternResult *sectionPatternResult = [self sectionPatternTupleWithSectionVM:sectionVM];

    Class headerViewClass = sectionPatternResult.second;
    if (!headerViewClass) {
        return nil;
    }
    
    NSString *reuseIdentifier = NSStringFromClass(headerViewClass);
    EZMTableViewHeaderFooterView *headerView = (EZMTableViewHeaderFooterView *)[self dequeueReusableHeaderFooterViewWithIdentifier:reuseIdentifier];
    if (headerView == nil) {
        headerView = [[headerViewClass alloc] initWithReuseIdentifier:reuseIdentifier];
    }
    if (sectionPatternResult.fourth) {
        sectionPatternResult.fourth(headerView.binder, sectionVM, headerView);
    }
    return headerView;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    id sectionVM = [self.data.value objectAtIndexedSubscript:section];
    ERTableSectionPatternResult *sectionPatternResult = [self sectionPatternTupleWithSectionVM:sectionVM];
    
    Class footerViewClass = sectionPatternResult.third;
    if (!footerViewClass) {
        return nil;
    }
    
    NSString *reuseIdentifier = NSStringFromClass(footerViewClass);
    EZMTableViewHeaderFooterView *footerView = (EZMTableViewHeaderFooterView *)[self dequeueReusableHeaderFooterViewWithIdentifier:reuseIdentifier];
    if (footerView == nil) {
        footerView = [[footerViewClass alloc] initWithReuseIdentifier:reuseIdentifier];
    }
    if (sectionPatternResult.fifth) {
        sectionPatternResult.fifth(footerView.binder, sectionVM, footerView);
    }
    return footerView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    id sectionVM = [self.data.value objectAtIndexedSubscript:section];
    ERTableSectionPatternResult *sectionPatternResult = [self sectionPatternTupleWithSectionVM:sectionVM];
    
    EZMContainer *cellVMContainer = sectionPatternResult.first;
    NSInteger cellCount = cellVMContainer.count.value.integerValue;
    return cellCount;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    id sectionVM = [self.data.value objectAtIndexedSubscript:indexPath.section];
    ERTableSectionPatternResult *sectionPatternResult = [self sectionPatternTupleWithSectionVM:sectionVM];
    ERSectionPattern *sectionPattern = sectionPatternResult.sixth;
    EZMContainer *cellVMContainer = sectionPatternResult.first;
    id cellVM = cellVMContainer[indexPath.row];
    
   EZTuple2<Class, ERCellBindingBlock> *pattern = [sectionPattern cellPatternForData:cellVM sectionVM:sectionVM];
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
        pattern.second(cell.binder, cell, cellVM, sectionVM);
    }
    return (UITableViewCell *)cell;
}

- (CGFloat)estimatedRowHeight {
    return self.rowHeight;
}

- (CGFloat)estimatedSectionFooterHeight {
    return self.sectionFooterHeight;
}

- (CGFloat)estimatedSectionHeaderHeight {
    return self.sectionHeaderHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    id sectionVM = [self.data.value objectAtIndexedSubscript:indexPath.section];
    ERTableSectionPatternResult *sectionPatternResult = [self sectionPatternTupleWithSectionVM:sectionVM];
    ERSectionPattern *sectionPattern = sectionPatternResult.sixth;
    EZMContainer *cellVMContainer = sectionPatternResult.first;
    id cellVM = cellVMContainer[indexPath.row];
    
   EZTuple2<Class, ERCellBindingBlock> *pattern = [sectionPattern cellPatternForData:cellVM sectionVM:sectionVM];
    
    EZMListCell *cell = [self reuseHeightCaleCellWithClass:pattern.first];
    [self.reuseCalcView addSubview:cell];
    pattern.second(cell.binder, cell, cellVM, sectionVM);
    [cell layoutIfNeeded];
    [cell.binder cancel];
    [cell removeFromSuperview];
    return CGRectGetHeight(cell.frame);
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    id sectionVM = [self.data.value objectAtIndexedSubscript:section];
    ERTableSectionPatternResult *sectionPatternResult = [self sectionPatternTupleWithSectionVM:sectionVM];
    
    Class headerViewClass = sectionPatternResult.second;
    if (!headerViewClass) {
        return 0.1f;
    }
    EZMTableViewHeaderFooterView *headerView = [self reuseHeightCaleHeaderFooterViewWithClass:headerViewClass];
    [self.reuseCalcView addSubview:headerView];
    if (sectionPatternResult.fourth) {
        sectionPatternResult.fourth(headerView.binder, sectionVM, headerView);
    }
    [headerView layoutIfNeeded];
    CGFloat height = CGRectGetHeight(headerView.frame);
    [headerView.binder cancel];
    [headerView removeFromSuperview];
    return height;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    id sectionVM = [self.data.value objectAtIndexedSubscript:section];
    ERTableSectionPatternResult *sectionPatternResult = [self sectionPatternTupleWithSectionVM:sectionVM];
    
    Class footerViewClass = sectionPatternResult.third;
    if (!footerViewClass) {
        return 0.1f;
    }
    EZMTableViewHeaderFooterView *footerView = [self reuseHeightCaleHeaderFooterViewWithClass:footerViewClass];
    [self.reuseCalcView addSubview:footerView];
    if (sectionPatternResult.fifth) {
        sectionPatternResult.fifth(footerView.binder, sectionVM, footerView);
    }
    CGFloat height = CGRectGetHeight(footerView.frame);
    [footerView.binder cancel];
    [footerView removeFromSuperview];
    return height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - internal methods

- (ERTableSectionPatternResult *)sectionPatternTupleWithSectionVM:(id)sectionVM {
    NSEnumerator<ERSectionPatternTuple *> *enumerator = [[self.sectionPatternTuples copy] objectEnumerator];
    ERSectionPatternTuple *enumeratedObject = nil;
    ERSectionTuple *sectionPatternResult = nil;
    while (sectionPatternResult == nil && (enumeratedObject = enumerator.nextObject)) {
        sectionPatternResult = enumeratedObject.first(sectionVM);
    }
    NSAssert(sectionPatternResult, @"找不到对应的Section匹配，请检查下- (ERSectionPattern<SectionVM, CellVM> *)sectionPattern:(ZTuple3<EZMContainer<CellVM> *, Class, Class> * (^)(SectionVM sectionVM))sectionPatternBlock headerBinding:(void (^ _Nullable)(EZMBinder *binder, SectionVM sectionVM, __kindof EZMTableViewHeaderFooterView * _Nullable headerView))headerBindingBlock footerBinding:(void (^ _Nullable)(EZMBinder *binder, SectionVM sectionVM, __kindof EZMTableViewHeaderFooterView * _Nullable footerView))footerBindingBlock方法");
    return EZTuple(sectionPatternResult.first,
                  sectionPatternResult.second,
                  sectionPatternResult.third,
                  enumeratedObject.second,
                  enumeratedObject.third,
                  enumeratedObject.fourth);
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

- (EZMTableViewHeaderFooterView *)reuseHeightCaleHeaderFooterViewWithClass:(Class)clazz {
    NSString *clazzName = NSStringFromClass(clazz);
    EZMTableViewHeaderFooterView *view = self.reuseHeightCaleHeaderFooterViewlMap[clazzName];
    if (!view) {
        view = [[clazz alloc] initWithReuseIdentifier:NSStringFromClass(clazz)];
        self.reuseHeightCaleHeaderFooterViewlMap[clazzName] = view;
    }
    return view;
}

@end
