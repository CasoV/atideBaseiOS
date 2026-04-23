//
//  ZQZFCertificateCell.m
//  PMPlatform_IOS
//
//  Created by 末末班车 on 2017/10/19.
//  Copyright © 2017年 com.atide. All rights reserved.
//

#import "ZQZFCertificateCell.h"

@interface ZQZFCertificateCell ()

@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UILabel *titleTxt;
@property (weak, nonatomic) IBOutlet UILabel *htTxt;
@property (weak, nonatomic) IBOutlet UILabel *sjTxt;
@property (weak, nonatomic) IBOutlet UILabel *bgTxt;
@property (weak, nonatomic) IBOutlet UILabel *bghTxt;
@property (weak, nonatomic) IBOutlet UILabel *bqmTxt;
@property (weak, nonatomic) IBOutlet UILabel *sqmTxt;
@property (weak, nonatomic) IBOutlet UILabel *bqTxt;

@end

@implementation ZQZFCertificateCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.bgView.layer.cornerRadius = 10;
    self.bgView.layer.borderColor = [UIColor hex:@"3f92e9"].CGColor;
    self.bgView.layer.borderWidth = 1;
}

- (void)loadDataModel:(ZQZFCertificateModel *)model {
    self.titleTxt.text = [NSString stringWithFormat:@"%@ %@", model.reportCode, model.listName];
    self.htTxt.text = model.orgAMT;
    self.sjTxt.text = model.designAMT;
    self.bgTxt.text = model.changeAMT;
    self.bghTxt.text = model.totalAMT;
    
    self.bqmTxt.text = model.cCompAMT;
    self.sqmTxt.text = model.pCompAMT;
    self.bqTxt.text = model.compAMT;
}

@end
