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

#import "ShopListItemView.h"
#import <Masonry/Masonry.h>

@interface ShopListItemView()

@property (nonatomic, strong) UILabel *shopNameLabel;
@property (nonatomic, strong) UIImageView *shopLogoView;
@property (nonatomic, strong) UILabel *shopDescriptionLabel;
@property (nonatomic, strong) UILabel *priceLabel;
@property (nonatomic, strong) UILabel *telephoneLabel;

@end

@implementation ShopListItemView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        _shopLogoView = [[UIImageView alloc] init];
        _shopNameLabel = [[UILabel alloc] init];
        _shopNameLabel.textAlignment = NSTextAlignmentLeft;
        _shopNameLabel.textColor = [UIColor blackColor];
        _shopNameLabel.numberOfLines = 1;
        _shopDescriptionLabel = [[UILabel alloc] init];
        _shopDescriptionLabel.textAlignment = NSTextAlignmentLeft;
        _shopDescriptionLabel.textColor = [UIColor darkGrayColor];
        _shopDescriptionLabel.numberOfLines = 2;
        _priceLabel = [[UILabel alloc] init];
        _priceLabel.textAlignment = NSTextAlignmentLeft;
        _priceLabel.textColor = [UIColor orangeColor];
        _telephoneLabel = [[UILabel alloc] init];
        _telephoneLabel.textAlignment = NSTextAlignmentRight;
        _telephoneLabel.textColor = [UIColor darkGrayColor];
        
        [super addSubview:_shopNameLabel];
        [super addSubview:_shopLogoView];
        [super addSubview:_shopDescriptionLabel];
        [super addSubview:_priceLabel];
        [super addSubview:_telephoneLabel];
        
        __weak typeof(self) weakSelf = self;
        [self.shopLogoView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.and.height.mas_equalTo(100.f);
            make.top.mas_equalTo(weakSelf.mas_top).offset(10.f);
            make.left.mas_equalTo(weakSelf.mas_left).offset(10.f);
        }];
        
        [self.shopNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(weakSelf.shopLogoView.mas_right).offset(10.f);
            make.right.mas_equalTo(weakSelf.mas_right).offset(-10.f);
            make.top.mas_equalTo(weakSelf.shopLogoView.mas_top);
            make.height.mas_equalTo(30.f);
        }];
        
        [self.shopDescriptionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(weakSelf.shopLogoView.mas_right).offset(10.f);
            make.right.mas_equalTo(weakSelf.mas_right).offset(-10.f);
            make.top.mas_equalTo(weakSelf.shopNameLabel.mas_bottom).offset(5.f);
            make.height.mas_equalTo(30.f);
        }];
        
        [self.priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_greaterThanOrEqualTo(100.f);
            make.height.mas_equalTo(30.f);
            make.left.mas_equalTo(weakSelf.shopLogoView.mas_right).offset(10.f);
            make.bottom.mas_equalTo(weakSelf.shopLogoView.mas_bottom);
        }];
        
        [self.telephoneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_greaterThanOrEqualTo(100.f);
            make.height.mas_equalTo(30.f);
            make.right.mas_equalTo(weakSelf.mas_right).offset(-10.f);
            make.bottom.mas_equalTo(weakSelf.shopLogoView.mas_bottom);
        }];

        //* test UI
        self.backgroundColor = [UIColor lightGrayColor];
        _shopLogoView.backgroundColor = [UIColor redColor];
        _shopNameLabel.backgroundColor = [UIColor greenColor];
        _shopDescriptionLabel.backgroundColor = [UIColor blueColor];
        _priceLabel.backgroundColor = [UIColor darkGrayColor];
        _telephoneLabel.backgroundColor = [UIColor purpleColor];
        //*/
        
        _price = _priceLabel.ezm_text;
        _shopName = _shopNameLabel.ezm_text;
        _telephone = _telephoneLabel.ezm_text;
        _shopDescription = _shopDescriptionLabel.ezm_text;
        _shopLogo = [EZRNode new];
        @ezr_weakify(self)
        [[_shopLogo listenedBy:self] withBlockOnMainQueue:^(NSString * _Nullable next) {
            @ezr_strongify(self)
            self.shopLogoView.image = [UIImage imageNamed:next];
        }];
    }
    return self;
}

@end
