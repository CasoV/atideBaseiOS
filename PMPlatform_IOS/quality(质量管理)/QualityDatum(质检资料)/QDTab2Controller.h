//
//  QDTab2Controller.h
//  HBConstructionApp
//
//  Created by vxg on 2018/03/28.
//  Copyright © 2018年 atide. All rights reserved.
//

#import "BaseViewController.h"

@interface QDTab2Controller : BaseViewController
- (IBAction)allAction:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *allBtn;
@property (nonatomic, strong) void(^block)(NSNumber *count);
- (IBAction)passAction:(UIButton *)sender;

@property (nonatomic, copy)NSString *partCode;

@end
