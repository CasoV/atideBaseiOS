//
//  WaitCheckBoxCell.h
//  HBConstructionApp
//
//  Created by vxg on 2018/03/28.
//  Copyright © 2018年 atide. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WaitCheckBean.h"

@interface WaitCheckBoxCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *leftLabel;
@property (weak, nonatomic) IBOutlet UILabel *rightLabel;
@property (weak, nonatomic) IBOutlet UIImageView *checkbox;
@property (weak, nonatomic) IBOutlet UIView *checkBoxBgV;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (nonatomic, strong) WaitCheckBean *model;

@end
