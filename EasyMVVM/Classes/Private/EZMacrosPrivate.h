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

#import <Foundation/Foundation.h>

#ifndef EZM_MACRO_PRIVATE_H
#define EZM_MACRO_PRIVATE_H

#define EZM_CONCAT(A, B)             EZM_CONCAT_(A, B)
#define EZM_CONCAT_(A, B)            A ## B

#define EZM_LOCK_TYPE                dispatch_semaphore_t
#define EZM_LOCK_DEF(LOCK)           dispatch_semaphore_t LOCK
#define EZM_LOCK_INIT(LOCK)          LOCK = dispatch_semaphore_create(1)
#define EZM_LOCK(LOCK)               dispatch_semaphore_wait(LOCK, DISPATCH_TIME_FOREVER)
#define EZM_UNLOCK(LOCK)             dispatch_semaphore_signal(LOCK)

static inline void EZM_unlock(EZM_LOCK_TYPE *lock) {
    EZM_UNLOCK(*lock);
}

#define EZM_SCOPELOCK(LOCK)          EZM_LOCK(LOCK);EZM_LOCK_TYPE EZM_CONCAT(auto_lock_, __LINE__) __attribute__((cleanup(EZM_unlock), unused)) = LOCK


#endif /* EZMMacrosPrivate.h */
