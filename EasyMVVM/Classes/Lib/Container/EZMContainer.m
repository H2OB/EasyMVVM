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
#import "EZMHeckelDiff.h"

@interface EZMContainer ()

@property (atomic, readwrite, assign) BOOL inTransaction;
@property (atomic, readwrite, assign) NSUInteger insideCount;
@property (atomic, readwrite, copy) NSArray *immutableArray;
@property (nonatomic, strong) EZMHeckelDiff *diffAlgorithms;

@end

NSString *const EZMContainerException = @"EZMContainerException ";
NSString *const EZMContainerReason_FlushInTransaction = @"can not flush all data in transaction block";
NSString *const EZMContainerReason_EndTransacitionNotInTransaction = @"can not end transaction dost not begin transaction";
NSString *const EZMContainerReason_RollBackNotInTransaction = @"can not rollBack transaction dost not begin transaction";

@implementation EZMContainer {
    EZM_LOCK_DEF(_arrayLock);
    EZM_LOCK_DEF(_transactionLock);
    NSMutableArray *_insideArray;
}

- (instancetype)init {
    if (self = [self initWithArray:nil]) {
        
    }
    return self;
}

- (instancetype)initWithArray:(nullable NSArray<id> *)array {
    if (self = [super init]) {
        EZM_LOCK_INIT(_arrayLock);
        EZM_LOCK_INIT(_transactionLock);
        _insideArray = [NSMutableArray array];
        _inTransaction = NO;
        _changes = [EZRNode new];
        if (array.count) {
            [_insideArray addObjectsFromArray:array];
        }
        _insideCount = _insideArray.count;
        _count = [EZRNode value:@(_insideCount)];
        _immutableArray = [_insideArray copy];
        _diffAlgorithms = [EZMHeckelDiff new];
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
}

- (void)endTransaction {
    if (!self.inTransaction) {
        EZR_THROW(EZMContainerException, EZMContainerReason_EndTransacitionNotInTransaction, nil);
    }
    EZMContainerChange *change = nil;
    {
        EZM_SCOPELOCK(_arrayLock);
        change = [self.diffAlgorithms diffFromOld:self.immutableArray toNew:_insideArray];
        [self updateNode];
    }
    self.changes.mutablify.value = change;
        
    self.inTransaction = NO;
    EZM_UNLOCK(_transactionLock);
}

- (void)rollbackTransaction {
    if (!self.inTransaction) {
        EZR_THROW(EZMContainerException, EZMContainerReason_RollBackNotInTransaction, nil);
    }
    _insideArray = [self.immutableArray mutableCopy];
    self.insideCount = [self.count.value unsignedIntegerValue];
    self.inTransaction = NO;
    EZM_UNLOCK(_transactionLock);
}

- (void)addObject:(id)object at:(NSUInteger)index {
    if (self.inTransaction) {
        EZM_SCOPELOCK(_arrayLock);
        self.insideCount += 1;
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

- (void)removeAllObjects {
    if (self.inTransaction) {
        EZM_SCOPELOCK(_arrayLock);
        self.insideCount = 0;
        [_insideArray removeAllObjects];
    } else {
        [self changeTransaction:^(EZMContainer * _Nonnull container) {
            [container removeAllObjects];
        }];
    }
}

- (void)addObjectsFromArray:(NSArray *)otherArray {
    if (self.inTransaction) {
        EZM_SCOPELOCK(_arrayLock);
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
        EZM_SCOPELOCK(_arrayLock);
        [_insideArray exchangeObjectAtIndex:sourceIndex withObjectAtIndex:destnationIndex];
    }
    EZM_SCOPELOCK(_transactionLock);
    id obj = _insideArray[sourceIndex];
    [_insideArray removeObjectAtIndex:sourceIndex];
    [_insideArray insertObject:obj atIndex:destnationIndex];
    [self updateNode];
    self.changes.mutablify.value = [EZMContainerMoveChange changeFromSource:sourceIndex toDestnation:destnationIndex];
}

- (NSString *)debugDescription {
    return [NSString stringWithFormat:@"Container contain objects :\n %@", self.immutableArray.description];
}

@end
