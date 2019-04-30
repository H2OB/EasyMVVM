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

#import "GridViewUITestViewModel.h"
#import "RubikUITestModel.h"
#import "SimpleGridItemViewModel.h"



@interface GridViewUITestViewModel ()

@property (nonatomic, strong) RubikUITestModel *model;



@end

@implementation GridViewUITestViewModel

- (instancetype)init {
    if (self = [super init]) {
        _model = EZM_MODEL(RubikUITestModel);
        
        _headerTitle = [EZRNode value:@"This is a header view."];
        _footerTitle = [EZRNode value:@"This is a footer view."];
        
        _columns = [EZRNode value:@5];
        _itemHeight = [EZRNode value:@80.f];


        _data = [EZRNode value:[[EZMContainer alloc] initWithArray:@[]]];
        
        @ezr_weakify(self)
        [[_model.gridViewData listenedBy:self] withBlock:^(NSArray<NSString *> * _Nullable next) {
            NSArray *vmArray = [[EZS_Sequence(next) map:^id _Nonnull(NSString * _Nonnull value) {
                SimpleGridItemViewModel *vm = [[SimpleGridItemViewModel alloc] init];
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
            [self.model.loadGridViewDataAction execute:nil];
           
        }];
        _requestDataForAddtionHandler = [[EZMHandler alloc] initWithBlock:^{
            @ezr_strongify(self)
            [self.model.loadGridViewDataForAddtionAction execute:nil];
           
        }];
        _requestDataForDeletionHandler = [[EZMHandler alloc] initWithBlock:^{
            @ezr_strongify(self)
            [self.model.loadGridViewDataForDeletingAction execute:nil];
           
        }];
        _requestDataForMovingHandler = [[EZMHandler alloc] initWithBlock:^{
            @ezr_strongify(self)
            [self.model.loadGridViewDataForMovingAction execute:nil];
           
        }];
        _requestDataForUpdatingHandler = [[EZMHandler alloc] initWithBlock:^{
            @ezr_strongify(self)
            [self.model.loadGridViewDataForUpdatingAction execute:nil];
           
        }];
        
        _increaseColumnHandler = [[EZMHandler alloc] initWithBlock:^{
            @ezr_strongify(self)
            self.columns.mutablify.value = @(self.columns.value.unsignedIntegerValue + 1);
           
        }];
        _decreaseColumnHandler = [[EZMHandler alloc] initWithBlock:^{
            @ezr_strongify(self)
            NSUInteger cols = self.columns.value.unsignedIntegerValue;
            if (cols - 1 > 0) {
                self.columns.mutablify.value = @(self.columns.value.unsignedIntegerValue - 1);
            }
           
        }];

        _increaseItemHeightHandler = [[EZMHandler alloc] initWithBlock:^{
            @ezr_strongify(self)
            self.itemHeight.mutablify.value = @(self.itemHeight.value.floatValue + 5.f);
           
        }];
        _decreaseItemHeightHandler = [[EZMHandler alloc] initWithBlock:^{
            @ezr_strongify(self)
            CGFloat height = self.itemHeight.value.floatValue;
            if (height - 5.f > 0.f) {
                self.itemHeight.mutablify.value = @(self.itemHeight.value.floatValue - 5.f);
            }
           
        }];
}
    return self;
}

@end
