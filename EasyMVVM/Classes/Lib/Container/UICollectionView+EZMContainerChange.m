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

#import "UICollectionView+EZMContainerChange.h"
#import "EZMContainerChange.h"
#import <EasyReact/EasyReact.h>

@implementation UICollectionView (EZMContainerChange)

- (void)reloadWithChange:(nonnull __kindof EZMContainerChange *)change section:(NSUInteger)section completion:(nullable void (^)(BOOL finished))completion {
    NSParameterAssert(change);
    if (!change) {
        return;
    }
    
    if (change.state == EZMContainerChangeStateFlush) {
        [self reloadSections:[NSIndexSet indexSetWithIndex:section]];
        return;
    }
    
    void (^updateBlock)(void) = ^{
        EZMContainerIndexedChange *indexChange = nil;
        EZMContainerMoveChange *moveChange = nil;
        EZMContainerTransactionChange *transactionChange = nil;
        switch (change.state) {
            case EZMContainerChangeStateFlush:
                break;
            case EZMContainerChangeStateInsert:
                indexChange = change;
                [self insertItemsAtIndexPaths:@[[NSIndexPath indexPathForRow:indexChange.index inSection:section]]];
                break;
            case EZMContainerChangeStateDelete:
                indexChange = change;
                [self deleteItemsAtIndexPaths:@[[NSIndexPath indexPathForRow:indexChange.index inSection:section]]];
                break;
            case EZMContainerChangeStateUpdate:
                indexChange = change;
                [self reloadItemsAtIndexPaths:@[[NSIndexPath indexPathForRow:indexChange.index inSection:section]]];
                break;
            case EZMContainerChangeStateMove:
                moveChange = change;
                [self moveItemAtIndexPath:[NSIndexPath indexPathForRow:moveChange.source inSection:section]
                              toIndexPath:[NSIndexPath indexPathForRow:moveChange.destnation inSection:section]];
                break;
            case EZMContainerChangeStateTransaction: {
                transactionChange = change;
                NSArray<NSIndexPath *> *deleteItems = [[[EZS_Sequence(transactionChange.changes) select:^BOOL(EZMContainerIndexedChange * value) {
                    return EZMContainerChangeStateDelete == value.state;
                }] map:^id _Nonnull(EZMContainerIndexedChange * value) {
                    return [NSIndexPath indexPathForRow:value.index inSection:section];
                }] as:NSArray.class];
                NSArray<NSIndexPath *> *insertItems = [[[EZS_Sequence(transactionChange.changes) select:^BOOL(EZMContainerIndexedChange * value) {
                    return EZMContainerChangeStateInsert == value.state;
                }] map:^id _Nonnull(EZMContainerIndexedChange * value) {
                    return [NSIndexPath indexPathForRow:value.index inSection:section];
                }] as:NSArray.class];
                NSArray<NSArray<NSIndexPath *> *> *movedItems = [[[EZS_Sequence(transactionChange.changes) select:^BOOL(EZMContainerMoveChange * value) {
                    return EZMContainerChangeStateMove == value.state;
                }] map:^id _Nonnull(EZMContainerMoveChange * value) {
                    return @[[NSIndexPath indexPathForRow:value.source inSection:section],
                             [NSIndexPath indexPathForRow:value.destnation inSection:section],
                             ];
                }] as:NSArray.class];
                if (deleteItems.count) {
                    [self deleteItemsAtIndexPaths:deleteItems];
                }
                if (insertItems.count) {
                    [self insertItemsAtIndexPaths:insertItems];
                }
                [EZS_Sequence(movedItems) forEach:^(NSArray<NSIndexPath *> * _Nonnull value) {
                    [self moveItemAtIndexPath:value[0] toIndexPath:value[1]];
                }];
                break;
            }
            default:
                NSAssert(NO, @"无法处理的change类型");
                break;
        }
    };
    
    [self performBatchUpdates:updateBlock completion:completion];
    
    if (EZMContainerChangeStateTransaction == change.state) {
        EZMContainerTransactionChange *transactionChange = change;
        NSArray<NSIndexPath *> *reloadItems = [[[EZS_Sequence(transactionChange.changes) select:^BOOL(EZMContainerIndexedChange * value) {
            return EZMContainerChangeStateUpdate == value.state;
        }] map:^id _Nonnull(EZMContainerIndexedChange * value) {
            return [NSIndexPath indexPathForRow:value.index inSection:section];
        }] as:NSArray.class];
        if (reloadItems.count) {
            [self reloadItemsAtIndexPaths:reloadItems];
        }
    }
}

@end
