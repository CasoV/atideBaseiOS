#pragma once

#import <Foundation/Foundation.h>
#import "zego-roomkitdc-constant-oc.h"

@protocol ZegoRoomkitDCMonitorDelegate <NSObject>

- (void)onNetworkTypeChanged:(ZegoRoomkitNetType)type;

@end

@interface ZegoRoomkitDCMonitor : NSObject

+(id) sharedInstance;

-(void) setDelegate:(id<ZegoRoomkitDCMonitorDelegate>)delegate;

/**
 获取设备唯一标识
 */
+(NSString *) guid;

/**
 获取平台数字类型
 */
+(int) platformType;

/**
 获取平台及版本号
 */
+(NSString *) platformInfo;

/**
 获取当前进程的 CPU 占用率
 */
+(double) CPUUsage;

/**
 获取当前进程的内存占用率
 */
+(double) memoryUsage;

/**
 获取网络是否连接
 */
+(BOOL) isNetworkConnected;

/**
 获取网络类型
 */
+(ZegoRoomkitNetType) currentNetworkType;

@end
