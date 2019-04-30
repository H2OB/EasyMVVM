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
#import "EZMHeckelDiff.h"
#import "EZMContainerChange.h"
#import <EasySequence/EasySequence.h>

typedef NS_ENUM(NSUInteger, EZMContainerCounter) {
    EZMContainerCounterZero,
    EZMContainerCounterOne,
    EZMContainerCounterMany
};

static inline EZMContainerCounter counter_increment(EZMContainerCounter counter) {
    return counter == EZMContainerCounterZero ? EZMContainerCounterOne : EZMContainerCounterMany;
}

@interface ETableEntry : NSObject

@property (nonatomic) EZMContainerCounter oldCounter;
@property (nonatomic) EZMContainerCounter newCounter;
@property (nonatomic, strong) NSMutableArray<NSNumber *> *indexesInOld;

@end

@implementation ETableEntry

- (instancetype)init {
    self = [super init];
    if (self) {
        _oldCounter = EZMContainerCounterZero;
        _newCounter = EZMContainerCounterZero;
        _indexesInOld = [NSMutableArray array];
    }
    return self;
}

- (BOOL)isEqual:(ETableEntry *)object {
    if (![object isKindOfClass:[self class]]) {
        return NO;
    }
    return self.oldCounter == object.oldCounter && self.newCounter == object.newCounter && [self.indexesInOld isEqualToArray:object.indexesInOld];
}

- (NSString *)debugDescription {
    return [NSString stringWithFormat:@"old = \(%@) new = \(%@) indexesOfOld = \(%@)", @(self.oldCounter), @(self.newCounter), self.indexesInOld];
}

@end

typedef NS_ENUM(NSUInteger, EZMArrayEntryType) {
    EZMArrayEntryTypeTable,
    EZMArrayEntryTypeindexInOther
};

@interface EZMArrayEntry : NSObject

@property (nonatomic) EZMArrayEntryType type;

@property (nonatomic, strong) ETableEntry *table;
@property (nonatomic, strong) NSNumber *indexInOther;

+ (instancetype)tableEntry:(ETableEntry *)table;
+ (instancetype)indexEntry:(NSNumber *)index;

@end

@implementation EZMArrayEntry

- (instancetype)initWithType:(EZMArrayEntryType)type table:(nullable ETableEntry *)table indexOfOther:(NSNumber *)index {
    if (self = [super init]) {
        _type = type;
        _table = table;
        _indexInOther = index;
    }
    return self;
}

+ (instancetype)tableEntry:(ETableEntry *)table {
    return [[EZMArrayEntry alloc] initWithType:EZMArrayEntryTypeTable table:table indexOfOther:@0];
}

+ (instancetype)indexEntry:(NSNumber *)index {
    return [[EZMArrayEntry alloc] initWithType:EZMArrayEntryTypeindexInOther table:nil indexOfOther:index];
}

- (BOOL)isEqual:(EZMArrayEntry *)object {
    if (![object isKindOfClass:[self class]]) {
        return NO;
    }
    
    if (self.type != object.type) {
        return NO;
    }
    if (EZMArrayEntryTypeTable == self.type) {
        return [self.table isEqual:object.table];
    } else {
        return [self.indexInOther isEqualToNumber:object.indexInOther];
    }
}

- (NSString *)debugDescription {
    if (EZMArrayEntryTypeTable == self.type) {
        return [self.table debugDescription];
    } else {
        return [NSString stringWithFormat:@"indexInOther = \(%@)", self.indexInOther];
    }
}

@end

@implementation EZMHeckelDiff

- (EZMContainerTransactionChange *)diffFromOld:(NSArray *)old toNew:(NSArray *)new {
    NSArray *preprocessChange = [self preprocess:old toNew:new];
    if (preprocessChange) {
        return [EZMContainerTransactionChange transactionChangeWithChanges:preprocessChange];
    }
    NSMutableDictionary<NSNumber *, ETableEntry *> *table = [NSMutableDictionary dictionary];
    NSMutableArray<EZMArrayEntry *> *oldArray = [NSMutableArray array];
    NSMutableArray<EZMArrayEntry *> *newArray = [NSMutableArray array];
    [self perform1stPass:new table:table newArray:newArray];
    [self perform2ndPass:old table:table oldArray:oldArray];
    [self perform345Pass:newArray oldArray:oldArray];
    NSArray *changes = [self perform6thPass:new old:old newArray:newArray oldArray:oldArray];
    return [EZMContainerTransactionChange transactionChangeWithChanges:changes];
}

- (void)perform1stPass:(NSArray *)new table:(NSMutableDictionary<NSNumber *, ETableEntry *> *)table newArray:(NSMutableArray<EZMArrayEntry *> *)newArray {
    [EZS_Sequence(new) forEach:^(NSObject *value) {
        ETableEntry *entry = table[@(value.hash)];
        if (!entry) {
            entry = [ETableEntry new];
        }
        entry.newCounter = counter_increment(entry.newCounter);
        [newArray addObject:[EZMArrayEntry tableEntry:entry]];
        table[@(value.hash)] = entry;
    }];
}

- (void)perform2ndPass:(NSArray *)old table:(NSMutableDictionary<NSNumber *, ETableEntry *> *)table oldArray:(NSMutableArray<EZMArrayEntry *> *)oldArray {
    [EZS_Sequence(old) forEachWithIndex:^(NSObject *value, NSUInteger index) {
        ETableEntry *entry = table[@(value.hash)];
        if (!entry) {
            entry = [ETableEntry new];
        }
        entry.oldCounter = counter_increment(entry.oldCounter);
        [entry.indexesInOld addObject:@(index)];
        [oldArray addObject:[EZMArrayEntry tableEntry:entry]];
        table[@(value.hash)] = entry;
    }];
}

- (void)perform345Pass:(NSMutableArray<EZMArrayEntry *> *)newArray oldArray:(NSMutableArray<EZMArrayEntry *> *)oldArray {
    [EZS_Sequence([newArray copy]) forEachWithIndex:^(EZMArrayEntry *value, NSUInteger indexOfNew) {
        if (EZMArrayEntryTypeTable == value.type) {
            if (value.table.indexesInOld.count) {
                NSNumber *indexOfOld =  value.table.indexesInOld.firstObject;
                [value.table.indexesInOld removeObjectAtIndex:0];
                BOOL isObservation1 = value.table.newCounter == EZMContainerCounterOne && value.table.oldCounter == EZMContainerCounterOne;
                BOOL isObservation2 = value.table.newCounter != EZMContainerCounterZero && value.table.oldCounter != EZMContainerCounterZero &&
                [newArray[indexOfNew] isEqual: oldArray[indexOfOld.unsignedIntegerValue]];
                if (isObservation1 || isObservation2) {
                    newArray[indexOfNew] = [EZMArrayEntry indexEntry:indexOfOld];
                    oldArray[indexOfOld.unsignedIntegerValue] = [EZMArrayEntry indexEntry:@(indexOfNew)];
                }
            }
        }
    }];
}

- (NSArray<__kindof EZMContainerChange *> *)perform6thPass:(NSArray *)new old:(NSArray *)old newArray:(NSArray<EZMArrayEntry *> *)newArray oldArray:(NSArray<EZMArrayEntry *> *)oldArray {
    NSMutableArray *changes = [NSMutableArray array];
    NSMutableArray<NSNumber *> *deleteOffsets = [NSMutableArray array];
    for (int i = 0; i< old.count; ++i) {
        [deleteOffsets addObject:@0];
    }
    
    {
        //    // deletions
        __block NSUInteger runningOffset = 0;
        [EZS_Sequence(oldArray) forEachWithIndex:^(EZMArrayEntry * _Nonnull value, NSUInteger index) {
            deleteOffsets[index] = @(runningOffset);
            if (value.type != EZMArrayEntryTypeTable) {
                return;
            }
            
            EZMContainerChange *change = [[EZMContainerIndexedChange alloc] initWithState:EZMContainerChangeStateDelete atIndex:index];
            [changes addObject:change];
            ++runningOffset;
        }];
    }
    {
        __block NSUInteger runningOffset = 0;
        [newArray enumerateObjectsUsingBlock:^(EZMArrayEntry * _Nonnull value, NSUInteger index, BOOL * _Nonnull stop) {
            if (EZMArrayEntryTypeTable == value.type) {
                ++runningOffset;
                EZMContainerChange *change = [[EZMContainerIndexedChange alloc] initWithState:EZMContainerChangeStateInsert atIndex:index];
                [changes addObject:change];
            } else {
                NSUInteger oldIndex = value.indexInOther.unsignedIntegerValue;
                if (![old[oldIndex] isEqual:new[index]]) {
                    EZMContainerChange *change = [[EZMContainerIndexedChange alloc] initWithState:EZMContainerChangeStateUpdate atIndex:index];
                    [changes addObject:change];
                    
                }
                NSUInteger deleteOffset = [deleteOffsets[oldIndex] unsignedIntegerValue];
                if ((oldIndex - deleteOffset + runningOffset) != index) {
                    EZMContainerChange *change = [EZMContainerMoveChange changeFromSource:oldIndex toDestnation:index];
                    [changes addObject:change];
                }
            }
        }];
    }
    
    return changes;
}

- (NSArray<EZMContainerIndexedChange *> *)preprocess:(NSArray *)old toNew:(NSArray *)new {
    BOOL oldEmpty = old.count == 0;
    BOOL newEmpty = new.count == 0;
    if (oldEmpty && newEmpty) {
        return @[];
    }
    if (oldEmpty == YES && newEmpty == NO) {
        return [[EZS_Sequence(new) mapWithIndex:^id _Nonnull(id  _Nonnull value, NSUInteger index) {
            return [[EZMContainerIndexedChange alloc] initWithState:(EZMContainerChangeStateInsert) atIndex:index];
        }] as:NSArray.class];
    }
    if (oldEmpty == NO && newEmpty == YES) {
        return [[EZS_Sequence(old) mapWithIndex:^id _Nonnull(id  _Nonnull value, NSUInteger index) {
            return [[EZMContainerIndexedChange alloc] initWithState:(EZMContainerChangeStateDelete) atIndex:index];
        }] as:NSArray.class];
    }
    return nil;
    
}

@end
