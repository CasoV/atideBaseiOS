//
//  UITextField+TLTextField.h
//  ZegoRoomkitDemo
//
//  Created by KaelDing on 2020/7/15.
//  Copyright © 2020 zego. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UITextField (TLTextField)

+ (UITextField *)textFieldWithPlaceholder:(NSString *)placeholder;

@end

NS_ASSUME_NONNULL_END
