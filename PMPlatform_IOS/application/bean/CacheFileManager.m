//
//  CacheFileManager.m
//
//
//  Created by mac.
//  Copyright (c) 2017年 atide. All rights reserved.
//

#import "CacheFileManager.h"

#define CONFIG_FILE @"config"
#define COM_CACHE_PATH [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"com.atide.cache"]

@implementation CacheFileManager



+ (NSString *)userCacheConfigFilePath{
    NSString *cachePath = COM_CACHE_PATH;//
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if(![fileManager fileExistsAtPath:cachePath]){
        [fileManager createDirectoryAtPath:cachePath withIntermediateDirectories:NO attributes:nil error:nil];
        
        
    }
    
    // 增加用户目录
    /*-------------------------------------*/
    NSString *account = [[NSUserDefaults standardUserDefaults] objectForKey:USER_DEFAULT_USER_NAME];
    NSString *dbPath = [cachePath stringByAppendingPathComponent:account];
    
    
	if (![fileManager fileExistsAtPath:dbPath])
	{
		[fileManager createDirectoryAtPath:dbPath withIntermediateDirectories:YES attributes:nil error:nil];
	}
    
    NSString *fileName = [NSString stringWithFormat:@"%@_v%d", CONFIG_FILE, kUserAgentVerson];
    dbPath = [dbPath stringByAppendingPathComponent:fileName];
    
    
    return dbPath;
}


+ (BOOL)removeUserCacheByUsername:(NSString *)username{
    NSString *cachePath = COM_CACHE_PATH;//
    NSString *dbPath = [cachePath stringByAppendingPathComponent:username];
    dbPath = [dbPath stringByAppendingPathComponent:CONFIG_FILE];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if(![fileManager fileExistsAtPath:cachePath]){
        return NO;
        
    }
    else{
        [fileManager removeItemAtPath:dbPath error:NULL];
        return YES;
    }

    
}

+ (BOOL)removeCurrentUserCache{
    
    NSString *username = [[NSUserDefaults standardUserDefaults] objectForKey:USER_DEFAULT_USER_NAME];
    return [[self class] removeUserCacheByUsername:username];
    
}

@end
