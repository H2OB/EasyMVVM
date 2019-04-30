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

#import <EasyMVVM/EZMRubikView.h>
#import <EasyMVVM/EZMListView.h>
#import "BannerCubeViewModel.h"
#import "RubikViewTestViewController.h"
#import "RubikViewModel.h"
#import "ShopListCubeViewModel.h"
#import "ShopListItemView.h"
#import "BannerView.h"
#import "HeaderView.h"
#import "FooterView.h"

@interface RubikViewTestViewController ()

@property (nonatomic, strong) EZMRubikView *rubikView;
@property (nonatomic, strong) RubikViewModel *rubikViewModel;

@property (nonatomic, strong) EZMListView<ShopListItemViewModel *> *listCubeView1;
@property (nonatomic, strong) ShopListCubeViewModel *shopListCubeViewModel1;
@property (nonatomic, strong) EZMListView<ShopListItemViewModel *> *listCubeView2;
@property (nonatomic, strong) ShopListCubeViewModel *shopListCubeViewModel2;
@property (nonatomic, strong) EZMContentView *contentView;
@property (nonatomic, strong) BannerView *bannerView;
@property (nonatomic, strong) BannerCubeViewModel *contentViewModel;

@end

@implementation RubikViewTestViewController

#pragma mark - life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIView *headerView = [[HeaderView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 30)];
    UIView *footerView = [[FooterView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 30)];
    UIView *contentHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 30)];
    contentHeaderView.backgroundColor = [UIColor magentaColor];
    self.rubikViewModel = [[RubikViewModel alloc] init];
    self.rubikView = [[EZMRubikView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:self.rubikView];
    
    self.shopListCubeViewModel1 = [[ShopListCubeViewModel alloc] init];
    self.shopListCubeViewModel2 = [[ShopListCubeViewModel alloc] init];
    self.listCubeView1 = [[EZMListView alloc] initWithFrame:self.view.bounds];
    self.listCubeView1.headerViewNode.value = headerView;
    self.listCubeView2 = [[EZMListView alloc] initWithFrame:self.view.bounds];
    self.listCubeView2.footerViewNode.value = footerView;
    
    self.contentViewModel = [[BannerCubeViewModel alloc] init];
    self.contentView = [[EZMContentView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 200.f)];
    self.contentView.headerViewNode.value = contentHeaderView;
    self.bannerView = [[BannerView alloc] initWithFrame:self.contentView.bounds];
    [self.contentView addSubview:self.bannerView];
}

#pragma mark - overrides

- (void)bindView:(EZMBinder *)binder {
    [super bindView:binder];

    [self.listCubeView1 cellClass:[ShopListItemView class]
                         pattern:EZMCellMatchAllData binding:^(EZMBinder * _Nonnull binder, __kindof ShopListItemView * _Nonnull cell, ShopListItemViewModel * _Nonnull viewModel) {
                             [binder bindNode:cell.shopName toNode:viewModel.shopName];
                             [binder bindNode:cell.shopLogo toNode:viewModel.shopLogo];
                             [binder bindNode:cell.shopDescription toNode:viewModel.shopDescription];
                             [binder bindNode:cell.price toNode:viewModel.price];
                             [binder bindNode:cell.telephone toNode:viewModel.telephone];
                             CGRect bounds = cell.bounds;
                             bounds.size.height = 120;
                             cell.bounds = bounds;
                         }];
    self.listCubeView1.data.value = self.shopListCubeViewModel1.items.value;
    [self.listCubeView2 cellClass:[ShopListItemView class]
                         pattern:EZMCellMatchAllData binding:^(EZMBinder * _Nonnull binder, __kindof ShopListItemView * _Nonnull cell, ShopListItemViewModel * _Nonnull viewModel) {
                             [binder bindNode:cell.shopName toNode:viewModel.shopName];
                             [binder bindNode:cell.shopLogo toNode:viewModel.shopLogo];
                             [binder bindNode:cell.shopDescription toNode:viewModel.shopDescription];
                             [binder bindNode:cell.price toNode:viewModel.price];
                             [binder bindNode:cell.telephone toNode:viewModel.telephone];
                             CGRect bounds = cell.bounds;
                             bounds.size.height = 120;
                             cell.bounds = bounds;
                         }];
    self.listCubeView2.data.value = self.shopListCubeViewModel2.items.value;

    [binder bindNode:self.bannerView.name toNode:self.contentViewModel.name];
    
    self.rubikView.cubePresentations.value = [@[ [self.listCubeView2 cubePresentation], self.contentView, [self.listCubeView1 cubePresentation]] ezm_toContainer];
}

@end
