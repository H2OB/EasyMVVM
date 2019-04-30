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

#import "CategoryItemView.h"
#import <Masonry/Masonry.h>

@interface CategoryItemView ()

@property (nonatomic, strong) UIImageView *iconView;
@property (nonatomic, strong) UILabel *nameLabel;

@end

@implementation CategoryItemView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        _iconView = [[UIImageView alloc] init];
        self.backgroundColor = [UIColor orangeColor];
        _iconView.contentMode = UIViewContentModeScaleAspectFit;
        
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.textAlignment = NSTextAlignmentCenter;
        _nameLabel.textColor = [UIColor darkGrayColor];
        
        [super addSubview:_iconView];
        [super addSubview:_nameLabel];
    
        __weak typeof(self) weakSelf = self;
        [self.iconView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(weakSelf.nameLabel.mas_top);
            make.top.mas_equalTo(weakSelf.mas_top);
            make.centerX.mas_equalTo(weakSelf.mas_centerX);
            make.width.mas_equalTo(weakSelf.iconView.mas_height);
        }];
        
        [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(weakSelf.mas_width);
            make.height.mas_equalTo(30.f);
            make.centerX.mas_equalTo(weakSelf.mas_centerX);
            make.bottom.mas_equalTo(weakSelf.mas_bottom);
        }];

        _iconName = [EZRNode new];
        _categoryName = _nameLabel.ezm_text;
        @ezr_weakify(self)
        [[_categoryName listenedBy:self] withBlockOnMainQueue:^(NSString * _Nullable next) {
            @ezr_strongify(self)
            self.iconView.image = [UIImage imageNamed:next];
        }];
    }
    return self;
}

@end
