//
//  InSealsCell.m
//  PMPlatform_IOS
//
//  Created by 高小伟 on 2018/11/7.
//  Copyright © 2018 com.atide. All rights reserved.
//

#import "InSealsCell.h"
#import "SearchFactory.h"

@interface InSealsCell ()
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UILabel *titleLb;
@property (weak, nonatomic) IBOutlet UILabel *userLb;
@property (weak, nonatomic) IBOutlet UILabel *useDeptLb;
@property (weak, nonatomic) IBOutlet UILabel *approvalTypeLb;
@property (weak, nonatomic) IBOutlet UILabel *statusLb;

@end
@implementation InSealsCell


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
- (void)loadDataModel:(InSealsModel *)model {
    self.userLb.text = model.operat;
    self.useDeptLb.text = model.useDept;
    self.approvalTypeLb.text =[SearchFactory getApprovalTypeName:model.approvalType.integerValue];
    self.statusLb.text =[SearchFactory getStatusTypeName:model.status.integerValue];
}
@end
