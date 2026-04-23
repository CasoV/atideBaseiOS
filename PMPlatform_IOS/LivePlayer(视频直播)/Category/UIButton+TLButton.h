//
//  UIButton+TLButton.h
//  ZegoRoomkitDemo
//
//  Created by KaelDing on 2020/7/15.
//  Copyright © 2020 zego. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TLRadioButton.h"

NS_ASSUME_NONNULL_BEGIN

@interface UIButton (TLButton)

+ (UIButton *)selectButtonWithTitle:(NSString *)title;

+ (UIButton *)actionButtonWithTitle:(NSString *)title;

+ (UIButton *)popupSettingButtonWithTitle:(NSString *)title isSelected:(BOOL)isSelected;

+ (TLRadioButton *)radionButtonWithTitle:(NSString *)title isSelected:(BOOL)isSelected;

@end

NS_ASSUME_NONNULL_END
