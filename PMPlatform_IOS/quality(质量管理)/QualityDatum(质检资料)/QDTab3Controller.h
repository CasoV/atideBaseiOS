//
//  QDTab3Controller.h
//  HBConstructionApp
//
//  Created by 末末班车 on 2018/6/6.
//  Copyright © 2018年 atide. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SiteModel.h"

@interface QDTab3Controller : UIViewController
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *addBtn;
@property (weak, nonatomic) IBOutlet UIButton *partBtn;
@property (nonatomic, copy) NSString *partCode;
- (IBAction)partAction:(UIButton *)sender;
- (void)fetchPart;
@end
