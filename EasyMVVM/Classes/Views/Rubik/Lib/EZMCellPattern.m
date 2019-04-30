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

#import "EZMCellPattern.h"
#import "EZMContainer.h"
#import <EasyReact/EasyReact.h>

typedef void(^EZMBindingBlock)(EZMBinder *binder, __kindof EZMCell *cell, id viewModel);

EZMCellPatternBlock EZMCellMatchAllData = ^(id _){
    return YES;
};

@implementation EZMCellPatternMetaData

- (instancetype)initWithClass:(Class)clazz pattern:(EZMCellPatternBlock)patternBlock bindingBlock:(EZMBindingBlock)bindingBlock {
    if (self = [super init]) {
        _cellClass = clazz;
        _patternBlock = [patternBlock copy];
        _bindingBlock = [bindingBlock copy];
    }
    return self;
}

@end

@implementation EZMCellPattern {
    EZMContainer<EZMCellPatternMetaData *> *_metaDataArray;
}

- (instancetype)init {
    if (self = [super init]) {
        _metaDataArray = [[EZMContainer alloc] initWithArray:@[]];
        @ezr_weakify(self)
        _cellClasses = [_metaDataArray.changes map:^id _Nullable(__kindof EZMContainerChange * _Nullable next) {
            @ezr_strongify(self)
            if (self == nil) return nil;
            return [[EZS_Sequence(self->_metaDataArray.array) map:^id _Nonnull(EZMCellPatternMetaData * _Nonnull value) {
                return value.cellClass;
            }] as:NSArray.class];
        }];
    }
    return self;
}

- (void)cellClass:(Class)clazz pattern:(EZMCellPatternBlock)patternBlock binding:(EZMBindingBlock)bindingBlock {
    [_metaDataArray appendObject:[[EZMCellPatternMetaData alloc] initWithClass:clazz pattern:patternBlock bindingBlock:bindingBlock]];
}

- (EZMCellPatternMetaData *)metaDataForVM:(id)viewModel {
    __block EZMCellPatternMetaData *metaData = nil;
    [EZS_Sequence(_metaDataArray.array) forEachWithIndexAndStop:^(EZMCellPatternMetaData * _Nonnull value, NSUInteger index, BOOL * _Nonnull stop) {
        if (value.patternBlock(viewModel)) {
            metaData = value;
            *stop = YES;
        }
    }];
    return metaData;
}

@end
