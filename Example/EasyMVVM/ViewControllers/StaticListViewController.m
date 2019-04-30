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

#import "StaticListViewController.h"
#import "LabelListCell.h"
#import "StaticListViewModel.h"
#import <EasyMVVM/EasyMVVM.h>

@interface StaticListViewController ()

@property (nonatomic, strong) EZMListView<ERStaticListItemViewModel *> *listView;
@property (nonatomic, strong) StaticListViewModel *viewModel;

@end

@implementation StaticListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.viewModel = [StaticListViewModel new];
    self.listView = [[EZMListView alloc] initWithFrame:self.view.frame];
    [self.view addSubview:self.listView];
    
    [self.listView cellPattern:EZMListViewMatchAllWithClass([LabelListCell class]) binding:^(EZMBinder *binder, __kindof LabelListCell *cell, ERStaticListItemViewModel *viewModel) {
        [binder bindNode:cell.title toNode:viewModel.title];
    }];
    
    self.listView.data.value = self.viewModel.items;
}


@end
