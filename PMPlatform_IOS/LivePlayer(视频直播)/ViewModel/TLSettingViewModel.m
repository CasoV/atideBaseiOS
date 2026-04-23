//
//  TLSettingViewModel.m
//  ZegoRoomkitDemo
//
//  Created by Kael Ding on 2020/7/17.
//  Copyright © 2020 zego. All rights reserved.
//

#import "TLSettingViewModel.h"
#import "TLManager.h"

@interface TLSettingViewModel()

@property (nonatomic, strong) TLSettingCellConfig *envConfig;

@end

@implementation TLSettingViewModel

- (instancetype)init {
    self = [super init];
    if (self) {
    }
    return self;
}

- (NSArray<NSArray<TLSettingCellConfig *> *> *)dataSource {
    if (!_dataSource) {
        TLSettingCellConfig *meetingSetting = [TLSettingCellConfig configWithHideSwitch:YES
                                                                     hideRightIndicator:NO
                                                                           hideSubtitle:YES
                                                                         hideBottomLine:NO
                                                              titleLabelAlignmentCenter:NO
                                                                    titleLabelTextColor:[UIColor colorWithHexString:@"040404"]
                                                                                  title:TLLocalizedString(setting_room)
                                                                               subtitle:nil];
        TLSettingCellConfig *uiSetting = [TLSettingCellConfig configWithHideSwitch:YES
                                                                hideRightIndicator:NO
                                                                      hideSubtitle:YES
                                                                    hideBottomLine:NO
                                                         titleLabelAlignmentCenter:NO
                                                               titleLabelTextColor:[UIColor colorWithHexString:@"040404"]
                                                                             title:TLLocalizedString(setting_custom_ui)
                                                                          subtitle:nil];
        TLSettingCellConfig *testSetting = [TLSettingCellConfig configWithHideSwitch:YES
                                                                  hideRightIndicator:NO
                                                                        hideSubtitle:YES
                                                                      hideBottomLine:NO
                                                           titleLabelAlignmentCenter:NO
                                                                 titleLabelTextColor:[UIColor colorWithHexString:@"040404"]
                                                                               title:@"测试设置"
                                                                            subtitle:nil];
        TLSettingCellConfig *accessEnv = [TLSettingCellConfig configWithHideSwitch:YES
                                                                hideRightIndicator:NO
                                                                      hideSubtitle:NO
                                                                    hideBottomLine:NO
                                                         titleLabelAlignmentCenter:NO
                                                               titleLabelTextColor:[UIColor colorWithHexString:@"040404"]
                                                                             title:TLLocalizedString(quick_join_access_env)
                                                                          subtitle:nil];
        TLSettingCellConfig *versionSetting = [TLSettingCellConfig configWithHideSwitch:YES
                                                                     hideRightIndicator:YES
                                                                           hideSubtitle:NO
                                                                         hideBottomLine:YES
                                                              titleLabelAlignmentCenter:NO
                                                                    titleLabelTextColor:[UIColor colorWithHexString:@"040404"]
                                                                                  title:TLLocalizedString(setting_version)
                                                                               subtitle:[NSString stringWithFormat:@"v%@.%@", [UIApplication sharedApplication].appVersion, [UIApplication sharedApplication].appBuildVersion]];
        TLSettingCellConfig *feedback = [TLSettingCellConfig configWithHideSwitch:YES
                                                                hideRightIndicator:NO
                                                                      hideSubtitle:YES
                                                                    hideBottomLine:YES
                                                         titleLabelAlignmentCenter:NO
                                                               titleLabelTextColor:[UIColor colorWithHexString:@"040404"]
                                                                             title:TLLocalizedString(setting_feedback)
                                                                          subtitle:nil];
        TLSettingCellConfig *uploadLog = [TLSettingCellConfig configWithHideSwitch:YES
                                                                hideRightIndicator:YES
                                                                      hideSubtitle:YES
                                                                    hideBottomLine:YES
                                                         titleLabelAlignmentCenter:YES
                                                               titleLabelTextColor:[UIColor colorWithHexString:@"040404"]
                                                                             title:TLLocalizedString(setting_upload_log)
                                                                          subtitle:nil];
        TLSettingCellConfig *clearCache = [TLSettingCellConfig configWithHideSwitch:YES
                                                                hideRightIndicator:YES
                                                                      hideSubtitle:YES
                                                                    hideBottomLine:YES
                                                         titleLabelAlignmentCenter:YES
                                                               titleLabelTextColor:[UIColor colorWithHexString:@"040404"]
                                                                             title:TLLocalizedString(setting_clear_cache)
                                                                          subtitle:nil];
        TLSettingCellConfig *loginoutSetting = [TLSettingCellConfig configWithHideSwitch:YES
                                                                      hideRightIndicator:YES
                                                                            hideSubtitle:YES
                                                                          hideBottomLine:YES
                                                               titleLabelAlignmentCenter:YES
                                                                     titleLabelTextColor:[UIColor colorWithHexString:@"e8193b"]
                                                                                   title:TLLocalizedString(setting_logout)
                                                                                subtitle:nil];
        
        meetingSetting.actionBlock = _meetingSettingBlock;
        uiSetting.actionBlock = _uiSettingBlock;
        testSetting.actionBlock = _testSettingBlock;
        uploadLog.actionBlock = _uploadLogBlock;
        loginoutSetting.actionBlock = _loginoutBlock;
        clearCache.actionBlock = _clearCacheBlock;
        feedback.actionBlock = _feedbackBlock;
        accessEnv.actionBlock = _accessEnvBlock;
        self.envConfig = accessEnv;
        
        if (![TLManager sharedInstance].isLogin) {
            _dataSource = @[@[meetingSetting, uiSetting,
                                    #ifdef HAVE_TEST_LOGIN
                                            testSetting,
                                    #endif
#ifdef ZEGO_ACCESS_ENV_FLAG
                              accessEnv,
#endif
                              versionSetting],
                            @[feedback],
                            @[uploadLog]];
        } else {
            _dataSource = @[@[meetingSetting, uiSetting,
#ifdef ZEGO_ACCESS_ENV_FLAG
                              accessEnv,
#endif
                              versionSetting],
                            @[feedback],
                            @[uploadLog],
                            @[clearCache],
                            @[loginoutSetting]];
        }
    }
    return _dataSource;
}

- (void)updateEnvSubtitle:(NSString *)subtitle {
    self.envConfig.subtitle = subtitle;
}

@end
