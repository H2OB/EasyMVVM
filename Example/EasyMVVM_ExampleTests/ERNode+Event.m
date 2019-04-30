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
    it(@"node generator a event", ^{
        EZRMutableNode<NSNumber *> *node1 = [EZRMutableNode new];
        EZMEvent *event = [node1 generatorEvent];
        EZMEvent *mockedEvent = OCMPartialMock(event);
        node1.value = @1;
        OCMVerify([mockedEvent invoke]);
    });
    
    it(@"event can capture temp node", ^{
        __weak EZRNode *tempNode = nil;
        
        @autoreleasepool {
            EZMEvent *event = nil;
            @autoreleasepool {
                EZRNode<NSNumber *> *node1 = [EZRNode value:@1];
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
