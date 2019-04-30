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

#import "UISlider+EZM_Extension.h"
#import "UIControl+EZM_Extension.h"
@import ObjectiveC.runtime;

static void *UISliderCancelableKey = &UISliderCancelableKey;

@implementation UISlider (EZM_Extension)

- (EZRMutableNode<NSNumber *> *)ezm_value {
    id<EZRCancelable> cancelable = objc_getAssociatedObject(self, UISliderCancelableKey);
    if (cancelable) {
        [cancelable cancel];
    }
    
    EZRMutableNode *node = EZR_PATH(self, value);
    [node linkTo:[[self ezm_nodeForEvents:UIControlEventValueChanged] map:^id _Nullable(EZMControlWithEvents * _Nullable next) {
        return @([(UISlider *)next.control value]);
    }]];
    objc_setAssociatedObject(self, UISliderCancelableKey, cancelable, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    return node;
}

@end

