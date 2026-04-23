//
//  QDTab1Controller.h
//  HBConstructionApp
//
//  Created by vxg on 2018/03/28.
//  Copyright © 2018年 atide. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QDTab1Controller : UIViewController

/** 是否来自二维码扫描 */
@property (nonatomic, assign)BOOL isFromScan;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *partBtn;
- (IBAction)partAction:(UIButton *)sender;
- (void)fetchPart;
@end
