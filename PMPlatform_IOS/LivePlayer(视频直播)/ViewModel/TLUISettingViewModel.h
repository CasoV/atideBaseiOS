//
//  TLUISettingViewModel.h
//  ZegoRoomkitDemo
//
//  Created by Kael Ding on 2020/7/20.
//  Copyright © 2020 zego. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TLSettingCellConfig.h"
#import "TLMeetingUIConfig.h"

NS_ASSUME_NONNULL_BEGIN

@interface TLUISettingViewModel : NSObject

@property (nonatomic, strong) NSArray<TLSettingCellConfig *> *dataSource;
@property (nonatomic, strong) TLMeetingUIConfig *uiConfig;

@property (nonatomic, copy) void (^micBlock)(BOOL status);
@property (nonatomic, copy) void (^moreBlock)(BOOL status);
@property (nonatomic, copy) void (^chatBlock)(BOOL status);
@property (nonatomic, copy) void (^shareBlock)(BOOL status);
@property (nonatomic, copy) void (^cameraBlock)(BOOL status);
@property (nonatomic, copy) void (^bottomBarBlock)(BOOL status);
@property (nonatomic, copy) void (^attendeesBlock)(BOOL status);
@property (nonatomic, copy) void (^memberCountBlock)(BOOL status);

@end

NS_ASSUME_NONNULL_END
