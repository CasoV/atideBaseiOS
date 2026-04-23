//
//  SpecialUseListCell.h
//  ycxm
//
//  Created by 末末班车 on 2018/12/18.
//  Copyright © 2018 末末班车. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SpecialUseListCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *codeLabel;
@property (weak, nonatomic) IBOutlet UILabel *deviceCodeLabel;
@property (weak, nonatomic) IBOutlet UILabel *usePlaceLabel;
@property (weak, nonatomic) IBOutlet UILabel *deviceNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *unitNameLabel;

@property (nonatomic, copy) void (^callback)(void);

@end

NS_ASSUME_NONNULL_END
