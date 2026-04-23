//
//  TLTestSettingViewModel.h
//  ZegoRoomkitDemo
//
//  Created by Kael Ding on 2020/7/20.
//  Copyright © 2020 zego. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TLSettingCellConfig.h"

NS_ASSUME_NONNULL_BEGIN

@interface TLTestSettingViewModel : NSObject

@property (nonatomic, strong) NSArray<TLSettingCellConfig *> *dataSource;

@property (nonatomic, strong) TLSettingCellConfig *config1; // 正式环境配置
@property (nonatomic, strong) TLSettingCellConfig *config2; // 测试环境配置
@property (nonatomic, strong) TLSettingCellConfig *config3; // alpha环境配置

// 当前的环境参数
@property (nonatomic, assign) NSInteger enviromentFlag;

/// 环境是否发生了改变
- (BOOL)isEnvironmentChanged;

@end

NS_ASSUME_NONNULL_END
