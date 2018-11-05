//
//  ALProtectLaunch.h
//  ALCatchCrash
//
//  Created by Alan on 2018/11/5.
//  Copyright © 2018 Alan. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef BOOL(^ALRepairedCompletionBlock)(void);
typedef void(^ALProtectRepairBlock)(ALRepairedCompletionBlock completion);

@interface ALProtectLaunch : NSObject

+ (BOOL)launchCrashProtect;
+ (NSInteger)crashCount;
+ (void)saveCrashCount:(NSInteger)count;

+ (void)setRepairBlock:(ALProtectRepairBlock)repair;
+ (void)setCompletionBlock:(ALRepairedCompletionBlock)completion;

@end
