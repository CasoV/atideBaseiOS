//
//  MidMeasureDetilPerformance.h
//  TrafficMs
//
//  Created by apple on 2015/11/15.
//  Copyright © 2015年 com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MidMeasureInfo.h"

@interface MidMeasureDetilPerformance : UIViewController<UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *currentStaticsLedger;
@property (weak, nonatomic) IBOutlet UILabel *currentRate;
@property (weak, nonatomic) IBOutlet UILabel *totalLedger;
@property (weak, nonatomic) IBOutlet UILabel *totalRate;
@property (weak, nonatomic) IBOutlet UILabel *leftLedger;
@property (weak, nonatomic) IBOutlet UILabel *leftRate;

-(void)setPerformanceParams:(MidMeasureInfo*)info;
@end
