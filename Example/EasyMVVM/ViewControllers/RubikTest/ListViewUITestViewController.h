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

#import <UIKit/UIKit.h>

@interface ListViewUITestViewController : UIViewController

@property (nonatomic, weak) IBOutlet UIButton *resetButton;
@property (nonatomic, weak) IBOutlet UIButton *addButton;
@property (nonatomic, weak) IBOutlet UIButton *deleteButton;
@property (nonatomic, weak) IBOutlet UIButton *moveButton;
@property (nonatomic, weak) IBOutlet UIButton *updateButton;

@property (nonatomic, weak) IBOutlet UIButton *addHeaderButton;
@property (nonatomic, weak) IBOutlet UIButton *removeHeaderButton;
@property (nonatomic, weak) IBOutlet UIButton *changeHeaderButton;
@property (nonatomic, weak) IBOutlet UIButton *addFooterButton;
@property (nonatomic, weak) IBOutlet UIButton *removeFooterButton;
@property (nonatomic, weak) IBOutlet UIButton *changeFooterButton;

@end
