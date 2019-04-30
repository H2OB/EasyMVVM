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

#import "EZMEvent.h"
#import "EZMBinder.h"
#import "EZMListCell+ProjectPrivate.h"

@implementation EZMListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        _selectEvent = [EZMEvent new];
        _willAppearEvent = [EZMEvent new];
        _willDisappearEvent = [EZMEvent new];
        _didAppearEvent = [EZMEvent new];
        _didDisappearEvent = [EZMEvent new];
        _binder = [EZMBinder new];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    if (selected) {
        [self.selectEvent invoke];
    }
}

- (void)prepareForReuse {
    [super prepareForReuse];
    [self.binder cancel];
}
- (void)willMoveToWindow:(UIWindow *)newWindow {
    if (newWindow) {
        [self.willAppearEvent invoke];
    } else {
        [self.willDisappearEvent invoke];
    }
}

- (void)didMoveToWindow {
    if (self.window) {
        [self.didAppearEvent invoke];
    } else {
        [self.didDisappearEvent invoke];
    }
}

@end
