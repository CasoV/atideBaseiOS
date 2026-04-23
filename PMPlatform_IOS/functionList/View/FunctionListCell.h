//
//  FunctionListCell.h
//  ycxm
//
//  Created by 末末班车 on 2018/9/29.
//  Copyright © 2018年 末末班车. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FunctionListCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topMargin;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomMargin;

@property (nonatomic, strong) PermissionModel *model;

@end
