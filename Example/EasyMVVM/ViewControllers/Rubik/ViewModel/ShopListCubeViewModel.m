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

#import "ShopListCubeViewModel.h"
#import "RubikModel.h"
#import <EasySequence/EasySequence.h>

@implementation ShopListItemViewModel

- (instancetype)init {
    if (self = [super init]) {        
        _shopName = [EZRNode new];
        _shopLogo = [EZRNode new];
        _shopDescription = [EZRNode new];
        _price = [EZRNode new];
        _telephone = [EZRNode new];
    }
    return self;
}

@end

@implementation ShopListCubeViewModel

- (instancetype)init {
    if (self = [super init]) {
        RubikModel *model = EZM_MODEL(RubikModel);
        _items = [model.data map:^id _Nullable(NSArray<NSDictionary *> * _Nullable next) {
            NSArray<NSDictionary *> *data = next[2][@"data"];
            NSArray<ShopListItemViewModel *> *items = [[EZS_Sequence(data) map:^id _Nonnull(NSDictionary * _Nonnull value) {
                ShopListItemViewModel *item = [ShopListItemViewModel new];
                item.shopName.mutablify.value = value[@"name"];
                item.shopLogo.mutablify.value = value[@"logo"];
                item.shopDescription.mutablify.value = value[@"desc"];
                item.price.mutablify.value = [NSString stringWithFormat:@"_￥_%@", value[@"price"]];
                item.telephone.mutablify.value = value[@"tel"];
                return item;
            }] as:NSArray.class];
            return [[EZMContainer alloc] initWithArray:items];
        }];
    }
    return self;
}

@end
