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

#import "CategoryCubeViewModel.h"
#import "RubikModel.h"
#import <EasySequence/EasySequence.h>

@implementation CategoryItemViewModel

- (instancetype)init {
    if (self = [super init]) {
        RubikModel *model = EZM_MODEL(RubikModel);
        _iconName = [EZRNode new];
        _categoryName = [EZRNode new];
    }
    return self;
}

@end

@implementation CategoryCubeViewModel

- (instancetype)init {
    if (self = [super init]) {
        RubikModel *model = EZM_MODEL(RubikModel);
        _column = [model.data map:^id _Nullable(NSArray<NSDictionary *> * _Nullable next) {
            return next[1][@"cols"];
        }];
        
        _items = [model.data map:^id _Nullable(NSArray<NSDictionary *> * _Nullable next) {
            NSArray<NSDictionary *> *data = next[1][@"data"];
            NSArray<CategoryItemViewModel *> *items = [[EZS_Sequence(data) map:^id _Nonnull(NSDictionary * _Nonnull value) {
                CategoryItemViewModel *item = [CategoryItemViewModel new];
                item.iconName.mutablify.value = value[@"title"];
                item.categoryName.mutablify.value = value[@"image"];
                return item;
            }] as:NSArray.class];
            NSMutableArray *array = [NSMutableArray array];
            [array addObjectsFromArray:items];
            [array addObjectsFromArray:items];
            [array addObjectsFromArray:items];
            [array addObjectsFromArray:items];
            [array addObjectsFromArray:items];
            [array addObjectsFromArray:items];
            [array addObjectsFromArray:items];
            [array addObjectsFromArray:items];
            [array addObjectsFromArray:items];
            [array addObjectsFromArray:items];
            [array addObjectsFromArray:items];
            [array addObjectsFromArray:items];
            return [[EZMContainer alloc] initWithArray:array];
        }];
    }
    return self;
}

@end
