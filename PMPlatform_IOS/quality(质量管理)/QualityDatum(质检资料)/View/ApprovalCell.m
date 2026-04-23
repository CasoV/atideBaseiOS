//
//  ApprovalCell.m
//  ycxm
//
//  Created by 高小伟 on 2019/3/14.
//  Copyright © 2019 末末班车. All rights reserved.
//

#import "ApprovalCell.h"

@implementation ApprovalCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.statusLb.transform = CGAffineTransformMakeRotation(0.75);
    self.statusBgView.clipsToBounds = true;
    
}

- (void)setModel:(ApprovalModel *)model{
    _model = model;
    self.titleLabel.text = _model.name;
    self.leftLabel.text = [@"申请人：" stringByAppendingString:_model.userName];
    self.rightLabel.text = [@"申请时间：" stringByAppendingString:[_model.date componentsSeparatedByString:@" "][0]];

    if([model.status isEqualToString:@"1"]){
        self.statusLb.text = @"草稿";
        self.statusLb.backgroundColor = [UIColor colorWithRed:54/255.0 green:54/255.0 blue:54/255.0 alpha:1.0];
    }else if([model.status isEqualToString:@"2"]){
        self.statusLb.text = @"退回";
        self.statusLb.backgroundColor = [UIColor colorWithRed:255/255.0 green:71/255.0 blue:81/255.0 alpha:1.0];
    }else if([model.status isEqualToString:@"3"]){
        self.statusLb.text = @"流转中";
        self.statusLb.backgroundColor = [UIColor colorWithRed:92/255.0 green:192/255.0 blue:156/255.0 alpha:1.0];
    }else if([model.status isEqualToString:@"4"]){
        self.statusLb.text = @"审批通过";
        self.statusLb.backgroundColor = [UIColor colorWithRed:0/255.0 green:191/255.0 blue:216/255.0 alpha:1.0];
    }else{
        self.statusLb.text = model.status;
        self.statusLb.backgroundColor =[UIColor colorWithRed:92/255.0 green:192/255.0 blue:156/255.0 alpha:1.0];
    }
  
}
@end
