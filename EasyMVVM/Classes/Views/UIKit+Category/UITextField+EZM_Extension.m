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

#import "UITextField+EZM_Extension.h"
#import "UIControl+EZM_Extension.h"
@import ObjectiveC.runtime;

@implementation UITextField (EZM_Extension)

- (EZRMutableNode<NSString *> *)ezm_text {
    EZRMutableNode<NSString *> *node = objc_getAssociatedObject(self, _cmd);
    if (!node) {
        @synchronized (self) {
            node = objc_getAssociatedObject(self, _cmd);
            if (!node) {
                node = [EZRMutableNode new];
                
                [[node listenedBy:self] withContextBlock:^(NSString * _Nullable next, id  _Nullable context) {
                    if (!context){
                        self.text = next;
                    }
                }];

                EZRNode<NSString *> *textEventNode = [[self ezm_nodeForEvents:UIControlEventAllEditingEvents] map:^id _Nullable(EZMControlWithEvents * _Nullable next) {
                    return [(UITextField *)next.control text];
                }];
                EZRMutableNode<NSString *> *textValueNode = EZR_PATH(self, text);
                
                [[[EZRNode merge:@[textEventNode, textValueNode]] listenedBy:self]  withContextBlock:^(id  _Nullable next, id  _Nullable context) {
                    [node setValue:next context:@YES];
                }];

                objc_setAssociatedObject(self, _cmd, node, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            }
        }
    }
    return node;
}

@end
