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

describe(@"UIGestureRecognizer+ERNode", ^{
    context(@"can get an EZRNode from a UIGestureRecognizer's state", ^{
        
        it(@"can be released correctly", ^{
            expectCheckTool(^(CheckReleaseTool *checkTool) {
                NSObject *listener = [NSObject new];
                UIGestureRecognizer *gestureRecognizer = [UIGestureRecognizer new];
                EZRNode *value = gestureRecognizer.ezm_state;
                UIView *view = [UIView new];
                [view addGestureRecognizer:gestureRecognizer];
                [[value listenedBy:listener] withBlock:^(id  _Nullable next) {
                    
                }];
                [checkTool checkObj:gestureRecognizer];
                [checkTool checkObj:value];
                [checkTool checkObj:view];
            }).to(beReleasedCorrectly());
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
