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

#import "EZModelCenter.h"
#import "EZMacrosPrivate.h"
#import "EZModel.h"
#import "NSObject+EZM_Placeholder.h"

static EZModelCenter *_instance;

@implementation EZModelCenter {
@private
    EZM_LOCK_DEF(_valueLock);
    NSMapTable<NSString *, id> *_values;
}

+ (EZModelCenter *)defaultCenter {
    return [[self alloc] init];
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (_instance == nil) {
            _instance = [super allocWithZone:zone];
            EZM_LOCK_INIT(_instance->_valueLock);
            _instance->_values = [NSMapTable strongToWeakObjectsMapTable];
        }
    });
    return _instance;
}

- (id)copyWithZone:(NSZone *)zone {
    return _instance;
}

- (id)mutableCopyWithZone:(NSZone *)zone {
    return _instance;
}

- (__kindof EZModel *)objectForKeyedSubscript:(Class)clazz {
    NSParameterAssert(clazz);
    NSString *keyPath = NSStringFromClass(clazz);
    if (!keyPath) {
        NSAssert(keyPath, @"类不存在");
        return nil;
    }
    
    EZM_SCOPELOCK(_valueLock);
    EZModel *model = [_values objectForKey:keyPath];
    
    if (model == nil) {
        model = [clazz new];
        [_values setObject:model forKey:keyPath];
    }
    // 为了让model延时释放。
    dispatch_async(dispatch_get_main_queue(), ^{
        [model ezm_placeholder];
    });
    return model;
}

- (void)removeModelForClass:(Class)clazz {
    NSParameterAssert(clazz);
    NSString *keyPath = NSStringFromClass(clazz);
    [_values removeObjectForKey:keyPath];
}

@end
