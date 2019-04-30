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

#import "RubikViewModel.h"
#import "BannerCubeViewModel.h"
#import "CategoryCubeViewModel.h"
#import "ShopListCubeViewModel.h"
#import "RubikModel.h"
#import <EasySequence/EasySequence.h>

@implementation RubikViewModel

- (instancetype)init {
    if (self = [super init]) {
        NSDictionary<NSNumber *, NSString *> *typeForId = @{
                                                            @1 : @"BannerCube",
                                                            @2 : @"CategoryCube",
                                                            @3 : @"ShopListCube",
                                                            };
        RubikModel *model = EZM_MODEL(RubikModel);
        
        _cubeIdentifiers = [model.data map:^id _Nullable(NSArray<NSDictionary *> * _Nullable next) {
            //*
            NSArray *result = [[EZS_Sequence(next) map:^id _Nonnull(NSDictionary * _Nonnull value) {
                return typeForId[value[@"type"]];
            }] as:NSArray.class];
            //*/
            //NSArray *result = @[@"CategoryCube", @"ShopListCube", @"CategoryCube", @"ShopListCube"];
            return [[EZMContainer alloc] initWithArray:result];;
        }];
    }
    return self;
}

@end

