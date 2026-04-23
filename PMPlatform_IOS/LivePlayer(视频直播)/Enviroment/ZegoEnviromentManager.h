//
//  ZegoEnviromentManager.h
//  ZegoRoomkitDemo
//
//  Created by Kael Ding on 2020/11/30.
//  Copyright © 2020 zego. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZegoEnviromentManager : NSObject

#ifdef ZEGO_ENVIROMENT_FLAG

+ (NSInteger)getSecretID;
+ (NSString *)getSecretSign;
+ (NSString *)getAppDomain;
+ (NSString *)getOutRoomServiceDomain;

#endif

#ifdef ZEGO_ACCESS_ENV_FLAG
+ (NSInteger)getProductIDOfRoomType:(NSInteger)roomType;
+ (void)setAccessEnv:(NSInteger)env;
+ (NSInteger)getAccessEnv;
#endif

@end

NS_ASSUME_NONNULL_END
