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
static NSInteger const AL_CrashOnLaunchMaxTimeTs = 5;
static NSInteger const AL_CrashOnLaunchMaxCount = 2;
static NSTimeInterval al_launchTime = 0;

@implementation ALProtectLaunch

+ (BOOL)launchCrashProtect {
    al_launchTime = [[NSDate date] timeIntervalSince1970];
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
    NSLog(@"crash count = %ld", count);
    [[NSUserDefaults standardUserDefaults] setInteger:count forKey:AL_CrashOnLaunchCountKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (void)setRepairBlock:(ALProtectRepairBlock)repair {
    al_repairBlock = repair;
}

+ (void)setCompletionBlock:(ALRepairedCompletionBlock)completion {
    al_completionBlock = completion;
}

+ (NSTimeInterval)launchTime {
    return al_launchTime;
}

+ (BOOL)canSaveCrashCount {
    NSTimeInterval nowTime = [[NSDate date] timeIntervalSince1970];
    if (nowTime - al_launchTime < AL_CrashOnLaunchMaxTimeTs) {
        return YES;
    }
    return NO;
}

@end
