//
//  TLHomeHeaderView.m
//  ZegoRoomkitDemo
//
//  Created by xia on 2021/6/7.
//  Copyright © 2021 zego. All rights reserved.
//

#import "TLHomeHeaderView.h"

@interface TLHomeHeaderView()

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *titleLabel;
@end

@implementation TLHomeHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    [self addSubview:self.imageView];
//    [self addSubview:self.titleLabel];
    
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(130);
        make.height.mas_equalTo(29);
        make.top.left.equalTo(self);
    }];
    
//    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.imageView.mas_right).offset(5);
//        make.centerY.equalTo(self.imageView);
//    }];
}

#pragma mark - Getter
- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
        [_imageView setImage:[UIImage imageNamed:@"m_roomkit_logo"]];
    }
    return _imageView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = BOLD_FONT(25);
        _titleLabel.textColor = UIColorHex(000000);
        _titleLabel.text = TLLocalizedString(RoomKit);
        [_titleLabel sizeToFit];
    }
    return _titleLabel;
}

@end
