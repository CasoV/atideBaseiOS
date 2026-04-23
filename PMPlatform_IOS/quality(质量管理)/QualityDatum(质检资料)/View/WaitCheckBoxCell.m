//
//  WaitCheckBoxCell.m
//  HBConstructionApp
//
//  Created by vxg on 2018/03/28.
//  Copyright © 2018年 atide. All rights reserved.
//

#import "WaitCheckBoxCell.h"


@implementation WaitCheckBoxCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModel:(WaitCheckBean *)model{
    _model = model;
    self.titleLabel.text = _model.title;
    self.leftLabel.text = [@"申请人：" stringByAppendingString:_model.drafterName];
    
    self.rightLabel.text = [@"申请时间：" stringByAppendingString:[_model.createTime componentsSeparatedByString:@" "][0]];
    if(_model.isSelected){
        self.checkbox.image = [UIImage imageNamed:@"cbox_blue_pro"];
    }else{
        self.checkbox.image = [UIImage imageNamed:@"cbox_def"];
    }
    
    switch (model.flowStatus) {
        case 1:
            self.statusLabel.text = @"未提交";
            self.statusLabel.textColor = UIColorStatus1;
            break;
        case 2:
            self.statusLabel.text = @"退回";
            self.statusLabel.textColor = UIColorStatus2;
            break;
        case 3:
            self.statusLabel.text = @"流转中";
            self.statusLabel.textColor = UIColorStatus3;
            break;
        default:
            self.statusLabel.text = @"未知";
            self.statusLabel.textColor = UIColorStatus0;
            break;
    }
}

@end
