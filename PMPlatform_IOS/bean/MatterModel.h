//
//  MatterModel.h
//  ConstructionApp
//
//  Created by RedLi on 2018/1/18.
//  Copyright © 2018年 atide. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MatterVariablesModel.h"

@interface MatterModel : NSObject

@property (nonatomic , copy) NSString              * doUrl;
@property (nonatomic , copy) NSString              * title;
@property (nonatomic , copy) NSString              * drafterName;
@property (nonatomic , copy) NSString              * preHandlerName;
@property (nonatomic , copy) NSString              * executionId;
@property (nonatomic , copy) NSString              * bizPk;
@property (nonatomic , copy) NSString              * drafter;
@property (nonatomic , copy) NSString              * bizTypeName;
@property (nonatomic , copy) NSString              * bizTypeId;
@property (nonatomic , copy) NSString              * id;
@property (nonatomic , copy) NSString              * instanceId;
@property (nonatomic , copy) NSString              * preHandler;
@property (nonatomic , copy) NSString              * preTaskKey;
@property (nonatomic , copy) NSString              * taskKey;
@property (nonatomic , copy) NSString              * handleTime;
@property (nonatomic , copy) NSString              * bizType;
@property (nonatomic , copy) NSString              * flowStatusName;
@property (nonatomic , copy) NSString              * preTaskName;
@property (nonatomic , assign) NSInteger              flowStatus;
@property (nonatomic , copy) NSString              * createTime;
@property (nonatomic , copy) NSString              * submitTime;
@property (nonatomic , copy) NSString              * taskName;
@property (nonatomic , copy) NSString              * drafterOrgId;
@property (nonatomic , copy) NSString              * drafterOrgName;
@property (nonatomic , copy) NSString              * taskArrivalTime;
@property (nonatomic , copy) NSString              * status;

@property (nonatomic , strong) MatterVariablesModel              * variables;

@end
