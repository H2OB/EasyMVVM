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

#import "EZMContainer.h"
#import "EZMacrosPrivate.h"

@interface EZMContainer ()

@property (atomic, readwrite, assign) BOOL inTransaction;
@property (atomic, readwrite, assign) NSUInteger insideCount;
@property (atomic, readwrite, copy) NSArray *immutableArray;

@end

NSString *const EZMContainerException = @"EZMContainerException ";
NSString *const EZMContainerReason_FlushInTransaction = @"can not flush all data in transaction block";
NSString *const EZMContainerReason_MoveInTransaction = @"can not move object in transaction block";
NSString *const EZMContainerReason_EndTransacitionNotInTransaction = @"can not end transaction dost not begin transaction";
NSString *const EZMContainerReason_RollBackNotInTransaction = @"can not rollBack transaction dost not begin transaction";

@implementation EZMContainer {
    EZM_LOCK_DEF(_arrayLock);
    EZM_LOCK_DEF(_transactionLock);
    NSMutableArray *_insideArray;
    EZMContainerTransactionChange *_transactionChanges;
}

- (instancetype)init {
    if (self = [super init]) {
        EZM_LOCK_INIT(_arrayLock);
        EZM_LOCK_INIT(_transactionLock);
        _insideArray = [NSMutableArray array];
        _inTransaction = NO;
        _insideCount = 0;
        _immutableArray = @[];
        _changes = [EZRNode new];
        _count = [EZRNode value:@0];
    }
    return self;
}

- (instancetype)initWithArray:(NSArray<id> *)array {
    if (self = [self init]) {
        [_insideArray addObjectsFromArray:array];
        _insideCount = array.count;
        _count.mutablify.value = @(_insideCount);
        _immutableArray = [_insideArray copy];
    }
    return self;
}

- (void)changeTransaction:(void (^)(EZMContainer<id> * _Nonnull container))block {
    [self beginTransaction];
    block(self);
    [self endTransaction];
}

- (void)beginTransaction {
    EZM_LOCK(_transactionLock);
    self.inTransaction = YES;
    _transactionChanges = [EZMContainerTransactionChange transactionChange];
}

- (void)endTransaction {
    if (!self.inTransaction) {
        EZR_THROW(EZMContainerException, EZMContainerReason_EndTransacitionNotInTransaction, nil);
    }
    [self updateNode];
    
    //TODO: 这里需要调整所有的事件的聚合为正确的
    self.changes.mutablify.value = [EZMContainerFlushChange flushChange];
    
    self.inTransaction = NO;
    _transactionChanges = nil;
    EZM_UNLOCK(_transactionLock);
}

- (void)rollbackTransaction {
    if (!self.inTransaction) {
        EZR_THROW(EZMContainerException, EZMContainerReason_RollBackNotInTransaction, nil);
    }
    _insideArray = [self.immutableArray mutableCopy];
    self.insideCount = [self.count.value unsignedIntegerValue];
    self.inTransaction = NO;
    _transactionChanges = nil;
    EZM_UNLOCK(_transactionLock);
}

- (void)addObject:(id)object at:(NSUInteger)index {
    if (self.inTransaction) {
        EZM_SCOPELOCK(_arrayLock);
        self.insideCount += 1;
        EZMContainerIndexedChange *change = [[EZMContainerIndexedChange alloc] initWithState:EZMContainerChangeStateInsert
                                                                                     atIndex:index];
        [_transactionChanges appendChange:change];
        [_insideArray insertObject:object atIndex:index];
    } else {
        EZM_SCOPELOCK(_transactionLock);
        self.insideCount += 1;
        [_insideArray insertObject:object atIndex:index];
        [self updateNode];
        self.changes.mutablify.value = [[EZMContainerIndexedChange alloc] initWithState:EZMContainerChangeStateInsert atIndex:index];
    }
}

- (void)appendObject:(id)object {
    [self addObject:object at:self.insideCount];
}

- (void)insertObjectFront:(id)object {
    [self addObject:object at:0];
}

- (void)deleteObjectAt:(NSUInteger)index {
    if (self.inTransaction) {
        EZM_SCOPELOCK(_arrayLock);
        self.insideCount -= 1;
        EZMContainerIndexedChange *change = [[EZMContainerIndexedChange alloc] initWithState:EZMContainerChangeStateDelete
                                                                                     atIndex:index];
        [_transactionChanges appendChange:change];
        [_insideArray removeObjectAtIndex:index];
    } else {
        EZM_SCOPELOCK(_transactionLock);
        self.insideCount -= 1;
        [_insideArray removeObjectAtIndex:index];
        [self updateNode];
        self.changes.mutablify.value = [[EZMContainerIndexedChange alloc] initWithState:EZMContainerChangeStateDelete atIndex:index];
    }
}

- (void)deleteObject:(id)object {
    if (self.inTransaction) {
        EZM_SCOPELOCK(_arrayLock);
        NSInteger index = [_insideArray indexOfObject:object];
        NSAssert(index != NSNotFound, @"remove object isn't exist!");
        if (index == NSNotFound) { return ;}
        EZMContainerIndexedChange *change = [[EZMContainerIndexedChange alloc] initWithState:EZMContainerChangeStateDelete
                                                                                     atIndex:index];
        [_transactionChanges appendChange:change];
        self.insideCount -= 1;
        [_insideArray removeObjectAtIndex:index];
    } else {
        EZM_SCOPELOCK(_transactionLock);
        NSUInteger index = [_insideArray indexOfObject:object];
        NSAssert(index != NSNotFound, @"remove object isn't exist!");
        if (index == NSNotFound) { return ;}
        self.insideCount -= 1;
        [_insideArray removeObjectAtIndex:index];
        [self updateNode];
        self.changes.mutablify.value = [[EZMContainerIndexedChange alloc] initWithState:EZMContainerChangeStateDelete atIndex:index];
    }
}

- (void)deleteFirstObject {
    [self deleteObjectAt:0];
}

- (void)deleteLastObject {
    [self deleteObjectAt:self.insideCount - 1];
}

- (void)exchangeObject:(id)object at:(NSUInteger)index {
    if (self.inTransaction) {
        EZM_SCOPELOCK(_arrayLock);
        EZMContainerIndexedChange *change = [[EZMContainerIndexedChange alloc] initWithState:EZMContainerChangeStateUpdate
                                                                                     atIndex:index];
        [_transactionChanges appendChange:change];
        _insideArray[index] = object;
    } else {
        EZM_SCOPELOCK(_transactionLock);
        _insideArray[index] = object;
        [self updateNode];
        self.changes.mutablify.value = [[EZMContainerIndexedChange alloc] initWithState:EZMContainerChangeStateUpdate atIndex:index];
    }
}

- (void)setObject:(id)object atIndexedSubscript:(NSUInteger)index {
    [self exchangeObject:object at:index];
}

- (id)objectAtIndexedSubscript:(NSUInteger)index {
    return self.immutableArray[index];
}

- (void)updateNode {
    // 此处注意需要在事务中调用，否则会有线程安全问题
    self.immutableArray = _insideArray;
    self.count.mutablify.value = @(self.insideCount);
}

- (NSArray *)array {
    return self.immutableArray;
}

- (void)setArray:(NSArray *)newArray {
    if (self.inTransaction) {
        EZR_THROW(EZMContainerException, EZMContainerReason_FlushInTransaction, nil);
    }
    EZM_SCOPELOCK(_transactionLock);
    self.insideCount = newArray.count;
    _insideArray = [newArray mutableCopy];
    self.immutableArray = [_insideArray copy];
    self.count.mutablify.value = @(self.insideCount);
    self.changes.mutablify.value = [EZMContainerFlushChange flushChange];
}

- (void)addObjectsFromArray:(NSArray *)otherArray {
    if (self.inTransaction) {
        EZM_SCOPELOCK(_arrayLock);
        NSUInteger startIndex = self.insideCount;
        
        [[otherArray.EZS_asSequence mapWithIndex:^id _Nonnull(id  _Nonnull value, NSUInteger index) {
            return [[EZMContainerIndexedChange alloc] initWithState:EZMContainerChangeStateInsert atIndex:startIndex + index];
        }] forEach:^(id  _Nonnull value) {
            [self->_transactionChanges appendChange:value];
        }];
        
        self.insideCount += otherArray.count;
        [_insideArray addObjectsFromArray:otherArray];
    } else {
        [self changeTransaction:^(EZMContainer * _Nonnull container) {
            [container addObjectsFromArray:otherArray];
        }];
    }
}

- (void)moveObjectAtIndex:(NSUInteger)sourceIndex toIndex:(NSUInteger)destnationIndex {
    if (self.inTransaction) {
        EZR_THROW(EZMContainerException, EZMContainerReason_MoveInTransaction, nil);
    }
    EZM_SCOPELOCK(_transactionLock);
    id obj = _insideArray[sourceIndex];
    [_insideArray removeObjectAtIndex:sourceIndex];
    [_insideArray insertObject:obj atIndex:destnationIndex];
    [self updateNode];
    self.changes.mutablify.value = [EZMContainerMoveChange changeFromSource:sourceIndex toDestnation:destnationIndex];
}

- (NSString *)description {
    return [NSString stringWithFormat:@"Container contain objects :\n %@", self.immutableArray.description];
}

@end
