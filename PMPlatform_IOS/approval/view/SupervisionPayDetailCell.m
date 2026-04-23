//
//  SupervisionPayDetailCell.m
//  PMPlatform_IOS
//
//  Created by 末末班车 on 2017/10/20.
//  Copyright © 2017年 com.atide. All rights reserved.
//

#import "SupervisionPayDetailCell.h"

@interface SupervisionPayDetailCell ()

@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *payment;
@property (weak, nonatomic) IBOutlet UILabel *calculate;
@property (weak, nonatomic) IBOutlet UILabel *leader;
@property (weak, nonatomic) IBOutlet UILabel *financeDepartment;


@end

@implementation SupervisionPayDetailCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.bgView.layer.cornerRadius = 10;
    self.bgView.layer.borderColor = [UIColor hex:@"a8abad"].CGColor;
    self.bgView.layer.borderWidth = 1;
}

- (void)loadDataModel:(SupervisionChargeModel *)model {
    //统一保留两位小数
    NSString *str_compamt = @"-";
    if (model.compamt != nil) {
        str_compamt = [NSString stringWithFormat:@"%.02f", [model.compamt floatValue]];
    }
    self.titleLabel.text = model.costname;
    self.payment.text = [NSString stringWithFormat:@"申请付款额:%@", str_compamt];
    self.calculate.text = [NSString stringWithFormat:@"指挥部计量审核数量:%@", str_compamt];
    self.leader.text = [NSString stringWithFormat:@"指挥部领导审核数:%@", str_compamt];
    self.financeDepartment.text = [NSString stringWithFormat:@"指挥部资产财务处审核数:%@", str_compamt];
}

@end
