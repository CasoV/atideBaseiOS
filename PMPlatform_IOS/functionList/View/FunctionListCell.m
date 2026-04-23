//
//  FunctionListCell.m
//  ycxm
//
//  Created by 末末班车 on 2018/9/29.
//  Copyright © 2018年 末末班车. All rights reserved.
//

#import "FunctionListCell.h"

@interface FunctionListCell()

@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *label;

@end

@implementation FunctionListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}


- (void)setModel:(PermissionModel *)model {
//    self.iconImageView.image = [UIImage imageNamed:model.imageName];
    self.label.text = model.resourceName;
}

@end
