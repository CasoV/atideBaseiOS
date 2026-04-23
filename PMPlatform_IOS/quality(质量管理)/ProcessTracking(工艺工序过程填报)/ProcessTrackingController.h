//
//  ProcessTrackingController.h
//  HBConstructionApp
//
//  Created by 末末班车 on 2018/5/23.
//  Copyright © 2018年 atide. All rights reserved.
//

#import "BaseViewController.h"
#import "ProcessReportModel.h"

@interface ProcessTrackingController : BaseViewController

@property (nonatomic, strong) ProcessReportModel *model;

@property (nonatomic, copy) NSString *partCode;

@property (nonatomic, assign) BOOL canEdit;

@end
