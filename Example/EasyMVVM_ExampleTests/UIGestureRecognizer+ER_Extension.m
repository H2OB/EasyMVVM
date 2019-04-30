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

QuickSpecBegin(UIGestureRecognizerExtension)

describe(@"UIGestureRecognizer+EZRNode", ^{
    context(@"can get an EZRNode from a UIGestureRecognizer's state", ^{
        
        it(@"can be released correctly", ^{
            __weak UIGestureRecognizer *weakGestureRecognizer = nil;
            __weak EZRNode *weakValue = nil;
            __weak UIView *weakView = nil;
            @autoreleasepool {
                UIGestureRecognizer *gestureRecognizer = [UIGestureRecognizer new];
                weakGestureRecognizer = gestureRecognizer;
                EZRNode *value = gestureRecognizer.ezm_state;
                weakValue = value;
                UIView *view = [UIView new];
                weakView = view;
                [view addGestureRecognizer:gestureRecognizer];
                [[value listenedBy:view] withBlockOnMainQueue:^(id _Nullable next) {
                    
                }];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                expect(weakGestureRecognizer).to(beNil());
                expect(weakValue).to(beNil());
                expect(weakView).to(beNil());
            });
        });

        it(@"will return the same node if it was called multiple times", ^{
            UIGestureRecognizer *g = [UIGestureRecognizer new];
            EZRNode *state1 = g.ezm_state;
            EZRNode *state2 = g.ezm_state;
            expect(state1 == state2).to(beTrue());
        });
    });
});

QuickSpecEnd
