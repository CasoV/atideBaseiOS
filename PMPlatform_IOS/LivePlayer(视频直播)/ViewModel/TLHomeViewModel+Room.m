//
//  TLHomeViewModel+Room.m
//  ZegoRoomkitDemo
//
//  Created by xia on 2021/6/9.
//  Copyright © 2021 zego. All rights reserved.
//

#import "TLHomeViewModel+Room.h"
#import "TLToken.h"
#import "TLManager.h"

@implementation TLHomeViewModel (Room)

- (NSDictionary *)createRoomDictWithData:(NSDictionary *)data {
    NSInteger hostID = TLManager.sharedInstance.userID;
    NSString *hostName = [NSString stringWithFormat:@"%ld", (long)hostID];
    NSInteger roomType = [data[@"type"] integerValue];
    
    
    //自定义参数
    NSString *subject = data[@"subject"];
    NSInteger beginTimestamp = [data[@"beginTimestamp"] integerValue];
    NSNumber *duration = data[@"duration"];

    
#ifdef ZEGO_ACCESS_ENV_FLAG
    NSInteger pid = [ZegoEnviromentManager getProductIDOfRoomType:roomType];
    BOOL isL3on = [NSUserDefaults.standardUserDefaults boolForKey:@"isL3on"];
    if (roomType ==  5 && isL3on) {
        pid = [ZegoEnviromentManager getProductIDOfRoomType:6];
    }
#else
    NSInteger pid = kProductID;
#endif
    
    BOOL is1v1Class = roomType == TLArrangeType1v1;
//    BOOL isSmallClass = roomType == TLArrangeTypeSmallClass;
    BOOL isLargeClass = roomType == TLArrangeTypeLargeClass;
    
    return @{
        @"uid": @(hostID),
        @"subject": subject,
//        @"room_type": @(roomType),
        @"begin_timestamp": @((NSInteger)beginTimestamp * 1000),
        @"duration": duration,
        @"password": @"",
//        @"max_attendee_count": is1v1Class ? @2 : @100,
        @"pid": @(pid),
        @"settings": @{
            @"enable_host_cam": @(YES),
            @"enable_host_mic": @(YES),
            // 仅大班课普通成员进房不开启麦克风和摄像头
            @"enable_attendee_cam": !isLargeClass ? @(YES) : @(NO),
            @"enable_attendee_mic": !isLargeClass ? @(YES) : @(NO),
            @"enable_chat": @(YES),
            // 1.14.0 仅大班课支持举手
            @"enable_raise_hand": isLargeClass ? @(YES) : @(NO),
            // 仅 1v1 房间的共享、画笔权限默认打开，其他都不打开 （大班课上台后是默认有这两个权限的）
            @"enable_attendee_share": (is1v1Class || isLargeClass) ? @(YES) : @(NO),
            @"enable_attendee_draw": (is1v1Class || isLargeClass) ? @(YES) : @(NO),
            // 仅大班课的自动启动不打开，其他都打开
            @"is_auto_start": isLargeClass ? @(NO) : @(YES),
            @"max_onstage_count": data[@"maxOnStageCount"],
            @"is_private_room": @(NO)
        },
        @"host": @{
            @"uid": @(hostID),
            @"name": hostName
        },
        @"attendees": @[
            @{ @"uid": @(hostID) }
        ],
        @"assistants": @[
           // @{ @"uid": @100062164 }
        ],
        // 以下为鉴权参数
        @"secret_id": @(kSecretID),
        @"sdk_token": [TLToken getToken],
        @"verify_type": @3, // 固定填 3
        @"device_id": [[ZegoRoomKit deviceID] lowercaseString],
    };
}

- (NSDictionary *)listRoomDict {
    return @{
        @"begin_timestamp": @((NSInteger)([[NSDate date] timeIntervalSince1970] - 12 * 60 * 60)* 1000),
        @"count": @20,
        @"end_timestamp": @0, // 查询结束时间，若无结束时间，则传0
        @"is_include_all": @0, // 0:只根据会议开始时间查询 1：返回所有的时间交集的会议
        @"page": @1,
        @"status": @3, // 会议状态 1:未开始 2:进行中 4:结束 8:取消
        @"uid": @(TLManager.sharedInstance.userID),
        // 以下为鉴权参数
        @"secret_id": @(kSecretID),
        @"sdk_token": [TLToken getToken],
        @"verify_type": @3, // 固定填 3
        @"device_id": [[ZegoRoomKit deviceID] lowercaseString],
    };
}

- (NSDictionary *)deleteRoomDictOfRoomID:(NSString *)roomID {
    return @{
        @"uid": @(TLManager.sharedInstance.userID),
        @"room_id": roomID,
        // 以下为鉴权参数
        @"secret_id": @(kSecretID),
        @"sdk_token": [TLToken getToken],
        @"verify_type": @3, // 固定填 3
        @"device_id": [[ZegoRoomKit deviceID] lowercaseString],
    };
}

- (NSDictionary *)queryRoomDictWithData:(NSDictionary *)data {
    NSString *roomID = data[@"roomID"];
    NSInteger roomType = [data[@"roomType"] integerValue];
#ifdef ZEGO_ACCESS_ENV_FLAG
    NSInteger pid = [ZegoEnviromentManager getProductIDOfRoomType:roomType];
    BOOL isL3on = [NSUserDefaults.standardUserDefaults boolForKey:@"isL3on"];
    if (roomType == 5 && isL3on) {
        pid = [ZegoEnviromentManager getProductIDOfRoomType:6];
    }
#else
    NSInteger pid = kProductID;
#endif
    NSString *token = [TLToken getToken] ? [TLToken getToken] : @"";
    return @{
        @"room_id": roomID,
        @"uid": @(TLManager.sharedInstance.userID),
        @"pid": @(pid),
        // 以下为鉴权参数
        @"secret_id": @(kSecretID),
        @"sdk_token": token,
        @"verify_type": @3, // 固定填 3
        @"device_id": [[ZegoRoomKit deviceID] lowercaseString],
    };
}

@end
