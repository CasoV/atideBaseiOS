//
//  UIButton+TLButton.m
//  ZegoRoomkitDemo
//
//  Created by KaelDing on 2020/7/15.
//  Copyright © 2020 zego. All rights reserved.
//

#import "UIButton+TLButton.h"

@implementation UIButton (TLButton)

+ (UIButton *)selectButtonWithTitle:(NSString *)title {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:[UIColor colorWithHexString:@"868ca0"] forState:UIControlStateNormal];
    [button setBackgroundColor:[UIColor colorWithHexString:@"f4f4f4"]];
    button.titleLabel.font = MEDIUM_FONT(16);
    button.layer.cornerRadius = 8;
    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    button.titleEdgeInsets = UIEdgeInsetsMake(0, 20, 0, -20);
    
    UIImageView *arrow = [UIImageView new];
    [arrow setImage:[UIImage imageNamed:@"m_join_option_up"]];
    [button addSubview:arrow];
    [arrow mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(button);
        make.right.equalTo(button).mas_offset(-15);
        make.width.height.mas_equalTo(12);
    }];
    
    return button;
}

+ (UIButton *)actionButtonWithTitle:(NSString *)title {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button setBackgroundColor:[UIColor colorWithHexString:@"2953ff"]];
    button.titleLabel.font = MEDIUM_FONT(16);
    button.layer.cornerRadius = 8;
    return button;
}

+ (UIButton *)popupSettingButtonWithTitle:(NSString *)title isSelected:(BOOL)isSelected {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:isSelected ? UIColorHex(2953ff) : UIColorHex(0f0f0f) forState:UIControlStateNormal];
    [button setBackgroundColor:[UIColor colorWithHexString:@"ffffff"]];
    button.titleLabel.font = REGULAR_FONT(16);
    
    UIView *upperLine = [[UIView alloc] init];
    upperLine.backgroundColor = UIColorHex(ececee);
    [button addSubview:upperLine];
    [upperLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(button);
        make.height.mas_equalTo(0.5);
    }];
    
    return button;
}

+ (TLRadioButton *)radionButtonWithTitle:(NSString *)title isSelected:(BOOL)isSelected {
    TLRadioButton *radio = [[TLRadioButton alloc] initWithTitle:title isSelected:isSelected];
    return radio;
}

@end
