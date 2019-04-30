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

QuickSpecBegin(EZMBinderSpec)

describe(@"EZMBinder test", ^{
    
    context(@"one way binding", ^{
        it(@"should cancel two node's link after self dealloc", ^{
            EZRNode *node1 = [EZRNode new];
            EZRMutableNode *node2 = [EZRMutableNode new];
            @autoreleasepool {
                EZMBinder *binder = [[EZMBinder alloc] init];
                [binder bindNode:node1 toNode:node2];
                node2.value = @1;
                expect(node1.value).to(equal(@1));
                expect(node1.upstreamNodes.firstObject.upstreamNodes).to(contain(node2));
            }
            expect(node1.hasUpstreamNode).notTo(beTrue());
        });
        
        it(@"should cancel two node's link after invoking self '- (void)cancel' method", ^{
            EZMBinder *binder = [[EZMBinder alloc] init];
            EZRNode *node1 = [EZRNode new];
            EZRNode *node2 = [EZRNode new];
            [binder bindNode:node1 toNode:node2];
            
            expect(node1.upstreamNodes.firstObject.upstreamNodes).to(contain(node2));
            [binder cancel];
            expect(node1.hasUpstreamNode).notTo(beTrue());
        });
        
        it(@"should keep two node existing after linking two nodes", ^{
            __weak EZMBinder *weakBinder = nil;
            __weak EZRNode *weakNode1 = nil;
            __weak EZRNode *weakNode2 = nil;
            @autoreleasepool {
                EZMBinder *binder = [[EZMBinder alloc] init];
                weakBinder = binder;
                EZRNode *node1 = [[EZRNode alloc] init];
                EZRNode *node2 = [[EZRNode alloc] init];
                weakNode1 = node1;
                weakNode2 = node2;
                [binder bindNode:weakNode1 toNode:weakNode2];
                node1 = nil;
                node2 = nil;
                expect(weakNode1).notTo(beNil());
                expect(weakNode2).notTo(beNil());
            }
            expect(weakNode1).to(beNil());
            expect(weakNode2).to(beNil());
        });
    });
    
    context(@"two way binding", ^{
        it(@"should cancel two node's link after self dealloc", ^{
            EZRMutableNode *node1 = [EZRMutableNode new];
            EZRMutableNode *node2 = [EZRMutableNode new];
            @autoreleasepool {
                EZMBinder *binder = [[EZMBinder alloc] init];
                [binder twoWayBindNode:node1 toNode:node2];
                node2.value = @1;
                expect(node1.value).to(equal(@1));
                node1.value = @2;
                expect(node2.value).to(equal(@2));
                // TODO: 修改测试
//                expect(node1.downstreamNodes).to(contain(node2));
            }
            // TODO: 修改测试
//            expect(node1.downstreamNodes).notTo(contain(node2));
        });
        
        it(@"should cancel two node's link after invoking self '- (void)cancel' method", ^{
            EZMBinder *binder = [[EZMBinder alloc] init];
            EZRNode *node1 = [EZRNode new];
            EZRNode *node2 = [EZRNode new];
            [binder twoWayBindNode:node1 toNode:node2];
            // TODO: 修改测试
//            expect(node1.downstreamNodes).to(contain(node2));
            [binder cancel];
            // TODO: 修改测试
//            expect(node1.downstreamNodes).notTo(contain(node2));
        });
        
        it(@"should keep two node existing after linking two nodes", ^{
            __weak EZMBinder *weakBinder = nil;
            __weak EZRNode *weakNode1 = nil;
            __weak EZRNode *weakNode2 = nil;
            @autoreleasepool {
                EZMBinder *binder = [[EZMBinder alloc] init];
                weakBinder = binder;
                EZRNode *node1 = [[EZRNode alloc] init];
                EZRNode *node2 = [[EZRNode alloc] init];
                weakNode1 = node1;
                weakNode2 = node2;
                [binder twoWayBindNode:weakNode1 toNode:weakNode2];
                node1 = nil;
                node2 = nil;
                expect(weakNode1).notTo(beNil());
                expect(weakNode2).notTo(beNil());
            }
            expect(weakNode1).to(beNil());
            expect(weakNode2).to(beNil());
        });
    });
    
    context(@"binding event to handler", ^{
        it(@"should cancel event and handler's link after self dealloc", ^{
            EZMEvent *event = [EZMEvent new];
            __block int testCount = 0;
            EZMHandler *handler = [[EZMHandler alloc] initWithBlock:^(){
                ++testCount;
            }];
            @autoreleasepool {
                EZMBinder *binder = [[EZMBinder alloc] init];
                [binder bindEvent:event toHandler:handler];
                [event invoke];
                expect(@(testCount)).to(equal(@1));
            }
            [event invoke];
            expect(@(testCount)).notTo(equal(@2));
        });
        
        it(@"should cancel two node's link after invoking self '- (void)cancel' method", ^{
            EZMBinder *binder = [[EZMBinder alloc] init];
            EZMEvent *event = [EZMEvent new];
            __block int testCount = 0;
            EZMHandler *handler = [[EZMHandler alloc] initWithBlock:^(){
                ++testCount;
            }];
            
            [binder bindEvent:event toHandler:handler];
            [event invoke];
            expect(@(testCount)).to(equal(@1));
            [binder cancel];
            [event invoke];
            expect(@(testCount)).notTo(equal(@2));
        });
        
        it(@"should keep two node existing after linking two nodes", ^{
            __weak EZMBinder *weakBinder = nil;
            __weak EZRNode *weakNode1 = nil;
            __weak EZRNode *weakNode2 = nil;
            @autoreleasepool {
                EZMBinder *binder = [[EZMBinder alloc] init];
                weakBinder = binder;
                EZRNode *node1 = [[EZRNode alloc] init];
                EZRNode *node2 = [[EZRNode alloc] init];
                weakNode1 = node1;
                weakNode2 = node2;
                [binder twoWayBindNode:weakNode1 toNode:weakNode2];
                node1 = nil;
                node2 = nil;
                expect(weakNode1).notTo(beNil());
                expect(weakNode2).notTo(beNil());
            }
            expect(weakNode1).to(beNil());
            expect(weakNode2).to(beNil());
        });
    });
});

QuickSpecEnd

