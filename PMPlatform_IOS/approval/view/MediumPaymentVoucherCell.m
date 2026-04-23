//
//  MediumPaymentVoucherCell.m
//  PMPlatform_IOS
//
//  Created by 末末班车 on 2017/10/17.
//  Copyright © 2017年 com.atide. All rights reserved.
//

#import "MediumPaymentVoucherCell.h"

@interface MediumPaymentVoucherCell ()

@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UILabel *costname;
@property (weak, nonatomic) IBOutlet UILabel *contractamt;
@property (weak, nonatomic) IBOutlet UILabel *compamt;
@property (weak, nonatomic) IBOutlet UILabel *designamt;
@property (weak, nonatomic) IBOutlet UILabel *sum;
@property (weak, nonatomic) IBOutlet UILabel *pCompAMT;

@end

@implementation MediumPaymentVoucherCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.bgView.layer.cornerRadius = 7;
    self.bgView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.bgView.layer.borderWidth = 1;
}

- (void)setDataModel:(MediumPaymentVoucherModel *)model {
    self.costname.text = model.costname;
    self.contractamt.text = model.contractamt;
    self.compamt.text = model.compamt;
    self.designamt.text = model.designamt;
    self.pCompAMT.text = model.pCompAMT;
    
    self.sum.text = [NSString stringWithFormat:@"%.01f", model.compamt.floatValue + model.pCompAMT.floatValue];
}

@end
