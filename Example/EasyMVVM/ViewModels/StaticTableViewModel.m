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

#import "StaticTableViewModel.h"

@implementation ERStaticTableItemViewModel

- (instancetype)init {
    if (self = [super init]) {
        _title = [EZRMutableNode new];
    }
    return self;
}

@end

@implementation ERStaticTableSectionViewModel

- (instancetype)init {
    if (self = [super init]) {
        _headerTitle = [EZRNode value:@"这是header"];
        _footerTitle = [EZRNode value:@"这是footer"];
        _items = [[EZMContainer alloc] init];
    }
    return self;
}

@end

@implementation StaticTableViewModel

- (instancetype)init {
    if (self = [super init]) {
        NSArray<NSString *> *mockArray1 = @[@"A", @"B", @"C", @"D", @"E", @"F", @"G", @"H"];
        NSArray<NSString *> *mockArray2 = @[@"1", @"2", @"3", @"4", @"5"];
       
        ERStaticTableSectionViewModel *sectionVM1 = [ERStaticTableSectionViewModel new];
        [sectionVM1.items setArray:[[mockArray1.EZS_asSequence map:^id _Nonnull(NSString * _Nonnull value) {
            ERStaticTableItemViewModel *item = [ERStaticTableItemViewModel new];
            item.title.value = value;
            return item;
        }] as:NSArray.class]];
        
        ERStaticTableSectionViewModel *sectionVM2 = [ERStaticTableSectionViewModel new];
        [sectionVM2.items setArray:[[mockArray2.EZS_asSequence map:^id _Nonnull(NSString * _Nonnull value) {
            ERStaticTableItemViewModel *item = [ERStaticTableItemViewModel new];
            item.title.value = value;
            return item;
        }] as:NSArray.class]];
        
        _sections = [[EZMContainer alloc] initWithArray:@[sectionVM1, sectionVM2]];
        _navigationTitle = [EZRNode value:@"NavagationTitle"];
    }
    return self;
}

@end
