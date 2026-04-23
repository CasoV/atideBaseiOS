//
//  ProcessListCell.m
//  PMPlatform_IOS
//
//  Created by 末末班车 on 2017/9/6.
//  Copyright © 2017年 com.atide. All rights reserved.
//

#import "ProcessListCell.h"

@interface ProcessListCell ()

@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UILabel *userLabel;
@property (weak, nonatomic) IBOutlet UILabel *orgLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;

@end

@implementation ProcessListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.bgView.layer.cornerRadius = 10;
    self.bgView.layer.borderColor = [UIColor hex:@"008AEB"].CGColor;
    self.bgView.layer.borderWidth = 1;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)loadDataModel:(ProcessListModel *)model {
    if(model.drafterName) self.userLabel.text = model.drafterName;
    if(model.drafterOrgName)self.orgLabel.text = [NSString stringWithFormat:@"(%@)", model.drafterOrgName];
    self.titleLabel.text = model.title;
    self.typeLabel.text = model.bizTypeName;
    self.dateLabel.text = model.createTime;
}

@end
