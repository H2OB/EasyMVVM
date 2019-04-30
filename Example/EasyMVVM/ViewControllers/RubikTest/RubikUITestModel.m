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

#import "RubikUITestModel.h"

@implementation RubikUITestModel

- (instancetype)init {
    if (self = [super init]) {
        @ezr_weakify(self)
        
        // list
        _listViewData = [EZRNode new];
        
        _loadListViewDataAction = [ERAction actionWithBlock:^(id  _Nullable param, EZRNode * _Nonnull result, EZRNode<NSError *> * _Nonnull error) {
            @ezr_strongify(self)
            self.listViewData.mutablify.value = @[@"A", @"B", @"C", @"D", @"E", @"F", @"G", @"H", @"I", @"J", @"K"];
            result.mutablify.value = nil;
        }];
        
        _loadListViewDataForAddtionAction = [ERAction actionWithBlock:^(id  _Nullable param, EZRNode * _Nonnull result, EZRNode<NSError *> * _Nonnull error) {
            @ezr_strongify(self)
            self.listViewData.mutablify.value = @[@"A", @"B", @"C", @"C1", @"D", @"E", @"E1", @"E2", @"F", @"G", @"H", @"I", @"J", @"K", @"L", @"M"];
            result.mutablify.value = nil;
        }];
        
        _loadListViewDataForDeletingAction = [ERAction actionWithBlock:^(id  _Nullable param, EZRNode * _Nonnull result, EZRNode<NSError *> * _Nonnull error) {
            @ezr_strongify(self)
            self.listViewData.mutablify.value = @[@"B", @"C", @"E", @"F", @"G", @"I", @"K"];
            result.mutablify.value = nil;
        }];
        
        _loadListViewDataForMovingAction = [ERAction actionWithBlock:^(id  _Nullable param, EZRNode * _Nonnull result, EZRNode<NSError *> * _Nonnull error) {
            @ezr_strongify(self)
            self.listViewData.mutablify.value = @[@"C", @"H", @"I", @"D", @"E", @"F",@"A", @"K", @"B", @"G", @"J"];
            result.mutablify.value = nil;
        }];

        _loadListViewDataForUpdatingAction = [ERAction actionWithBlock:^(id  _Nullable param, EZRNode * _Nonnull result, EZRNode<NSError *> * _Nonnull error) {
            @ezr_strongify(self)
            self.listViewData.mutablify.value = @[@"AAA", @"B", @"CCC", @"DDD", @"EEE", @"FFFF", @"G", @"H", @"I", @"J", @"KKKK"];
            result.mutablify.value = nil;
        }];

        // grid
        _gridViewData = [EZRNode new];
        
        _loadGridViewDataAction = [ERAction actionWithBlock:^(id  _Nullable param, EZRNode * _Nonnull result, EZRNode<NSError *> * _Nonnull error) {
            @ezr_strongify(self)
            self.gridViewData.mutablify.value = @[@"A", @"B", @"C", @"D", @"E", @"F", @"G", @"H", @"I", @"J", @"K"];
            result.mutablify.value = nil;
        }];
        
        _loadGridViewDataForAddtionAction = [ERAction actionWithBlock:^(id  _Nullable param, EZRNode * _Nonnull result, EZRNode<NSError *> * _Nonnull error) {
            @ezr_strongify(self)
            self.gridViewData.mutablify.value = @[@"A", @"B", @"C", @"C1", @"D", @"E", @"E1", @"E2", @"F", @"G", @"H", @"I", @"J", @"K", @"L", @"M"];
            result.mutablify.value = nil;
        }];
        
        _loadGridViewDataForDeletingAction = [ERAction actionWithBlock:^(id  _Nullable param, EZRNode * _Nonnull result, EZRNode<NSError *> * _Nonnull error) {
            @ezr_strongify(self)
            self.gridViewData.mutablify.value = @[@"B", @"C", @"E", @"F", @"G", @"I", @"K"];
            result.mutablify.value = nil;
        }];
        
        _loadGridViewDataForMovingAction = [ERAction actionWithBlock:^(id  _Nullable param, EZRNode * _Nonnull result, EZRNode<NSError *> * _Nonnull error) {
            @ezr_strongify(self)
            self.gridViewData.mutablify.value = @[ @"C", @"H", @"I", @"D", @"E", @"F",@"A", @"K", @"B", @"G", @"J", ];
            result.mutablify.value = nil;
        }];
        
        _loadGridViewDataForUpdatingAction = [ERAction actionWithBlock:^(id  _Nullable param, EZRNode * _Nonnull result, EZRNode<NSError *> * _Nonnull error) {
            @ezr_strongify(self)
            self.gridViewData.mutablify.value = @[@"AAA", @"B", @"CCC", @"DDD", @"EEE", @"FFFF", @"G", @"H", @"I", @"J", @"KKKK"];
            result.mutablify.value = nil;
        }];
    }
    return self;
}

@end
