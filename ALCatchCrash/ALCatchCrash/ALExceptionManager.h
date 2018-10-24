//
//  ALExceptionManager.h
//  ALCatchCrash
//
//  Created by Alan on 24/10/2018.
//  Copyright © 2018 Alan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ALExceptionManager : NSObject

/// save crash log, default is YES.
@property (nonatomic, assign) BOOL isSaveCrashLog;

/// when run app, the max number of crash, if more than the max number, then repaire it. default is 2.
@property (nonatomic, assign) NSInteger launchProtectionCount;

+ (instancetype)shareInstance;

@end

void InstallUncaughtExceptionHandler(void);
void InstallSignalHandler(void);

