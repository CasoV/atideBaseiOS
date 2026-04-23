//
//  ListConditionViewController.h
//  ycTest
//
//  Created by 末末班车 on 2018/9/12.
//  Copyright © 2018年 末末班车. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ConditionModel.h"

@interface ListConditionViewController : UIViewController

@property (nonatomic, copy) NSArray <ConditionModel *>*conditionModels;

@property (nonatomic, copy) void (^callback)(void);

@property (weak, nonatomic) IBOutlet UIButton *projectBtn;

@property (nonatomic, assign) BOOL showDate;

@property (nonatomic, assign) BOOL showKeyword;

@property (nonatomic, assign) BOOL hiddenPartBtn;

@property (nonatomic, copy) NSString *keyword;

@property (nonatomic, copy) NSString *partCode;

- (NSDictionary *)params;

@end
