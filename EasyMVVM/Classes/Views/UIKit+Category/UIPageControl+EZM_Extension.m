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

#import "UIPageControl+EZM_Extension.h"
#import "UIControl+EZM_Extension.h"

@import ObjectiveC.runtime;

static void *UIPageControlCancelableKey = &UIPageControlCancelableKey;

@implementation UIPageControl (EZM_Extension)

- (EZRMutableNode<NSNumber *> *)ezm_currentPage {
    id<EZRCancelable> cancelable = objc_getAssociatedObject(self, UIPageControlCancelableKey);
    if (cancelable) {
        [cancelable cancel];
    }
    
    EZRMutableNode *node = EZR_PATH(self, currentPage);
    cancelable = [node linkTo:[[self ezm_nodeForEvents:UIControlEventValueChanged] map:^id _Nullable(EZMControlWithEvents * _Nullable next) {
        return @([(UIPageControl *)next.control currentPage]);
    }]];
    objc_setAssociatedObject(self, UIPageControlCancelableKey, cancelable, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    return node;
}

@end
