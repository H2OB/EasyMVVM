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

class StaticListTests: QuickSpec {

    override func spec() {
         describe("Static list test") {
            it("should show static listcells correctly") {
                let application = XCUIApplication()
                application.launch()
                let tablesQuery = application.tables
                tablesQuery/*@START_MENU_TOKEN@*/.staticTexts["ListView Test"]/*[[".cells.staticTexts[\"ListView Test\"]",".staticTexts[\"ListView Test\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
                tablesQuery/*@START_MENU_TOKEN@*/.staticTexts["显示静态VM"]/*[[".cells.staticTexts[\"显示静态VM\"]",".staticTexts[\"显示静态VM\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
                
                let cellValues = application.cells;
                let expectText = ["A", "B", "C", "D", "E", "F", "G", "H"]
                let textsInView = cellValues.children(matching: .staticText).allElementsBoundByIndex.map { $0.label }

                expect(textsInView).to(equal(expectText))
            }
        }
    }
}

