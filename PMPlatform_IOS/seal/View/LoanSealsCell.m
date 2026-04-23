//
//  LoanSealsCell.m
//  PMPlatform_IOS
//
//  Created by 高小伟 on 2018/11/9.
//  Copyright © 2018 com.atide. All rights reserved.
//

#import "LoanSealsCell.h"
#import "SearchFactory.h"

@interface LoanSealsCell ()

@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UILabel *createTimeLb;
@property (weak, nonatomic) IBOutlet UILabel *fillerNameLb;
@property (weak, nonatomic) IBOutlet UILabel *orgNameLb;
@property (weak, nonatomic) IBOutlet UILabel *estiReturnDateLb;
@property (weak, nonatomic) IBOutlet UILabel *actualReturnDateLb;
@property (weak, nonatomic) IBOutlet UILabel *returnManLb;
@property (weak, nonatomic) IBOutlet UILabel *statusLb;

@end

@implementation LoanSealsCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.bgView.layer.cornerRadius = 10;
    self.bgView.layer.borderColor = [UIColor hex:@"008AEB"].CGColor;
    self.bgView.layer.borderWidth = 1;
}

- (void)loadDataModel:(LoanSealModel *)model{

    self.createTimeLb.text = model.createTime;
    self.fillerNameLb.text = model.fillerName;
    self.orgNameLb.text = model.orgName;
    self.estiReturnDateLb.text = model.estiReturnDate;
    self.actualReturnDateLb.text = model.actualReturnDate;
    self.returnManLb.text = model.returnMan;
    self.statusLb.text =[SearchFactory getStatusTypeName:model.status.integerValue];
    
}

@end
