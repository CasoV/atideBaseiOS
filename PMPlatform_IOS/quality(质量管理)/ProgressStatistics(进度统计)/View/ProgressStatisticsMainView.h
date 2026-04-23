//
//  ProgressStatisticsMainView.h
//  HBConstructionApp
//
//  Created by 末末班车 on 2018/4/13.
//  Copyright © 2018年 atide. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProgressStatisticsModel.h"

@interface ProgressStatisticsMainView : UIView

@property (nonatomic, assign) BOOL canClicked;

@property (nonatomic, copy) NSArray <ProgressStatisticsModel *>*data;

@property (nonatomic, copy) void (^block)(CGFloat viewHeight);

@property (nonatomic, copy) void (^callBack)(ProgressStatisticsModel *model);

- (void)updateData:(NSArray <ProgressStatisticsModel *>*)data;

@end
