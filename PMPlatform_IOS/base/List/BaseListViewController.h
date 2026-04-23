//
//  BaseListViewController.h
//  ycTest
//
//  Created by 末末班车 on 2018/9/12.
//  Copyright © 2018年 末末班车. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseListViewController : BaseViewController

@property (nonatomic, strong) UIButton *addBtn;

@property (nonatomic, assign) FunctionType type;

@property (nonatomic, copy) NSString *pid;
@property (nonatomic, copy) NSString *noticeId;
@end
