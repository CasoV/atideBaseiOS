//
//  FlowPicPopCell.m
//  PMPlatform_IOS
//
//  Created by 末末班车 on 2017/9/13.
//  Copyright © 2017年 com.atide. All rights reserved.
//

#import "FlowPicPopCell.h"

@interface FlowPicPopCell ()

@property (weak, nonatomic) IBOutlet UILabel *createTime;
@property (weak, nonatomic) IBOutlet UILabel *message;
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UILabel *doRet;

@end

@implementation FlowPicPopCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)loadDataModel:(FlowApprovalResult *)model {
    self.createTime.text = model.time;
    self.message.text = model.message;
    self.userName.text = model.userName;
    self.doRet.text = model.doRet;
}

@end
