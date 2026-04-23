//
//  ProjectInvestDetailCell.m
//  PMPlatform_IOS
//
//  Created by vxg on 2017/09/08.
//  Copyright © 2017年 com.atide. All rights reserved.
//

#import "ProjectInvestDetailCell.h"

@implementation ProjectInvestDetailCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)initData:(NSString *)nameTxt value:(NSString *)valueTxt{
    self.name.text = nameTxt;
    self.value.text = valueTxt;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
