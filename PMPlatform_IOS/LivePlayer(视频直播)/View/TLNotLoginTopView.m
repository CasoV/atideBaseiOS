//
//  TLNotLoginTopView.m
//  ZegoRoomkitDemo
//
//  Created by KaelDing on 2020/7/15.
//  Copyright © 2020 zego. All rights reserved.
//

#import "TLNotLoginTopView.h"

@interface TLNotLoginTopView ()

@property (nonatomic, strong) UIButton *quickJoinButton;
@property (nonatomic, strong) UIButton *testLoginButton;

@end

@implementation TLNotLoginTopView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    [self addSubview:self.quickJoinButton];
    [self addSubview:self.testLoginButton];
    [self.quickJoinButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self);
        make.left.equalTo(self).offset(30);
        make.height.mas_equalTo(29);
    }];
    [self.testLoginButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.quickJoinButton);
        make.left.equalTo(self.quickJoinButton.mas_right).offset(40);
        make.height.mas_equalTo(29);
    }];
}

#pragma mark - Public
- (void)selectTopViewActionButtonWithType:(TLTopButtonType)type {
    [self setButtonSelectedWithType:type];
}
#pragma mark - action
- (void)actionButtonClick:(UIButton *)sender {
    [self setButtonSelectedWithType:sender.tag];
    
    if ([self.delegate respondsToSelector:@selector(notLoginTopViewDidClickWithActionButton:)]) {
        [self.delegate notLoginTopViewDidClickWithActionButton:sender];
    }
}

#pragma mark - Private
- (UIButton *)createButton {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitleColor:[UIColor colorWithHexString:@"2953ff"] forState:UIControlStateSelected];
    [button setTitleColor:[UIColor colorWithHexString:@"040404"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(actionButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    button.titleLabel.font = BOLD_FONT(27);
    [button.titleLabel sizeToFit];
    return button;
}
- (void)setButtonSelectedWithType:(TLTopButtonType)type {
    self.quickJoinButton.selected = type == self.quickJoinButton.tag;
    self.testLoginButton.selected = type == self.testLoginButton.tag;
}

#pragma mark - getter
- (UIButton *)quickJoinButton {
    if (!_quickJoinButton) {
        _quickJoinButton = [self createButton];
        [_quickJoinButton setImage:[UIImage imageNamed:@"m_roomkit_logo"] forState:UIControlStateNormal];
        _quickJoinButton.tag = TLTopButtonTypeQuickJoin;
        _quickJoinButton.selected = YES;
    }
    return _quickJoinButton;
}
- (UIButton *)testLoginButton {
    if (!_testLoginButton) {
        _testLoginButton = [self createButton];
        [_testLoginButton setTitle:@"测试登录" forState:UIControlStateNormal];
        _testLoginButton.tag = TLTopButtonTypeTestLogin;
        #ifndef HAVE_TEST_LOGIN
        _testLoginButton.hidden = YES;
        #endif
    }
    return _testLoginButton;
}
@end
