//
//  BaseViewController.h
//  ycTest
//
//  Created by 末末班车 on 2018/9/10.
//  Copyright © 2018年 末末班车. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PermissionModel.h"

@interface BaseViewController : UIViewController

@property(nonatomic, strong) UIView *line;

@property(nonatomic, copy) NSString *code;

@property(nonatomic, copy) NSString *resourceTitle;

@property(nonatomic, copy) NSString *projectId;

@property(nonatomic, copy) NSString *projectCode;

@property(nonatomic, copy) NSString *sectionId;

@property(nonatomic, copy) NSString *sectionCode;

@property (nonatomic, copy) NSArray<PermissionModel *> * children;

@property(nonatomic, assign) NSInteger vcTypeValue;

@property (nonatomic, assign) BOOL isFirst;

@end
