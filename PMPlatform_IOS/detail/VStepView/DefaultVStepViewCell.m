//
//  DefaultVStepViewCell.m
//  PMPlatform_IOS
//
//  Created by 末末班车 on 2017/9/11.
//  Copyright © 2017年 com.atide. All rights reserved.
//

#import "DefaultVStepViewCell.h"

@implementation DefaultVStepViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.userName.font = [UIFont systemFontOfSize:10];
    self.date.font = [UIFont systemFontOfSize:12];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.circleIcon.layer.cornerRadius = 5;
    self.circleIcon.layer.borderWidth = 1;
    self.circleIcon.layer.borderColor = [UIColor colorWithRed:0x1c/0xff green:0x98/0xff blue:0x0f/0xff alpha:0.7].CGColor;
    self.childCircle.layer.cornerRadius = 3;
    self.circleIcon.clipsToBounds = YES;
    self.headPhoto.layer.cornerRadius = 25;
    self.headPhoto.clipsToBounds = YES;
    self.status.layer.cornerRadius = 5;
    self.status.layer.borderColor = [UIColor redColor].CGColor;
    self.status.layer.borderWidth = 1;
    self.status.clipsToBounds = YES;
}

- (void)fillData {
    self.headPhoto.image = [UIImage imageNamed:@"default_useravatar"];
    self.status.text = @"  通过  ";
    self.desc.text = @"审核通过";
    self.date.text = @"2017-09-11 14:30";
    self.stepName.text = @"测试数据";
    self.userName.text = @"(xxxx)";
}

@end
