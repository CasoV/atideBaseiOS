//
//  TLMeetingConfig.h
//  ZegoRoomkitDemo
//
//  Created by Kael Ding on 2020/7/20.
//  Copyright © 2020 zego. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TLMeetingUIConfig : NSObject<NSCoding>

@property (nonatomic, assign) ZegoToolBarHiddenMode isBottomBarHidden; // 底部工具栏隐藏模式
@property (nonatomic, assign) BOOL isChatHidden;    // 是否隐藏聊天按钮
@property (nonatomic, assign) BOOL isAttendeesHidden;       // 是否隐藏成员按钮
@property (nonatomic, assign) BOOL isShareHidden;   // 是否隐藏共享按钮
@property (nonatomic, assign) BOOL isCameraHidden;  // 是否隐藏摄像头按钮
@property (nonatomic, assign) BOOL isMicrophoneHidden;      // 是否隐藏麦克风按钮
@property (nonatomic, assign) BOOL isMoreHidden;    // 是否隐藏更多按钮
@property (nonatomic, assign) BOOL isUploadFileHidden;      // 是否隐藏上传文件/图片按钮
@property (nonatomic, assign) BOOL isMemberCountHidden;      // 是否隐藏上传文件/图片按钮

- (ZegoJoinRoomUIConfig *)joinMeetingUIConfig;

@end

NS_ASSUME_NONNULL_END
