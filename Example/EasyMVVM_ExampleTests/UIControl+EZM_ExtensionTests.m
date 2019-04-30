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

QuickSpecBegin(UIControlExtension)

describe(@"UIControl extension test", ^{
    context(@"UIControl extension", ^{
        it(@"can get a value from an UIControl", ^{
            NSObject *listener = [NSObject new];
            UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
            EZRNode<EZMControlWithEvents *> *node = [button ezm_nodeForEvents:UIControlEventTouchUpInside];
            
            [node startListenForTestWithObj:listener];
            expect(node).notTo(beNil());
            
            [button sendActionsForControlEvents:UIControlEventTouchUpInside];
            expect(node.value.control).to(equal(button));
            expect(@(node.value.events)).to(equal(@(UIControlEventTouchUpInside)));
        });
        
        it(@"can listen to each event from an UIControl", ^{
            NSObject *listener = [NSObject new];
            UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
            EZRNode<EZMControlWithEvents *> *value = [button ezm_nodeForEvents:UIControlEventTouchUpInside];
            
            TestListenEdge *listenEdge = [TestListenEdge new];
            [[value listenedBy:listener] withListenEdge:listenEdge];
            
            [button sendActionsForControlEvents:UIControlEventTouchUpInside];
            [button sendActionsForControlEvents:UIControlEventTouchDown];
            [button sendActionsForControlEvents:UIControlEventTouchUpInside];
            
            expect(listenEdge.receiveValues).to(haveCount(2));
        });

        it(@"can be released correctly", ^{
            expectCheckTool(^(CheckReleaseTool *checkTool) {
                UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
                EZRNode<EZMControlWithEvents *> *node = [button ezm_nodeForEvents:UIControlEventTouchUpInside];
                [checkTool checkObj:node];
                [checkTool checkObj:button];
            }).to(beReleasedCorrectly());
        });
        
        it(@"won't be released if there is at least one listener", ^{
            __weak EZRNode<EZMControlWithEvents *> *value = nil;
            @autoreleasepool {
                NSObject *listener = [NSObject new];
                UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
                id<EZRCancelable> cancelable = nil;
                @autoreleasepool {
                    EZRNode<EZMControlWithEvents *> *strongValue = [button ezm_nodeForEvents:UIControlEventTouchUpInside];
                    value = strongValue;
                    cancelable = [[value listenedBy:listener] withBlock:^(EZMControlWithEvents * _Nullable next) {
                        
                    }];
                }
                expect(value).notTo(beNil());
                [cancelable cancel];
            }
            expect(value).to(beNil());
        });
        
        it(@"will be released if the UIControl is released", ^{
            expectCheckTool(^(CheckReleaseTool *checkTool) {
                NSObject *listener = [NSObject new];
                UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
                EZRNode *value = [button ezm_nodeForEvents:UIControlEventTouchUpInside];
                [[value listenedBy:listener] withBlock:^(id  _Nullable next) {
                    
                }];
                [checkTool checkObj:button];
                [checkTool checkObj:value];
            }).to(beReleasedCorrectly());
        });
    });
    
    context(@"UIButton+ERAction", ^{
        it(@"can bind an ERAction to a UIButton", ^{
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            __block NSString *result = nil;
            EZMHandler *handler = [[EZMHandler alloc] initWithBlock:^{
                result = @"result";
            }];
 
            EZMBinder *binder = [[EZMBinder alloc] initWithAssociateObject:button];
            [binder bindEvent:button.ezm_touchEvent toHandler:handler];
            [button sendActionsForControlEvents:UIControlEventTouchUpInside];
            expect(result).to(equal(@"result"));
        });
        
        it(@"can be released correctly", ^{
            expectCheckTool(^(CheckReleaseTool *checkTool) {
                UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
                __block NSString *result = nil;
                EZMHandler *handler = [[EZMHandler alloc] initWithBlock:^{
                    result = @"result";
                }];
                
                EZMBinder *binder = [[EZMBinder alloc] initWithAssociateObject:button];
                [binder bindEvent:button.ezm_touchEvent toHandler:handler];
                [button sendActionsForControlEvents:UIControlEventTouchUpInside];
                
                [checkTool checkObj:button];
            }).to(beReleasedCorrectly());
        });
    });
    
    context(@"UIBarButtonItem+EZMEvent", ^{
        it(@"can bind an ERAction to a UIBarButtonItem", ^{
            UIBarButtonItem *barItem = [[UIBarButtonItem alloc] initWithCustomView:[UIView new]];
             __block NSString *result = nil;
            EZMHandler *handler = [[EZMHandler alloc] initWithBlock:^{
                result = @"result";
            }];
            EZMBinder *binder = [[EZMBinder alloc] initWithAssociateObject:barItem];
            [binder bindEvent:barItem.ezm_touchEvent toHandler:handler];

            [barItem performSelector:barItem.action];
            expect(result).to(equal(@"result"));
        });
        
        it(@"can be released correctly", ^{
            expectCheckTool(^(CheckReleaseTool *checkTool) {
                UIBarButtonItem *barItem = [[UIBarButtonItem alloc] initWithCustomView:[UIView new]];
                 __block NSString *result = nil;
                EZMHandler *handler = [[EZMHandler alloc] initWithBlock:^{
                    result = @"result";
                }];
                EZMBinder *binder = [[EZMBinder alloc] initWithAssociateObject:barItem];
                [binder bindEvent:barItem.ezm_touchEvent toHandler:handler];
                [checkTool checkObj:barItem];
            }).to(beReleasedCorrectly());
        });
    });
    
    context(@"Extension for UIControls", ^{
        it(@"can get the selected index of a UISegmentedControl through an EZRNode", ^{
            UISegmentedControl *segControl = [[UISegmentedControl alloc] initWithItems:@[@"a", @"b", @"c"]];
            EZRNode<NSNumber *> *index = segControl.ezm_selectedIndex;
            index.mutablify.value = @2;
            expect(segControl.selectedSegmentIndex).to(equal(2));
            segControl.selectedSegmentIndex = 1;
            expect(index.value).to(equal(@1));
        });
        
        it(@"can get the value of a UISlider through an EZRNode", ^{
            UISlider *slider = [[UISlider alloc] init];
            EZRNode<NSNumber *> *slidERNode = slider.ezm_value;
            slider.value = 0.5;
            expect(slidERNode.value).to(equal(@0.5));
            slidERNode.mutablify.value = @0.3;
            expect(slider.value).to(beCloseTo(@0.3));
        });
        
        it(@"can get the status of a UISwitch through an EZRNode", ^{
            UISwitch *sw = [[UISwitch alloc] init];
            EZRNode<NSNumber *> *switchValue = sw.ezm_on;
            expect(switchValue.value.boolValue).to(beFalse());
            switchValue.mutablify.value = @YES;
            expect(sw.isOn).to(beTrue());
            sw.on = NO;
            expect(switchValue.value.boolValue).to(beFalse());
        });
        
        it(@"can get the value of a UIStepper through an EZRNode", ^{
            UIStepper *stepper = [[UIStepper alloc] init];
            EZRNode<NSNumber *> *steppERNode = stepper.ezm_value;
            expect(steppERNode.value).to(equal(@0));
            stepper.value = 42;
            expect(steppERNode.value).to(equal(@42));
            steppERNode.mutablify.value = @99;
            expect(stepper.value).to(equal(99));
        });
        
        it(@"can get the value of a UILabel through an EZRNode", ^{
            UILabel *label = [[UILabel alloc] init];
            EZRNode<NSString *> *labeelNode = label.ezm_text;
            
            label.text = @"xx";
            expect(labeelNode.value).to(equal(@"xx"));
            labeelNode.mutablify.value = @"zz";
            expect(label.text).to(equal(@"zz"));
        });
        
        it(@"can get the current page of a UIPageControl through an EZRNode", ^{
            UIPageControl *pageControl = [[UIPageControl alloc] init];
            pageControl.numberOfPages = 5;
            EZRNode<NSNumber *> *pageValue = pageControl.ezm_currentPage;
            expect(pageValue.value).to(equal(@0));
            pageValue.mutablify.value = @3;
            expect(pageControl.currentPage).to(equal(3));
            pageControl.currentPage = 4;
            expect(pageValue.value).to(equal(@4));
        });
        
        it(@"can get the current text of a UITextField through an EZRNode", ^{
            UITextField *tf = [[UITextField alloc] init];
            EZRNode<NSString *> *textValue = tf.ezm_text;
            expect(textValue.value).to(equal(@""));
            
            tf.text = @"test";
            expect(textValue.value).to(equal(@"test"));
            
            textValue.mutablify.value = @"aaa";
            expect(tf.text).to(equal(@"aaa"));
        });
        
        it(@"returns the same node if it was called multiple times", ^{
            UISegmentedControl *seg = [[UISegmentedControl alloc] initWithItems:@[@"a"]];
            EZRNode *segIndex1 = seg.ezm_selectedIndex;
            EZRNode *segIndex2 = seg.ezm_selectedIndex;
            expect(segIndex1 == segIndex2).to(beTrue());
            
            UISlider *slider = [UISlider new];
            EZRNode *sliderNode1 = slider.ezm_value;
            EZRNode *sliderNode2 = slider.ezm_value;
            expect(sliderNode1 == sliderNode2).to(beTrue());
            
            UISwitch *sw = [UISwitch new];
            EZRNode *switchNode1 = sw.ezm_on;
            EZRNode *switchNode2 = sw.ezm_on;
            expect(switchNode1 == switchNode2).to(beTrue());
            
            UIStepper *st = [UIStepper new];
            EZRNode *stepperNode1 = st.ezm_value;
            EZRNode *stepperNode2 = st.ezm_value;
            expect(stepperNode1 == stepperNode2).to(beTrue());
            
            UIPageControl *pageControl = [UIPageControl new];
            EZRNode *page1 = pageControl.ezm_currentPage;
            EZRNode *page2 = pageControl.ezm_currentPage;
            expect(page1 == page2).to(beTrue());
            
            UITextField *tf = [UITextField new];
            EZRNode *text1 = tf.ezm_text;
            EZRNode *text2 = tf.ezm_text;
            expect(text1 == text2).to(beTrue());
            
            UILabel *label = [UILabel new];
            EZRNode *labelNode1 = label.ezm_text;
            EZRNode *labelNode2 = label.ezm_text;
            expect(labelNode1).to(beIdenticalTo(labelNode2));
        });
        
        xit(@"can be released correctly", ^{
            {
                void (^check)(CheckReleaseTool *checkTool) = ^(CheckReleaseTool *checkTool) {
                    UISegmentedControl *segControl = [[UISegmentedControl alloc] initWithItems:@[@"a", @"b", @"c"]];
                    EZRNode<NSNumber *> *index = segControl.ezm_selectedIndex;
                    index.mutablify.value = @2;
                    [checkTool checkObj:segControl];
                    [checkTool checkObj:index];
                };
                expectCheckTool(check).to(beReleasedCorrectly());
            }
            
            {
                expectCheckTool(^(CheckReleaseTool *checkTool) {
                    UISlider *slider = [[UISlider alloc] init];
                    EZRNode<NSNumber *> *slidERNode = slider.ezm_value;
                    slider.value = 0.5;
                    slidERNode.mutablify.value = @0.3;
                    
                    [checkTool checkObj:slider];
                    [checkTool checkObj:slidERNode];
                }).to(beReleasedCorrectly());
            }
            
            {
                expectCheckTool(^(CheckReleaseTool *checkTool) {
                    UISwitch *sw = [[UISwitch alloc] init];
                    EZRNode<NSNumber *> *switchValue = sw.ezm_on;
                    switchValue.mutablify.value = @YES;
                    sw.on = NO;
                    [checkTool checkObj:sw];
                    [checkTool checkObj:switchValue];
                }).to(beReleasedCorrectly());
            }
            
            {
                expectCheckTool(^(CheckReleaseTool *checkTool) {
                    UIStepper *stepper = [[UIStepper alloc] init];
                    EZRNode<NSNumber *> *steppERNode = stepper.ezm_value;
                    stepper.value = 42;
                    steppERNode.mutablify.value = @99;
                    
                    [checkTool checkObj:stepper];
                    [checkTool checkObj:steppERNode];
                }).to(beReleasedCorrectly());
            }
            
            {
                expectCheckTool(^(CheckReleaseTool *checkTool) {
                    UILabel *label = [[UILabel alloc] init];
                    EZRNode<NSString *> *labelNode = label.ezm_text;
                    label.text = @"xx";
                    labelNode.mutablify.value = @"zz";
                    
                    [checkTool checkObj:label];
                    [checkTool checkObj:labelNode];
                }).to(beReleasedCorrectly());
            }
            
            {
                expectCheckTool(^(CheckReleaseTool *checkTool) {
                    UIPageControl *pageControl = [[UIPageControl alloc] init];
                    pageControl.numberOfPages = 5;
                    EZRNode<NSNumber *> *pageValue = pageControl.ezm_currentPage;
                    pageValue.mutablify.value = @3;
                    pageControl.currentPage = 4;
                    [checkTool checkObj:pageControl];
                    [checkTool checkObj:pageValue];
                }).to(beReleasedCorrectly());
            }
            
            {
                expectCheckTool(^(CheckReleaseTool *checkTool) {
                    UITextField *tf = [[UITextField alloc] init];
                    EZRNode<NSString *> *textValue = tf.ezm_text;
                    tf.text = @"test1";
                    textValue.mutablify.value = @"test2";
                    [checkTool checkObj:tf];
                    [checkTool checkObj:textValue];
                }).to(beReleasedCorrectly());
            }
        });
    });
});

QuickSpecEnd
