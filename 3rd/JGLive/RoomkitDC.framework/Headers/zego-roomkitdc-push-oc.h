//
//  zego-roomkitdc-push-oc.h
//  RoomkitDC
//
//  Created by zego on 2020/5/13.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol ZegoRoomkitDCPushDelegate <NSObject>
/**
push消息通知

@param message 通知消息
{
    [
        "message_id":"",        // 消息id
        "content_type":1,        // 内容类型
        "title":"",                // 标题
        "author":"",            // 发信人
        "content":"",            // 内容
        "create_time":1            // 发送时间
    ],
}
*/
- (void)onPushMessage:(NSString *)meesageJson;

@end

@interface ZegoRoomkitDCPush : NSObject

+ (id)sharedInstance;

- (void)setDelegate:(id<ZegoRoomkitDCPushDelegate>)delegate;
/**
设置apn/极光推送的token

@param json
{
    "push_token" : ""
}

@note 保证在zego_roomkitdc_entry_login之前调用，因为entry后开始建立链接
*/
- (void)setPushTokenWithJson:(NSString *)json;

@end

NS_ASSUME_NONNULL_END
