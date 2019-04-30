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

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, EZMContainerChangeState) {
    EZMContainerChangeStateUnknown = -1,
    EZMContainerChangeStateTransaction,
    EZMContainerChangeStateFlush,
    EZMContainerChangeStateInsert,
    EZMContainerChangeStateDelete,
    EZMContainerChangeStateUpdate,
    EZMContainerChangeStateMove,
};

@interface EZMContainerChange : NSObject

@property (nonatomic, readonly, assign) EZMContainerChangeState state;

- (instancetype)init __unavailable;
+ (instancetype)new __unavailable;;

@end

@interface EZMContainerMoveChange : EZMContainerChange

@property (nonatomic, readonly, assign) NSUInteger source;
@property (nonatomic, readonly, assign) NSUInteger destnation;

+ (instancetype)changeFromSource:(NSUInteger)source toDestnation:(NSUInteger)destnation;

- (instancetype)init __unavailable;
+ (instancetype)new __unavailable;

@end

@interface EZMContainerIndexedChange : EZMContainerChange

@property (atomic, readonly, assign) NSUInteger index;
@property (atomic, readonly, assign) BOOL needDestory;

- (instancetype)initWithState:(EZMContainerChangeState)state atIndex:(NSUInteger)index;

- (instancetype)init __unavailable;
+ (instancetype)new __unavailable;

@end

@interface EZMContainerFlushChange : EZMContainerChange

+ (instancetype)flushChange;

- (instancetype)init __unavailable;
+ (instancetype)new __unavailable;;

@end

@interface EZMContainerTransactionChange : EZMContainerChange

@property (nonatomic, readonly, copy, nullable) NSArray<EZMContainerIndexedChange *> *changes;

+ (instancetype)transactionChange;

- (instancetype)init __unavailable;
- (instancetype)new __unavailable;;

- (void)appendChange:(EZMContainerIndexedChange *)change;

@end

NS_ASSUME_NONNULL_END
