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

#import "UIView+EZM_FrameExtension.h"
#import <EasyReact/EasyReact.h>
@import ObjectiveC.runtime;

const static void *UIViewEZMExtentionXKey = &UIViewEZMExtentionXKey;
const static void *UIViewEZMExtentionYKey = &UIViewEZMExtentionYKey;
const static void *UIViewEZMExtentionWidthKey = &UIViewEZMExtentionWidthKey;
const static void *UIViewEZMExtentionHeightKey = &UIViewEZMExtentionHeightKey;

@implementation UIView (EZM_FrameExtension)

- (EZRMutableNode<NSNumber *> *)x {
    __block BOOL frameChanged = NO;
    __block BOOL nodeChanged = NO;
    EZRMutableNode<NSNumber *> *xNode = objc_getAssociatedObject(self, UIViewEZMExtentionXKey);
    if (!xNode) {
        @synchronized (self) {
            xNode = objc_getAssociatedObject(self, UIViewEZMExtentionXKey);
            if (!xNode) {
                xNode = [EZRMutableNode new];
                @ezr_weakify(self)
                [[xNode listenedBy:self] withBlock:^(NSNumber * _Nullable next) {
                    @ezr_strongify(self)
                    if (!frameChanged) {
                        nodeChanged = YES;
                        CGRect rect = self.frame;
                        rect.origin.x = next.floatValue;
                        self.frame = rect;
                        nodeChanged = NO;
                    }
                }];
                [[EZR_PATH(self, frame) listenedBy:self] withBlock:^(NSValue * _Nullable next) {
                    if (!nodeChanged) {
                        frameChanged = YES;
                        xNode.value = @(next.CGRectValue.origin.x);
                        frameChanged = NO;
                    }
                }];
                objc_setAssociatedObject(self, UIViewEZMExtentionXKey, xNode, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            }
        }
    }
    return xNode;
}

- (EZRMutableNode<NSNumber *> *)y {
    __block BOOL frameChanged = NO;
    __block BOOL nodeChanged = NO;
    EZRMutableNode<NSNumber *> *yNode = objc_getAssociatedObject(self, UIViewEZMExtentionYKey);
    if (!yNode) {
        @synchronized (self) {
            yNode = objc_getAssociatedObject(self, UIViewEZMExtentionYKey);
            if (!yNode) {
                yNode = [EZRMutableNode new];
                @ezr_weakify(self)
                [[yNode listenedBy:self] withBlock:^(NSNumber * _Nullable next) {
                    @ezr_strongify(self)
                    if (!frameChanged) {
                        nodeChanged = YES;
                        CGRect rect = self.frame;
                        rect.origin.y = next.floatValue;
                        self.frame = rect;
                        nodeChanged = NO;
                    }
                }];
                [[EZR_PATH(self, frame) listenedBy:self] withBlock:^(NSValue * _Nullable next) {
                    if (!nodeChanged) {
                        frameChanged = YES;
                        yNode.value = @(next.CGRectValue.origin.y);
                        frameChanged = NO;
                    }
                }];
                objc_setAssociatedObject(self, UIViewEZMExtentionYKey, yNode, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            }
        }
    }
    return yNode;
}

- (EZRMutableNode<NSNumber *> *)width {
    __block BOOL frameChanged = NO;
    __block BOOL nodeChanged = NO;
    EZRMutableNode<NSNumber *> *widthNode = objc_getAssociatedObject(self, UIViewEZMExtentionWidthKey);
    if (!widthNode) {
        @synchronized (self) {
            widthNode = objc_getAssociatedObject(self, UIViewEZMExtentionWidthKey);
            if (!widthNode) {
                widthNode = [EZRMutableNode new];
                @ezr_weakify(self)
                [[widthNode listenedBy:self] withBlock:^(NSNumber * _Nullable next) {
                    @ezr_strongify(self)
                    if (!frameChanged) {
                        nodeChanged = YES;
                        CGRect rect = self.frame;
                        rect.size.width = next.floatValue;
                        self.frame = rect;
                        nodeChanged = NO;
                    }
                }];
                [[EZR_PATH(self, frame) listenedBy:self] withBlock:^(NSValue * _Nullable next) {
                    if (!nodeChanged) {
                        frameChanged = YES;
                        widthNode.value = @(next.CGRectValue.size.width);
                        frameChanged = NO;
                    }
                }];
                objc_setAssociatedObject(self, UIViewEZMExtentionWidthKey, widthNode, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            }
        }
    }
    return widthNode;
}

- (EZRMutableNode<NSNumber *> *)height {
    __block BOOL frameChanged = NO;
    __block BOOL nodeChanged = NO;
    EZRMutableNode<NSNumber *> *heightNode = objc_getAssociatedObject(self, UIViewEZMExtentionHeightKey);
    if (!heightNode) {
        @synchronized (self) {
            heightNode = objc_getAssociatedObject(self, UIViewEZMExtentionHeightKey);
            if (!heightNode) {
                heightNode = [EZRMutableNode new];
                @ezr_weakify(self)
                [[heightNode listenedBy:self] withBlock:^(NSNumber * _Nullable next) {
                    @ezr_strongify(self)
                    if (!frameChanged) {
                        nodeChanged = YES;
                        CGRect rect = self.frame;
                        rect.size.height = next.floatValue;
                        self.frame = rect;
                        nodeChanged = NO;
                    }
                }];
                [[EZR_PATH(self, frame) listenedBy:self] withBlock:^(NSValue * _Nullable next) {
                    if (!nodeChanged) {
                        frameChanged = YES;
                        heightNode.value = @(next.CGRectValue.size.height);
                        frameChanged = NO;
                    }
                }];
                objc_setAssociatedObject(self, UIViewEZMExtentionHeightKey, heightNode, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            }
        }
    }
    return heightNode;
}

@end
