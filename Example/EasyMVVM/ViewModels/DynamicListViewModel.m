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

#import "DynamicListViewModel.h"

@implementation DynamicListItemViewModel

- (instancetype)init {
    self = [super init];
    if (self) {
        _title = [EZRMutableNode new];
    }
    return self;
}

@end


@implementation ERDynamicListViewModel

- (instancetype)init {
    self = [super init];
    if (self) {
        NSArray<NSString *> *mockArray = @[@"A", @"B", @"C", @"D", @"E", @"F", @"G", @"H"];
        
        NSArray<DynamicListItemViewModel *> *mockItemArray = [[mockArray.EZS_asSequence map:^id _Nonnull(NSString * _Nonnull value) {
            DynamicListItemViewModel *item = [DynamicListItemViewModel new];
            item.title.value = value;
            return item;
        }] as:NSArray.class];
        
        _items = [[EZMContainer alloc] initWithArray:mockItemArray];
        @ezr_weakify(self)
        _addRowHandler = [[EZMHandler alloc] initWithBlock:^{
            @ezr_strongify(self)
            DynamicListItemViewModel *item = [DynamicListItemViewModel new];
            item.title.value = @"T";
            [self.items appendObject:item];
        }];
        _deleteRowHandler = [[EZMHandler alloc] initWithBlock:^{
            @ezr_strongify(self)
            [self.items deleteLastObject];
        }];
        _modifyCellHandler = [[EZMHandler alloc] initWithBlock:^{
            @ezr_strongify(self)
            self.items[0].title.value = @"T";
        }];
        _resetTableViewHandler = [[EZMHandler alloc] initWithBlock:^{
            @ezr_strongify(self)
            NSArray<NSString *> *mockArray = @[@"1", @"2", @"3", @"4", @"5"];
            
            NSArray<DynamicListItemViewModel *> *mockItemArray = [[mockArray.EZS_asSequence map:^id _Nonnull(NSString * _Nonnull value) {
                DynamicListItemViewModel *item = [DynamicListItemViewModel new];
                item.title.value = value;
                return item;
            }] as:NSArray.class];
            
            [self.items setArray:mockItemArray];
        }];
    }
    return self;
}


@end
