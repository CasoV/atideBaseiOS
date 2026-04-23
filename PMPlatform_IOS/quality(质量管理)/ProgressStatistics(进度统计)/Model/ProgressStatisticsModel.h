//
//  ProgressStatisticsModel.h
//  HBConstructionApp
//
//  Created by 末末班车 on 2018/4/13.
//  Copyright © 2018年 atide. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ProgressStatisticsModel : NSObject

@property (nonatomic, copy) NSString * name;
@property (nonatomic, copy) NSString * code;
@property (nonatomic, copy) NSString * ratio;
@property (nonatomic, copy) NSString * percent;

@property (nonatomic, assign) NSInteger unstart;
@property (nonatomic, assign) NSInteger total;
@property (nonatomic, assign) NSInteger start;
@property (nonatomic, assign) NSInteger end;
@property (nonatomic, assign) BOOL canClicked;

@property (nonatomic, copy) NSString * status;
@property (nonatomic, copy) NSString * part_id;
@property (nonatomic, copy) NSString * part_name;
@property (nonatomic, copy) NSString * type_name;

@property (nonatomic, copy) NSString * start_time;
@property (nonatomic, copy) NSString * end_time;

@end
