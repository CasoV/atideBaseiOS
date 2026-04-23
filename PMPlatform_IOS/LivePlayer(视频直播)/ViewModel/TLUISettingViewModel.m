//
//  TLUISettingViewModel.m
//  ZegoRoomkitDemo
//
//  Created by Kael Ding on 2020/7/20.
//  Copyright © 2020 zego. All rights reserved.
//

#import "TLUISettingViewModel.h"

@implementation TLUISettingViewModel

- (instancetype)init {
    self = [super init];
    if (self) {
        _uiConfig = [TLMeetingUIConfig new];
    }
    return self;
}

- (NSArray<TLSettingCellConfig *> *)dataSource {
    if (!_dataSource) {
        
        TLSettingCellConfig *bottomBarConfig = [TLSettingCellConfig switchConfigWithTitle:TLLocalizedString(custom_ui_hide_bottom_bar)
                                                                           switchOn:self.uiConfig.isBottomBarHidden];
        TLSettingCellConfig *chatConfig = [TLSettingCellConfig switchConfigWithTitle:TLLocalizedString(custom_ui_hide_chat)
                                                                            switchOn:self.uiConfig.isChatHidden];
        TLSettingCellConfig *attendeesConfig = [TLSettingCellConfig switchConfigWithTitle:TLLocalizedString(custom_ui_hide_member)
                                                                                 switchOn:self.uiConfig.isAttendeesHidden];
        TLSettingCellConfig *shareConfig = [TLSettingCellConfig switchConfigWithTitle:TLLocalizedString(custom_ui_hide_share)
                                                                             switchOn:self.uiConfig.isShareHidden];
        TLSettingCellConfig *cameraConfig = [TLSettingCellConfig switchConfigWithTitle:TLLocalizedString(custom_ui_hide_camera)
                                                                              switchOn:self.uiConfig.isCameraHidden];
        TLSettingCellConfig *micConfig = [TLSettingCellConfig switchConfigWithTitle:TLLocalizedString(custom_ui_hide_mic)
                                                                           switchOn:self.uiConfig.isMicrophoneHidden];
        TLSettingCellConfig *moreConfig = [TLSettingCellConfig switchConfigWithTitle:TLLocalizedString(custom_ui_hide_more)
                                                                            switchOn:self.uiConfig.isMoreHidden];
        TLSettingCellConfig *meberCountConfig = [TLSettingCellConfig switchConfigWithTitle:TLLocalizedString(custom_ui_hide_member_count)
                                                                            switchOn:self.uiConfig.isMemberCountHidden];
        bottomBarConfig.switchBlock = _bottomBarBlock;
        chatConfig.switchBlock = _chatBlock;
        attendeesConfig.switchBlock = _attendeesBlock;
        shareConfig.switchBlock =_shareBlock;
        cameraConfig.switchBlock = _cameraBlock;
        micConfig.switchBlock = _micBlock;
        moreConfig.switchBlock = _moreBlock;
        meberCountConfig.switchBlock = _memberCountBlock;
        
        _dataSource = @[bottomBarConfig,
                        chatConfig,
                        attendeesConfig,
                        shareConfig,
                        cameraConfig,
                        micConfig,
                        moreConfig,
                        meberCountConfig];
    }
    return _dataSource;
}

@end
