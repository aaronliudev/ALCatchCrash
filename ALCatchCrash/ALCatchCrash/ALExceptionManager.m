//
//  ALExceptionManager.m
//  ALCatchCrash
//
//  Created by Alan on 24/10/2018.
//  Copyright © 2018 Alan. All rights reserved.
//

#import "ALExceptionManager.h"
#include <execinfo.h>
#include <libkern/OSAtomic.h>

volatile int32_t UncaughtExceptionCount = 0;
const int32_t UncaughtExceptionMaximum = 1;   //表示最多只截获10次异常，如果超过十次则不截获弹出alter了直接崩溃

@implementation ALExceptionManager

+ (instancetype)shareInstance {
    static ALExceptionManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [ALExceptionManager new];
        manager.isSaveCrashLog = YES;
        manager.launchProtectionCount = 2;
    });
    return manager;
}

+ (void)al_saveCrash:(NSString *)exceptionInfo isSignal:(BOOL)isSignal {
    if (![ALExceptionManager shareInstance].isSaveCrashLog) {
        return;
    }
    NSString * path = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"ALCrash"];
    if (![[NSFileManager defaultManager] fileExistsAtPath:path]){
        [[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    NSDate *dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval timeInterval = [dat timeIntervalSince1970];
    NSString *timeString = [NSString stringWithFormat:@"%f", timeInterval];
    
    NSString *savePath = [path stringByAppendingFormat:@"/%@-error%@.log", isSignal ? @"signal" : @"oc", timeString];
    
    [exceptionInfo writeToFile:savePath atomically:YES encoding:NSUTF8StringEncoding error:nil];
}


@end

#pragma mark - OC Exception
//截取异常信息
void OCException(NSException *exception){
    
    // 异常堆栈信息
    NSArray *stackArray = [exception callStackSymbols];
    
    // 异常原因
    NSString *reason = [exception reason];
    
    // 异常名称
    NSString *name = [exception name];
    
    NSString *info = [NSString stringWithFormat:@"name:%@\n reason:%@\n  stack:%@", name, reason, stackArray];
    NSLog(@"%@", info);
    
    // save
    [ALExceptionManager al_saveCrash:info isSignal:NO];
}

void InstallUncaughtExceptionHandler(void) {
    NSSetUncaughtExceptionHandler(&OCException);
}

#pragma mark - Signale Exception
void SignalException(int signal) {
    
    // 递增一个全局计数器，当发生 signal exception 时，会发生大量的信号，如果写 log 的情况下，会产生相当大的数据量
    int32_t exceptionCount = OSAtomicIncrement32(&UncaughtExceptionCount);
    
    if (exceptionCount > UncaughtExceptionMaximum) {
        return;
    }
    NSMutableString *mstr = [[NSMutableString alloc] init];
    [mstr appendString:@"Stack:\n"];
    void* callstack[128];
    int i, frames = backtrace(callstack, 128);
    char** strs = backtrace_symbols(callstack, frames);
    for (i = 0; i <frames; ++i) {
        [mstr appendFormat:@"%s\n", strs[i]];
    }
    // save
    [ALExceptionManager al_saveCrash:mstr isSignal:YES];
}

void InstallSignalHandler(void) {
    signal(SIGHUP, SignalException);
    signal(SIGINT, SignalException);
    signal(SIGQUIT, SignalException);
    
    signal(SIGABRT, SignalException);
    signal(SIGILL, SignalException);
    signal(SIGSEGV, SignalException);
    signal(SIGFPE, SignalException);
    signal(SIGBUS, SignalException);
    signal(SIGPIPE, SignalException);
    // SIGKILL、SIGSTOP这两个信号无法捕获
//    signal(SIGKILL, SignalException);
    
}
