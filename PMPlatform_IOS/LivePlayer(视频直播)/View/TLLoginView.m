//
//  TLLoginView.m
//  ZegoRoomkitDemo
//
//  Created by KaelDing on 2020/7/15.
//  Copyright © 2020 zego. All rights reserved.
//

#import "TLLoginView.h"
#import "UITextField+TLTextField.h"
#import "UIButton+TLButton.h"

@interface TLLoginView () <UITextFieldDelegate>
@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) UIButton *loginButton;
@end

@implementation TLLoginView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
//        [self bindInfo];
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    [self addSubview:self.textField];
    [self addSubview:self.loginButton];
    
    [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(30);
        make.right.equalTo(self).offset(-30);
        make.top.equalTo(self).offset(30);
        make.height.mas_equalTo(50);
    }];
    [self.loginButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(30);
        make.right.equalTo(self).offset(-30);
        make.top.equalTo(self.textField.mas_bottom).offset(20);
        make.height.mas_equalTo(50);
    }];
}

#pragma mark - UITextFieldDelegate
- (void)textFieldDidEndEditing:(UITextField *)textField {
    self.loginName = textField.text;
}

#pragma mark - action
- (void)loginButtonClick:(UIButton *)sender {
    if([self.textField isFirstResponder])
        [self.textField resignFirstResponder];
    
    [self.loginAction sendNext:nil];
}

#pragma mark - getter
- (UITextField *)textField {
    if (!_textField) {
        _textField = [UITextField textFieldWithPlaceholder:TLLocalizedString(quick_join_input_nickname)];
        _textField.delegate = self;
    }
    return _textField;
}
- (UIButton *)loginButton {
    if (!_loginButton) {
        _loginButton = [UIButton actionButtonWithTitle:TLLocalizedString(login)];
        [_loginButton addTarget:self action:@selector(loginButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _loginButton;
}
- (RACSubject *)loginAction {
    if (!_loginAction) {
        _loginAction = [RACSubject subject];
    }
    return _loginAction;
}
@end
