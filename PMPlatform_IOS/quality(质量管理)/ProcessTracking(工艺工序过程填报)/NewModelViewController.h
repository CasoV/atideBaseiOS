//
//  NewModelViewController.h
//  HBConstructionApp
//
//  Created by 末末班车 on 2018/5/23.
//  Copyright © 2018年 atide. All rights reserved.
//

#import "BaseViewController.h"

@interface NewModelViewController : BaseViewController

@property (nonatomic, copy) NSString *modelId;
@property (nonatomic, copy) NSString *pid;

@property (nonatomic, copy) NSString *partCode;
@property (nonatomic, assign) BOOL isFromScan;

@end
