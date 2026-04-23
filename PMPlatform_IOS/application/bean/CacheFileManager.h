//
//  DBFileManager.h
//  MobileCRM
//
//  Created by Arthur Wang on 14-3-21.
//  Copyright (c) 2014年 speed. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CacheFileManager : NSObject

+ (NSString *)userCacheConfigFilePath;

+ (BOOL)removeUserCacheByUsername:(NSString *)username;

+ (BOOL)removeCurrentUserCache;
@end
