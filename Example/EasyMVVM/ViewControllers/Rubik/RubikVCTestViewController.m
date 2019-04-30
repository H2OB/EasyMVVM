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

#import "RubikVCTestViewController.h"
#import "ShopCubeViewController.h"
#import "BannerViewController.h"
#import "GoodsViewController.h"
#import <EasyMVVM/EasyMVVM.h>

@interface RubikVCTestViewController ()


@end

@implementation RubikVCTestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self registerClass:[ShopCubeViewController class] identifier:@"ShopCubeViewController"];
    [self registerClass:[BannerViewController class] identifier:@"BannerViewController"];
    [self registerClass:[GoodsViewController class] identifier:@"GoodsViewController"];
}

- (void)bindView:(EZMBinder *)binder {
    [super bindView:binder];

    self.cubeIdentifiers.value = [@[@"ShopCubeViewController", @"BannerViewController"] ezm_toContainer];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.cubeIdentifiers.value = [@[@"BannerViewController", @"GoodsViewController"] ezm_toContainer];
    });
}

@end
