//
//  UITextField+TLTextField.m
//  ZegoRoomkitDemo
//
//  Created by KaelDing on 2020/7/15.
//  Copyright © 2020 zego. All rights reserved.
//

#import "UITextField+TLTextField.h"

@implementation UITextField (TLTextField)

+ (UITextField *)textFieldWithPlaceholder:(NSString *)placeholder {
    UITextField *textField = [UITextField new];
    textField.font = MEDIUM_FONT(16);
    textField.layer.cornerRadius = 8;
    textField.backgroundColor = [UIColor colorWithHexString:@"f4f4f4"];
    NSAttributedString *attrString = [[NSAttributedString alloc] initWithString:placeholder
                                                                     attributes:
                                      @{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"868ca0"],
                                        NSFontAttributeName:textField.font}];
    textField.attributedPlaceholder = attrString;
    UIView *leftView = [UIView new];
    leftView.frame = CGRectMake(0, 0, 16, 50);
    UIView *rightView = [UIView new];
    rightView.frame = CGRectMake(0, 0, 16, 50);
    textField.leftView = leftView;
    textField.rightView = rightView;
    textField.leftViewMode = UITextFieldViewModeAlways;
    textField.rightViewMode = UITextFieldViewModeAlways;
    return textField;
}

@end
