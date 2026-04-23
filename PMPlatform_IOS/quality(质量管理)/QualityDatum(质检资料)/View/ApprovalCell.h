//
//  ApprovalCell.h
//  ycxm
//
//  Created by 高小伟 on 2019/3/14.
//  Copyright © 2019 末末班车. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ApprovalModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ApprovalCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *leftLabel;
@property (weak, nonatomic) IBOutlet UILabel *rightLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusLb;
@property (weak, nonatomic) IBOutlet UIView *statusBgView;
@property (nonatomic, strong) ApprovalModel *model;
@end

NS_ASSUME_NONNULL_END
