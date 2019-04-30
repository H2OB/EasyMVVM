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

static inline EZMContainerIndexedChange * indexChange(EZMContainerChangeState state, uint index) {
    return [[EZMContainerIndexedChange alloc] initWithState:state atIndex:index];
}

static inline EZMContainerMoveChange * moveChaneg(uint source, uint destnation) {
    return [EZMContainerMoveChange changeFromSource:source toDestnation:destnation];
}

QuickSpecBegin(EZMContainerSpec)

describe(@"EZMContainer test", ^{
    context(@"initalize ERDataContainer", ^{
        it(@"can initalize with empty data", ^{
            EZMContainer<NSNumber *> *container = [[EZMContainer alloc] init];
            expect([container array]).to(beEmpty());
            expect(container.count.value).to(equal(@0));
            expect(container.changes.value).to(equal(EZREmpty.new));
        });
        
        it(@"can initalize with data", ^{
            NSArray<NSNumber *> *array = @[@1, @2];
            EZMContainer<NSNumber *> *container = [[EZMContainer alloc] initWithArray:array];
            expect([container array]).to(equal(array));
            expect(container.count.value).to(equal(@2));
            expect(container.changes.value).to(equal(EZREmpty.new));
            expect([container array]).to(equal(@[@1, @2]));
        });
        
    });
    
    context(@"not in transcation block", ^{
        context(@"add object methods", ^{
            it(@"can effect changes and count use `addObject:at:` method", ^{
                NSObject *listener = [NSObject new];
                NSArray<NSNumber *> *array = @[@1, @2];
                EZMContainer<NSNumber *> *container = [[EZMContainer alloc] initWithArray:array];
                [container.count startListenForTestWithObj:listener];
                [container.changes startListenForTestWithObj:listener];
                [container addObject:@3 at:1];
                [container addObject:@4 at:0];
                EZMContainerChange *change1 = [[EZMContainerIndexedChange alloc] initWithState:EZMContainerChangeStateInsert atIndex:1];
                EZMContainerChange *change2 = [[EZMContainerIndexedChange alloc] initWithState:EZMContainerChangeStateInsert atIndex:0];
                expect(container.count).to(receive(@[@2, @3, @4]));
                expect(container.changes).to(receive(@[change1, change2]));
                expect(container.changes.value).to(equal(change2));
                expect(container.count.value).to(equal(@4));
                expect([container array]).to(equal(@[@4, @1, @3, @2]));
            });
            
            it(@"can effect changes and count use `appendObject` method", ^{
                NSObject *listener = [NSObject new];
                NSArray<NSNumber *> *array = @[@1, @2];
                EZMContainer<NSNumber *> *container = [[EZMContainer alloc] initWithArray:array];
                [container.count startListenForTestWithObj:listener];
                [container.changes startListenForTestWithObj:listener];
                [container appendObject:@10];
                [container appendObject:@11];
                
                EZMContainerChange *change1 = [[EZMContainerIndexedChange alloc] initWithState:EZMContainerChangeStateInsert atIndex:2];
                EZMContainerChange *change2 = [[EZMContainerIndexedChange alloc] initWithState:EZMContainerChangeStateInsert atIndex:3];
                expect(container.count).to(receive(@[@2, @3, @4]));
                expect(container.changes).to(receive(@[change1, change2]));
                expect(container.changes.value).to(equal(change2));
                expect(container.count.value).to(equal(@4));
                expect([container array]).to(equal(@[@1, @2, @10, @11]));
            });
            
            it(@"can effect changes and count use `insertObjectFront` method", ^{
                NSObject *listener = [NSObject new];
                NSArray<NSNumber *> *array = @[@1, @2];
                EZMContainer<NSNumber *> *container = [[EZMContainer alloc] initWithArray:array];
                [container.count startListenForTestWithObj:listener];
                [container.changes startListenForTestWithObj:listener];
                [container insertObjectFront:@3];
                [container insertObjectFront:@4];
                
                EZMContainerChange *change1 = [[EZMContainerIndexedChange alloc] initWithState:EZMContainerChangeStateInsert atIndex:0];
                EZMContainerChange *change2 = [[EZMContainerIndexedChange alloc] initWithState:EZMContainerChangeStateInsert atIndex:0];
                expect(container.count).to(receive(@[@2, @3, @4]));
                expect(container.changes).to(receive(@[change1, change2]));
                expect(container.changes.value).to(equal(change2));
                expect(container.count.value).to(equal(@4));
                expect([container array]).to(equal(@[@4, @3, @1, @2]));
            });
            
            it(@"can effect changes and count use `addObjectsFromArray` method", ^{
                NSObject *listener = [NSObject new];
                NSArray<NSNumber *> *array = @[@1, @2, @3, @4];
                EZMContainer<NSNumber *> *container = [[EZMContainer alloc] initWithArray:@[]];
                [container.count startListenForTestWithObj:listener];
                [container.changes startListenForTestWithObj:listener];
                [container addObjectsFromArray:array];
                
                EZMContainerChange *change1 = [[EZMContainerIndexedChange alloc] initWithState:EZMContainerChangeStateInsert atIndex:0];
                EZMContainerChange *change2 = [[EZMContainerIndexedChange alloc] initWithState:EZMContainerChangeStateInsert atIndex:1];
                EZMContainerChange *change3 = [[EZMContainerIndexedChange alloc] initWithState:EZMContainerChangeStateInsert atIndex:2];
                EZMContainerChange *change4 = [[EZMContainerIndexedChange alloc] initWithState:EZMContainerChangeStateInsert atIndex:3];
                EZMContainerTransactionChange *change = [EZMContainerTransactionChange transactionChangeWithChanges:@[change1, change2, change3, change4]];
                expect(container.count).to(receive(@[@0, @4]));
                expect(container.changes).to(receive(@[change]));
                expect(container.changes.value).to(equal(change));
                expect(container.count.value).to(equal(@4));
                expect([container array]).to(equal(@[@1, @2, @3, @4]));
            });
        });
        
        context(@"delete object methods", ^{
            it(@"can effect changes and count use `deleteObjectAt:` method", ^{
                NSObject *listener = [NSObject new];
                NSArray<NSNumber *> *array = @[@1, @2, @3, @4];
                EZMContainer<NSNumber *> *container = [[EZMContainer alloc] initWithArray:array];
                [container.count startListenForTestWithObj:listener];
                [container.changes startListenForTestWithObj:listener];
                [container deleteObjectAt:2];
                [container deleteObjectAt:0];
                
                EZMContainerChange *change1 = [[EZMContainerIndexedChange alloc] initWithState:EZMContainerChangeStateDelete atIndex:2];
                EZMContainerChange *change2 = [[EZMContainerIndexedChange alloc] initWithState:EZMContainerChangeStateDelete atIndex:0];
                expect(container.count).to(receive(@[@4, @3, @2]));
                expect(container.changes).to(receive(@[change1, change2]));
                expect(container.changes.value).to(equal(change2));
                expect(container.count.value).to(equal(@2));
                expect([container array]).to(equal(@[@2, @4]));
            });
            
            it(@"can effect changes and count use `deleteObject:` method", ^{
                NSObject *listener = [NSObject new];
                NSArray<NSNumber *> *array = @[@1, @2, @3, @4];
                EZMContainer<NSNumber *> *container = [[EZMContainer alloc] initWithArray:array];
                [container.count startListenForTestWithObj:listener];
                [container.changes startListenForTestWithObj:listener];
                [container deleteObject:@1];
                [container deleteObject:@3];
                [[container.changes listenedBy:listener] withBlock:^(__kindof EZMContainerChange * _Nullable next) {
                    NSLog(@"change is %@", next);
                }];
                EZMContainerChange *change1 = [[EZMContainerIndexedChange alloc] initWithState:EZMContainerChangeStateDelete atIndex:0];
                EZMContainerChange *change2 = [[EZMContainerIndexedChange alloc] initWithState:EZMContainerChangeStateDelete atIndex:1];
                expect(container.count).to(receive(@[@4, @3, @2]));
                expect(container.changes).to(receive(@[change1, change2]));
                expect(container.changes.value).to(equal(change2));
                expect(container.count.value).to(equal(@2));
                expect([container array]).to(equal(@[@2, @4]));
            });
            
            it(@"can effect changes and count use `deleteFirstObject` method", ^{
                NSObject *listener = [NSObject new];
                NSArray<NSNumber *> *array = @[@1, @2, @3, @4];
                EZMContainer<NSNumber *> *container = [[EZMContainer alloc] initWithArray:array];
                [container.count startListenForTestWithObj:listener];
                [container.changes startListenForTestWithObj:listener];
                [container deleteFirstObject];
                [container deleteFirstObject];
                
                EZMContainerChange *change1 = [[EZMContainerIndexedChange alloc] initWithState:EZMContainerChangeStateDelete atIndex:0];
                EZMContainerChange *change2 = [[EZMContainerIndexedChange alloc] initWithState:EZMContainerChangeStateDelete atIndex:0];
                expect(container.count).to(receive(@[@4, @3, @2]));
                expect(container.changes).to(receive(@[change1, change2]));
                expect(container.changes.value).to(equal(change2));
                expect(container.count.value).to(equal(@2));
                expect([container array]).to(equal(@[@3, @4]));
            });
            
            it(@"can effect changes and count use `deleteLastObject` method", ^{
                NSObject *listener = [NSObject new];
                NSArray<NSNumber *> *array = @[@1, @2, @3, @4];
                EZMContainer<NSNumber *> *container = [[EZMContainer alloc] initWithArray:array];
                [container.count startListenForTestWithObj:listener];
                [container.changes startListenForTestWithObj:listener];
                [container deleteLastObject];
                [container deleteLastObject];
                
                EZMContainerChange *change1 = [[EZMContainerIndexedChange alloc] initWithState:EZMContainerChangeStateDelete atIndex:3];
                EZMContainerChange *change2 = [[EZMContainerIndexedChange alloc] initWithState:EZMContainerChangeStateDelete atIndex:2];
                expect(container.count).to(receive(@[@4, @3, @2]));
                expect(container.changes).to(receive(@[change1, change2]));
                expect(container.changes.value).to(equal(change2));
                expect(container.count.value).to(equal(@2));
                expect([container array]).to(equal(@[@1, @2]));
            });
            
            it(@"can effect changes and count use `removeAllObjects` method", ^{
                NSObject *listener = [NSObject new];
                NSArray<NSNumber *> *array = @[@1, @2, @3, @4];
                EZMContainer<NSNumber *> *container = [[EZMContainer alloc] initWithArray:array];
                [container.count startListenForTestWithObj:listener];
                [container.changes startListenForTestWithObj:listener];
                [container removeAllObjects];
                
                EZMContainerChange *change1 = [[EZMContainerIndexedChange alloc] initWithState:EZMContainerChangeStateDelete atIndex:0];
                EZMContainerChange *change2 = [[EZMContainerIndexedChange alloc] initWithState:EZMContainerChangeStateDelete atIndex:1];
                EZMContainerChange *change3 = [[EZMContainerIndexedChange alloc] initWithState:EZMContainerChangeStateDelete atIndex:2];
                EZMContainerChange *change4 = [[EZMContainerIndexedChange alloc] initWithState:EZMContainerChangeStateDelete atIndex:3];
                EZMContainerTransactionChange *change = [EZMContainerTransactionChange transactionChangeWithChanges:@[change1, change2, change3, change4]];
                expect(container.count).to(receive(@[@4, @0]));
                expect(container.changes).to(receive(@[change]));
                expect(container.changes.value).to(equal(change));
                expect(container.count.value).to(equal(@0));
                expect([container array]).to(equal(@[]));
            });
        });
        
        context(@"update object methods", ^{
            it(@"can effect changes and count use `exchangeObject:` method", ^{
                NSObject *listener = [NSObject new];
                NSArray<NSNumber *> *array = @[@1, @2, @3, @4];
                EZMContainer<NSNumber *> *container = [[EZMContainer alloc] initWithArray:array];
                [container.count startListenForTestWithObj:listener];
                [container.changes startListenForTestWithObj:listener];
                [container exchangeObject:@10 at:2];
                [container exchangeObject:@113 at:0];
                
                EZMContainerChange *change1 = [[EZMContainerIndexedChange alloc] initWithState:EZMContainerChangeStateUpdate atIndex:2];
                EZMContainerChange *change2 = [[EZMContainerIndexedChange alloc] initWithState:EZMContainerChangeStateUpdate atIndex:0];
                expect(container.count).to(receive(@[@4, @4, @4]));
                expect(container.changes).to(receive(@[change1, change2]));
                expect(container.changes.value).to(equal(change2));
                expect(container.count.value).to(equal(@4));
                expect([container array]).to(equal(@[@113, @2, @10, @4]));
            });
            
            it(@"can effect changes and count use `subscriptMethod:` method", ^{
                NSObject *listener = [NSObject new];
                NSArray<NSNumber *> *array = @[@1, @2, @3, @4];
                EZMContainer<NSNumber *> *container = [[EZMContainer alloc] initWithArray:array];
                [container.count startListenForTestWithObj:listener];
                [container.changes startListenForTestWithObj:listener];
                container[2] = @11;
                container[0] = @11;
                
                EZMContainerChange *change1 = [[EZMContainerIndexedChange alloc] initWithState:EZMContainerChangeStateUpdate atIndex:2];
                EZMContainerChange *change2 = [[EZMContainerIndexedChange alloc] initWithState:EZMContainerChangeStateUpdate atIndex:0];
                expect(container.count).to(receive(@[@4, @4, @4]));
                expect(container.changes).to(receive(@[change1, change2]));
                expect(container.changes.value).to(equal(change2));
                expect(container.count.value).to(equal(@4));
                expect([container array]).to(equal(@[@11, @2, @11, @4]));
            });
        });
        
        context(@"flush all objects methods", ^{
            it(@"can effect changes and count use `setArray:` method", ^{
                NSObject *listener = [NSObject new];
                NSArray<NSNumber *> *array = @[@1, @2, @3, @4];
                EZMContainer<NSNumber *> *container = [[EZMContainer alloc] initWithArray:array];
                [container.count startListenForTestWithObj:listener];
                [container.changes startListenForTestWithObj:listener];
                [container setArray:@[@1, @2, @100, @3542, @423]];
                
                EZMContainerChange *change1 = [EZMContainerFlushChange flushChange];
                expect(container.count).to(receive(@[@4, @5]));
                expect(container.changes).to(receive(@[change1]));
                expect(container.changes.value).to(equal(change1));
                expect(container.count.value).to(equal(@5));
                expect([container array]).to(equal(@[@1, @2, @100, @3542, @423]));
            });
        });
        
        context(@"move object methods", ^{
            it(@"can effect changes and count use `moveObjectAtIndex:toIndex` method", ^{
                NSObject *listener = [NSObject new];
                NSArray<NSNumber *> *array = @[@1, @2, @3, @4, @5];
                EZMContainer<NSNumber *> *container = [[EZMContainer alloc] initWithArray:array];
                [container.count startListenForTestWithObj:listener];
                [container.changes startListenForTestWithObj:listener];
                [container moveObjectAtIndex:1 toIndex:3];
                
                EZMContainerChange *change1 = [EZMContainerMoveChange changeFromSource:1 toDestnation:3];
                expect(container.count).to(receive(@[@5, @5]));
                expect(container.changes).to(receive(@[change1]));
                expect(container.changes.value).to(equal(change1));
                expect(container.count.value).to(equal(@5));
                expect([container array]).to(equal(@[@1, @3, @4, @2, @5]));
            });
        });
    });
    
    context(@"in transcation", ^{
        it(@"test all insert", ^{
            NSArray *old = @[];
            NSArray *new = @[@"a", @"b", @"c"];
            EZMContainer<NSNumber *> *container = [[EZMContainer alloc] initWithArray:old];
            [container changeTransaction:^(EZMContainer<NSNumber *> * _Nonnull container) {
                [container removeAllObjects];
                
                [EZS_Sequence(new) forEachWithIndex:^(id  _Nonnull value, NSUInteger index) {
                    container[index] = value;
                }];
            }];
            EZMContainerIndexedChange *change1 = indexChange(EZMContainerChangeStateInsert, 0);
            EZMContainerIndexedChange *change2 = indexChange(EZMContainerChangeStateInsert, 1);
            EZMContainerIndexedChange *change3 = indexChange(EZMContainerChangeStateInsert, 2);
            
            EZMContainerTransactionChange *expectChanges = [EZMContainerTransactionChange transactionChangeWithChanges:@[change1, change2, change3]];
            expect(container.changes.value).to(equal(expectChanges));
        });
        
        it(@"test all delete", ^{
            NSArray *old = @[@"a", @"b", @"c"];
            NSArray *new = @[];
            EZMContainer<NSNumber *> *container = [[EZMContainer alloc] initWithArray:old];
            [container changeTransaction:^(EZMContainer<NSNumber *> * _Nonnull container) {
                [container removeAllObjects];
                [EZS_Sequence(new) forEachWithIndex:^(id  _Nonnull value, NSUInteger index) {
                    container[index] = value;
                }];
            }];
            EZMContainerIndexedChange *change1 = indexChange(EZMContainerChangeStateDelete, 0);
            EZMContainerIndexedChange *change2 = indexChange(EZMContainerChangeStateDelete, 1);
            EZMContainerIndexedChange *change3 = indexChange(EZMContainerChangeStateDelete, 2);
            
            EZMContainerTransactionChange *expectChanges = [EZMContainerTransactionChange transactionChangeWithChanges:@[change1, change2, change3]];
            expect(container.changes.value).to(equal(expectChanges));
        });
        
        it(@"test update", ^{
            NSArray *old = @[@"a", @"b", @"c"];
            NSArray *new = @[@"a", @"B", @"c"];
            EZMContainer<NSNumber *> *container = [[EZMContainer alloc] initWithArray:old];
            [container changeTransaction:^(EZMContainer<NSNumber *> * _Nonnull container) {
                [container removeAllObjects];
                [EZS_Sequence(new) forEachWithIndex:^(id  _Nonnull value, NSUInteger index) {
                    container[index] = value;
                }];
            }];
            EZMContainerIndexedChange *change1 = indexChange(EZMContainerChangeStateDelete, 1);
            EZMContainerIndexedChange *change2 = indexChange(EZMContainerChangeStateInsert, 1);
            EZMContainerTransactionChange *expectChanges = [EZMContainerTransactionChange transactionChangeWithChanges:@[change1, change2]];
            expect(container.changes.value).to(equal(expectChanges));
        });
        
        it(@"test all update", ^{
            NSArray *old = @[@"a", @"b", @"c"];
            NSArray *new = @[@"A", @"B", @"C"];
            EZMContainer<NSNumber *> *container = [[EZMContainer alloc] initWithArray:old];
            [container changeTransaction:^(EZMContainer<NSNumber *> * _Nonnull container) {
                [container removeAllObjects];
                [EZS_Sequence(new) forEachWithIndex:^(id  _Nonnull value, NSUInteger index) {
                    container[index] = value;
                }];
            }];
            EZMContainerIndexedChange *change1 = indexChange(EZMContainerChangeStateDelete, 0);
            EZMContainerIndexedChange *change2 = indexChange(EZMContainerChangeStateDelete, 1);
            EZMContainerIndexedChange *change3 = indexChange(EZMContainerChangeStateDelete, 2);
            EZMContainerIndexedChange *change4 = indexChange(EZMContainerChangeStateInsert, 0);
            EZMContainerIndexedChange *change5 = indexChange(EZMContainerChangeStateInsert, 1);
            EZMContainerIndexedChange *change6 = indexChange(EZMContainerChangeStateInsert, 2);
            EZMContainerTransactionChange *expectChanges = [EZMContainerTransactionChange transactionChangeWithChanges:@[change1, change2, change3, change4, change5, change6]];
            expect(container.changes.value).to(equal(expectChanges));
        });
        
         it(@"test same prefix", ^{
            NSArray *old = @[@"a", @"b", @"c"];
            NSArray *new = @[@"a", @"B"];
            EZMContainer<NSNumber *> *container = [[EZMContainer alloc] initWithArray:old];
            [container changeTransaction:^(EZMContainer<NSNumber *> * _Nonnull container) {
                [container removeAllObjects];
                [EZS_Sequence(new) forEachWithIndex:^(id  _Nonnull value, NSUInteger index) {
                    container[index] = value;
                }];
            }];
            
            EZMContainerIndexedChange *change1 = indexChange(EZMContainerChangeStateDelete, 1);
            EZMContainerIndexedChange *change2 = indexChange(EZMContainerChangeStateDelete, 2);
            EZMContainerIndexedChange *change3 = indexChange(EZMContainerChangeStateInsert, 1);
            EZMContainerTransactionChange *expectChanges = [EZMContainerTransactionChange transactionChangeWithChanges:@[change1, change2, change3]];
            expect(container.changes.value).to(equal(expectChanges));
        });
        
        it(@"test reversed", ^{
            NSArray *old = @[@"a", @"b", @"c"];
            NSArray *new = @[@"c", @"b", @"a"];
            EZMContainer<NSNumber *> *container = [[EZMContainer alloc] initWithArray:old];
            [container changeTransaction:^(EZMContainer<NSNumber *> * _Nonnull container) {
                [container removeAllObjects];
                [EZS_Sequence(new) forEachWithIndex:^(id  _Nonnull value, NSUInteger index) {
                    container[index] = value;
                }];
            }];
            
            EZMContainerMoveChange *change1 = moveChaneg(2, 0);
            EZMContainerMoveChange *change2 = moveChaneg(0, 2);
            EZMContainerTransactionChange *expectChanges = [EZMContainerTransactionChange transactionChangeWithChanges:@[change1, change2]];
            expect(container.changes.value).to(equal(expectChanges));
        });
        
        it(@"test small chanes at edges", ^{
            NSArray *old = @[@"s", @"i", @"t", @"t", @"i", @"n", @"g"];
            NSArray *new = @[@"k", @"i", @"t", @"t", @"e", @"n"];
            EZMContainer<NSNumber *> *container = [[EZMContainer alloc] initWithArray:old];
            
            [container changeTransaction:^(EZMContainer<NSNumber *> * _Nonnull container) {
                [container removeAllObjects];
                [EZS_Sequence(new) forEachWithIndex:^(id  _Nonnull value, NSUInteger index) {
                    container[index] = value;
                }];
            }];
            
            EZMContainerIndexedChange *change1 = indexChange(EZMContainerChangeStateDelete, 0);
            EZMContainerIndexedChange *change2 = indexChange(EZMContainerChangeStateDelete, 4);
            EZMContainerIndexedChange *change3 = indexChange(EZMContainerChangeStateDelete, 6);
            EZMContainerIndexedChange *change4 = indexChange(EZMContainerChangeStateInsert, 0);
            EZMContainerIndexedChange *change5 = indexChange(EZMContainerChangeStateInsert, 4);
            
            EZMContainerTransactionChange *expectChanges = [EZMContainerTransactionChange transactionChangeWithChanges:@[change1, change2, change3, change4, change5]];
            expect(container.changes.value).to(equal(expectChanges));
        });
        
        it(@"test same postfix", ^{
            NSArray *old = @[@"a", @"b", @"c", @"d", @"e", @"f"];
            NSArray *new = @[@"d", @"e", @"f"];
            EZMContainer<NSNumber *> *container = [[EZMContainer alloc] initWithArray:old];
            [container changeTransaction:^(EZMContainer<NSNumber *> * _Nonnull container) {
                [container removeAllObjects];
                [EZS_Sequence(new) forEachWithIndex:^(id  _Nonnull value, NSUInteger index) {
                    container[index] = value;
                }];
            }];
            
            EZMContainerIndexedChange *change1 = indexChange(EZMContainerChangeStateDelete, 0);
            EZMContainerIndexedChange *change2 = indexChange(EZMContainerChangeStateDelete, 1);
            EZMContainerIndexedChange *change3 = indexChange(EZMContainerChangeStateDelete, 2);
            
            EZMContainerTransactionChange *expectChanges = [EZMContainerTransactionChange transactionChangeWithChanges:@[change1, change2, change3]];
            expect(container.changes.value).to(equal(expectChanges));
        });
        
        it(@"test shift", ^{
            NSArray *old = @[@"a", @"b", @"c", @"d"];
            NSArray *new = @[@"c", @"d", @"e", @"f"];
            EZMContainer<NSNumber *> *container = [[EZMContainer alloc] initWithArray:old];
            [container changeTransaction:^(EZMContainer<NSNumber *> * _Nonnull container) {
                [container removeAllObjects];
                [EZS_Sequence(new) forEachWithIndex:^(id  _Nonnull value, NSUInteger index) {
                    container[index] = value;
                }];
            }];
            
            EZMContainerIndexedChange *change1 = indexChange(EZMContainerChangeStateDelete, 0);
            EZMContainerIndexedChange *change2 = indexChange(EZMContainerChangeStateDelete, 1);
            EZMContainerIndexedChange *change3 = indexChange(EZMContainerChangeStateInsert, 2);
            EZMContainerIndexedChange *change4 = indexChange(EZMContainerChangeStateInsert, 3);
            EZMContainerTransactionChange *expectChanges = [EZMContainerTransactionChange transactionChangeWithChanges:@[change1, change2, change3, change4, ]];
            expect(container.changes.value).to(equal(expectChanges));
        });
        
        it(@"test replace whole word", ^{
            NSArray *old = @[@"a", @"b", @"c"];
            NSArray *new = @[@"d"];
            EZMContainer<NSNumber *> *container = [[EZMContainer alloc] initWithArray:old];
            [container changeTransaction:^(EZMContainer<NSNumber *> * _Nonnull container) {
                [container removeAllObjects];
                [EZS_Sequence(new) forEachWithIndex:^(id  _Nonnull value, NSUInteger index) {
                    container[index] = value;
                }];
            }];
            
            EZMContainerIndexedChange *change1 = indexChange(EZMContainerChangeStateDelete, 0);
            EZMContainerIndexedChange *change2 = indexChange(EZMContainerChangeStateDelete, 1);
            EZMContainerIndexedChange *change3 = indexChange(EZMContainerChangeStateDelete, 2);
            EZMContainerIndexedChange *change4 = indexChange(EZMContainerChangeStateInsert, 0);
            EZMContainerTransactionChange *expectChanges = [EZMContainerTransactionChange transactionChangeWithChanges:@[change1, change2, change3, change4, ]];
            expect(container.changes.value).to(equal(expectChanges));
        });
        
        it(@"test replace 1 character", ^{
            NSArray *old = @[@"a"];
            NSArray *new = @[@"b"];
            EZMContainer<NSNumber *> *container = [[EZMContainer alloc] initWithArray:old];
            [container changeTransaction:^(EZMContainer<NSNumber *> * _Nonnull container) {
                [container removeAllObjects];
                [EZS_Sequence(new) forEachWithIndex:^(id  _Nonnull value, NSUInteger index) {
                    container[index] = value;
                }];
            }];
            
            EZMContainerIndexedChange *change1 = indexChange(EZMContainerChangeStateDelete, 0);
            
            EZMContainerIndexedChange *change2 = indexChange(EZMContainerChangeStateInsert, 0);
            EZMContainerTransactionChange *expectChanges = [EZMContainerTransactionChange transactionChangeWithChanges:@[change1, change2]];
            expect(container.changes.value).to(equal(expectChanges));
        });
        
        it(@"test object update", ^{
            NSArray *old = @[[[ERPerson alloc] initWithName:@"ZS"],
                             [[ERPerson alloc] initWithName:@"LS"],
                             [[ERPerson alloc] initWithName:@"WW"]];
            NSArray *new = @[[[ERPerson alloc] initWithName:@"ZS"],
                             [[ERPerson alloc] initWithName:@"XX"],
                             [[ERPerson alloc] initWithName:@"WW"]];
            EZMContainer<NSNumber *> *container = [[EZMContainer alloc] initWithArray:old];
            [container changeTransaction:^(EZMContainer<NSNumber *> * _Nonnull container) {
                [container removeAllObjects];
                [EZS_Sequence(new) forEachWithIndex:^(id  _Nonnull value, NSUInteger index) {
                    container[index] = value;
                }];
            }];
            
            EZMContainerIndexedChange *change1 = indexChange(EZMContainerChangeStateDelete, 1);
            EZMContainerIndexedChange *change2 = indexChange(EZMContainerChangeStateInsert, 1);
            EZMContainerTransactionChange *expectChanges = [EZMContainerTransactionChange transactionChangeWithChanges:@[change1, change2]];
            expect(container.changes.value).to(equal(expectChanges));
        });
        
        it(@"testmove with insert and delete", ^{
            NSArray *old = @[@"1", @"2", @"3", @"4", @"5"];
            NSArray *new = @[@"1", @"5", @"2", @"3", @"4"];
            EZMContainer<NSNumber *> *container = [[EZMContainer alloc] initWithArray:old];
            [container changeTransaction:^(EZMContainer<NSNumber *> * _Nonnull container) {
                [container removeAllObjects];
                [EZS_Sequence(new) forEachWithIndex:^(id  _Nonnull value, NSUInteger index) {
                    container[index] = value;
                }];
            }];
            EZMContainerMoveChange *change1 = moveChaneg(4, 1);
            EZMContainerMoveChange *change2 = moveChaneg(1, 2);
            EZMContainerMoveChange *change3 = moveChaneg(2, 3);
            EZMContainerMoveChange *change4 = moveChaneg(3, 4);
            EZMContainerTransactionChange *expectChanges = [EZMContainerTransactionChange transactionChangeWithChanges:@[change1, change2, change3, change4]];
            expect(container.changes.value).to(equal(expectChanges));
        });
        
        it(@"testmove with delete and insert", ^{
            NSArray *old = @[@"1", @"5", @"2", @"3", @"4"];
            NSArray *new = @[@"1", @"2", @"3", @"4", @"5"];
            EZMContainer<NSNumber *> *container = [[EZMContainer alloc] initWithArray:old];
            [container changeTransaction:^(EZMContainer<NSNumber *> * _Nonnull container) {
                [container removeAllObjects];
                [EZS_Sequence(new) forEachWithIndex:^(id  _Nonnull value, NSUInteger index) {
                    container[index] = value;
                }];
            }];
            EZMContainerMoveChange *change1 = moveChaneg(2, 1);
            EZMContainerMoveChange *change2 = moveChaneg(3, 2);
            EZMContainerMoveChange *change3 = moveChaneg(4, 3);
            EZMContainerMoveChange *change4 = moveChaneg(1, 4);
            EZMContainerTransactionChange *expectChanges = [EZMContainerTransactionChange transactionChangeWithChanges:@[change1, change2, change3, change4]];
            expect(container.changes.value).to(equal(expectChanges));
        });
        
        it(@"testmove with replace move replace", ^{
            NSArray *old = @[@"3", @"4", @"1", @"5", @"2"];
            NSArray *new = @[@"5", @"1", @"3", @"2", @"4"];
            EZMContainer<NSNumber *> *container = [[EZMContainer alloc] initWithArray:old];
            [container changeTransaction:^(EZMContainer<NSNumber *> * _Nonnull container) {
                [container removeAllObjects];
                [EZS_Sequence(new) forEachWithIndex:^(id  _Nonnull value, NSUInteger index) {
                    container[index] = value;
                }];
            }];
            EZMContainerMoveChange *change1 = moveChaneg(3, 0);
            EZMContainerMoveChange *change2 = moveChaneg(2, 1);
            EZMContainerMoveChange *change3 = moveChaneg(0, 2);
            EZMContainerMoveChange *change4 = moveChaneg(4, 3);
            EZMContainerMoveChange *change5 = moveChaneg(1, 4);
            EZMContainerTransactionChange *expectChanges = [EZMContainerTransactionChange transactionChangeWithChanges:@[change1, change2, change3, change4, change5]];
            expect(container.changes.value).to(equal(expectChanges));
        });
        
        it(@"testmove with replace insert replace delete", ^{
            NSArray *old = @[@"a", @"b", @"c"];
            NSArray *new = @[@"a"];
            EZMContainer<NSNumber *> *container = [[EZMContainer alloc] initWithArray:old];
            [container changeTransaction:^(EZMContainer<NSNumber *> * _Nonnull container) {
                [container removeAllObjects];
                [EZS_Sequence(new) forEachWithIndex:^(id  _Nonnull value, NSUInteger index) {
                    container[index] = value;
                }];
            }];
            EZMContainerIndexedChange *change1 = indexChange(EZMContainerChangeStateDelete, 1);
            EZMContainerIndexedChange *change2 = indexChange(EZMContainerChangeStateDelete, 2);
            EZMContainerTransactionChange *expectChanges = [EZMContainerTransactionChange transactionChangeWithChanges:@[change1, change2]];
            expect(container.changes.value).to(equal(expectChanges));
        });
        
        it(@"testmove with replace insert replace delete", ^{
            NSArray *old = @[@"1", @"3", @"0", @"2"];
            NSArray *new = @[@"0", @"2", @"3", @"1"];
            EZMContainer<NSNumber *> *container = [[EZMContainer alloc] initWithArray:old];
            [container changeTransaction:^(EZMContainer<NSNumber *> * _Nonnull container) {
                [container removeAllObjects];
                [EZS_Sequence(new) forEachWithIndex:^(id  _Nonnull value, NSUInteger index) {
                    container[index] = value;
                }];
            }];
            EZMContainerMoveChange *change1 = moveChaneg(2, 0);
            EZMContainerMoveChange *change2 = moveChaneg(3, 1);
            EZMContainerMoveChange *change3 = moveChaneg(1, 2);
            EZMContainerMoveChange *change4 = moveChaneg(0, 3);
            EZMContainerTransactionChange *expectChanges = [EZMContainerTransactionChange transactionChangeWithChanges:@[change1, change2, change3, change4]];
            expect(container.changes.value).to(equal(expectChanges));
        });
        
        it(@"testmove with replace move replace", ^{
            NSArray *old = @[@"2", @"0", @"1", @"3"];
            NSArray *new = @[@"1", @"3", @"0", @"2"];
            EZMContainer<NSNumber *> *container = [[EZMContainer alloc] initWithArray:old];
            [container changeTransaction:^(EZMContainer<NSNumber *> * _Nonnull container) {
                [container removeAllObjects];
                [EZS_Sequence(new) forEachWithIndex:^(id  _Nonnull value, NSUInteger index) {
                    container[index] = value;
                }];
            }];
            EZMContainerMoveChange *change1 = moveChaneg(2, 0);
            EZMContainerMoveChange *change2 = moveChaneg(3, 1);
            EZMContainerMoveChange *change3 = moveChaneg(1, 2);
            EZMContainerMoveChange *change4 = moveChaneg(0, 3);
            EZMContainerTransactionChange *expectChanges = [EZMContainerTransactionChange transactionChangeWithChanges:@[change1, change2, change3, change4]];
            expect(container.changes.value).to(equal(expectChanges));
        });
        
        it(@"should raise exception when flush all data in transaction block", ^{
            NSArray<NSNumber *> *array = @[@1, @2, @3, @4];
            EZMContainer<NSNumber *> *container = [[EZMContainer alloc] initWithArray:array];
            expectAction(^{
                [container changeTransaction:^(EZMContainer * _Nonnull container) {
                    [container setArray:@[]];
                }];
            }).to(raiseException().named(EZMContainerException).reason(EZMContainerReason_FlushInTransaction));
        });
    });
    
    context(@"manual open transcation", ^{
        it(@"test all insert", ^{
            NSArray *old = @[];
            NSArray *new = @[@"a", @"b", @"c"];
            EZMContainer<NSNumber *> *container = [[EZMContainer alloc] initWithArray:old];
            [container beginTransaction];
            [container removeAllObjects];
            [EZS_Sequence(new) forEachWithIndex:^(id  _Nonnull value, NSUInteger index) {
                container[index] = value;
            }];
            [container endTransaction];
            EZMContainerIndexedChange *change1 = indexChange(EZMContainerChangeStateInsert, 0);
            EZMContainerIndexedChange *change2 = indexChange(EZMContainerChangeStateInsert, 1);
            EZMContainerIndexedChange *change3 = indexChange(EZMContainerChangeStateInsert, 2);
            
            EZMContainerTransactionChange *expectChanges = [EZMContainerTransactionChange transactionChangeWithChanges:@[change1, change2, change3]];
            expect(container.changes.value).to(equal(expectChanges));
        });
        
        it(@"test all delete", ^{
            NSArray *old = @[@"a", @"b", @"c"];
            NSArray *new = @[];
            EZMContainer<NSNumber *> *container = [[EZMContainer alloc] initWithArray:old];
            [container beginTransaction];
            [container removeAllObjects];
            [EZS_Sequence(new) forEachWithIndex:^(id  _Nonnull value, NSUInteger index) {
                container[index] = value;
            }];
            [container endTransaction];
            EZMContainerIndexedChange *change1 = indexChange(EZMContainerChangeStateDelete, 0);
            EZMContainerIndexedChange *change2 = indexChange(EZMContainerChangeStateDelete, 1);
            EZMContainerIndexedChange *change3 = indexChange(EZMContainerChangeStateDelete, 2);
            
            EZMContainerTransactionChange *expectChanges = [EZMContainerTransactionChange transactionChangeWithChanges:@[change1, change2, change3]];
            expect(container.changes.value).to(equal(expectChanges));
        });
        
        it(@"test update", ^{
            NSArray *old = @[@"a", @"b", @"c"];
            NSArray *new = @[@"a", @"B", @"c"];
            EZMContainer<NSNumber *> *container = [[EZMContainer alloc] initWithArray:old];
            [container beginTransaction];
            [container removeAllObjects];
            [EZS_Sequence(new) forEachWithIndex:^(id  _Nonnull value, NSUInteger index) {
                container[index] = value;
            }];
            [container endTransaction];
            EZMContainerIndexedChange *change1 = indexChange(EZMContainerChangeStateDelete, 1);
            EZMContainerIndexedChange *change2 = indexChange(EZMContainerChangeStateInsert, 1);
            EZMContainerTransactionChange *expectChanges = [EZMContainerTransactionChange transactionChangeWithChanges:@[change1, change2]];
            expect(container.changes.value).to(equal(expectChanges));
        });
        
        it(@"test all update", ^{
            NSArray *old = @[@"a", @"b", @"c"];
            NSArray *new = @[@"A", @"B", @"C"];
            EZMContainer<NSNumber *> *container = [[EZMContainer alloc] initWithArray:old];
            [container beginTransaction];
            [container removeAllObjects];
            [EZS_Sequence(new) forEachWithIndex:^(id  _Nonnull value, NSUInteger index) {
                container[index] = value;
            }];
            [container endTransaction];
            EZMContainerIndexedChange *change1 = indexChange(EZMContainerChangeStateDelete, 0);
            EZMContainerIndexedChange *change2 = indexChange(EZMContainerChangeStateDelete, 1);
            EZMContainerIndexedChange *change3 = indexChange(EZMContainerChangeStateDelete, 2);
            EZMContainerIndexedChange *change4 = indexChange(EZMContainerChangeStateInsert, 0);
            EZMContainerIndexedChange *change5 = indexChange(EZMContainerChangeStateInsert, 1);
            EZMContainerIndexedChange *change6 = indexChange(EZMContainerChangeStateInsert, 2);
            EZMContainerTransactionChange *expectChanges = [EZMContainerTransactionChange transactionChangeWithChanges:@[change1, change2, change3, change4, change5, change6]];
            expect(container.changes.value).to(equal(expectChanges));
        });
        
        it(@"test same prefix", ^{
            NSArray *old = @[@"a", @"b", @"c"];
            NSArray *new = @[@"a", @"B"];
            EZMContainer<NSNumber *> *container = [[EZMContainer alloc] initWithArray:old];
            [container beginTransaction];
            [container removeAllObjects];
            [EZS_Sequence(new) forEachWithIndex:^(id  _Nonnull value, NSUInteger index) {
                container[index] = value;
            }];
            [container endTransaction];
            
            EZMContainerIndexedChange *change1 = indexChange(EZMContainerChangeStateDelete, 1);
            EZMContainerIndexedChange *change2 = indexChange(EZMContainerChangeStateDelete, 2);
            EZMContainerIndexedChange *change3 = indexChange(EZMContainerChangeStateInsert, 1);
            EZMContainerTransactionChange *expectChanges = [EZMContainerTransactionChange transactionChangeWithChanges:@[change1, change2, change3]];
            expect(container.changes.value).to(equal(expectChanges));
        });
        
        it(@"test reversed", ^{
            NSArray *old = @[@"a", @"b", @"c"];
            NSArray *new = @[@"c", @"b", @"a"];
            EZMContainer<NSNumber *> *container = [[EZMContainer alloc] initWithArray:old];
            [container beginTransaction];
            [container removeAllObjects];
            [EZS_Sequence(new) forEachWithIndex:^(id  _Nonnull value, NSUInteger index) {
                container[index] = value;
            }];
            [container endTransaction];
            
            EZMContainerMoveChange *change1 = moveChaneg(2, 0);
            EZMContainerMoveChange *change2 = moveChaneg(0, 2);
            EZMContainerTransactionChange *expectChanges = [EZMContainerTransactionChange transactionChangeWithChanges:@[change1, change2]];
            expect(container.changes.value).to(equal(expectChanges));
        });
        
        it(@"test small chanes at edges", ^{
            NSArray *old = @[@"s", @"i", @"t", @"t", @"i", @"n", @"g"];
            NSArray *new = @[@"k", @"i", @"t", @"t", @"e", @"n"];
            EZMContainer<NSNumber *> *container = [[EZMContainer alloc] initWithArray:old];
            
            [container beginTransaction];
            [container removeAllObjects];
            [EZS_Sequence(new) forEachWithIndex:^(id  _Nonnull value, NSUInteger index) {
                container[index] = value;
            }];
            [container endTransaction];
            
            EZMContainerIndexedChange *change1 = indexChange(EZMContainerChangeStateDelete, 0);
            EZMContainerIndexedChange *change2 = indexChange(EZMContainerChangeStateDelete, 4);
            EZMContainerIndexedChange *change3 = indexChange(EZMContainerChangeStateDelete, 6);
            EZMContainerIndexedChange *change4 = indexChange(EZMContainerChangeStateInsert, 0);
            EZMContainerIndexedChange *change5 = indexChange(EZMContainerChangeStateInsert, 4);
            
            EZMContainerTransactionChange *expectChanges = [EZMContainerTransactionChange transactionChangeWithChanges:@[change1, change2, change3, change4, change5]];
            expect(container.changes.value).to(equal(expectChanges));
        });
        
        it(@"test same postfix", ^{
            NSArray *old = @[@"a", @"b", @"c", @"d", @"e", @"f"];
            NSArray *new = @[@"d", @"e", @"f"];
            EZMContainer<NSNumber *> *container = [[EZMContainer alloc] initWithArray:old];
            [container beginTransaction];
            [container removeAllObjects];
            [EZS_Sequence(new) forEachWithIndex:^(id  _Nonnull value, NSUInteger index) {
                container[index] = value;
            }];
            [container endTransaction];
            
            EZMContainerIndexedChange *change1 = indexChange(EZMContainerChangeStateDelete, 0);
            EZMContainerIndexedChange *change2 = indexChange(EZMContainerChangeStateDelete, 1);
            EZMContainerIndexedChange *change3 = indexChange(EZMContainerChangeStateDelete, 2);
            
            EZMContainerTransactionChange *expectChanges = [EZMContainerTransactionChange transactionChangeWithChanges:@[change1, change2, change3]];
            expect(container.changes.value).to(equal(expectChanges));
        });
        
        it(@"test shift", ^{
            NSArray *old = @[@"a", @"b", @"c", @"d"];
            NSArray *new = @[@"c", @"d", @"e", @"f"];
            EZMContainer<NSNumber *> *container = [[EZMContainer alloc] initWithArray:old];
            [container beginTransaction];
            [container removeAllObjects];
            [EZS_Sequence(new) forEachWithIndex:^(id  _Nonnull value, NSUInteger index) {
                container[index] = value;
            }];
            [container endTransaction];
            
            EZMContainerIndexedChange *change1 = indexChange(EZMContainerChangeStateDelete, 0);
            EZMContainerIndexedChange *change2 = indexChange(EZMContainerChangeStateDelete, 1);
            EZMContainerIndexedChange *change3 = indexChange(EZMContainerChangeStateInsert, 2);
            EZMContainerIndexedChange *change4 = indexChange(EZMContainerChangeStateInsert, 3);
            EZMContainerTransactionChange *expectChanges = [EZMContainerTransactionChange transactionChangeWithChanges:@[change1, change2, change3, change4, ]];
            expect(container.changes.value).to(equal(expectChanges));
        });
        
        it(@"test replace whole word", ^{
            NSArray *old = @[@"a", @"b", @"c"];
            NSArray *new = @[@"d"];
            EZMContainer<NSNumber *> *container = [[EZMContainer alloc] initWithArray:old];
            [container beginTransaction];
            [container removeAllObjects];
            [EZS_Sequence(new) forEachWithIndex:^(id  _Nonnull value, NSUInteger index) {
                container[index] = value;
            }];
            [container endTransaction];
            
            EZMContainerIndexedChange *change1 = indexChange(EZMContainerChangeStateDelete, 0);
            EZMContainerIndexedChange *change2 = indexChange(EZMContainerChangeStateDelete, 1);
            EZMContainerIndexedChange *change3 = indexChange(EZMContainerChangeStateDelete, 2);
            EZMContainerIndexedChange *change4 = indexChange(EZMContainerChangeStateInsert, 0);
            EZMContainerTransactionChange *expectChanges = [EZMContainerTransactionChange transactionChangeWithChanges:@[change1, change2, change3, change4, ]];
            expect(container.changes.value).to(equal(expectChanges));
        });
        
        it(@"test replace 1 character", ^{
            NSArray *old = @[@"a"];
            NSArray *new = @[@"b"];
            EZMContainer<NSNumber *> *container = [[EZMContainer alloc] initWithArray:old];
            [container beginTransaction];
            [container removeAllObjects];
            [EZS_Sequence(new) forEachWithIndex:^(id  _Nonnull value, NSUInteger index) {
                container[index] = value;
            }];
            [container endTransaction];
            
            EZMContainerIndexedChange *change1 = indexChange(EZMContainerChangeStateDelete, 0);
            
            EZMContainerIndexedChange *change2 = indexChange(EZMContainerChangeStateInsert, 0);
            EZMContainerTransactionChange *expectChanges = [EZMContainerTransactionChange transactionChangeWithChanges:@[change1, change2]];
            expect(container.changes.value).to(equal(expectChanges));
        });
        
        it(@"test object update", ^{
            NSArray *old = @[[[ERPerson alloc] initWithName:@"ZS"],
                             [[ERPerson alloc] initWithName:@"LS"],
                             [[ERPerson alloc] initWithName:@"WW"]];
            NSArray *new = @[[[ERPerson alloc] initWithName:@"ZS"],
                             [[ERPerson alloc] initWithName:@"XX"],
                             [[ERPerson alloc] initWithName:@"WW"]];
            EZMContainer<NSNumber *> *container = [[EZMContainer alloc] initWithArray:old];
            [container beginTransaction];
            [container removeAllObjects];
            [EZS_Sequence(new) forEachWithIndex:^(id  _Nonnull value, NSUInteger index) {
                container[index] = value;
            }];
            [container endTransaction];
            
            EZMContainerIndexedChange *change1 = indexChange(EZMContainerChangeStateDelete, 1);
            EZMContainerIndexedChange *change2 = indexChange(EZMContainerChangeStateInsert, 1);
            EZMContainerTransactionChange *expectChanges = [EZMContainerTransactionChange transactionChangeWithChanges:@[change1, change2]];
            expect(container.changes.value).to(equal(expectChanges));
        });
        
        it(@"testmove with insert and delete", ^{
            NSArray *old = @[@"1", @"2", @"3", @"4", @"5"];
            NSArray *new = @[@"1", @"5", @"2", @"3", @"4"];
            EZMContainer<NSNumber *> *container = [[EZMContainer alloc] initWithArray:old];
            [container beginTransaction];
            [container removeAllObjects];
            [EZS_Sequence(new) forEachWithIndex:^(id  _Nonnull value, NSUInteger index) {
                container[index] = value;
            }];
            [container endTransaction];
            EZMContainerMoveChange *change1 = moveChaneg(4, 1);
            EZMContainerMoveChange *change2 = moveChaneg(1, 2);
            EZMContainerMoveChange *change3 = moveChaneg(2, 3);
            EZMContainerMoveChange *change4 = moveChaneg(3, 4);
            EZMContainerTransactionChange *expectChanges = [EZMContainerTransactionChange transactionChangeWithChanges:@[change1, change2, change3, change4]];
            expect(container.changes.value).to(equal(expectChanges));
        });
        
        it(@"testmove with delete and insert", ^{
            NSArray *old = @[@"1", @"5", @"2", @"3", @"4"];
            NSArray *new = @[@"1", @"2", @"3", @"4", @"5"];
            EZMContainer<NSNumber *> *container = [[EZMContainer alloc] initWithArray:old];
            [container beginTransaction];
            [container removeAllObjects];
            [EZS_Sequence(new) forEachWithIndex:^(id  _Nonnull value, NSUInteger index) {
                container[index] = value;
            }];
            [container endTransaction];
            EZMContainerMoveChange *change1 = moveChaneg(2, 1);
            EZMContainerMoveChange *change2 = moveChaneg(3, 2);
            EZMContainerMoveChange *change3 = moveChaneg(4, 3);
            EZMContainerMoveChange *change4 = moveChaneg(1, 4);
            EZMContainerTransactionChange *expectChanges = [EZMContainerTransactionChange transactionChangeWithChanges:@[change1, change2, change3, change4]];
            expect(container.changes.value).to(equal(expectChanges));
        });
        
        it(@"testmove with replace move replace", ^{
            NSArray *old = @[@"3", @"4", @"1", @"5", @"2"];
            NSArray *new = @[@"5", @"1", @"3", @"2", @"4"];
            EZMContainer<NSNumber *> *container = [[EZMContainer alloc] initWithArray:old];
            [container beginTransaction];
            [container removeAllObjects];
            [EZS_Sequence(new) forEachWithIndex:^(id  _Nonnull value, NSUInteger index) {
                container[index] = value;
            }];
            [container endTransaction];
            EZMContainerMoveChange *change1 = moveChaneg(3, 0);
            EZMContainerMoveChange *change2 = moveChaneg(2, 1);
            EZMContainerMoveChange *change3 = moveChaneg(0, 2);
            EZMContainerMoveChange *change4 = moveChaneg(4, 3);
            EZMContainerMoveChange *change5 = moveChaneg(1, 4);
            EZMContainerTransactionChange *expectChanges = [EZMContainerTransactionChange transactionChangeWithChanges:@[change1, change2, change3, change4, change5]];
            expect(container.changes.value).to(equal(expectChanges));
        });
        
        it(@"testmove with replace insert replace delete", ^{
            NSArray *old = @[@"a", @"b", @"c"];
            NSArray *new = @[@"a"];
            EZMContainer<NSNumber *> *container = [[EZMContainer alloc] initWithArray:old];
            [container beginTransaction];
            [container removeAllObjects];
            [EZS_Sequence(new) forEachWithIndex:^(id  _Nonnull value, NSUInteger index) {
                container[index] = value;
            }];
            [container endTransaction];
            EZMContainerIndexedChange *change1 = indexChange(EZMContainerChangeStateDelete, 1);
            EZMContainerIndexedChange *change2 = indexChange(EZMContainerChangeStateDelete, 2);
            EZMContainerTransactionChange *expectChanges = [EZMContainerTransactionChange transactionChangeWithChanges:@[change1, change2]];
            expect(container.changes.value).to(equal(expectChanges));
        });
        
        it(@"testmove with replace insert replace delete", ^{
            NSArray *old = @[@"1", @"3", @"0", @"2"];
            NSArray *new = @[@"0", @"2", @"3", @"1"];
            EZMContainer<NSNumber *> *container = [[EZMContainer alloc] initWithArray:old];
            [container beginTransaction];
            [container removeAllObjects];
            [EZS_Sequence(new) forEachWithIndex:^(id  _Nonnull value, NSUInteger index) {
                container[index] = value;
            }];
            [container endTransaction];
            EZMContainerMoveChange *change1 = moveChaneg(2, 0);
            EZMContainerMoveChange *change2 = moveChaneg(3, 1);
            EZMContainerMoveChange *change3 = moveChaneg(1, 2);
            EZMContainerMoveChange *change4 = moveChaneg(0, 3);
            EZMContainerTransactionChange *expectChanges = [EZMContainerTransactionChange transactionChangeWithChanges:@[change1, change2, change3, change4]];
            expect(container.changes.value).to(equal(expectChanges));
        });
        
        it(@"testmove with replace move replace", ^{
            NSArray *old = @[@"2", @"0", @"1", @"3"];
            NSArray *new = @[@"1", @"3", @"0", @"2"];
            EZMContainer<NSNumber *> *container = [[EZMContainer alloc] initWithArray:old];
            [container beginTransaction];
            [container removeAllObjects];
            [EZS_Sequence(new) forEachWithIndex:^(id  _Nonnull value, NSUInteger index) {
                container[index] = value;
            }];
            [container endTransaction];
            EZMContainerMoveChange *change1 = moveChaneg(2, 0);
            EZMContainerMoveChange *change2 = moveChaneg(3, 1);
            EZMContainerMoveChange *change3 = moveChaneg(1, 2);
            EZMContainerMoveChange *change4 = moveChaneg(0, 3);
            EZMContainerTransactionChange *expectChanges = [EZMContainerTransactionChange transactionChangeWithChanges:@[change1, change2, change3, change4]];
            expect(container.changes.value).to(equal(expectChanges));
        });
        
        it(@"should raise exception when flush all data in transaction", ^{
            NSArray<NSNumber *> *array = @[@1, @2, @3, @4];
            EZMContainer<NSNumber *> *container = [[EZMContainer alloc] initWithArray:array];
            expectAction(^{
                [container beginTransaction];
                [container setArray:@[]];
                [container endTransaction];
            }).to(raiseException().named(EZMContainerException).reason(EZMContainerReason_FlushInTransaction));
        });
        
        it(@"should raise exception when use `endTransaction` method does not begin Transaction ", ^{
            NSArray<NSNumber *> *array = @[@1, @2, @3, @4];
            EZMContainer<NSNumber *> *container = [[EZMContainer alloc] initWithArray:array];
            expectAction(^{
                [container endTransaction];
            }).to(raiseException().named(EZMContainerException).reason(EZMContainerReason_EndTransacitionNotInTransaction));
        });
        
        it(@"should raise exception when use `rollbackTransaction` method does not begin Transaction ", ^{
            NSArray<NSNumber *> *array = @[@1, @2, @3, @4];
            EZMContainer<NSNumber *> *container = [[EZMContainer alloc] initWithArray:array];
            expectAction(^{
                [container rollbackTransaction];
            }).to(raiseException().named(EZMContainerException).reason(EZMContainerReason_RollBackNotInTransaction));
        });
    });
});

QuickSpecEnd
