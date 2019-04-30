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

#import "StaticTableViewController.h"
#import <EasyMVVM/EasyMVVM.h>
#import "LabelListCell.h"
#import "LabelHeaderFooterView.h"
#import "StaticTableViewModel.h"

@interface StaticTableViewController ()

@property (nonatomic, strong) EZMTableView<ERStaticTableSectionViewModel *, ERStaticTableItemViewModel *> *tableView;

@end

@implementation StaticTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _tableView = [[EZMTableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
    [self.view addSubview:_tableView];
    
    // section绑定，有headerFooterView
    ERSectionPattern<ERStaticTableSectionViewModel *, ERStaticTableItemViewModel *> *sb1 =

    [self.tableView sectionPattern:^EZTuple3<EZMContainer<ERStaticTableItemViewModel *> *,Class,Class> * _Nonnull(ERStaticTableSectionViewModel * _Nonnull sectionVM) {
        return EZTuple(sectionVM.items, [LabelHeaderFooterView class], [LabelHeaderFooterView class]);
    } headerBinding:^(EZMBinder * _Nonnull binder, ERStaticTableSectionViewModel * _Nonnull sectionVM, LabelHeaderFooterView * _Nullable headerView) {
        [binder bindNode:headerView.title toNode:sectionVM.headerTitle];
    } footerBinding:^(EZMBinder * _Nonnull binder, ERStaticTableSectionViewModel * _Nonnull sectionVM, LabelHeaderFooterView * _Nullable footerView) {
        [binder bindNode:footerView.title toNode:sectionVM.footerTitle];
    }];
    
    [sb1 cellPattern:^Class _Nullable(ERStaticTableItemViewModel * _Nonnull viewModel, ERStaticTableSectionViewModel * _Nonnull sectionVM) {
         return [LabelListCell class];
    } binding:^(EZMBinder * _Nonnull binder, __kindof LabelListCell * _Nonnull cell, ERStaticTableItemViewModel * _Nonnull viewModel, ERStaticTableSectionViewModel *sectionVM) {
        [binder bindNode:cell.title toNode:viewModel.title];
    }];
    
    // section绑定，没有headerFooterView
    ERSectionPattern<ERStaticTableSectionViewModel *, ERStaticTableItemViewModel *> *sb2 =
    [self.tableView sectionPattern:ERSectionMatchAllWithProperty(@"items")];
    [sb2 cellPattern:^Class _Nullable(ERStaticTableItemViewModel * _Nonnull viewModel, ERStaticTableSectionViewModel * _Nonnull sectionVM) {
        return [LabelListCell class];
    } binding:^(EZMBinder * _Nonnull binder, __kindof LabelListCell * _Nonnull cell, ERStaticTableItemViewModel * _Nonnull viewModel, ERStaticTableSectionViewModel *sectionVM) {
        [binder bindNode:cell.title toNode:viewModel.title];
    }];
    
    StaticTableViewModel *tableViewVM = [StaticTableViewModel new];
    _tableView.data.value = tableViewVM.sections;
}

@end
