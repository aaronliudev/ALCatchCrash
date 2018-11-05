//
//  ALProtectLaunch.m
//  ALCatchCrash
//
//  Created by Alan on 2018/11/5.
//  Copyright © 2018 Alan. All rights reserved.
//

#import "ALProtectLaunch.h"

ALProtectRepairBlock al_repairBlock;
ALRepairedCompletionBlock al_completionBlock;

static NSString *const AL_CrashOnLaunchCountKey = @"AL_CrashOnLaunchCountKey";
//static NSString *const AL_CrashOnLaunchCountKey = @"AL_CrashOnLaunchCountKey";
static NSInteger const AL_CrashOnLaunchMaxCount = 2;

@implementation ALProtectLaunch

+ (BOOL)launchCrashProtect {
    NSInteger crash = [ALProtectLaunch crashCount];
    /// 超过阈值，询问是否修复
    if (crash >= AL_CrashOnLaunchMaxCount) {
        if (al_repairBlock) {
            al_repairBlock(^BOOL() {
                [self saveCrashCount:0];
                if (al_completionBlock) {
                    return al_completionBlock();
                }
                else {
                    return NO;
                }
            });
        }
    }
    else {
        if (al_completionBlock) {
            return al_completionBlock();
        }
    }
    return NO;
}

+ (NSInteger)crashCount {
    return [[NSUserDefaults standardUserDefaults] integerForKey:AL_CrashOnLaunchCountKey];
}

+ (void)saveCrashCount:(NSInteger)count {
    [[NSUserDefaults standardUserDefaults] setInteger:count forKey:AL_CrashOnLaunchCountKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (void)setRepairBlock:(ALProtectRepairBlock)repair {
    al_repairBlock = repair;
}

+ (void)setCompletionBlock:(ALRepairedCompletionBlock)completion {
    al_completionBlock = completion;
}

@end
