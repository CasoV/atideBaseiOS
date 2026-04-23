//
//  NSDate+Timestamp.h
//  CmbcApp
//
//  Created by Arthur Wang on 14-1-23.
//  Copyright (c) 2014年 eruipan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (Timestamp)

+ (NSString *)dateStringYYMMddHHmmssWithTimestamp:(NSString *)timestamp;

+ (NSString *)dateStringYYMMddHHmmssWithLLTimestampChinese:(long long)llTimestamp;
+ (NSString *)dateStringYYMMddHHmmssWithLLTimestamp:(long long)llTimestamp;
+ (NSString *)dateStringYYMMddHHmmWithLLTimestamp:(long long)llTimestamp;

+ (NSString *)dateStringMMddHHmmWithLLTimestamp:(long long)llTimestamp;

+ (NSString *)dateStringYYMMddWithTimestamp:(NSString *)timestamp;

+ (NSString *)dateStringYYMMddWithLLTimestamp:(long long)llTimestamp;

+ (NSString *)dateStringHHmmWithLLTimestamp:(long long)llTimestamp;//返回24小时制时间

+ (NSString *)todayDateStringYYMMdd;

+ (NSString *)nowDateStringYYMMddHHmmss;

//MARK:一周的第一天
- (NSDate *)weekFirstDay;
//MARK:一周的最后一天
- (NSDate *)weekLastDay;

@end
