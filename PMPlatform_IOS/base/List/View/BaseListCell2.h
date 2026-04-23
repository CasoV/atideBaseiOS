//
//  BaseListCell2.h
//  ycxm
//
//  Created by 末末班车 on 2018/9/20.
//  Copyright © 2018年 末末班车. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseListCell2 : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *label1;
@property (weak, nonatomic) IBOutlet UILabel *label2;
@property (weak, nonatomic) IBOutlet UILabel *label3;
@property (weak, nonatomic) IBOutlet UILabel *label4;
@property (weak, nonatomic) IBOutlet UILabel *label5;
@property (weak, nonatomic) IBOutlet UILabel *label6;

@property (weak, nonatomic) IBOutlet UIButton *btn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *btnWidth;

@property (nonatomic, copy) void (^callback)(void);

@end
