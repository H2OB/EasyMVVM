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

QuickSpecBegin(EZRNodeEvent)

describe(@"EZRNode+Event test", ^{
    it(@"node generator a event and can be invoked", ^{
        EZMBinder *binder = [EZMBinder binderWithAssociateObject:self];
        EZRMutableNode<NSNumber *> *node1 = [EZRMutableNode new];
        EZMEvent *event = [node1 generatorEvent];
        expect(event).toNot(beNil());
        __block NSUInteger sum = 0;
        [binder bindEvent:event toHandler:[[EZMHandler alloc] initWithBlock:^{
            sum ++;
        }]];
        expect(sum).to(equal(0));

        [event invoke];
        expect(sum).to(equal(1));

        node1.value = @1;
        expect(sum).to(equal(2));

        node1.value = @1;
        expect(sum).to(equal(3));
    });

    it(@"event can capture temp node", ^{
        __weak EZRNode *tempNode = nil;
        
        @autoreleasepool {
            EZMEvent *event = nil;
            @autoreleasepool {
                EZRNode<NSNumber *> *node1 = [EZRNode new];
                
                EZRNode *node2 = [[node1 map:^id(NSNumber *next) {
                    return @([next integerValue] * 100);
                }] named:@"tempNode"];
                tempNode = node2;
                event = [node2 generatorEvent];
            }
            expect(tempNode).notTo(beNil());
            event = nil;
        }
        
        expect(tempNode).to(beNil());
    });
});

QuickSpecEnd
