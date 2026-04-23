//
//  TLTestSettingViewModel.m
//  ZegoRoomkitDemo
//
//  Created by Kael Ding on 2020/7/20.
//  Copyright © 2020 zego. All rights reserved.
//

#import "TLTestSettingViewModel.h"

@implementation TLTestSettingViewModel
{
    NSInteger _isEnvironmentOriginal;//进入界面时的设置 保存起来
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _isEnvironmentOriginal = [[NSUserDefaults standardUserDefaults] integerForKey:@"ZEGO_ENVIROMENT_FLAG"];
        _enviromentFlag = _isEnvironmentOriginal;
    }
    return self;
}

#pragma mark - Public
- (BOOL)isEnvironmentChanged {
    return _enviromentFlag != _isEnvironmentOriginal;
}
#pragma mark - getter
- (NSArray<TLSettingCellConfig *> *)dataSource {
    if (!_dataSource) {
        _dataSource = @[self.config1, self.config2, self.config3];
    }
    return _dataSource;
}
- (TLSettingCellConfig *)config1 {
    if (!_config1) {
        _config1 = [TLSettingCellConfig checkConfigWithTitle:@"正式环境" isSelected:NO];
        _config1.isSelected = _isEnvironmentOriginal == 0;
    }
    return _config1;
}
- (TLSettingCellConfig *)config2 {
    if (!_config2) {
        _config2 = [TLSettingCellConfig checkConfigWithTitle:@"测试环境" isSelected:NO];
        _config2.isSelected = _isEnvironmentOriginal == 1;
    }
    return _config2;
}
- (TLSettingCellConfig *)config3 {
    if (!_config3) {
        _config3 = [TLSettingCellConfig checkConfigWithTitle:@"Alpha环境" isSelected:NO];
        _config3.isSelected = _isEnvironmentOriginal == 2;
    }
    return _config3;
}

@end
