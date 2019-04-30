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

#import "EZMContainerView.h"
#import "EZMCubePresentation.h"
#import "EZMContainer.h"
#import "EZMRubikView.h"
#import <objc/runtime.h>

@interface EZMContainerView ()

@property (nonatomic, strong) EZMRubikView *rubikView;

@end

@implementation EZMContainerView

- (void)willMoveToSuperview:(UIView *)newSuperview {
    [super willMoveToSuperview:newSuperview];
    
    if (newSuperview) {
        // avoid to create RubikView repeatly
        if (objc_getAssociatedObject(self, _cmd)) {
            return;
        }
        [self layoutIfNeeded];
        self.rubikView = [[EZMRubikView alloc] initWithFrame:self.bounds];
        self.rubikView.cubePresentations.value = [[EZMContainer alloc] initWithArray:@[[self cubePresentation]]];
        self.rubikView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [self addSubview:self.rubikView];
        
        /*
        //[self.rubikView setTranslatesAutoresizingMaskIntoConstraints:NO];
        [self addConstraints:
            @[[NSLayoutConstraint constraintWithItem:self.rubikView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeWidth multiplier:1.f constant:0.f],
            [NSLayoutConstraint constraintWithItem:self.rubikView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeHeight multiplier:1.f constant:0.f],
            [NSLayoutConstraint constraintWithItem:self.rubikView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1.f constant:0.f],
            [NSLayoutConstraint constraintWithItem:self.rubikView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1.f constant:0.f]]
        ];
        //[self layoutIfNeeded];
        //*/
        objc_setAssociatedObject(self, _cmd, @YES, OBJC_ASSOCIATION_RETAIN);
    }
}

@end
