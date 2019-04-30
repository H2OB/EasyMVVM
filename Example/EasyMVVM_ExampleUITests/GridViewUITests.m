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

@import Quick;
@import Nimble;
@import EasyReact;

@interface GridViewUITest: QuickSpec
@end

@implementation GridViewUITest

- (void)spec {
    
    describe(@"EZMGridView UI Tests",^{
        
        it(@"can show cells correctly when cells were added", ^{
            XCUIApplication *app = [[XCUIApplication alloc] init];
            [app launch];
            [app.tables.staticTexts[@"EZMGridView Data React Test"] tap];
            
            XCUIElement *resetButton = app.buttons[@"Reset"];
            XCUIElement *addButton = app.buttons[@"Add"];
            {
                [resetButton tap];
                
                NSArray<NSString *> *expectLabels = @[@"A", @"B", @"C", @"D", @"E", @"F", @"G", @"H", @"I", @"J", @"K"];
                NSArray<XCUIElement *> *elements = app.collectionViews.firstMatch.cells.allElementsBoundByIndex;
                NSMutableArray *labels = [NSMutableArray array];
                [elements enumerateObjectsUsingBlock:^(XCUIElement * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    [labels addObject:[[[obj staticTexts] firstMatch] label]];
                }];
                expect(labels).to(equal(expectLabels));
            }
            {
                [addButton tap];
                
                NSArray<NSString *> *expectLabels = @[@"A", @"B", @"C", @"C1", @"D", @"E", @"E1", @"E2", @"F", @"G", @"H", @"I", @"J", @"K", @"L", @"M"];
                NSArray<XCUIElement *> *elements = app.collectionViews.firstMatch.cells.allElementsBoundByIndex;
                NSMutableArray *labels = [NSMutableArray array];
                [elements enumerateObjectsUsingBlock:^(XCUIElement * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    [labels addObject:[[[obj staticTexts] firstMatch] label]];
                }];
                expect(labels).to(equal(expectLabels));
            }
        });
        
        it(@"can show cells correctly when cells were deleted", ^{
            XCUIApplication *app = [[XCUIApplication alloc] init];
            [app launch];
            [app.tables.staticTexts[@"EZMGridView Data React Test"] tap];
            
            XCUIElement *resetButton = app.buttons[@"Reset"];
            XCUIElement *deleteButton = app.buttons[@"Delete"];
            {
                [resetButton tap];
                
                NSArray<NSString *> *expectLabels = @[@"A", @"B", @"C", @"D", @"E", @"F", @"G", @"H", @"I", @"J", @"K"];
                NSArray<XCUIElement *> *elements = app.collectionViews.firstMatch.cells.allElementsBoundByIndex;
                NSMutableArray *labels = [NSMutableArray array];
                [elements enumerateObjectsUsingBlock:^(XCUIElement * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    [labels addObject:[[[obj staticTexts] firstMatch] label]];
                }];
                expect(labels).to(equal(expectLabels));
            }
            {
                [deleteButton tap];
                
                NSArray<NSString *> *expectLabels = @[@"B", @"C", @"E", @"F", @"G", @"I", @"K"];
                NSArray<XCUIElement *> *elements = app.collectionViews.firstMatch.cells.allElementsBoundByIndex;
                NSMutableArray *labels = [NSMutableArray array];
                [elements enumerateObjectsUsingBlock:^(XCUIElement * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    [labels addObject:[[[obj staticTexts] firstMatch] label]];
                }];
                expect(labels).to(equal(expectLabels));
            }
        });
        
        it(@"can show cells correctly when cells were moved", ^{
            XCUIApplication *app = [[XCUIApplication alloc] init];
            [app launch];
            [app.tables.staticTexts[@"EZMGridView Data React Test"] tap];
            
            XCUIElement *resetButton = app.buttons[@"Reset"];
            XCUIElement *moveButton = app.buttons[@"Move"];
            {
                [resetButton tap];
                
                NSArray<NSString *> *expectLabels = @[@"A", @"B", @"C", @"D", @"E", @"F", @"G", @"H", @"I", @"J", @"K"];
                NSArray<XCUIElement *> *elements = app.collectionViews.firstMatch.cells.allElementsBoundByIndex;
                NSMutableArray *labels = [NSMutableArray array];
                [elements enumerateObjectsUsingBlock:^(XCUIElement * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    [labels addObject:[[[obj staticTexts] firstMatch] label]];
                }];
                expect(labels).to(equal(expectLabels));
            }
            {
                [moveButton tap];
                
                NSArray<NSString *> *expectLabels = @[@"C", @"H", @"I", @"D", @"E", @"F",@"A", @"K", @"B", @"G", @"J"];
                NSArray<XCUIElement *> *elements = app.collectionViews.firstMatch.cells.allElementsBoundByIndex;
                NSMutableArray *labels = [NSMutableArray array];
                [elements enumerateObjectsUsingBlock:^(XCUIElement * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    [labels addObject:[[[obj staticTexts] firstMatch] label]];
                }];
                expect(labels).to(equal(expectLabels));
            }
        });
        
        it(@"can show cells correctly when cells were updated", ^{
            XCUIApplication *app = [[XCUIApplication alloc] init];
            [app launch];
            [app.tables.staticTexts[@"EZMGridView Data React Test"] tap];
            
            XCUIElement *resetButton = app.buttons[@"Reset"];
            XCUIElement *updateButton = app.buttons[@"Update"];
            {
                [resetButton tap];
                
                NSArray<NSString *> *expectLabels = @[@"A", @"B", @"C", @"D", @"E", @"F", @"G", @"H", @"I", @"J", @"K"];
                NSArray<XCUIElement *> *elements = app.collectionViews.firstMatch.cells.allElementsBoundByIndex;
                NSMutableArray *labels = [NSMutableArray array];
                [elements enumerateObjectsUsingBlock:^(XCUIElement * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    [labels addObject:[[[obj staticTexts] firstMatch] label]];
                }];
                expect(labels).to(equal(expectLabels));
            }
            {
                [updateButton tap];
                
                NSArray<NSString *> *expectLabels = @[@"AAA", @"B", @"CCC", @"DDD", @"EEE", @"FFFF", @"G", @"H", @"I", @"J", @"KKKK"];
                NSArray<XCUIElement *> *elements = app.collectionViews.firstMatch.cells.allElementsBoundByIndex;
                NSMutableArray *labels = [NSMutableArray array];
                [elements enumerateObjectsUsingBlock:^(XCUIElement * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    [labels addObject:[[[obj staticTexts] firstMatch] label]];
                }];
                expect(labels).to(equal(expectLabels));
            }
        });
        
        it(@"can show header view correctly when header view was added", ^{
            XCUIApplication *app = [[XCUIApplication alloc] init];
            [app launch];
            [app.tables.staticTexts[@"EZMGridView Data React Test"] tap];
            
            XCUIElement *resetButton = app.buttons[@"Reset"];
            XCUIElement *addHeaderButton = app.buttons[@"Add Header"];
            
            [resetButton tap];
            
            // get frame of first cell
            XCUIElement *firstElement = app.collectionViews.firstMatch.cells.allElementsBoundByIndex.firstObject;
            expect(firstElement.staticTexts.firstMatch.label).to(equal(@"A"));
            CGRect firstCellFrame = firstElement.frame;
            
            [addHeaderButton tap];
            
            // check header view
            CGFloat expectHeaderViewHeight = 30;
            CGRect headerViewFrame = [app.collectionViews.firstMatch.staticTexts[@"This is a header view."] frame];
            CGFloat headerViewHeight = headerViewFrame.size.height;
            expect(headerViewHeight).to(equal(expectHeaderViewHeight));
            
            // check origin-y of first cell
            expect(firstElement.frame.origin.y).to(equal(firstCellFrame.origin.y + expectHeaderViewHeight));
            
            // check cell
            NSArray<NSString *> *expectLabels = @[@"A", @"B", @"C", @"D", @"E", @"F", @"G", @"H", @"I", @"J", @"K"];
            NSArray<XCUIElement *> *elements = [[[app.collectionViews firstMatch] cells] allElementsBoundByIndex];
            NSMutableArray *labels = [NSMutableArray array];
            [elements enumerateObjectsUsingBlock:^(XCUIElement * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                [labels addObject:[[[obj staticTexts] firstMatch] label]];
            }];
            expect(labels).to(equal(expectLabels));
        });
        
        it(@"can show cells correctly when header view was removed", ^{
            XCUIApplication *app = [[XCUIApplication alloc] init];
            [app launch];
            [app.tables.staticTexts[@"EZMGridView Data React Test"] tap];
            
            XCUIElement *resetButton = app.buttons[@"Reset"];
            XCUIElement *addHeaderButton = app.buttons[@"Add Header"];
            XCUIElement *removeHeaderButton = app.buttons[@"Remove Header"];
            
            [resetButton tap];
            
            // get frame of first cell
            XCUIElement *firstElement = app.collectionViews.firstMatch.cells.allElementsBoundByIndex.firstObject;
            expect(firstElement.staticTexts.firstMatch.label).to(equal(@"A"));
            CGRect firstCellFrame = firstElement.frame;
            
            [addHeaderButton tap];
            
            // check header view
            CGFloat expectHeaderViewHeight = 30;
            XCUIElement *headerViewElement = app.collectionViews.firstMatch.staticTexts[@"This is a header view."];
            CGRect headerViewFrame = [headerViewElement frame];
            CGFloat headerViewHeight = headerViewFrame.size.height;
            expect(headerViewHeight).to(equal(expectHeaderViewHeight));
            
            // check origin-y of first cell
            expect(firstElement.frame.origin.y).to(equal(firstCellFrame.origin.y + expectHeaderViewHeight));
            
            // check cell
            NSArray<NSString *> *expectLabels = @[@"A", @"B", @"C", @"D", @"E", @"F", @"G", @"H", @"I", @"J", @"K"];
            NSArray<XCUIElement *> *elements = [[[app.collectionViews firstMatch] cells] allElementsBoundByIndex];
            NSMutableArray *labels = [NSMutableArray array];
            [elements enumerateObjectsUsingBlock:^(XCUIElement * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                [labels addObject:[[[obj staticTexts] firstMatch] label]];
            }];
            expect(labels).to(equal(expectLabels));
            
            [removeHeaderButton tap];
            expect([NSValue valueWithCGRect:firstElement.frame]).to(equal([NSValue valueWithCGRect:firstCellFrame]));
        });
        
        it(@"can show header view correctly when header view was changed", ^{
            XCUIApplication *app = [[XCUIApplication alloc] init];
            [app launch];
            [app.tables.staticTexts[@"EZMGridView Data React Test"] tap];
            
            XCUIElement *resetButton = app.buttons[@"Reset"];
            XCUIElement *addHeaderButton = app.buttons[@"Add Header"];
            XCUIElement *changeHeaderButton = app.buttons[@"Change Header"];
            
            [resetButton tap];
            
            // get frame of first cell
            XCUIElement *firstElement = app.collectionViews.firstMatch.cells.allElementsBoundByIndex.firstObject;
            expect(firstElement.staticTexts.firstMatch.label).to(equal(@"A"));
            CGRect firstCellFrame = firstElement.frame;
            
            [addHeaderButton tap];
            
            // check header view
            CGFloat expectHeaderViewHeight = 30;
            XCUIElement *headerViewElement = app.collectionViews.firstMatch.staticTexts[@"This is a header view."];
            CGRect headerViewFrame = [headerViewElement frame];
            CGFloat headerViewHeight = headerViewFrame.size.height;
            expect(headerViewHeight).to(equal(expectHeaderViewHeight));
            
            // check origin-y of first cell
            expect(firstElement.frame.origin.y).to(equal(firstCellFrame.origin.y + expectHeaderViewHeight));
            
            // check cell
            NSArray<NSString *> *expectLabels = @[@"A", @"B", @"C", @"D", @"E", @"F", @"G", @"H", @"I", @"J", @"K"];
            NSArray<XCUIElement *> *elements = [[[app.collectionViews firstMatch] cells] allElementsBoundByIndex];
            NSMutableArray *labels = [NSMutableArray array];
            [elements enumerateObjectsUsingBlock:^(XCUIElement * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                [labels addObject:[[[obj staticTexts] firstMatch] label]];
            }];
            expect(labels).to(equal(expectLabels));
            
            [changeHeaderButton tap];
            
            // check header view after changed
            CGFloat expectChangedHeaderViewHeight = 60;
            XCUIElement *changedHeaderViewElement = app.collectionViews.firstMatch.staticTexts[@"This is a header view."];
            CGRect changedHeaderViewFrame = [changedHeaderViewElement frame];
            CGFloat changedHeaderViewHeight = changedHeaderViewFrame.size.height;
            expect(changedHeaderViewHeight).to(equal(expectChangedHeaderViewHeight));
            
            // check origin-y of first cell after changed
            expect(firstElement.frame.origin.y).to(equal(firstCellFrame.origin.y + expectChangedHeaderViewHeight));
        });
        
        it(@"can show footer view correctly when footer view was added", ^{
            XCUIApplication *app = [[XCUIApplication alloc] init];
            [app launch];
            [app.tables.staticTexts[@"EZMGridView Data React Test"] tap];
            
            XCUIElement *resetButton = app.buttons[@"Reset"];
            XCUIElement *addFooterButton = app.buttons[@"Add Footer"];
            
            [resetButton tap];
            
            // get frame of last cell
            XCUIElement *lastElement = app.collectionViews.firstMatch.cells.allElementsBoundByIndex.lastObject;
            expect(lastElement.staticTexts.firstMatch.label).to(equal(@"K"));
            
            [addFooterButton tap];
            
            // check footer view
            CGFloat expectFooterViewHeight = 30;
            CGRect footerViewFrame = [app.collectionViews.firstMatch.staticTexts[@"This is a footer view."] frame];
            CGFloat footerViewHeight = footerViewFrame.size.height;
            expect(footerViewHeight).to(equal(expectFooterViewHeight));
            
            // check origin-y of footer view
            expect(footerViewFrame.origin.y).to(equal(lastElement.frame.origin.y + lastElement.frame.size.height));
            
            // check cell
            NSArray<NSString *> *expectLabels = @[@"A", @"B", @"C", @"D", @"E", @"F", @"G", @"H", @"I", @"J", @"K"];
            NSArray<XCUIElement *> *elements = [[[app.collectionViews firstMatch] cells] allElementsBoundByIndex];
            NSMutableArray *labels = [NSMutableArray array];
            [elements enumerateObjectsUsingBlock:^(XCUIElement * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                [labels addObject:[[[obj staticTexts] firstMatch] label]];
            }];
            expect(labels).to(equal(expectLabels));
        });
        
        it(@"can show cells correctly when footer view was removed", ^{
            XCUIApplication *app = [[XCUIApplication alloc] init];
            [app launch];
            [app.tables.staticTexts[@"EZMGridView Data React Test"] tap];
            
            XCUIElement *resetButton = app.buttons[@"Reset"];
            XCUIElement *addFooterButton = app.buttons[@"Add Footer"];
            XCUIElement *removeFooterButton = app.buttons[@"Remove Footer"];
            
            [resetButton tap];
            
            // get frame of last cell
            XCUIElement *lastElement = app.collectionViews.firstMatch.cells.allElementsBoundByIndex.lastObject;
            expect(lastElement.staticTexts.firstMatch.label).to(equal(@"K"));
            
            [addFooterButton tap];
            
            // check footer view
            CGFloat expectFooterViewHeight = 30;
            CGRect footerViewFrame = [app.collectionViews.firstMatch.staticTexts[@"This is a footer view."] frame];
            CGFloat footerViewHeight = footerViewFrame.size.height;
            expect(footerViewHeight).to(equal(expectFooterViewHeight));
            
            // check origin-y of footer view
            expect(footerViewFrame.origin.y).to(equal(lastElement.frame.origin.y + lastElement.frame.size.height));
            
            // check cell
            NSArray<NSString *> *expectLabels = @[@"A", @"B", @"C", @"D", @"E", @"F", @"G", @"H", @"I", @"J", @"K"];
            NSArray<XCUIElement *> *elements = [[[app.collectionViews firstMatch] cells] allElementsBoundByIndex];
            NSMutableArray *labels = [NSMutableArray array];
            [elements enumerateObjectsUsingBlock:^(XCUIElement * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                [labels addObject:[[[obj staticTexts] firstMatch] label]];
            }];
            expect(labels).to(equal(expectLabels));
            
            [removeFooterButton tap];
            //TODO: check footer is nil
        });
        
        it(@"can show footer view correctly when footer view was changed", ^{
            XCUIApplication *app = [[XCUIApplication alloc] init];
            [app launch];
            [app.tables.staticTexts[@"EZMGridView Data React Test"] tap];
            
            XCUIElement *resetButton = app.buttons[@"Reset"];
            XCUIElement *addFooterButton = app.buttons[@"Add Footer"];
            XCUIElement *changeFooterButton = app.buttons[@"Change Footer"];
            
            [resetButton tap];
            
            // get frame of last cell
            XCUIElement *lastElement = app.collectionViews.firstMatch.cells.allElementsBoundByIndex.lastObject;
            expect(lastElement.staticTexts.firstMatch.label).to(equal(@"K"));
            
            [addFooterButton tap];
            
            // check footer view
            CGFloat expectFooterViewHeight = 30;
            CGRect footerViewFrame = [app.collectionViews.firstMatch.staticTexts[@"This is a footer view."] frame];
            CGFloat footerViewHeight = footerViewFrame.size.height;
            expect(footerViewHeight).to(equal(expectFooterViewHeight));
            
            // check origin-y of footer view
            expect(footerViewFrame.origin.y).to(equal(lastElement.frame.origin.y + lastElement.frame.size.height));
            
            // check cell
            NSArray<NSString *> *expectLabels = @[@"A", @"B", @"C", @"D", @"E", @"F", @"G", @"H", @"I", @"J", @"K"];
            NSArray<XCUIElement *> *elements = [[[app.collectionViews firstMatch] cells] allElementsBoundByIndex];
            NSMutableArray *labels = [NSMutableArray array];
            [elements enumerateObjectsUsingBlock:^(XCUIElement * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                [labels addObject:[[[obj staticTexts] firstMatch] label]];
            }];
            expect(labels).to(equal(expectLabels));
            
            [changeFooterButton tap];
            
            // check footer view after changed
            CGFloat expectChangedFooterViewHeight = 100;
            XCUIElement *changedFooterViewElement = app.collectionViews.firstMatch.staticTexts[@"This is a footer view."];
            CGRect changedFooterViewFrame = [changedFooterViewElement frame];
            CGFloat changedFooterViewHeight = changedFooterViewFrame.size.height;
            expect(changedFooterViewHeight).to(equal(expectChangedFooterViewHeight));
            
            //TODO: check cells aren't changed
        });

        it(@"can increase column count", ^{
            XCUIApplication *app = [[XCUIApplication alloc] init];
            [app launch];
            [app.tables.staticTexts[@"EZMGridView Data React Test"] tap];
            
            XCUIElement *resetButton = app.buttons[@"Reset"];
            XCUIElement *increaseButton = app.buttons[@"increase column count"];
            
            {
                [resetButton tap];
                
                NSArray<NSString *> *expectLabels = @[@"A", @"B", @"C", @"D", @"E", @"F", @"G", @"H", @"I", @"J", @"K"];
                NSArray<XCUIElement *> *elements = app.collectionViews.firstMatch.cells.allElementsBoundByIndex;
                NSMutableArray *labels = [NSMutableArray array];
                [elements enumerateObjectsUsingBlock:^(XCUIElement * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    [labels addObject:[[[obj staticTexts] firstMatch] label]];
                }];
                expect(labels).to(equal(expectLabels));
            }
            {
                [increaseButton tap];
                
                NSArray<NSString *> *expectLabels = @[@"A", @"B", @"C", @"D", @"E", @"F", @"G", @"H", @"I", @"J", @"K"];
                NSArray<XCUIElement *> *elements = app.collectionViews.firstMatch.cells.allElementsBoundByIndex;
                NSMutableArray *labels = [NSMutableArray array];
                [elements enumerateObjectsUsingBlock:^(XCUIElement * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    [labels addObject:[[[obj staticTexts] firstMatch] label]];
                }];
                expect(labels).to(equal(expectLabels));
            }
            {
                [increaseButton tap];
                
                NSArray<NSString *> *expectLabels = @[@"A", @"B", @"C", @"D", @"E", @"F", @"G", @"H", @"I", @"J", @"K"];
                NSArray<XCUIElement *> *elements = app.collectionViews.firstMatch.cells.allElementsBoundByIndex;
                NSMutableArray *labels = [NSMutableArray array];
                [elements enumerateObjectsUsingBlock:^(XCUIElement * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    [labels addObject:[[[obj staticTexts] firstMatch] label]];
                }];
                expect(labels).to(equal(expectLabels));
            }
        });
        
        it(@"can decrease column count", ^{
            XCUIApplication *app = [[XCUIApplication alloc] init];
            [app launch];
            [app.tables.staticTexts[@"EZMGridView Data React Test"] tap];
            
            XCUIElement *resetButton = app.buttons[@"Reset"];
            XCUIElement *decreaseButton = app.buttons[@"decrease column count"];
            
            {
                [resetButton tap];
                
                NSArray<NSString *> *expectLabels = @[@"A", @"B", @"C", @"D", @"E", @"F", @"G", @"H", @"I", @"J", @"K"];
                NSArray<XCUIElement *> *elements = app.collectionViews.firstMatch.cells.allElementsBoundByIndex;
                NSMutableArray *labels = [NSMutableArray array];
                [elements enumerateObjectsUsingBlock:^(XCUIElement * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    [labels addObject:[[[obj staticTexts] firstMatch] label]];
                }];
                expect(labels).to(equal(expectLabels));
            }
            {
                [decreaseButton tap];
                
                NSArray<NSString *> *expectLabels = @[@"A", @"B", @"C", @"D", @"E", @"F", @"G", @"H", @"I", @"J", @"K"];
                NSArray<XCUIElement *> *elements = app.collectionViews.firstMatch.cells.allElementsBoundByIndex;
                NSMutableArray *labels = [NSMutableArray array];
                [elements enumerateObjectsUsingBlock:^(XCUIElement * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    [labels addObject:[[[obj staticTexts] firstMatch] label]];
                }];
                expect(labels).to(equal(expectLabels));
            }
            {
                [decreaseButton tap];
                
                NSArray<NSString *> *expectLabels = @[@"A", @"B", @"C", @"D", @"E", @"F", @"G", @"H", @"I", @"J", @"K"];
                NSArray<XCUIElement *> *elements = app.collectionViews.firstMatch.cells.allElementsBoundByIndex;
                NSMutableArray *labels = [NSMutableArray array];
                [elements enumerateObjectsUsingBlock:^(XCUIElement * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    [labels addObject:[[[obj staticTexts] firstMatch] label]];
                }];
                expect(labels).to(equal(expectLabels));
            }
        });

        it(@"can increase item height", ^{
            XCUIApplication *app = [[XCUIApplication alloc] init];
            [app launch];
            [app.tables.staticTexts[@"EZMGridView Data React Test"] tap];
            
            XCUIElement *resetButton = app.buttons[@"Reset"];
            XCUIElement *increaseButton = app.buttons[@"increase item height"];
            
            {
                [resetButton tap];
                
                NSArray<NSString *> *expectLabels = @[@"A", @"B", @"C", @"D", @"E", @"F", @"G", @"H", @"I", @"J", @"K"];
                NSArray<XCUIElement *> *elements = app.collectionViews.firstMatch.cells.allElementsBoundByIndex;
                NSMutableArray *labels = [NSMutableArray array];
                [elements enumerateObjectsUsingBlock:^(XCUIElement * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    [labels addObject:[[[obj staticTexts] firstMatch] label]];
                }];
                expect(labels).to(equal(expectLabels));
            }
            {
                [increaseButton tap];
                
                NSArray<NSString *> *expectLabels = @[@"A", @"B", @"C", @"D", @"E", @"F", @"G", @"H", @"I", @"J", @"K"];
                NSArray<XCUIElement *> *elements = app.collectionViews.firstMatch.cells.allElementsBoundByIndex;
                NSMutableArray *labels = [NSMutableArray array];
                [elements enumerateObjectsUsingBlock:^(XCUIElement * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    [labels addObject:[[[obj staticTexts] firstMatch] label]];
                }];
                expect(labels).to(equal(expectLabels));
            }
            {
                [increaseButton tap];
                
                NSArray<NSString *> *expectLabels = @[@"A", @"B", @"C", @"D", @"E", @"F", @"G", @"H", @"I", @"J", @"K"];
                NSArray<XCUIElement *> *elements = app.collectionViews.firstMatch.cells.allElementsBoundByIndex;
                NSMutableArray *labels = [NSMutableArray array];
                [elements enumerateObjectsUsingBlock:^(XCUIElement * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    [labels addObject:[[[obj staticTexts] firstMatch] label]];
                }];
                expect(labels).to(equal(expectLabels));
            }
        });

        it(@"can decrease item height", ^{
            XCUIApplication *app = [[XCUIApplication alloc] init];
            [app launch];
            [app.tables.staticTexts[@"EZMGridView Data React Test"] tap];
            
            XCUIElement *resetButton = app.buttons[@"Reset"];
            XCUIElement *decreaseButton = app.buttons[@"decrease item height"];
            
            {
                [resetButton tap];
                
                NSArray<NSString *> *expectLabels = @[@"A", @"B", @"C", @"D", @"E", @"F", @"G", @"H", @"I", @"J", @"K"];
                NSArray<XCUIElement *> *elements = app.collectionViews.firstMatch.cells.allElementsBoundByIndex;
                NSMutableArray *labels = [NSMutableArray array];
                [elements enumerateObjectsUsingBlock:^(XCUIElement * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    [labels addObject:[[[obj staticTexts] firstMatch] label]];
                }];
                expect(labels).to(equal(expectLabels));
            }
            {
                [decreaseButton tap];
                
                NSArray<NSString *> *expectLabels = @[@"A", @"B", @"C", @"D", @"E", @"F", @"G", @"H", @"I", @"J", @"K"];
                NSArray<XCUIElement *> *elements = app.collectionViews.firstMatch.cells.allElementsBoundByIndex;
                NSMutableArray *labels = [NSMutableArray array];
                [elements enumerateObjectsUsingBlock:^(XCUIElement * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    [labels addObject:[[[obj staticTexts] firstMatch] label]];
                }];
                expect(labels).to(equal(expectLabels));
            }
            {
                [decreaseButton tap];
                
                NSArray<NSString *> *expectLabels = @[@"A", @"B", @"C", @"D", @"E", @"F", @"G", @"H", @"I", @"J", @"K"];
                NSArray<XCUIElement *> *elements = app.collectionViews.firstMatch.cells.allElementsBoundByIndex;
                NSMutableArray *labels = [NSMutableArray array];
                [elements enumerateObjectsUsingBlock:^(XCUIElement * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    [labels addObject:[[[obj staticTexts] firstMatch] label]];
                }];
                expect(labels).to(equal(expectLabels));
            }
        });
    });
}

@end
