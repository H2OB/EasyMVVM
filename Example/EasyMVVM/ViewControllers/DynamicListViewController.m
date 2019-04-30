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

#import "DynamicListViewController.h"
#import "DynamicListViewModel.h"
#import "LabelListCell.h"

@interface DynamicListViewController ()

@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UIButton *addRowButton;
@property (weak, nonatomic) IBOutlet UIButton *deleteRowButton;
@property (weak, nonatomic) IBOutlet UIButton *resetTableViewButton;
@property (weak, nonatomic) IBOutlet UIButton *modifyCellButton;

@property (nonatomic, strong) EZMListView<DynamicListItemViewModel *> *listView;
@property (nonatomic, strong) ERDynamicListViewModel *viewModel;

@end

@implementation DynamicListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.viewModel = [ERDynamicListViewModel new];
    self.listView = [[EZMListView alloc] initWithFrame:self.containerView.frame];
    [self.containerView addSubview:self.listView];
    
    [self.listView cellPattern:EZMListViewMatchAllWithClass([LabelListCell class])
                       binding:^(EZMBinder *binder, LabelListCell *cell, DynamicListItemViewModel *viewModel) {
                           [binder bindNode:cell.title toNode:viewModel.title];
    }];
    
    self.listView.data.value = self.viewModel.items;
    EZMBinder *binder = [[EZMBinder alloc] initWithAssociateObject:self];
    [binder bindEvent:self.addRowButton.ezm_touchEvent toHandler:self.viewModel.addRowHandler];
    [binder bindEvent:self.deleteRowButton.ezm_touchEvent toHandler:self.viewModel.deleteRowHandler];
    [binder bindEvent:self.modifyCellButton.ezm_touchEvent toHandler:self.viewModel.modifyCellHandler];
    [binder bindEvent:self.resetTableViewButton.ezm_touchEvent toHandler:self.viewModel.resetTableViewHandler];
}


@end
