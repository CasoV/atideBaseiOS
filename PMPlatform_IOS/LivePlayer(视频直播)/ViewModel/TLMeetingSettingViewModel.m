//
//  TLMeetingSettingViewModel.m
//  ZegoRoomkitDemo
//
//  Created by Kael Ding on 2020/7/20.
//  Copyright © 2020 zego. All rights reserved.
//

#import "TLMeetingSettingViewModel.h"

@implementation TLMeetingSettingViewModel

- (instancetype)init {
    self = [super init];
    if (self) {
        _meetingSetting = [ZegoRoomKit sharedInstance].roomSettings;
    }
    return self;
}

- (NSArray<NSArray<TLSettingCellConfig *> *> *)dataSource {
    if (!_dataSource) {
        
        TLSettingCellConfig *micConfig = [TLSettingCellConfig switchConfigWithTitle:TLLocalizedString(setting_room_mic_off_when_joining)
                                                                           switchOn:!self.meetingSetting.isMicrophoneOnWhenJoiningRoom];
        TLSettingCellConfig *cameraConfig = [TLSettingCellConfig switchConfigWithTitle:TLLocalizedString(setting_room_camera_off_when_joining)
                                                                              switchOn:!self.meetingSetting.isCameraOnWhenJoiningRoom];
        TLSettingCellConfig *beautyConfig = [TLSettingCellConfig switchConfigWithTitle:TLLocalizedString(setting_room_beautify)
                                                                              switchOn:self.meetingSetting.beautifyMode];
        TLSettingCellConfig *videoMirrorConfig = [TLSettingCellConfig switchConfigWithTitle:TLLocalizedString(setting_room_preview_mirror)
                                                                                   switchOn:self.meetingSetting.previewVideoMirrorMode];
        TLSettingCellConfig *videoFillConfig = [TLSettingCellConfig switchConfigWithTitle:TLLocalizedString(setting_room_video_fit)
                                                                                 switchOn:self.meetingSetting.videoFitMode];
        TLSettingCellConfig *isSaveTrafficModeOnConfig = [TLSettingCellConfig switchConfigWithTitle:TLLocalizedString(setting_save_traffic)
                                                                                           switchOn:self.meetingSetting.isSaveTrafficModeOn];
        TLSettingCellConfig *L3Config = [TLSettingCellConfig switchConfigWithTitle:TLLocalizedString(setting_item_L3)
                                                                          switchOn:[NSUserDefaults.standardUserDefaults boolForKey:@"isL3on"]];
        
        TLSettingCellConfig *joinMsgConfig = [TLSettingCellConfig switchConfigWithTitle:TLLocalizedString(隐藏进房消息)
                                                                          switchOn:[NSUserDefaults.standardUserDefaults boolForKey:@"joinMsg"]];
        
        TLSettingCellConfig *leaveMsgConfig = [TLSettingCellConfig switchConfigWithTitle:TLLocalizedString(隐藏退房消息)
                                                                          switchOn:[NSUserDefaults.standardUserDefaults boolForKey:@"leaveMsg"]];
        
        TLSettingCellConfig *teacherHideAvatarConfig = [TLSettingCellConfig switchConfigWithTitle:TLLocalizedString(老师进房无头像)
                                                                          switchOn:[NSUserDefaults.standardUserDefaults boolForKey:@"teacherHideAvatar"]];
        
        TLSettingCellConfig *studentHideAvatarConfig = [TLSettingCellConfig switchConfigWithTitle:TLLocalizedString(学生进房无头像)
                                                                          switchOn:[NSUserDefaults.standardUserDefaults boolForKey:@"studentHideAvatar"]];
        
        TLSettingCellConfig * fixedInOutConfig = [TLSettingCellConfig switchConfigWithTitle:TLLocalizedString(固定展示进退房消息)
                                                                          switchOn:[NSUserDefaults.standardUserDefaults boolForKey:@"fixedInOutMsg"]];
        
        L3Config.switchBlock = _L3Block;
        micConfig.switchBlock = _micBlock;
        cameraConfig.switchBlock = _cameraBlock;
        beautyConfig.switchBlock = _beautifyBlock;
        videoFillConfig.switchBlock = _videoFitBlock;
        videoMirrorConfig.switchBlock = _videoMirrorBlock;
        isSaveTrafficModeOnConfig.switchBlock = _saveTrafficBlock;
        joinMsgConfig.switchBlock = _joinMessageBlock;
        leaveMsgConfig.switchBlock = _leaveMessageBlock;
        teacherHideAvatarConfig.switchBlock = _teacherAvatarBlock;
        studentHideAvatarConfig.switchBlock = _studentAvatarBlock;
        fixedInOutConfig.switchBlock = _fixedInOutMsgBlock;

        _dataSource = @[
                        @[micConfig, cameraConfig],
                        @[beautyConfig, videoMirrorConfig, videoFillConfig],
                        @[L3Config],
#ifdef ZEGO_ENVIROMENT_FLAG
                        @[isSaveTrafficModeOnConfig],
                        @[joinMsgConfig, leaveMsgConfig],
                        @[teacherHideAvatarConfig, studentHideAvatarConfig],
                        @[fixedInOutConfig]
#endif
                    ];
    }
    return _dataSource;
}

@end
