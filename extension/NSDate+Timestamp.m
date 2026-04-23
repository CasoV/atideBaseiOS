//
//  NSDate+Timestamp.m
//  CmbcApp
//
//  Created by Arthur Wang on 14-1-23.
//  Copyright (c) 2014年 eruipan. All rights reserved.
//

#import "NSDate+Timestamp.h"

@implementation NSDate (Timestamp)
+ (NSString *)dateStringYYMMddHHmmssWithTimestamp:(NSString *)timestamp{

    NSTimeInterval secs = [timestamp doubleValue]/1000;
	NSDate *date = [NSDate dateWithTimeIntervalSince1970:secs];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setLocale:[NSLocale systemLocale]];
	[dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
	
	NSString *dateStr = [dateFormatter stringFromDate:date];
	
	return dateStr;
}

+ (NSString *)dateStringYYMMddHHmmssWithLLTimestamp:(long long)llTimestamp{
    if (llTimestamp == 0) {
        return @"";
    }
    NSTimeInterval secs = llTimestamp/1000.0;
	NSDate *date = [NSDate dateWithTimeIntervalSince1970:secs];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setLocale:[NSLocale systemLocale]];
	[dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
	
	NSString *dateStr = [dateFormatter stringFromDate:date];
	
	return dateStr;
}

+ (NSString *)dateStringYYMMddHHmmssWithLLTimestampChinese:(long long)llTimestamp{
    if (llTimestamp == 0) {
        return @"";
    }
    NSTimeInterval secs = llTimestamp/1000.0;
	NSDate *date = [NSDate dateWithTimeIntervalSince1970:secs];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setLocale:[NSLocale systemLocale]];
	[dateFormatter setDateFormat:@"yyyy年MM月dd日 HH:mm:ss"];
	
	NSString *dateStr = [dateFormatter stringFromDate:date];
	
	return dateStr;
}

+ (NSString *)dateStringYYMMddHHmmWithLLTimestamp:(long long)llTimestamp{
    if (llTimestamp == 0) {
        return @"";
    }
    
    NSTimeInterval secs = llTimestamp/1000.0;
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:secs];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setLocale:[NSLocale systemLocale]];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    
    NSString *dateStr = [dateFormatter stringFromDate:date];
    
    return dateStr;
}

+ (NSString *)dateStringMMddHHmmWithLLTimestamp:(long long)llTimestamp{
    if (llTimestamp == 0) {
        return @"";
    }
    NSTimeInterval secs = llTimestamp/1000.0;
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:secs];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setLocale:[NSLocale systemLocale]];
    [dateFormatter setDateFormat:@"MM-dd HH:mm"];
    
    NSString *dateStr = [dateFormatter stringFromDate:date];
    
    return dateStr;
}

+ (NSString *)dateStringYYMMddWithTimestamp:(NSString *)timestamp{

    NSTimeInterval secs = [timestamp doubleValue]/1000;
	NSDate *date = [NSDate dateWithTimeIntervalSince1970:secs];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setLocale:[NSLocale systemLocale]];
	[dateFormatter setDateFormat:@"yyyy年MM月dd日"];
	
	NSString *dateStr = [dateFormatter stringFromDate:date];
	
	return dateStr;
}


+ (NSString *)dateStringYYMMddWithLLTimestamp:(long long)llTimestamp{
    if (llTimestamp==0) {
        return @"";
    }
    
    NSTimeInterval secs = llTimestamp/1000;
	NSDate *date = [NSDate dateWithTimeIntervalSince1970:secs];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setLocale:[NSLocale systemLocale]];
	[dateFormatter setDateFormat:@"yyyy-MM-dd"];
	
	NSString *dateStr = [dateFormatter stringFromDate:date];
	
	return dateStr;
}

+ (NSString *)dateStringHHmmWithLLTimestamp:(long long)llTimestamp{
    
    if (llTimestamp == 0) {
        return @"";
    }
    
    NSTimeInterval secs = llTimestamp/1000;
	NSDate *date = [NSDate dateWithTimeIntervalSince1970:secs];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setLocale:[NSLocale systemLocale]];
		[dateFormatter setDateFormat:@"HH:mm"];
	
	NSString *dateStr = [dateFormatter stringFromDate:date];
	
	return dateStr;
}

+ (NSString *)todayDateStringYYMMdd{
    NSDate *date = [[NSDate alloc] init];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setLocale:[NSLocale systemLocale]];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    
    NSString *dateStr = [dateFormatter stringFromDate:date];
    
    return dateStr;
}

+ (NSString *)nowDateStringYYMMddHHmmss{
    NSDate *date = [[NSDate alloc] init];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setLocale:[NSLocale systemLocale]];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSString *dateStr = [dateFormatter stringFromDate:date];
    
    return dateStr;
}

//MARK:一周的第一天
- (NSDate *)weekFirstDay {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *dateComponents = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekday fromDate:self];
    if (dateComponents.weekday != 7) {
        dateComponents.day = dateComponents.day - dateComponents.weekday;
    }
    
    return [calendar dateFromComponents:dateComponents];
}

//MARK:一周的最后一天
- (NSDate *)weekLastDay {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *dateComponents = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekday fromDate:self];
    if (dateComponents.weekday != 7) {
        dateComponents.day = dateComponents.day - dateComponents.weekday + 6;
    } else {
        dateComponents.day = dateComponents.day + 6;
    }

    return [calendar dateFromComponents:dateComponents];
}

@end
