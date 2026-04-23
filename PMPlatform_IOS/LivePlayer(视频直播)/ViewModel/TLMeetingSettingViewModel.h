//
//  TLMeetingSettingViewModel.h
//  ZegoRoomkitDemo
//
//  Created by Kael Ding on 2020/7/20.
//  Copyright © 2020 zego. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TLSettingCellConfig.h"

NS_ASSUME_NONNULL_BEGIN

@interface TLMeetingSettingViewModel : NSObject

@property (nonatomic, strong) ZegoRoomSettings *meetingSetting;
@property (nonatomic, strong) NSArray<NSArray<TLSettingCellConfig *> *> *dataSource;

@property (nonatomic, copy) void (^L3Block)(BOOL status);
@property (nonatomic, copy) void (^micBlock)(BOOL status);
@property (nonatomic, copy) void (^cameraBlock)(BOOL status);
@property (nonatomic, copy) void (^beautifyBlock)(BOOL status);
@property (nonatomic, copy) void (^videoFitBlock)(BOOL status);
@property (nonatomic, copy) void (^videoMirrorBlock)(BOOL status);
@property (nonatomic, copy) void (^saveTrafficBlock)(BOOL status);
@property (nonatomic, copy) void (^joinMessageBlock)(BOOL status);
@property (nonatomic, copy) void (^leaveMessageBlock)(BOOL status);
@property (nonatomic, copy) void (^teacherAvatarBlock)(BOOL status);
@property (nonatomic, copy) void (^studentAvatarBlock)(BOOL status);
@property (nonatomic, copy) void (^fixedInOutMsgBlock)(BOOL status);

@end

NS_ASSUME_NONNULL_END
