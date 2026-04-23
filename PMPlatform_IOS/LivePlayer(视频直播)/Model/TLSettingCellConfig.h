//
//  TLSettingCellConfig.h
//  ZegoRoomkitDemo
//
//  Created by Kael Ding on 2020/7/19.
//  Copyright © 2020 zego. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TLSettingCellConfig : NSObject


/// 是否隐藏switch
@property (nonatomic, assign) BOOL isHideSwitch;

/// 是否隐藏右边的指示
@property (nonatomic, assign) BOOL isHideRightIndicator;

/// 是否隐藏subtitle
@property (nonatomic, assign) BOOL isHideSubtitle;

/// 是否隐藏底部线条
@property (nonatomic, assign) BOOL isHideBottomLine;

/// title内容是否居中
@property (nonatomic, assign) BOOL isTitleLabelAlignmentCenter;

/// titleLabel颜色
@property (nonatomic, strong) UIColor *titleLabelTextColor;

/// title内容
@property (nonatomic, copy) NSString *title;

/// subtitle内容
@property (nonatomic, copy, nullable) NSString *subtitle;

/// 点击setting cell的block
@property (nonatomic, copy) void (^actionBlock)(void);
@property (nonatomic, copy) void (^switchBlock) (BOOL status);

/// switch是否开启
@property (nonatomic, assign) BOOL isSwitchOn;
@property (nonatomic, assign) BOOL isSelected;


+ (instancetype)configWithHideSwitch:(BOOL)isHideSwitch
                  hideRightIndicator:(BOOL)isHideRightIndicator
                        hideSubtitle:(BOOL)isHideSubtitle
                      hideBottomLine:(BOOL)isHideBottomLine
           titleLabelAlignmentCenter:(BOOL)isTitleLabelAlignmentCenter
                 titleLabelTextColor:(UIColor *)titleLabelTextColor
                               title:(NSString *)title
                            subtitle:(nullable NSString *)subtitle;

+ (instancetype)switchConfigWithTitle:(NSString *)title switchOn:(BOOL)isSwitchOn;

+ (instancetype)checkConfigWithTitle:(NSString *)title isSelected:(BOOL)isSelected;

@end

NS_ASSUME_NONNULL_END
