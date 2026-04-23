//
//  TLTestLoginView.m
//  ZegoRoomkitDemo
//
//  Created by KaelDing on 2020/7/15.
//  Copyright © 2020 zego. All rights reserved.
//

#import "TLTestLoginView.h"
#import "UITextField+TLTextField.h"
#import "UIButton+TLButton.h"

@interface TLTestLoginView () <UITextFieldDelegate>

@property (nonatomic, strong) UITextField *meetingTextField;
@property (nonatomic, strong) UITextField *nameTextField;
@property (nonatomic, strong) UIButton *loginButton;

@end

@implementation TLTestLoginView
 
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    [self addSubview:self.meetingTextField];
//    [self addSubview:self.nameTextField];
    [self addSubview:self.loginButton];
    
    [self.meetingTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(30);
        make.right.equalTo(self).offset(-30);
        make.top.equalTo(self).offset(0);
        make.height.mas_equalTo(48);
    }];
//    [self.nameTextField mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self).offset(30);
//        make.right.equalTo(self).offset(-30);
//        make.top.equalTo(self.meetingTextField.mas_bottom).offset(19);
//        make.height.mas_equalTo(48);
//    }];
    [self.loginButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(30);
        make.right.equalTo(self).offset(-30);
        make.top.equalTo(self.meetingTextField.mas_bottom).offset(35);
        make.height.mas_equalTo(50);
    }];
}


#pragma mark - UITextFieldDelegate
- (void)textFieldDidEndEditing:(UITextField *)textField {
    if(textField == self.nameTextField)
        self.testLoginName = textField.text;
    else
        self.testLoginId = textField.text;
}

#pragma mark - getter
- (void)loginButtonClick:(UIButton *)sender {
    if([self.meetingTextField isFirstResponder])
       [self.meetingTextField resignFirstResponder];
    if([self.nameTextField isFirstResponder])
       [self.nameTextField resignFirstResponder];
    
    if(self.testLoginBlock)
        self.testLoginBlock();
}

#pragma mark - getter
- (UITextField *)meetingTextField {
    if (!_meetingTextField) {
        _meetingTextField = [UITextField textFieldWithPlaceholder:@"请输入用户ID"];
        _meetingTextField.keyboardType = UIKeyboardTypeNumberPad;
        _meetingTextField.delegate = self;
    }
    return _meetingTextField;
}
- (UITextField *)nameTextField {
    if (!_nameTextField) {
        _nameTextField = [UITextField textFieldWithPlaceholder:TLLocalizedString(quick_join_input_nickname)];
        _nameTextField.delegate = self;
    }
    return _nameTextField;
}
- (UIButton *)loginButton {
    if (!_loginButton) {
        _loginButton = [UIButton actionButtonWithTitle:TLLocalizedString(login)];
        [_loginButton addTarget:self action:@selector(loginButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _loginButton;
}
@end
