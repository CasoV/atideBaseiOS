//
//  DocumentCell.m
//  PMPlatform_IOS
//
//  Created by 末末班车 on 2017/9/7.
//  Copyright © 2017年 com.atide. All rights reserved.
//

#import "DocumentCell.h"
#import "SearchFactory.h"

@interface DocumentCell ()

@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UILabel *rcvUserNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *orgNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *rcvTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *itemTypeNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *publicLabel;
@property (weak, nonatomic) IBOutlet UILabel *urgencyLabel;
@property (weak, nonatomic) IBOutlet UILabel *secretLevelLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UILabel *docNatrueNameLabel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *statusHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *statusLabelHeight;
@property (weak, nonatomic) IBOutlet UIImageView *lineiv;

@end

@implementation DocumentCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.bgView.layer.cornerRadius = 10;
    self.bgView.layer.borderColor = [UIColor hex:@"008AEB"].CGColor;
    self.bgView.layer.borderWidth = 1;
}

- (void)loadDataModel:(DocumentModel *)model {
    self.rcvUserNameLabel.text = model.userName;
    self.orgNameLabel.text = [NSString stringWithFormat:@"(%@)", model.orgName];
    self.rcvTimeLabel.text = model.createTime;
    self.titleLabel.text = model.title;
    self.itemTypeNameLabel.text = model.itemName;
    self.publicLabel.text = @"公司";
    self.urgencyLabel.text = [SearchFactory getUrgencyTypeName:model.urgency.integerValue];
    self.secretLevelLabel.text = [SearchFactory getSecretLevelTypeName:model.secretLevel.integerValue];
    self.statusLabel.text = [SearchFactory getStatusTypeName:model.status.integerValue];
    self.docNatrueNameLabel.text = model.docNatrueName;
    
    [self updateStatusLabel];
}

- (void)loadDataRcvModel:(DocumentRcvModel *)model {
    self.rcvUserNameLabel.text = model.rcvUserName;
    self.orgNameLabel.text = [NSString stringWithFormat:@"(%@)", model.rcvOrgName];
    self.rcvTimeLabel.text = model.createTime;
    self.titleLabel.text = model.title;
    self.itemTypeNameLabel.text = model.itemTypeName;
    self.publicLabel.text = @"公司";
    self.urgencyLabel.text = [SearchFactory getUrgencyTypeName:model.urgency.integerValue];
    self.secretLevelLabel.text = [SearchFactory getSecretLevelTypeName:model.secretLevel.integerValue];
    self.statusLabel.text = [SearchFactory getStatusTypeName:model.status.integerValue];
    self.docNatrueNameLabel.text = model.docNatrueName;
    
    [self updateStatusLabel];
}

- (void)updateStatusLabel {
    if (self.searchType == 6) {
        self.statusHeight.constant = 0;
        self.statusLabelHeight.constant = 0;
        self.lineiv.hidden = YES;
    }
}

@end
