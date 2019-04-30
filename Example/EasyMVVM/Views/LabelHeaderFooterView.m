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

#import "LabelHeaderFooterView.h"

@interface LabelHeaderFooterView ()

@property (nonatomic, strong) UILabel *titleLabel;

@end

@implementation LabelHeaderFooterView

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 11, 300, 22)];
        _titleLabel.backgroundColor = [UIColor lightGrayColor];
        [super.contentView addSubview:_titleLabel];
        _title = _titleLabel.ezm_text;
    }
    return self;
}

- (void)willMoveToSuperview:(UIView *)newSuperview {
    self.frame = CGRectMake(0, 0, CGRectGetWidth(newSuperview.frame), 44);
}

@end
