//
//  AppDelegate+ALCC.m
//  ALCatchCrash
//
//  Created by Alan on 23/10/2018.
//  Copyright © 2018 Alan. All rights reserved.
//

#import "AppDelegate+ALCC.h"
#import <objc/runtime.h>
#import "ALExceptionManager.h"
#import "ALProtectLaunch.h"

@implementation AppDelegate (ALCC)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [[self class] exchangeMethod];
    });
}

+ (void)exchangeMethod {
    Class class = [super class];
    
    // When swizzling a class method, use the following:
    // Class class = object_getClass((id)self);
    
    SEL originalSelector = @selector(application:didFinishLaunchingWithOptions:);
    SEL swizzledSelector = @selector(swizzled_application:didFinishLaunchingWithOptions:);
    
    Method originalMethod = class_getInstanceMethod(class, originalSelector);
    Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
    
    BOOL didAddMethod =
    class_addMethod(class,
                    originalSelector,
                    method_getImplementation(swizzledMethod),
                    method_getTypeEncoding(swizzledMethod));
    
    if (didAddMethod) {
        class_replaceMethod(class,
                            swizzledSelector,
                            method_getImplementation(originalMethod),
                            method_getTypeEncoding(originalMethod));
    } else {
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
}

- (BOOL)swizzled_application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // 启用crash监控
    InstallUncaughtExceptionHandler();
    InstallSignalHandler();
    //
    if (launchOptions != nil) {
        [self swizzled_application:application didFinishLaunchingWithOptions:launchOptions];
    }
    
    [ALProtectLaunch setRepairBlock:^(ALRepairedCompletionBlock completion) {
        [self showAlertForNeedFixCrashOnCompletion:completion];
    }];
    [ALProtectLaunch setCompletionBlock:^BOOL{
        return [self swizzled_application:application didFinishLaunchingWithOptions:launchOptions];
    }];
    return [ALProtectLaunch launchCrashProtect];
}

- (void)showAlertForNeedFixCrashOnCompletion:(ALRepairedCompletionBlock)completion {
    UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:nil message:@"监测到应用可能已损坏，是否尝试修复？" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        if (completion) {
            completion();
        }
    }];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self tryToFixCrash:completion];
    }] ;
    [alertVc addAction:cancelAction];
    [alertVc addAction:okAction];
    [self presentAlertVc:alertVc];
}

/// 这里进行修复操作，完成之后，调用block
- (void)tryToFixCrash:(ALRepairedCompletionBlock)completion {
    // 解决crash，删除没用的目录文件等缓存
    
    if (completion) {
        completion();
    }
}

- (void)presentAlertVc:(UIViewController *)vc {
    if (!self.window) {
        self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
        self.window.backgroundColor = [UIColor whiteColor];
        self.window.rootViewController = [UIViewController new];
    }
    [self.window makeKeyAndVisible];
    [self.window.rootViewController presentViewController:vc animated:YES completion:nil];
}

@end
