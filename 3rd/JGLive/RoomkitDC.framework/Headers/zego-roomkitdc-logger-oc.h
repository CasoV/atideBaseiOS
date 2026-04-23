#pragma once

#import <Foundation/Foundation.h>

@interface ZegoRoomkitDCLogger : NSObject

/**
 设置和开启日志功能
 
 @param folder 日志文件夹路径，最后以斜线分隔符结尾，比如"C:\"
 @param limitedSize 单个日志文件最大尺寸，设置为 0 时，默认 5MB. 最小 5MB，最大 100MB
 */
+(void) setLogFolder: (NSString *)folder limitedSize: (unsigned int)limitedSize;

/**
 打印一行普通日志
 
 @note 打印内容中包含时间、线程、内容，函数名、行号需自行在 content 中包含，下同
 */
+(void) notice: (NSString *)content;

/**
 打印一行警告
 */
+(void) warn: (NSString *)content;

/**
 打印一行错误
 */
+(void) error: (NSString *)content;

@end
