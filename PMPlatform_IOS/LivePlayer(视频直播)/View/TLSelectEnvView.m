//
//  TLSelectEnvView.m
//  ZegoRoomkitDemo
//
//  Created by xia on 2021/6/7.
//  Copyright © 2021 zego. All rights reserved.
//

#import "TLSelectEnvView.h"
#import "UIButton+TLButton.h"

@interface TLSelectEnvView()

@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) UIButton *titleButton;
@property (nonatomic, strong) NSMutableArray *radioButtons;
@property (nonatomic, copy) NSArray *envs;
@property (nonatomic, assign) NSInteger selectedEnv;
@property (nonatomic, strong) UILabel *tipsView;

@end

@implementation TLSelectEnvView

- (instancetype)initWithSelectedEnv:(NSInteger)env {
    self = [super init];
    if (self) {
        self.selectedEnv = env;
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    [self addSubview:self.lineView];
    [self addSubview:self.titleButton];
    [self createRadioButtons];
    
    [self.titleButton.titleLabel sizeToFit];
    CGFloat width = self.titleButton.titleLabel.width + self.titleButton.imageView.width + 24 + 2;
    [self.titleButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.centerX.equalTo(self);
        make.height.mas_equalTo(20);
        make.width.mas_equalTo(width);
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.centerY.equalTo(self.titleButton);
        make.height.mas_offset(1);
    }];
    
    [self layoutRadioButtons];
}

#pragma mark - Public
- (void)selectEnv:(NSInteger)env {
    for (TLRadioButton *radio in self.radioButtons) {
        [radio setSelected:radio.tag == env];
    }
}

#pragma mark - Action
- (void)onTitleButtonClick:(UIButton *)sender {
    self.tipsView.hidden = !self.tipsView.hidden;
    [self.titleButton.imageView setTintColor:[UIColor colorWithHexString:self.tipsView.hidden ? @"afb6be" : @"2953ff"]];
}

- (void)onRadioButtonClicked:(NSInteger)tag {
    if (self.selectEnvBlock) {
        self.selectEnvBlock(tag);
    }
    for (TLRadioButton *radio in self.radioButtons) {
        [radio setSelected:radio.tag == tag];
    }
}

#pragma mark - Private
- (void)createRadioButtons {
    for (NSDictionary *dict in self.envs) {
        TLRadioButton *button = [UIButton radionButtonWithTitle:dict[@"title"] isSelected:[dict[@"isSelected"] boolValue]];
        button.tag = [dict[@"tag"] integerValue];
        button.actionBlock = ^(NSInteger tag){
            [self onRadioButtonClicked:tag];
        };
        [self.radioButtons addObject:button];
        [self addSubview:button];
    }
}

- (void)layoutRadioButtons {
    TLRadioButton *first = self.radioButtons.firstObject;
    TLRadioButton *second = self.radioButtons.lastObject;
    [first mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleButton.mas_bottom).mas_offset(25);
        make.height.mas_equalTo(20);
        make.width.mas_equalTo(80);
        make.right.equalTo(self.mas_centerX).mas_offset(-30);
    }];
    [second mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleButton.mas_bottom).mas_offset(25);
        make.height.mas_equalTo(20);
        make.width.mas_equalTo(80);
        make.left.equalTo(self.mas_centerX).mas_offset(30);
    }];
}

#pragma mark - Getter
- (UIButton *)titleButton {
    if (!_titleButton) {
        _titleButton = [[UIButton alloc] init];
        [_titleButton setTitle:TLLocalizedString(quick_join_access_env) forState:UIControlStateNormal];
        [_titleButton setTitleColor:UIColorHex(afb6be) forState:UIControlStateNormal];
        _titleButton.backgroundColor = UIColorHex(ffffff);
        _titleButton.titleLabel.font = REGULAR_FONT(13);
        UIImage *image = [UIImage imageNamed:@"environment_tips_normal"];
        image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        [_titleButton setImage:image forState:UIControlStateNormal];
        [_titleButton.imageView setTintColor:UIColorHex(afb6be)];
        _titleButton.titleEdgeInsets = UIEdgeInsetsMake(0, -14, 0, 14);
        [_titleButton.titleLabel sizeToFit];
        _titleButton.imageEdgeInsets = UIEdgeInsetsMake(0, _titleButton.titleLabel.width + 2, 0, - (_titleButton.titleLabel.width + 2));
        [_titleButton addTarget:self action:@selector(onTitleButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _titleButton;
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [UIView new];
        _lineView.backgroundColor = UIColorHex(e6e6e6);
    }
    return _lineView;
}

- (NSMutableArray *)radioButtons {
    if (!_radioButtons) {
        _radioButtons = [NSMutableArray array];
    }
    return _radioButtons;
}

- (UILabel *)tipsView {
    if (!_tipsView) {
        UILabel *tips = [UILabel new];
        NSString *text = TLLocalizedString(quick_join_access_env_tips);
        tips.textColor = UIColorHex(ffffff);
        tips.font = REGULAR_FONT(12);
        tips.layer.cornerRadius = 4.f;
        tips.layer.masksToBounds = YES;
        tips.backgroundColor = [UIColor zego_colorWithRGB:@"#141720" alpha:0.88];
        tips.hidden = YES;
        tips.numberOfLines = 2;
        
        NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:text];
        NSMutableParagraphStyle *style = [NSMutableParagraphStyle new];
        style.lineSpacing = 2;
        style.paragraphSpacing = 2;
        style.lineBreakMode = NSLineBreakByWordWrapping;
        style.alignment = NSTextAlignmentLeft;
        style.firstLineHeadIndent = 10;
        style.headIndent = 10;
        [attrStr addAttributes:@{NSParagraphStyleAttributeName: style,
                                 NSFontAttributeName: REGULAR_FONT(12),
                                 NSForegroundColorAttributeName: UIColorHex(ffffff)}
                         range:NSMakeRange(0, text.length)];
        tips.attributedText = attrStr;
        
        [self addSubview:tips];
        _tipsView = tips;
        CGFloat width = [text boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, 54)
                                           options:NSStringDrawingUsesLineFragmentOrigin
                                        attributes:@{NSParagraphStyleAttributeName:style,
                                                     NSFontAttributeName: REGULAR_FONT(12)}
                                           context:nil].size.width;
        [tips mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(54);
            make.width.mas_equalTo(width / 2.0 + 40);
            make.centerX.equalTo(self.titleButton.mas_centerX).mas_offset(30);
            make.bottom.equalTo(self.titleButton.mas_top).mas_offset(-6);
        }];
    }
    return _tipsView;
}

- (NSArray *)envs {
    return @[
        @{@"title": TLLocalizedString(quick_join_access_env_mainland),
          @"tag": @1,
          @"isSelected": @(self.selectedEnv == 1),
        },
        @{@"title": TLLocalizedString(quick_join_access_env_overseas),
          @"tag": @2,
          @"isSelected": @(self.selectedEnv == 2),
        }
    ];
}



@end
