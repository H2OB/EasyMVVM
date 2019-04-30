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

#import "EZMContainerChange.h"
#import "EZMacrosPrivate.h"
#import <EasyReact/EasyReact.h>

@implementation EZMContainerChange

- (instancetype)initWithState:(EZMContainerChangeState)state {
    if (self = [super init]) {
        _state = state;
    }
    return self;
}

- (BOOL)isEqual:(EZMContainerChange *)object {
    return self.state == object.state;
}

@end

@interface EZMContainerChangeStateController : NSObject

- (EZMContainerChangeState)state;
- (void)change:(EZMContainerIndexedChange *)change beEffectBy:(EZMContainerIndexedChange *)effectChange;

@end

@implementation EZMContainerChangeStateController

- (EZMContainerChangeState)state {
    NSAssert(NO, @"sub class must override");
    return EZMContainerChangeStateUnknown;
}

- (void)change:(EZMContainerIndexedChange *)change beEffectBy:(EZMContainerIndexedChange *)effectChange {
    NSAssert(NO, @"sub class must override");
}

@end

@interface EZMContainerIndexedChange ()

@property (atomic, readwrite, assign) NSUInteger index;
@property (atomic, readwrite, assign) BOOL needDestory;
@property (atomic, readwrite, strong) EZMContainerChangeStateController *stateController;

- (void)beEffectBy:(__kindof EZMContainerIndexedChange *)otherChange;

@end

@interface EZMContainerChangeInsertStateController : EZMContainerChangeStateController

@end

@interface EZMContainerChangeUpdateStateController : EZMContainerChangeStateController

@end

@interface EZMContainerChangeDeleteStateController : EZMContainerChangeStateController

@end

@implementation EZMContainerChangeInsertStateController

- (EZMContainerChangeState)state {
    return EZMContainerChangeStateInsert;
}

- (void)change:(EZMContainerIndexedChange *)change beEffectBy:(EZMContainerIndexedChange *)effectChange {
    switch (effectChange.state) {
            case EZMContainerChangeStateInsert:
            //             "ABCDE"
            //              case 1
            //              insert F at 2 (I 2 )  insertChange G  at 1 (I 1)
            //              "AGBFCDE" result  (I 3) (I 1)
            if (effectChange.index < change.index ) {
                change.index += 1;
                return ;
            }
            //              "ABCDE"
            //              case 2
            //              insert F at 2 (I 2 )  insertChange G  at 2 (I 2)
            //              "ABGFCDE" result  (I 2) (I 3)
            if (change.index == effectChange.index) {
                //            TODO: mofify which
                effectChange.index += 1;
                //                                change.index += 1;
                return ;
            }
            //              "ABCDE"
            //              case 2
            //              insert F at 2 (I 2 )  insertChange G  at 3 (I 3)
            //              "ABFGCDE" result  (I 2) (I 3)
            if (effectChange.index > change.index) {
                // nothing change
                return ;
            }
            break;
            case EZMContainerChangeStateDelete:
            //             "ABCDE"
            //              case 1
            //              insert F at 2 (I 2 )  delete B  at 1 (D 1)
            //              "AFCDE" result  (I 1) (D 1)
            if (effectChange.index < change.index ) {
                change.index -= 1;
                return ;
            }
            //              "ABCDE"
            //              case 2
            //              insert F at 2 (I 2 )  delete B  at 2 (D 2)
            //              "ABCDE" result ()
            if (change.index == effectChange.index) {
                change.needDestory = YES;
                effectChange.needDestory = YES;
                return ;
            }
            //              "ABCDE"
            //              case 2
            //              insert F at 2 (I 2 )  delete C  at 3 (D 2)
            //              "ABFDE" result  (I 2) (D 2)
            if (effectChange.index > change.index) {
                //                effectChange.index -= 1;
                return ;
            }
            break;
            case EZMContainerChangeStateUpdate:
            //             "ABCDE"
            //              case 1
            //              insert F at 2 (I 2 )  update 'G'  at 1 (U 1)
            //              "AGFCDE" result  (I 2) (U 1)
            if (effectChange.index < change.index ) {
                // nothing change
                return ;
            }
            //              "ABCDE"
            //              case 2
            //              insert F at 2 (I 2 )  update 'G'  at 2 (U 2)
            //              "ABGCDE" result (I 2)
            if (change.index == effectChange.index) {
                effectChange.needDestory = YES;
                return ;
            }
            //              "ABCDE"
            //              case 2
            //              insert F at 2 (I 2 )  update 'G'  at 3 (U 3)
            //              "ABFGDE" result  (I 2) (U 2)
            if (effectChange.index > change.index) {
                effectChange.index -= 1;
                
                return ;
            }
            break;
            
        default:
            break;
    }
}

- (BOOL)isEqual:(EZMContainerChangeStateController *)object {
    return [self state] == [object state];
}

@end

@implementation EZMContainerChangeUpdateStateController

- (EZMContainerChangeState)state {
    return EZMContainerChangeStateUpdate;
}

- (void)change:(EZMContainerIndexedChange *)change beEffectBy:(EZMContainerIndexedChange *)effectChange {
    switch (effectChange.state) {
            case EZMContainerChangeStateInsert:
            //             "ABCDE"
            //              case 1
            //              updateChange C->F(U 2 )  insertChange G  at 1 (I 1)
            //              "AGBFDE" result  (U 2) (I 1)
            if (effectChange.index < change.index ) {
                // nothing change
                return ;
            }
            //              "ABCDE"
            //              case 2
            //              updateChange C->F(U 2 )  insertChange G at 2 (I 2)
            //              "ABGFDE" result  (U 2) (I 2)
            if (change.index == effectChange.index) {
                // nothing change
                return ;
            }
            //              "ABCDE"
            //              case 2
            //              updateChange C->F(U 2 )  insertChange G at 3 (I 3)
            //              "ABFGDE" result  (U 2) (I 3)
            if (effectChange.index > change.index) {
                // nothing change
                return ;
            }
            break;
            case EZMContainerChangeStateDelete:
            //             "ABCDE"
            //              case 1
            //              updateChange C->F(U 2 )  deleteChange B (D1)
            //              "AFDE" result  (D 1) (U 1)
            if (effectChange.index < change.index ) {
                // nothing change
                return ;
            }
            //              "ABCDE"
            //              case 2
            //              updateChange C->F(U 2 )  deleteChange F (D 2)
            //              "ABDE" result (D 2)
            if (change.index == effectChange.index) {
                change.needDestory = YES;
                return ;
            }
            //              "ABCDE"
            //              case 2
            //              updateChange C->F(U 2 )  deleteChange 'D' (D 3)
            //              "ABFE" result (U 2) (D 3)
            if (effectChange.index > change.index) {
                // nothing change
                return ;
            }
            
            break;
            case EZMContainerChangeStateUpdate:
            if (change.index == effectChange.index) {
                effectChange.needDestory = YES;
            }
            break;
            
        default:
            break;
    }
}

- (BOOL)isEqual:(EZMContainerChangeStateController *)object {
    return [self state] == [object state];
}

@end

@implementation EZMContainerChangeDeleteStateController

- (EZMContainerChangeState)state {
    return EZMContainerChangeStateDelete;
}

- (void)change:(EZMContainerIndexedChange *)change beEffectBy:(EZMContainerIndexedChange *)effectChange {
    switch (effectChange.state) {
            case EZMContainerChangeStateInsert:
            //             "ABCDE"
            //              case 1
            //              delete C At 2 (D 2 )  insertChange G  at 1 (I 1)
            //              "AGBDE" result  (D 2) (I 1)
            if (effectChange.index < change.index ) {
                // nothing change
                return ;
            }
            //              "ABCDE"
            //              case 2
            //              delete C At 2 (D 2 )  insertChange G  at 2 (I 2)
            //              "ABGDE" result  (u 2)
            if (change.index == effectChange.index) {
                // nothing change
                change.stateController = [EZMContainerChangeUpdateStateController new];
                effectChange.needDestory = YES;
                return ;
            }
            //              "ABCDE"
            //              case 2
            //              delete C At 2 (D 2 )  insertChange G  at 2 (I 3)
            //              "ABDGE" result  (D 2) (I 3)
            if (effectChange.index > change.index) {
                // nothing change
                return ;
            }
            break;
            case EZMContainerChangeStateDelete:
            //             "ABCDE"
            //              case 1
            //              delete C At 2 (D 2 )  delete B  at 1 (D 1)
            //              "ADE" result  (D 2) (D 1)
            if (effectChange.index < change.index ) {
                // nothing change
                return ;
            }
            //              "ABCDE"
            //              case 2
            //              delete C At 2 (D 2 )  delete D  at 2 (D 2)
            //              "ABE" result  (D 2) (D 3)
            if (change.index == effectChange.index) {
                //            TODO: mofify which
                effectChange.index += 1;
                //                change.index += 1;
                return ;
            }
            //              "ABCDE"
            //              case 2
            //              delete C At 2 (D 2 )  Delete E  at 3 (D 3)
            //              "ABD" result  (D 2)  (D 4)
            if (effectChange.index > change.index) {
                effectChange.index += 1;
                return ;
            }
            break;
            case EZMContainerChangeStateUpdate:
            //             "ABCDE"
            //              case 1
            //              delete C At 2 (D 2 )  updateChange F  at 1 (U 1)
            //              "AFDE" result  (D 2) (U 1)
            if (effectChange.index < change.index ) {
                // nothing change
                return ;
            }
            //              "ABCDE"
            //              case 2
            //              delete C At 2 (D 2 )  updateChange F  at 2 (U 2)
            //              "ABFE" result  (D 2) (U 3)
            if (change.index == effectChange.index) {
                effectChange.index += 1;
                return ;
            }
            //              "ABCDE"
            //              case 2
            //              delete C At 2 (D 2 )  updateChange F  at 3 (U 3)
            //              "ABDF" result  (D 2) (U 4)
            if (effectChange.index > change.index) {
                effectChange.index  += 1;
                return ;
            }
            break;
            
        default:
            break;
    }
}

- (BOOL)isEqual:(EZMContainerChangeStateController *)object {
    return [self state] == [object state];
}

@end

@implementation EZMContainerIndexedChange

- (instancetype)initWithState:(EZMContainerChangeState)state atIndex:(NSUInteger)index {
    if (self = [super initWithState:state]) {
        _index = index;
        switch (state) {
                case EZMContainerChangeStateInsert:
                _stateController = [EZMContainerChangeInsertStateController new];
                break;
                case EZMContainerChangeStateUpdate:
                _stateController = [EZMContainerChangeUpdateStateController new];
                break;
                case EZMContainerChangeStateDelete:
                _stateController = [EZMContainerChangeDeleteStateController new];
                break;
                
            default:
                break;
        }
    }
    return self;
}

- (void)beEffectBy:(__kindof EZMContainerIndexedChange *)otherChange {
    [self.stateController change:self beEffectBy:otherChange];
}

- (EZMContainerChangeState)state {
    return [self.stateController state];
}


- (BOOL)isEqual:(EZMContainerIndexedChange *)object {
    return [self state] == [object state] && self.index == object.index;
}

@end


@implementation EZMContainerTransactionChange {
    NSMutableArray<EZMContainerIndexedChange *> *_insideChanges;
    EZM_LOCK_DEF(_insideChangeLock);
}

- (instancetype)init {
    if (self = [super initWithState:EZMContainerChangeStateTransaction]) {
        _insideChanges = [NSMutableArray array];
        EZM_LOCK_INIT(_insideChangeLock);
    }
    return self;
}

+ (instancetype)transactionChange {
    return [[self alloc] init];
}

- (void)appendChange:(EZMContainerIndexedChange *)change {
    EZM_SCOPELOCK(_insideChangeLock);
    
    _insideChanges = [[[_insideChanges.EZS_asSequence select:^BOOL(EZMContainerIndexedChange * _Nonnull value) {
        [value beEffectBy:change];
        return !value.needDestory;
    }] as:[NSMutableArray class]] mutableCopy];
    
    if (!change.needDestory) {
        [_insideChanges addObject:change];
    }
}

- (NSArray<EZMContainerIndexedChange *> *)changes {
    EZM_SCOPELOCK(_insideChangeLock);
    return [_insideChanges copy];
}

- (BOOL)isEqual:(EZMContainerTransactionChange *)object {
    return self.state == object.state && [self.changes isEqual:object.changes];
}

@end

@implementation EZMContainerFlushChange

+ (instancetype)flushChange {
    return [[self alloc] initWithState:EZMContainerChangeStateFlush];
}

- (BOOL)isEqual:(EZMContainerFlushChange *)object {
    return [self state] == [object state];
}

@end

@implementation EZMContainerMoveChange

- (instancetype)initWithSource:(NSUInteger)source toDestnation:(NSUInteger)destnation {
    if (self = [super initWithState:EZMContainerChangeStateMove]) {
        _source = source;
        _destnation = destnation;
    }
    return self;
}

+ (instancetype)changeFromSource:(NSUInteger)source toDestnation:(NSUInteger)destnation {
    return [[self alloc] initWithSource:source toDestnation:destnation];
}

- (BOOL)isEqual:(EZMContainerMoveChange *)object {
    return [self state] == [object state] && self.source == object.source && self.destnation == object.destnation;
}


@end
