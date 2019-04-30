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

#import "GridViewTestViewController.h"
#import <EasyMVVM/EZMGridView.h>
#import "CategoryCubeViewModel.h"
#import "CategoryItemView.h"
#import "HeaderView.h"
#import "FooterView.h"

@interface GridViewTestViewController ()

@property (nonatomic, strong) EZMGridView<CategoryItemViewModel *> *gridView;
@property (nonatomic, strong) CategoryCubeViewModel *gridViewModel;

@end

@implementation GridViewTestViewController

#pragma mark - life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIView *headerView = [[HeaderView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 30)];
    UIView *footerView = [[FooterView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 30)];

    self.gridViewModel = [[CategoryCubeViewModel alloc] init];
    self.gridView = [[EZMGridView alloc] initWithFrame:self.view.bounds];
    self.gridView.itemHeight.value = @80.f;
    self.gridView.headerViewNode.value = headerView;
    self.gridView.footerViewNode.value = footerView;

    [self.view addSubview:self.gridView];
}

#pragma mark - overrides

- (void)bindView:(EZMBinder *)binder {
    [super bindView:binder];
    [self.gridView cellClass:[CategoryItemView class]
                     pattern:EZMCellMatchAllData
                     binding:^(EZMBinder * _Nonnull binder, __kindof CategoryItemView * _Nonnull cell, CategoryItemViewModel * _Nonnull viewModel) {
                         [binder bindNode:cell.iconName toNode:viewModel.iconName];
                         [binder bindNode:cell.categoryName toNode:viewModel.categoryName];
    }];
    self.gridView.data.value = self.gridViewModel.items.value;    
}

@end
