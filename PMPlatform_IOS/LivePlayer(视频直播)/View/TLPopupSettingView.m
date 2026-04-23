//
//  TLPopupSettingView.m
//  ZegoRoomkitDemo
//
//  Created by xia on 2021/6/7.
//  Copyright © 2021 zego. All rights reserved.
//

#import "TLPopupSettingView.h"
#import "UIButton+TLButton.h"

@interface TLPopupSettingView()

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSArray *options;
@property (nonatomic, strong) NSMutableArray *buttons;
@property (nonatomic, strong) UILabel *titleLabel;

@end

@implementation TLPopupSettingView

- (instancetype)initWithTitle:(NSString *)title options:(NSArray<NSDictionary *> *)options {
    self = [super initWithFrame:[UIScreen mainScreen].bounds showViewFrame:CGRectZero];
    if (self) {
        self.title = title;
        self.options = options;
        [self setupUI];
    }
    return self;
}

#pragma mark - Action
- (void)onButtonClicked:(UIButton *)sender {
    if (self.actionBlock) {
        self.actionBlock(sender.tag);
    }
    [self removeFromSuperview];
}

#pragma mark - Public
+ (TLPopupSettingView *)addPopupSettingViewWithTitle:(NSString *)title
                                             options:(NSArray *)options
                                              onView:(UIView *)view {
    TLPopupSettingView *popup = [[TLPopupSettingView alloc] initWithTitle:title options:options];
    [view addSubview:popup];
    [popup mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(view);
        make.height.mas_equalTo(popup.height);
    }];
    return popup;
}

#pragma mark - Private
- (void)setupUI {
    self.showView.backgroundColor = [UIColor zego_colorWithRGB:@"#000000" alpha:0.15];
    [self addButtons];
    [self.showView addSubview:self.titleLabel];
    
    CGFloat height = self.buttons.count * 50 + 50;
    [self.showView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self);
        make.height.mas_equalTo(height);
    }];
    
    [self layoutButtons];
    
    UIButton *top = self.buttons.lastObject;
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(top.mas_top);
        make.left.right.equalTo(top);
        make.height.mas_equalTo(50);
    }];
}

- (void)addButtons {
    for (NSDictionary *option in self.options.reverseObjectEnumerator) {
        UIButton *button = [UIButton popupSettingButtonWithTitle:option[@"title"] isSelected:[option[@"isSelected"] boolValue]];
        [button addTarget:self action:@selector(onButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        button.tag = [option[@"tag"] integerValue];
        [self.showView addSubview:button];
        [self.buttons addObject:button];
    }
}

- (void)layoutButtons {
    for (int i = 0; i < self.buttons.count; i++) {
        UIButton *button = self.buttons[i];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.showView.mas_bottom).mas_offset(- i * 50);
            make.left.right.equalTo(self.showView);
            make.height.mas_equalTo(50);
        }];
    }
}

#pragma mark - Getter
- (NSMutableArray *)buttons {
    if (!_buttons) {
        _buttons = [NSMutableArray array];
    }
    return _buttons;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
        _titleLabel.font = REGULAR_FONT(13);
        _titleLabel.textColor = UIColorHex(565e66);
        _titleLabel.backgroundColor = UIColorHex(ffffff);
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.text = self.title;
    }
    return _titleLabel;
}

@end
