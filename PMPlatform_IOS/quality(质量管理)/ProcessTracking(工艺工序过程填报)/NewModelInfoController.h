//
//  NewModelInfoController.h
//  HBConstructionApp
//
//  Created by 末末班车 on 2018/5/23.
//  Copyright © 2018年 atide. All rights reserved.
//

#import "FDBaseViewController.h"

@interface NewModelInfoController : FDBaseViewController

@property (nonatomic, copy) NSString *partCode;

@property (nonatomic, copy) NSString *modelId;

@property (nonatomic, copy) NSString *pid;

@property (nonatomic, assign) BOOL canEdit;

@property (nonatomic, assign) BOOL isUserXY;

@end
