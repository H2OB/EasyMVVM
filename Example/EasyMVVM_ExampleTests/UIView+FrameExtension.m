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

QuickSpecBegin(UIViewFrameExtension)

describe(@"UIView frame extension test", ^{
    context(@"UIView frame extension", ^{
        it(@"can get x / y / width / height value from a node", ^{
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(10, 20, 30, 40)];
            expect(view.x.value.floatValue).to(equal(10));
            expect(view.y.value.floatValue).to(equal(20));
            expect(view.width.value.floatValue).to(equal(30));
            expect(view.height.value.floatValue).to(equal(40));
        });
        
        it(@"can set x / y / width / height value from a node", ^{
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(10, 20, 30, 40)];
            view.x.value = @(50);
            view.y.value = @(60);
            view.width.value = @(70);
            view.height.value = @(80);
            expect(view.frame.origin.x).to(equal(50));
            expect(view.frame.origin.y).to(equal(60));
            expect(view.frame.size.width).to(equal(70));
            expect(view.frame.size.height).to(equal(80));
        });
        
        it(@"can be released correctly", ^{
            expectCheckTool(^(CheckReleaseTool *checkTool) {
                UIView *view = [[UIView alloc] initWithFrame:CGRectMake(10, 20, 30, 40)];
                view.x.value = @(50);
                view.y.value = @(60);
                view.width.value = @(70);
                view.height.value = @(80);
                
                expect(view).notTo(beNil());
                [checkTool checkObj:view];
            }).to(beReleasedCorrectly());
        });
    });
});

QuickSpecEnd
