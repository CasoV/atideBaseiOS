//
//  ZQZFpzCell.m
//  PMPlatform_IOS
//
//  Created by 末末班车 on 2017/10/19.
//  Copyright © 2017年 com.atide. All rights reserved.
//

#import "ZQZFpzCell.h"

@interface ZQZFpzCell ()

@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *zsqm;
@property (weak, nonatomic) IBOutlet UILabel *zbqm;
@property (weak, nonatomic) IBOutlet UILabel *bq;

@end

@implementation ZQZFpzCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.bgView.layer.cornerRadius = 7;
    self.bgView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.bgView.layer.borderWidth = 1;
}

- (void)loadDataModel:(ZQZFpzModel *)model {
    self.titleLabel.text = [model.listName isEqualToString:@"小计"] ? @"章节合计" : model.listName;
    self.zbqm.text = model.cCompAMT;
    self.zsqm.text = model.pCompAMT;
    self.bq.text = model.compAMT;
}

@end
