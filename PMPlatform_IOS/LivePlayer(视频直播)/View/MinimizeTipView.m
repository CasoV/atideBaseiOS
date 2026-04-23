//
//  MinimizeTipView.m
//  ZegoRoomkitDemo
//
//  Created by zego on 2021/3/22.
//  Copyright © 2021 zego. All rights reserved.
//

#import "MinimizeTipView.h"

@implementation MinimizeTipView

- (instancetype)init{
    if(self == [super init]){
        [self configUI];
    }
    return self;
}

- (void)configUI{
    [self addSubview:self.labelRoom];
    [self addSubview:self.buttonJoin];
    [self addSubview:self.imageRoom];
    self.backgroundColor = UIColor.whiteColor;
    
    [self.buttonJoin mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.mas_right).offset(-12);
        make.width.mas_equalTo(75);
        make.height.mas_equalTo(20);
        make.centerY.mas_equalTo(self);
    }];
    [self.imageRoom mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self).offset(18);
        make.height.width.mas_equalTo(20);
        make.centerY.mas_equalTo(self);
    }];
    [self.labelRoom mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.imageRoom.mas_right).offset(9);
        make.right.mas_equalTo(self.buttonJoin.mas_left).offset(-28);
        make.height.mas_equalTo(20);
        make.centerY.mas_equalTo(self);
    }];
}

- (void)setMinimizeTipTitle{
    self.labelRoom.text = [NSString stringWithFormat:@"[%@] 正在进行", ZegoRoomKit.sharedInstance.inRoomService.getCurrentRoomInfo.subject];
}

- (void)onButtonTap{
    if(self.joinRoomBlock)
        self.joinRoomBlock();
}


#pragma mark - getter

- (UILabel *)labelRoom{
    if(!_labelRoom){
        _labelRoom = [[UILabel alloc] init];
        _labelRoom.text = @"dahdoahdlahdlahdla";
        _labelRoom.textColor = [UIColor colorWithHexString:@"0f0f0f"];
        _labelRoom.font = [UIFont systemFontOfSize:13];
        _labelRoom.lineBreakMode = NSLineBreakByTruncatingMiddle;
    }
    return _labelRoom;
}
- (UIButton *)buttonJoin{
    if(!_buttonJoin){
        _buttonJoin = [[UIButton alloc] init];
        _buttonJoin.semanticContentAttribute = UISemanticContentAttributeForceRightToLeft;
        [_buttonJoin setTitle:@"点击加入" forState:UIControlStateNormal];
        _buttonJoin.titleLabel.font = [UIFont systemFontOfSize:13];
        [_buttonJoin setTitleColor:[UIColor colorWithHexString:@"2953ff"] forState:UIControlStateNormal];
        [_buttonJoin setImage:[UIImage imageNamed:@"list_tooltip_enter"] forState:UIControlStateNormal];
        [_buttonJoin setTarget:self action:@selector(onButtonTap) forControlEvents:UIControlEventTouchUpInside];
    }
    return _buttonJoin;
}
- (UIImageView *)imageRoom{
    if(!_imageRoom){
        _imageRoom = [[UIImageView alloc] init];
        _imageRoom.image = [UIImage imageNamed:@"list_tooltip_video"];
    }
    return _imageRoom;
}

@end
