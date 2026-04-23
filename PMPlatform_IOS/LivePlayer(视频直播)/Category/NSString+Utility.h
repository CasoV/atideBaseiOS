//
//  NSString+Utility.h
//  ZegoRoomkitDemo
//
//  Created by Kael Ding on 2020/7/17.
//  Copyright © 2020 zego. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (Utility)

+ (NSString *)getSecretSignWithDeviceId:(NSString *)deviceId timestamp:(long long)timestamp;

+ (NSString *)getDeviceName;

+ (NSString *)appVersion;

+ (NSString *)systemVersion;

+ (NSString *)logFileName;

+ (NSString *)paramStrFromDict:(NSDictionary *)dict;

@end

NS_ASSUME_NONNULL_END
