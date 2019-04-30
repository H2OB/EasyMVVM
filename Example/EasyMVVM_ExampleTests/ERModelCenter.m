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

QuickSpecBegin(ERModelCenterSpec)

describe(@"ERModelCenter test", ^{
    it(@"can get a value from ERModelConter", ^{
        ERTestModel *testmodel = EZM_MODEL(ERTestModel);
        expect(testmodel).notTo(beNil());
    });
    
    it(@"multi times get values from ERModelCenter are same", ^{
        ERTestModel *testmodel1 = EZM_MODEL(ERTestModel);
        ERTestModel *testmodel2 = EZM_MODEL(ERTestModel);
        expect(testmodel1).to(beIdenticalTo(testmodel2));
    });
    
    it(@"should assert when class does not exist", ^{
        {
            assertExpect(^{
                [[EZModelCenter defaultCenter] objectForKeyedSubscript:nil];
            }).to(hasParameterAssert());
        }
        {
            assertExpect(^{
                [[EZModelCenter defaultCenter] objectForKeyedSubscript:NSClassFromString(@"someDoesNotExistClass")];
            }).to(hasAssert());
        }
    });
    
    it(@"can be released correctly", ^{
        expectCheckTool(^(CheckReleaseTool *checkTool) {
            ERTestModel *testmodel = EZM_MODEL(ERTestModel);
            expect(testmodel).notTo(beNil());
            [checkTool checkObj:testmodel];
            
            waitUntil( ^(void (^done)(void)) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    done();
                });
            });
            
        }).to(beReleasedCorrectly());
    });

    it(@"can remove model correctly", ^{
        ERTestModel *testmodel = EZM_MODEL(ERTestModel);
        expect(testmodel).notTo(beNil());
        [[EZModelCenter defaultCenter] removeModelForClass:[ERTestModel class]];
        NSMapTable *internalMapTable = [[EZModelCenter defaultCenter] valueForKey:@"values"];
        id value = [internalMapTable objectForKey:NSStringFromClass([ERTestModel class])];
        expect(value).to(beNil());
    });

});
QuickSpecEnd
