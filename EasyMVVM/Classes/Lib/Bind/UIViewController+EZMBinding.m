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

#import "UIViewController+EZMBinding.h"
#import <objc/runtime.h>
#import <objc/message.h>

static void swizzleViewDidLoadIfNeeded(Class classToSwizzle);
static void swizzleInitalized(Class classToSwizzle);

static NSMutableSet *swizzledClasses() {
    static dispatch_once_t onceToken;
    static NSMutableSet *swizzledClasses = nil;
    dispatch_once(&onceToken, ^{
        swizzledClasses = [[NSMutableSet alloc] init];
    });
    
    return swizzledClasses;
}

@implementation UIViewController (EZMBinding)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        swizzleInitalized(self);
    });
}

- (void)bindView:(EZMBinder *)binder {
    
}

@end

static void swizzleInitalized(Class classToSwizzle) {
    SEL initWithNibNameSelector = @selector(initWithNibName:bundle:);
    SEL initWithCoderSelector = @selector(initWithCoder:);
    
    __block id (*originalInitWithNibName)(__unsafe_unretained id, SEL, NSString *, NSBundle *) = NULL;
    __block id (*originalinitWithCoder)(__unsafe_unretained id, SEL, NSCoder *) = NULL;
    
    id newInitWithNibName = ^(__unsafe_unretained id self, NSString *nibName, NSBundle *bundle) {
        //        hook viewDidload
        swizzleViewDidLoadIfNeeded(object_getClass(self));
        
        if (originalInitWithNibName == NULL) {
            struct objc_super superInfo = {
                .receiver = self,
                .super_class = class_getSuperclass(classToSwizzle)
            };
            
            id (*msgSend)(struct objc_super *, SEL, NSString *, NSBundle *) = (__typeof__(msgSend))objc_msgSendSuper;
            return msgSend(&superInfo, initWithNibNameSelector, nibName, bundle);
        } else {
            return originalInitWithNibName(self, initWithNibNameSelector, nibName, bundle);
        }
    };
    id newInitWithCoder = ^(__unsafe_unretained id self, NSCoder *aCoder) {
        //        hook viewDidload
        swizzleViewDidLoadIfNeeded(object_getClass(self));
        if (originalinitWithCoder == NULL) {
            struct objc_super superInfo = {
                .receiver = self,
                .super_class = class_getSuperclass(classToSwizzle)
            };
            
            id (*msgSend)(struct objc_super *, SEL, NSCoder *aCoder) = (__typeof__(msgSend))objc_msgSendSuper;
            return msgSend(&superInfo, initWithCoderSelector, aCoder);
        } else {
            return originalinitWithCoder(self, initWithCoderSelector, aCoder);
        }
    };
    
    IMP newInitWithNibNameIMP = imp_implementationWithBlock(newInitWithNibName);
    Method initWithNibNameMethod = class_getInstanceMethod(classToSwizzle, initWithNibNameSelector);
    originalInitWithNibName = (__typeof__(originalInitWithNibName))method_getImplementation(initWithNibNameMethod);
    originalInitWithNibName = (__typeof__(originalInitWithNibName))method_setImplementation(initWithNibNameMethod, newInitWithNibNameIMP);
    
    IMP newInitWithCoderIMP = imp_implementationWithBlock(newInitWithCoder);
    Method initWithCoderMethod = class_getInstanceMethod(classToSwizzle, initWithCoderSelector);
    originalinitWithCoder = (__typeof__(originalinitWithCoder))method_getImplementation(initWithCoderMethod);
    originalinitWithCoder = (__typeof__(originalinitWithCoder))method_setImplementation(initWithCoderMethod, newInitWithCoderIMP);
}

static void swizzleViewDidLoadIfNeeded(Class classToSwizzle) {
    @synchronized (swizzledClasses()) {
        NSString *className = NSStringFromClass(classToSwizzle);
        if ([swizzledClasses() containsObject:className]) return;
        
        SEL viewDidloadSelector = @selector(viewDidLoad);
        
        __block void (*originalDdidload)(__unsafe_unretained id, SEL) = NULL;
        
        id newViewDidload = ^(__unsafe_unretained id self) {
            if (originalDdidload == NULL) {
                struct objc_super superInfo = {
                    .receiver = self,
                    .super_class = class_getSuperclass(classToSwizzle)
                };
                
                void (*msgSend)(struct objc_super *, SEL) = (__typeof__(msgSend))objc_msgSendSuper;
                msgSend(&superInfo, viewDidloadSelector);
            } else {
                originalDdidload(self, viewDidloadSelector);
            }
            Class captureClass = classToSwizzle;
            Class realClass = object_getClass(self);
            if (captureClass != realClass) {
                return ;
            }
            EZMBinder *binder = [[EZMBinder alloc] initWithAssociateObject:self];
            [self bindView:binder];
        };
        
        IMP newViewDidloadIMP = imp_implementationWithBlock(newViewDidload);
        
        if (!class_addMethod(classToSwizzle, viewDidloadSelector, newViewDidloadIMP, "v@:")) {
            Method viewDidloadMethod = class_getInstanceMethod(classToSwizzle, viewDidloadSelector);
            originalDdidload = (__typeof__(originalDdidload))method_getImplementation(viewDidloadMethod);
            originalDdidload = (__typeof__(originalDdidload))method_setImplementation(viewDidloadMethod, newViewDidloadIMP);
        }
        [swizzledClasses() addObject:className];
    }
}
