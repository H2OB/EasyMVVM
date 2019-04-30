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

#import "BannerView.h"
#import <Masonry/Masonry.h>

@interface BannerView ()

@property (nonatomic, strong) UILabel *nameLabel;

@end

@implementation BannerView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.textAlignment = NSTextAlignmentLeft;
        
        [super addSubview:_nameLabel];
        super.backgroundColor = [UIColor orangeColor];
        _nameLabel.backgroundColor = [UIColor colorWithWhite:.5 alpha:1.f];
        _name = _nameLabel.ezm_text;

        __weak typeof (self) weakSelf = self;
        [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(weakSelf.mas_width);
            make.centerX.mas_equalTo(weakSelf.mas_centerX);
            make.height.mas_equalTo(30.f);
            make.bottom.mas_equalTo(weakSelf.mas_bottom);
        }];
    }
    return self;
}

@end
