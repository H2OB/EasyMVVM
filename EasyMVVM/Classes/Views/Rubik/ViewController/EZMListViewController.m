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

#import "EZMListViewController.h"

@interface EZMListViewController ()

@end

@implementation EZMListViewController

- (void)loadView {
    _listView = [[EZMListView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.view = _listView;
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)bindView:(EZMBinder *)binder {
    [super bindView:binder];
}

- (instancetype)initWithIdentifier:(NSString *)identifier {
    if (self = [super initWithNibName:nil bundle:nil]) {
        
    }
    return self;
}

- (id<EZMCubePresentation>)cubePresentation {
    return self.listView.cubePresentation;
}

@end
