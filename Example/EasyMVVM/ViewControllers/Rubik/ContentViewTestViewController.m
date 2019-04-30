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

#import "ContentViewTestViewController.h"
#import <EasyMVVM/EZMContentView.h>
#import "BannerCubeViewModel.h"
#import "BannerView.h"
#import "HeaderView.h"
#import "FooterView.h"

@interface ContentViewTestViewController ()

@property (nonatomic, strong) EZMContentView *contentView;
@property (nonatomic, strong) BannerView *bannerView;
@property (nonatomic, strong) BannerCubeViewModel *contentViewModel;

@end

@implementation ContentViewTestViewController

#pragma mark - life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIView *headerView = [[HeaderView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 30)];
    UIView *footerView = [[FooterView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 30)];

    self.contentViewModel = [[BannerCubeViewModel alloc] init];
    self.contentView = [[EZMContentView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 200.f)];
    self.bannerView = [[BannerView alloc] initWithFrame:self.contentView.bounds];
    [self.contentView addSubview:self.bannerView];
    self.contentView.headerViewNode.value = headerView;
    self.contentView.footerViewNode.value = footerView;
    [self.view addSubview:self.contentView];
}

#pragma mark - overrides

- (void)bindView:(EZMBinder *)binder {
    [super bindView:binder];
    [binder bindNode:self.bannerView.name toNode:self.contentViewModel.name];
}

@end
