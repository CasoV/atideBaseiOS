//
//  TLQuickJoinView.m
//  ZegoRoomkitDemo
//
//  Created by KaelDing on 2020/7/15.
//  Copyright © 2020 zego. All rights reserved.
//

#import "TLQuickJoinView.h"
#import "UITextField+TLTextField.h"
#import "UIButton+TLButton.h"

@interface TLQuickJoinView ()<UITextFieldDelegate>

@property (nonatomic, strong) UITextField *roomIDTextField;
@property (nonatomic, strong) UITextField *nameTextField;
@property (nonatomic, strong) UIButton *selectTypeButton;
@property (nonatomic, strong) UIButton *selectRoleButton;

@property (nonatomic, strong) UIButton *quickJoinButton;
@property (nonatomic, strong) UIButton *createButton;

@end

@implementation TLQuickJoinView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    [self addSubview:self.roomIDTextField];
    [self addSubview:self.nameTextField];
//    [self addSubview:self.selectRoleButton];
    [self addSubview:self.quickJoinButton];
//    [self addSubview:self.createButton];
    
    [self.roomIDTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(30);
        make.right.equalTo(self).offset(-30);
        make.top.equalTo(self).offset(0);
        make.height.mas_equalTo(48);
    }];
    
    [self.nameTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.height.equalTo(self.roomIDTextField);
        make.top.equalTo(self.roomIDTextField.mas_bottom).offset(14);
    }];
    UIView *topView = self.nameTextField;
#ifdef ZEGO_ACCESS_ENV_FLAG
    [self addSubview:self.selectTypeButton];
    [self.selectTypeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.height.equalTo(self.roomIDTextField);
        make.top.equalTo(self.nameTextField.mas_bottom).offset(14);
    }];
    topView = self.selectTypeButton;
#endif
//    [self.selectRoleButton mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.right.height.equalTo(self.roomIDTextField);
//        make.top.equalTo(topView.mas_bottom).offset(14);
//    }];
    
    [self.quickJoinButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.height.equalTo(self.roomIDTextField);
        make.top.equalTo(self.nameTextField.mas_bottom).offset(35);
    }];
    
//    [self.createButton mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.quickJoinButton.mas_bottom).offset(16);
//        make.centerX.equalTo(self.quickJoinButton.mas_centerX);
//        make.height.mas_equalTo(35);
//    }];
    
   
}

#pragma mark - Public
- (void)resignFirstResponder {
    [self.roomIDTextField resignFirstResponder];
    [self.nameTextField resignFirstResponder];
}

- (void)updateJoinButtonToEnable:(BOOL)enabled {
//    self.quickJoinButton.enabled = enabled;
    [self.quickJoinButton setBackgroundColor:[UIColor zego_colorWithRGB:@"#2953ff" alpha:enabled ? 1 : 0.75]];
}

#pragma mark - Private
- (NSString *)stripNonNumberOfString:(NSString *)input {
    NSMutableString *output = [NSMutableString new];
    for (int i = 0; i < input.length; i++) {
        char c = [input characterAtIndex:i];
        NSString *cStr = [NSString stringWithFormat:@"%c", c];
        if ([@"1234567890" containsString:cStr]) {
            [output appendString:cStr];
        }
    }
    return output;
}

#pragma mark - UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (textField == self.nameTextField) {
        if (textField.text.length > 20) {
            return NO;
        }
        if (textField.text.length + string.length > 20) {
            textField.text = [NSString stringWithFormat:@"%@%@", textField.text, [string substringToIndex:(20 - textField.text.length)]];
            return NO;
        }
        return YES;
    }
    if (textField == self.roomIDTextField) {
        if (textField.text.length > 12) {
            return NO;
        }
        if (string.length == 0) {
            return YES;
        }
        NSString *addition = [self stripNonNumberOfString:string];
        NSString *text = textField.text.length + addition.length > 12 ? [addition substringToIndex:(12 - textField.text.length)] : addition;
        textField.text = [NSString stringWithFormat:@"%@%@", textField.text, text];
        return NO;
    }
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (textField == self.roomIDTextField) {
        self.quickJoinRoomID = textField.text;
        self.quickJoinName =  _nameTextField.text;
    }
//    else {
//        self.quickJoinName = textField.text;
//    }
}

#pragma mark - action
- (void)onCreateButtonClick:(UIButton *)sender {
    if (self.createBlock) self.createBlock();
}

- (void)quickJoinButtonClick:(UIButton *)sender {
    if ([self.roomIDTextField isFirstResponder]) [self.roomIDTextField resignFirstResponder];
    if ([self.nameTextField isFirstResponder]) [self.nameTextField resignFirstResponder];
    
    if (self.quickJoinBlock) self.quickJoinBlock();
}

- (void)selectTypeButtonClick:(UIButton *)sender {
    [self resignFirstResponder];
    if (self.selectTypeBlock) {
        self.selectTypeBlock();
    }
}

- (void)selectRoleButtonClick:(UIButton *)sender {
    [self resignFirstResponder];
    if (self.selectRoleBlock) {
        self.selectRoleBlock();
    }
}

#pragma mark - Setter
- (void)setRoomTypeTitle:(NSString *)title {
    [self.selectTypeButton setTitle:title forState:UIControlStateNormal];
    [self.selectTypeButton setTitleColor:[UIColor colorWithHexString:@"000000"] forState:UIControlStateNormal];
}

- (void)setRoleTitle:(NSString *)title {
    [self.selectRoleButton setTitle:title forState:UIControlStateNormal];
    [self.selectRoleButton setTitleColor:[UIColor colorWithHexString:@"000000"] forState:UIControlStateNormal];
}

#pragma mark - getter
- (UITextField *)roomIDTextField {
    if (!_roomIDTextField) {
        _roomIDTextField = [UITextField textFieldWithPlaceholder:TLLocalizedString(quick_join_input_id)];
        _roomIDTextField.keyboardType = UIKeyboardTypeNumberPad;
        _roomIDTextField.delegate = self;
    }
    return _roomIDTextField;
}

- (UITextField *)nameTextField {
    if (!_nameTextField) {
        _nameTextField = [UITextField textFieldWithPlaceholder:TLLocalizedString(quick_join_input_nickname)];
        _nameTextField.delegate = self;
        _nameTextField.text = [UserInfo getInstance].name;
    }
    return _nameTextField;
}

- (UIButton *)selectTypeButton {
    if (!_selectTypeButton) {
        _selectTypeButton = [UIButton selectButtonWithTitle:TLLocalizedString(quick_join_select_room_type)];
        [_selectTypeButton addTarget:self action:@selector(selectTypeButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _selectTypeButton;
}

- (UIButton *)selectRoleButton {
    if (!_selectRoleButton) {
        _selectRoleButton = [UIButton selectButtonWithTitle:TLLocalizedString(quick_join_select_role)];
        [_selectRoleButton addTarget:self action:@selector(selectRoleButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _selectRoleButton;
}

- (UIButton *)quickJoinButton {
    if (!_quickJoinButton) {
        _quickJoinButton = [UIButton actionButtonWithTitle:TLLocalizedString(quick_join_room)];
        [self updateJoinButtonToEnable:NO];
        [_quickJoinButton addTarget:self action:@selector(quickJoinButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _quickJoinButton;
}

- (UIButton *)createButton {
    if (!_createButton) {
        _createButton = [[UIButton alloc] init];
        [_createButton setTitle:TLLocalizedString(create_room) forState:UIControlStateNormal];
        [_createButton setTitleColor:UIColorHex(2953ff) forState:UIControlStateNormal];
        _createButton.titleLabel.font = REGULAR_FONT(15);
        [_createButton addTarget:self action:@selector(onCreateButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [_createButton.titleLabel sizeToFit];
    }
    return _createButton;
}

- (CGFloat)bottomPoint {
    return self.createButton.bottom;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    if (textField == _nameTextField) {
        return NO;
    }
    
    return YES;
}

@end
