//
//  TLSettingCellConfig.m
//  ZegoRoomkitDemo
//
//  Created by Kael Ding on 2020/7/19.
//  Copyright © 2020 zego. All rights reserved.
//

#import "TLSettingCellConfig.h"

@implementation TLSettingCellConfig

+ (instancetype)configWithHideSwitch:(BOOL)isHideSwitch
                  hideRightIndicator:(BOOL)isHideRightIndicator
                        hideSubtitle:(BOOL)isHideSubtitle
                      hideBottomLine:(BOOL)isHideBottomLine
           titleLabelAlignmentCenter:(BOOL)isTitleLabelAlignmentCenter
                 titleLabelTextColor:(UIColor *)titleLabelTextColor
                               title:(NSString *)title
                            subtitle:(nullable NSString *)subtitle {
    
    TLSettingCellConfig *config = [TLSettingCellConfig new];
    config.isHideSwitch = isHideSwitch;
    config.isHideRightIndicator = isHideRightIndicator;
    config.isHideSubtitle = isHideSubtitle;
    config.isHideBottomLine = isHideBottomLine;
    config.isTitleLabelAlignmentCenter = isTitleLabelAlignmentCenter;
    config.titleLabelTextColor = titleLabelTextColor;
    config.title = title;
    config.subtitle = subtitle;
    config.isSelected = NO;
    return config;
}

+ (instancetype)switchConfigWithTitle:(NSString *)title switchOn:(BOOL)isSwitchOn {
    TLSettingCellConfig *config = [self configWithHideSwitch:NO
                                          hideRightIndicator:YES
                                                hideSubtitle:YES
                                              hideBottomLine:NO
                                   titleLabelAlignmentCenter:NO
                                         titleLabelTextColor:[UIColor colorWithHexString:@"040404"]
                                                       title:title
                                                    subtitle:nil];
    config.isSwitchOn = isSwitchOn;
    return config;
}

+ (instancetype)checkConfigWithTitle:(NSString *)title isSelected:(BOOL)isSelected {
    TLSettingCellConfig *config = [self configWithHideSwitch:YES
                                          hideRightIndicator:YES
                                                hideSubtitle:YES
                                              hideBottomLine:NO
                                   titleLabelAlignmentCenter:NO
                                         titleLabelTextColor:[UIColor colorWithHexString:@"040404"]
                                                       title:title
                                                    subtitle:nil];
    config.isSelected = isSelected;
    return config;
}

@end
