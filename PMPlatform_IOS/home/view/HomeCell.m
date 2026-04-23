//
//  HomeCell.m
//  PMPlatform_IOS
//
//  Created by 末末班车 on 2017/9/5.
//  Copyright © 2017年 com.atide. All rights reserved.
//

#import "HomeCell.h"

@interface HomeCell ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *userLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;

@end

@implementation HomeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)loadDataModel:(HomeModel *)model {
    self.titleLabel.text = [NSString stringWithFormat:@"[%@] %@", model.bizTypeName, model.title];
   if(model.drafterName) self.userLabel.text = [NSString stringWithFormat:@"申请人:%@", model.drafterName];
    self.dateLabel.text = model.createTime;
}

@end
