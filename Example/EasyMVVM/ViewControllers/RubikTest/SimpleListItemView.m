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

#import "SimpleListItemView.h"
#import <Masonry/Masonry.h>

@interface SimpleListItemView ()

@property (nonatomic, strong) UILabel *titleLabel;

@end

@implementation SimpleListItemView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        _titleLabel = [[UILabel alloc] initWithFrame:self.frame];
        _titleLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        _titleLabel.font = [UIFont systemFontOfSize:10.f];
        [self addSubview:_titleLabel];
        
        _text = _titleLabel.ezm_text;

        NSUInteger colorIndex = (int)arc4random_uniform(5.f-0.f+1.f)+0.f;
        NSArray *randomColorArray = @[[UIColor colorWithRed:1.f green:.4f blue:.4f alpha:1.f],
                                      [UIColor yellowColor],
                                      [UIColor colorWithRed:0.f green:.6f blue:1.f alpha:1.f],
                                      [UIColor colorWithRed:0.f green:.8f blue:.4f alpha:1.f],
                                      [UIColor colorWithWhite:.92f alpha:1.f],
                                      [UIColor orangeColor]];
        self.backgroundColor = [randomColorArray objectAtIndex:colorIndex];
        self.clipsToBounds = YES;
    
        __weak typeof(self) weakSelf = self;
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.and.height.equalTo(weakSelf).multipliedBy(0.96);
            make.center.equalTo(weakSelf);
        }];
    }
    return self;
}

@end
