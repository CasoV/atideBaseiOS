//
//  TLSettingCell.m
//  ZegoRoomkitDemo
//
//  Created by Kael Ding on 2020/7/19.
//  Copyright © 2020 zego. All rights reserved.
//

#import "TLSettingCell.h"

@interface TLSettingCell ()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *subtitleLabel;
@property (nonatomic, strong) UIImageView *rightIndicator;
@property (nonatomic, strong) UIView *bottomLine;
@property (nonatomic, strong) UISwitch *s;
@property (nonatomic, strong) UIImageView *checkImageView;

@end

@implementation TLSettingCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.subtitleLabel];
    [self.contentView addSubview:self.rightIndicator];
    [self.contentView addSubview:self.bottomLine];
    [self.contentView addSubview:self.s];
    [self.contentView addSubview:self.checkImageView];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(16);
        make.centerY.equalTo(self.contentView);
        make.height.mas_equalTo(16);
    }];
    [self.subtitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).offset(-16);
        make.centerY.equalTo(self.contentView);
        make.height.mas_equalTo(14);
    }];
    [self.rightIndicator mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.right.equalTo(self.contentView).offset(-16);
        make.width.height.mas_equalTo(14);
    }];
    [self.bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.contentView);
        make.height.mas_equalTo(0.5);
    }];
    [self.s mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).offset(-16);
        make.centerY.equalTo(self.contentView);
    }];
    [self.checkImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.right.equalTo(self.contentView).offset(-16);
        make.width.height.mas_equalTo(30);
    }];
}

#pragma mark - setter
- (void)setConfig:(TLSettingCellConfig *)config {
    _config = config;
    
    self.titleLabel.text = config.title;
    self.subtitleLabel.text = config.subtitle;
    self.titleLabel.textColor = config.titleLabelTextColor ? config.titleLabelTextColor : [UIColor colorWithHexString:@"040404"];
    self.titleLabel.textAlignment = config.isTitleLabelAlignmentCenter ? NSTextAlignmentCenter : NSTextAlignmentLeft;
    self.rightIndicator.hidden = config.isHideRightIndicator;
    self.s.hidden = config.isHideSwitch;
    self.subtitleLabel.hidden = config.isHideSubtitle;
    self.bottomLine.hidden = config.isHideBottomLine;
    self.s.on = config.isSwitchOn;
    self.checkImageView.hidden = !config.isSelected;
    
    [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.height.mas_equalTo(16);
        if (config.isTitleLabelAlignmentCenter) {
            make.centerX.equalTo(self.contentView);
        } else {
            make.left.equalTo(self.contentView).offset(16);
        }
    }];
}

#pragma mark - action
- (void)switchValueDidChange:(UISwitch *)s {
    if ([self.delegate respondsToSelector:@selector(switchButtonClickWithConfig:isSwitchOn:)]) {
        [self.delegate switchButtonClickWithConfig:self.config isSwitchOn:s.isOn];
    }
}


#pragma mark - getter
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        _titleLabel.textColor = [UIColor colorWithHexString:@"040404"];
        _titleLabel.font = MEDIUM_FONT(16);
    }
    return _titleLabel;
}
- (UILabel *)subtitleLabel {
    if (!_subtitleLabel) {
        _subtitleLabel = [UILabel new];
        _subtitleLabel.textAlignment = NSTextAlignmentRight;
        _subtitleLabel.textColor = [UIColor colorWithHexString:@"868ca0"];
        _subtitleLabel.font = REGULAR_FONT(14);
    }
    return _subtitleLabel;
}
- (UIImageView *)rightIndicator {
    if (!_rightIndicator) {
        _rightIndicator = [UIImageView new];
        _rightIndicator.image = [UIImage imageNamed:@"more"];
    }
    return _rightIndicator;
}
- (UIView *)bottomLine {
    if (!_bottomLine) {
        _bottomLine = [UIView new];
        _bottomLine.backgroundColor = [UIColor colorWithHexString:@"f1f1f1"];
    }
    return _bottomLine;
}
- (UISwitch *)s {
    if (!_s) {
        _s = [UISwitch new];
        _s.onTintColor = [UIColor colorWithHexString:@"2953ff"];
        [_s addTarget:self action:@selector(switchValueDidChange:) forControlEvents:UIControlEventValueChanged];
    }
    return _s;
}
- (UIImageView *)checkImageView {
    if (!_checkImageView) {
        _checkImageView = [UIImageView new];
        _checkImageView.image = [UIImage imageNamed:@"check"];
    }
    return _checkImageView;
}
@end
