//
//  MidMeasureDetilApprovalInfo.h
//  TrafficMs
//
//  Created by apple on 2015/11/15.
//  Copyright © 2015年 com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MidMeasureInfo.h"

@interface MidMeasureDetilApprovalInfo : UIViewController<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
-(void)setParams:(MidMeasureInfo *)info;
@end
