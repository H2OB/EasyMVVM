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

#import "ListViewUITestViewModel.h"
#import "RubikUITestModel.h"
#import "SimpleListItemViewModel.h"
#import <EasySequence/EasySequence.h>

@interface ListViewUITestViewModel ()

@property (nonatomic, strong) RubikUITestModel *model;

@end

@implementation ListViewUITestViewModel

- (instancetype)init {
    if (self = [super init]) {
        _model = EZM_MODEL(RubikUITestModel);
        _data = [EZRNode value:[[EZMContainer alloc] initWithArray:@[]]];
        _headerTitle = [EZRNode value:@"This is a header view."];
        _footerTitle = [EZRNode value:@"This is a footer view."];

        @ezr_weakify(self)
        [[_model.listViewData listenedBy:self] withBlock:^(NSArray<NSString *> * _Nullable next) {
            NSArray *vmArray = [[EZS_Sequence(next) map:^id _Nonnull(NSString * _Nonnull value) {
                SimpleListItemViewModel *vm = [[SimpleListItemViewModel alloc] init];
                vm.textNode.mutablify.value = value;
                return vm;
            }] as:NSArray.class];
            @ezr_strongify(self)
            EZMContainer *container = self.data.value;
            [container beginTransaction];
            [container removeAllObjects];
            [container addObjectsFromArray:vmArray];
            [container endTransaction];
        }];
        
        _requestDataHandler = [[EZMHandler alloc] initWithBlock:^{
            @ezr_strongify(self)
            [self.model.loadListViewDataAction execute:nil];
            
        }];

        _requestDataForAddtionHandler = [[EZMHandler alloc] initWithBlock:^{
            @ezr_strongify(self)
            [self.model.loadListViewDataForAddtionAction execute:nil];
            
        }];

        _requestDataForDeletionHandler = [[EZMHandler alloc] initWithBlock:^{
            @ezr_strongify(self)
            [self.model.loadListViewDataForDeletingAction execute:nil];
            
        }];

        _requestDataForMovingHandler = [[EZMHandler alloc] initWithBlock:^{
            @ezr_strongify(self)
            [self.model.loadListViewDataForMovingAction execute:nil];
            
        }];

        _requestDataForUpdatingHandler = [[EZMHandler alloc] initWithBlock:^{
            @ezr_strongify(self)
            [self.model.loadListViewDataForUpdatingAction execute:nil];
            
        }];
    }
    return self;
}

@end
