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

#import <EasyReact/EasyReact.h>
#import <EasyMVVM/EZMContainerChange.h>

NS_ASSUME_NONNULL_BEGIN

@class EZMContainer, EZMContainerChange;

extern NSString *const EZMContainerException;
extern NSString *const EZMContainerReason_FlushInTransaction;
extern NSString *const EZMContainerReason_MoveInTransaction;
extern NSString *const EZMContainerReason_EndTransacitionNotInTransaction;
extern NSString *const EZMContainerReason_RollBackNotInTransaction;

@interface EZMContainer<__covariant T: id> : NSObject

@property (atomic, readonly, strong) EZRNode<__kindof EZMContainerChange *> *changes;
@property (atomic, readonly, strong) EZRNode<NSNumber *> *count;

- (instancetype)init NS_DESIGNATED_INITIALIZER;
- (instancetype)initWithArray:(NSArray<T> *)array;

- (void)changeTransaction:(void (^)(EZMContainer<T> * _Nonnull container))block;
- (void)beginTransaction;
- (void)endTransaction;
- (void)rollbackTransaction;
- (void)addObject:(T)object at:(NSUInteger)index;
- (void)appendObject:(T)object;
- (void)insertObjectFront:(T)object;
- (void)deleteObjectAt:(NSUInteger)index;
- (void)deleteObject:(T)object;
- (void)deleteFirstObject;
- (void)deleteLastObject;
- (void)exchangeObject:(T)object at:(NSUInteger)index;
- (void)setObject:(T)object atIndexedSubscript:(NSUInteger)index;
- (T)objectAtIndexedSubscript:(NSUInteger)index;
- (void)addObjectsFromArray:(NSArray<T> *)otherArray;
- (void)moveObjectAtIndex:(NSUInteger)sourceIndex toIndex:(NSUInteger)destnationIndex;

- (NSArray<T> *)array;
- (void)setArray:(NSArray<T> *)newArray;

@end

NS_ASSUME_NONNULL_END
