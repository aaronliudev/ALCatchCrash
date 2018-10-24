//
//  AppDelegate+ALCC.m
//  ALCatchCrash
//
//  Created by Alan on 23/10/2018.
//  Copyright © 2018 Alan. All rights reserved.
//

#import "AppDelegate+ALCC.h"
#import <objc/runtime.h>

@implementation AppDelegate (ALCC)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [[self class] exchangeMethod];
    });
}

+ (void)exchangeMethod {
    Class class = [self class];
    
    SEL originalSEL = @selector(application:didFinishLaunchingWithOptions:);
    SEL swizzledSEL = @selector(swizzled_application:didFinishLaunchingWithOptions:);
    
    Method originalM = class_getClassMethod(class, originalSEL);
    Method swizzledM = class_getClassMethod(class, swizzledSEL);
    
    BOOL isAddMethod = class_addMethod(class, originalSEL, method_getImplementation(swizzledM), method_getTypeEncoding(swizzledM));
    if (isAddMethod) {
        class_replaceMethod(class, swizzledSEL, method_getImplementation(originalM), method_getTypeEncoding(originalM));
    }
    else {
        method_exchangeImplementations(originalM, swizzledM);
    }
}

+ (void)swizzled_application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
}

@end
