//
//  WaitCheckBean.h
//  HBConstructionApp
//
//  Created by vxg on 2018/03/28.
//  Copyright © 2018年 atide. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VariablesBean : NSObject
@property (nonatomic, assign) NSInteger result;
@property (nonatomic, assign) BOOL _ACTIVITI_SKIP_EXPRESSION_ENABLED;
@property (nonatomic, copy) NSString *numId;
@property (nonatomic, copy) NSString *own_org_id;
@property (nonatomic, copy) NSString *initiator;
@property (nonatomic, copy) NSString *own_user_id;
@property (nonatomic, assign) NSInteger skip;
@property (nonatomic, copy) NSString *partCode;
@property (nonatomic, copy) NSString *biz_type_id;
@property (nonatomic, copy) NSString *biz_type_key;
@property (nonatomic, copy) NSString *tableUrlStr;
@property (nonatomic, copy) NSString * nowKey;
@property (nonatomic, copy) NSString * target;
@end

@interface WaitCheckBean : NSObject

@property (nonatomic, copy) NSString *id;
@property (nonatomic, copy) NSString *executionId;
@property (nonatomic, copy) NSString *instanceId;
@property (nonatomic, copy) NSString *doUrl;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *bizPk;
@property (nonatomic, copy) NSString *drafter;
@property (nonatomic, copy) NSString *drafterName;
@property (nonatomic, copy) NSString *drafterOrgId;
@property (nonatomic, copy) NSString *drafterOrgName;
@property (nonatomic, copy) NSString *createTime;
@property (nonatomic, copy) NSString *taskArrivalTime;
@property (nonatomic, copy) NSString *handleTime;
@property (nonatomic, copy) NSString *taskKey;
@property (nonatomic, copy) NSString *taskName;
@property (nonatomic, assign) NSInteger  flowStatus;
@property (nonatomic, copy) NSString *flowStatusName;
@property (nonatomic, copy) NSString *bizType;
@property (nonatomic, copy) NSString *bizTypeId;
@property (nonatomic, copy) NSString *bizTypeName;
@property (nonatomic, copy) NSString *preHandler;
@property (nonatomic, copy) NSString *preHandlerName;
@property (nonatomic, copy) NSString *preTaskKey;
@property (nonatomic, copy) NSString *preTaskName;
@property (nonatomic, strong) VariablesBean *variables;
@property (nonatomic, assign) BOOL isSelected;
@end
