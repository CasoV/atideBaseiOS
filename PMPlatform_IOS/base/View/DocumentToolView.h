//
//  DocumentToolView.h
//  YXConstructionApp
//
//  Created by 末末班车 on 2018/3/23.
//  Copyright © 2018年 atide. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Panel.h"

@interface DocumentToolView : UIView

@property (nonatomic, copy) NSString *bizPk;

@property (nonatomic, copy) NSString *bizKey;

@property (nonatomic, copy) NSString *bizUrl;

@property (nonatomic, copy) NSString *completeInfo;

@property (nonatomic, copy) NSString *taskId;

@property (nonatomic, copy) NSString *vcTitle;

@property (nonatomic, copy) NSArray <Panel *>*data;

@property (nonatomic, copy) void (^block)(BOOL isRemove);

@property (nonatomic, copy) void (^rejectBlock)(BOOL isReject);

@property (nonatomic, copy) void (^completeBlock)(NSString *btnTitle);

@property (nonatomic, copy) void (^reportBlock)(BOOL isReport);

@property (nonatomic, copy) void (^callBack)(Panel *item);

@property (nonatomic, assign) BOOL isEmpty;

@property (nonatomic, assign) BOOL canSave;

@property (nonatomic, assign) FunctionType type;

@property (nonatomic, copy) NSString *modelId;

@property (nonatomic, copy) NSString *status;
@end
