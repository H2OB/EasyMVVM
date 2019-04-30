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

#import "ListViewUITestViewController.h"
#import <EasyMVVM/EasyMVVM.h>
#import "HeaderView.h"
#import "FooterView.h"
#import "SimpleListItemView.h"
#import "SimpleListItemViewModel.h"
#import "ListViewUITestViewModel.h"
#import "RubikUITestModel.h"

@interface ListViewUITestViewController ()

@property (nonatomic, strong) EZMListView *listView;
@property (nonatomic, strong) ListViewUITestViewModel *viewModel;
@property (nonatomic, strong) RubikUITestModel *model;
@property (nonatomic, strong) HeaderView *headerView;
@property (nonatomic, strong) FooterView *footerView;
@property (nonatomic, strong) HeaderView *anotherHeaderView;
@property (nonatomic, strong) FooterView *anotherFooterView;

@end

@implementation ListViewUITestViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.model = EZM_MODEL(RubikUITestModel);
    self.viewModel = [[ListViewUITestViewModel alloc] init];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    CGRect listFrame = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height - 140.f);
    self.listView = [[EZMListView alloc] initWithFrame:listFrame];
    [self.view addSubview:self.listView];
}

- (HeaderView *)headerView {
    if (!_headerView){
        _headerView = [[HeaderView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 30)];
    }
    return _headerView;
}

- (FooterView *)footerView {
    if (!_footerView) {
        _footerView = [[FooterView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 30)];
    }
    return _footerView;
}

- (HeaderView *)anotherHeaderView {
    if (!_anotherHeaderView){
        _anotherHeaderView = [[HeaderView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 60)];
    }
    return _anotherHeaderView;
}

- (FooterView *)anotherFooterView {
    if (!_anotherFooterView) {
        _anotherFooterView = [[FooterView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 100)];
    }
    return _anotherFooterView;
}

- (void)bindView:(EZMBinder *)binder {
    [super bindView:binder];
    [self.listView cellClass:[SimpleListItemView class]
                     pattern:EZMCellMatchAllData
                     binding:^(EZMBinder * _Nonnull binder, __kindof SimpleListItemView * _Nonnull cell, SimpleListItemViewModel *viewModel) {
                         [binder bindNode:cell.text toNode:viewModel.textNode];
                         CGRect bounds = cell.bounds;
                         bounds.size.height = 27.f;
                         cell.bounds = bounds;
    }];
    
    [binder bindNode:self.listView.data toNode:self.viewModel.data];
    [binder bindEvent:self.resetButton.ezm_touchEvent toHandler:self.viewModel.requestDataHandler];
    [binder bindEvent:self.addButton.ezm_touchEvent toHandler:self.viewModel.requestDataForAddtionHandler];
    [binder bindEvent:self.deleteButton.ezm_touchEvent toHandler:self.viewModel.requestDataForDeletionHandler];
    [binder bindEvent:self.moveButton.ezm_touchEvent toHandler:self.viewModel.requestDataForMovingHandler];
    [binder bindEvent:self.updateButton.ezm_touchEvent toHandler:self.viewModel.requestDataForUpdatingHandler];
    
    [binder bindNode:self.headerView.title toNode:self.viewModel.headerTitle];
    [binder bindNode:self.anotherHeaderView.title toNode:self.viewModel.headerTitle];
    [binder bindNode:self.footerView.title toNode:self.viewModel.footerTitle];
    [binder bindNode:self.anotherFooterView.title toNode:self.viewModel.footerTitle];

    @ezr_weakify(self)
    [binder bindEvent:self.addHeaderButton.ezm_touchEvent toHandler:[[EZMHandler alloc] initWithBlock:^{
        @ezr_strongify(self)
        self.listView.headerViewNode.value = self.headerView;
        
    }]];
    [binder bindEvent:self.removeHeaderButton.ezm_touchEvent toHandler:[[EZMHandler alloc] initWithBlock:^{
        @ezr_strongify(self)
        self.listView.headerViewNode.value = nil;
        
    }]];
    [binder bindEvent:self.changeHeaderButton.ezm_touchEvent toHandler:[[EZMHandler alloc] initWithBlock:^{
        @ezr_strongify(self)
        self.listView.headerViewNode.value = self.anotherHeaderView;
        
    }]];
    
    [binder bindEvent:self.addFooterButton.ezm_touchEvent toHandler:[[EZMHandler alloc] initWithBlock:^{
        @ezr_strongify(self)
        self.listView.footerViewNode.value = self.footerView;
        
    }]];
    [binder bindEvent:self.removeFooterButton.ezm_touchEvent toHandler:[[EZMHandler alloc] initWithBlock:^{
        @ezr_strongify(self)
        self.listView.footerViewNode.value = nil;
        
    }]];
    [binder bindEvent:self.changeFooterButton.ezm_touchEvent toHandler:[[EZMHandler alloc] initWithBlock:^{
        @ezr_strongify(self)
        self.listView.footerViewNode.value = self.anotherFooterView;
    }]];
}

@end
