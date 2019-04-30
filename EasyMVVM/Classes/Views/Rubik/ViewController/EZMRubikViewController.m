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

#import "EZMRubikViewController.h"
#import "EZMRubikView.h"
#import "EZMContainerView.h"
#import "NSArray+EZMContainer.h"
#import "EZMCubePresentationPrivoder.h"
#import <EasySequence/EasySequence.h>

@interface EZMRubikViewController ()

@property (nonatomic, strong) EZMRubikView *rubikView;
@property (nonatomic, strong) NSMutableDictionary<NSString *, Class> *cubeIdForClasses;
@property (nonatomic, strong) NSMutableArray<EZTuple2<NSString *, UIViewController<EZMCubePresentationPrivoder> *> *> *cubeViewControllers;

@end

@implementation EZMRubikViewController

#pragma mark - life cycle

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        _cubeIdentifiers = [EZRMutableNode new];
        _cubeIdForClasses = [NSMutableDictionary dictionary];
        _cubeViewControllers = [NSMutableArray array];
        @ezr_weakify(self)
        [[[[_cubeIdentifiers flattenMap:^EZRNode * _Nullable(EZMContainer<id<EZMCubePresentation>> * _Nullable next) {
            return [EZRNode merge:@[[EZRNode value:nil], next.changes]];
        }] map:^id _Nullable(id  _Nullable next) {
            @ezr_strongify(self)
            return self->_cubeIdentifiers.value;
        }] listenedBy:self] withBlock:^(EZMContainer<NSString *> * _Nullable next) {
            @ezr_strongify(self)
            // 暂且认为只能是set
            // 1. 计算将要移除的 应该刷新的 应该添加的
            // 2. 移除旧的
            // 3. 添加新的
            // 4. 刷新那些要刷新的





            NSSet<NSString *> *alreadyExistCubeIdentifiers = [NSSet setWithArray:[[EZS_Sequence(self.cubeViewControllers) map:^id _Nonnull(EZTuple2<NSString *, UIViewController<EZMCubePresentationPrivoder> *> *value) {
                return value.first;
            }] as:NSArray.class]];
            NSSet<NSString *> *cubeIdentifiers = [NSSet setWithArray:next.array];
            NSMutableSet<NSString *> *needToRemovedViewControllers = [alreadyExistCubeIdentifiers mutableCopy];
            [needToRemovedViewControllers minusSet:cubeIdentifiers];
            NSMutableSet<NSString *> *needToReloadedViewControllers = [alreadyExistCubeIdentifiers mutableCopy];
            [needToReloadedViewControllers minusSet:needToRemovedViewControllers];
            NSMutableSet<NSString *> *needToAddedViewControllers = [cubeIdentifiers mutableCopy];
            [needToAddedViewControllers minusSet:alreadyExistCubeIdentifiers];
            
            [needToRemovedViewControllers enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, BOOL * _Nonnull stop) {
                [[EZS_Sequence(self.cubeViewControllers) select:^BOOL(EZTuple2<NSString *, UIViewController<EZMCubePresentationPrivoder> *> * _Nonnull value) {
                    return [value.first isEqualToString:obj];
                }] forEach:^(EZTuple2<NSString *, UIViewController<EZMCubePresentationPrivoder> *> * _Nonnull value) {

                    [self.cubeViewControllers removeObject:value];

                }];
            }];
            [needToReloadedViewControllers enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, BOOL * _Nonnull stop) {
                [[EZS_Sequence(self.cubeViewControllers) select:^BOOL(EZTuple2<NSString *, UIViewController<EZMCubePresentationPrivoder> *> * _Nonnull value) {
                    return [value.first isEqualToString:obj];
                }] forEach:^(EZTuple2<NSString *, UIViewController<EZMCubePresentationPrivoder> *> * _Nonnull value) {


                }];
            }];
            [needToAddedViewControllers enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, BOOL * _Nonnull stop) {
                UIViewController<EZMCubePresentationPrivoder> *vc = [[self.cubeIdForClasses[obj] alloc] initWithIdentifier:obj];
                [vc loadViewIfNeeded];
                [self.cubeViewControllers addObject:EZTuple(obj, vc)];
            }];
            
            self.rubikView.cubePresentations.value = [[[EZS_Sequence(self.cubeViewControllers) map:^id _Nonnull(EZTuple2<NSString *, UIViewController<EZMCubePresentationPrivoder> *> * _Nonnull value) {
                return value.second.cubePresentation;
            }] as:NSArray.class] ezm_toContainer];
        }];
    }
    return self;
}

- (void)loadView {
    self.rubikView = [[EZMRubikView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.view = self.rubikView;
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)registerClass:(Class)clazz identifier:(NSString *)identifier {
    NSParameterAssert(identifier);
    NSParameterAssert(clazz);
    if (identifier && clazz) {
        self.cubeIdForClasses[identifier] = clazz;
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [EZS_Sequence(self.cubeViewControllers) forEach:^(EZTuple2<NSString *,UIViewController<EZMCubePresentationPrivoder> *> * _Nonnull value) {
        [value.second viewWillAppear:animated];
    }];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [EZS_Sequence(self.cubeViewControllers) forEach:^(EZTuple2<NSString *,UIViewController<EZMCubePresentationPrivoder> *> * _Nonnull value) {
        [value.second viewDidAppear:animated];
    }];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [EZS_Sequence(self.cubeViewControllers) forEach:^(EZTuple2<NSString *,UIViewController<EZMCubePresentationPrivoder> *> * _Nonnull value) {
        [value.second viewWillDisappear:animated];
    }];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [EZS_Sequence(self.cubeViewControllers) forEach:^(EZTuple2<NSString *,UIViewController<EZMCubePresentationPrivoder> *> * _Nonnull value) {
        [value.second viewDidDisappear:animated];
    }];
}

@end
