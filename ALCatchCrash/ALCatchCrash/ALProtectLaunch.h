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

/// launch
+ (BOOL)launchCrashProtect;

+ (NSInteger)crashCount;
+ (void)saveCrashCount:(NSInteger)count;
/// a block to repair
+ (void)setRepairBlock:(ALProtectRepairBlock)repair;
/// whever repair or not, the completion block needs to be executed once
+ (void)setCompletionBlock:(ALRepairedCompletionBlock)completion;

/// app launch time ts
+ (NSTimeInterval)launchTime;
/// app crashed when launched in 5s，crash count +1
+ (BOOL)canSaveCrashCount;

@end
