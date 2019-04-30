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

import Quick
import Nimble

class DynamicListTests: QuickSpec {
    
    override func spec() {
        describe("Dynamic list test") {
            it("should show dynamic listcells correctly") {
                let app = XCUIApplication()
                app.launch()
                let tablesQuery = app.tables
                tablesQuery/*@START_MENU_TOKEN@*/.staticTexts["ListView Test"]/*[[".cells.staticTexts[\"ListView Test\"]",".staticTexts[\"ListView Test\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
                tablesQuery/*@START_MENU_TOKEN@*/.staticTexts["显示动态VM"]/*[[".cells.staticTexts[\"显示动态VM\"]",".staticTexts[\"显示动态VM\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
                
                let mapLabel = { (v: XCUIElement) in
                    return v.label
                }
                let cellValues = app.cells;
                var expectText = ["A", "B", "C", "D", "E", "F", "G", "H"]
                var textsInView = cellValues.children(matching: .staticText).allElementsBoundByIndex.map(mapLabel)
                
                expect(textsInView).to(equal(expectText))
                
                app.buttons["添加一行"].tap()
                expectText.append("T")
                textsInView = cellValues.children(matching: .staticText).allElementsBoundByIndex.map(mapLabel)
                expect(textsInView).to(equal(expectText))
                
                app.buttons["删除一行"].tap()
                expectText.removeLast()
                textsInView = cellValues.children(matching: .staticText).allElementsBoundByIndex.map(mapLabel)
                expect(textsInView).to(equal(expectText))
                
                app.buttons["cell修改"].tap()
                expectText[0] = "T"
                textsInView = cellValues.children(matching: .staticText).allElementsBoundByIndex.map(mapLabel)
                expect(textsInView).to(equal(expectText))
                
                app.buttons["重置"].tap()
                expectText = ["1", "2", "3", "4", "5"]
                textsInView = cellValues.children(matching: .staticText).allElementsBoundByIndex.map(mapLabel)
                expect(textsInView).to(equal(expectText))
            }
        }
    }
}

