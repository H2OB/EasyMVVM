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

#import "NSObject+EZMHandler.h"
#import "EZMHandler.h"

@implementation NSObject (EZMHandler)

- (EZMHandler *)ezm_handlerForSelector:(SEL)aSelector {
    @ezr_weakify(self)

    return [[EZMHandler alloc] initWithBlock:^{
        @ezr_strongify(self)
#if DEBUG
        if ([NSStringFromSelector(aSelector) containsString:@":"]) {
            NSAssert(NO, @"不接受带有参数的seleator");
        }
#endif
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        [self performSelector:aSelector];
#pragma clang diagnostic pop
    }];    
}

@end
