//
//  QualityProblemReplyCell.m
//  ycxm
//
//  Created by 末末班车 on 2018/9/30.
//  Copyright © 2018年 末末班车. All rights reserved.
//

#import "QualityProblemReplyCell.h"

@interface QualityProblemReplyCell ()

@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UILabel *content;
@property (weak, nonatomic) IBOutlet UILabel *doRet;
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UILabel *time;
@property (weak, nonatomic) IBOutlet UIImageView *signatureImageView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageWidth;

@end

@implementation QualityProblemReplyCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.bgView.layer.borderWidth = 0.5;
    self.bgView.layer.borderColor = [UIColor darkGrayColor].CGColor;
    self.bgView.layer.cornerRadius = 3;
}

- (void)setModel:(QualityProblemReplyModel *)model {
    self.content.text = model.content;
    self.userName.text = model.userName;
    self.time.text = model.createTime;
    if ([model.status isEqualToString:@"1"]) {
        self.doRet.text = @"已确认整改";
        self.doRet.textColor = UIColorTextBlue;
    } else if ([model.status isEqualToString:@"2"]) {
        self.doRet.text = @"复查未通过";
        self.doRet.textColor = [UIColor redColor];
    } else if ([model.status isEqualToString:@"3"]) {
        self.doRet.text = @"复查通过";
        self.doRet.textColor = UIColorTextBlue;
    } else {
        self.doRet.text = @"回复";
        self.doRet.textColor = [UIColor darkGrayColor];
    }
    
    if (model.fileIds.count == 0) {
        self.imageWidth.constant = 0;
    } else {
        self.imageWidth.constant = 38;
    }
}

@end
