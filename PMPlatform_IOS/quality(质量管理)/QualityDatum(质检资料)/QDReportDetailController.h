//
//  QDReportDetailController.h
//  HBConstructionApp
//
//  Created by vxg on 2018/04/04.
//  Copyright © 2018年 atide. All rights reserved.
//

#import "ReviewBaseController.h"
#import "NewQDKeyModel.h"

@interface QDReportDetailController : ReviewBaseController

@property (nonatomic, copy) NSString *url;
@property (nonatomic, copy) NSString *code;
@property (nonatomic, copy) NSString *formType;

@property (nonatomic, strong) NewQDKeyModel *model;

@end
