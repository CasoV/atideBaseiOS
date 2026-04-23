//
//  ProcessListModel.h
//  PMPlatform_IOS
//
//  Created by 末末班车 on 2017/9/6.
//  Copyright © 2017年 com.atide. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ProcessListModel : NSObject

@property (nonatomic, copy) NSString *createTime;
@property (nonatomic, copy) NSString *taskArrivalTime;
@property (nonatomic, copy) NSString *bizPk;
@property (nonatomic, copy) NSString *executionId;
@property (nonatomic, copy) NSString *flowStatus;
@property (nonatomic, copy) NSString *drafterOrgId;
@property (nonatomic, copy) NSString *preTaskName;
@property (nonatomic, copy) NSString *preHandlerName;
@property (nonatomic, copy) NSString *taskName;
@property (nonatomic, copy) NSString *handleTime;
@property (nonatomic, copy) NSString *ID;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *doUrl;
@property (nonatomic, copy) NSString *flowStatusName;
@property (nonatomic, copy) NSString *drafter;
@property (nonatomic, copy) NSString *preTaskKey;
@property (nonatomic, copy) NSString *bizTypeName;
@property (nonatomic, copy) NSString *bizTypeId;
@property (nonatomic, copy) NSString *instanceId;
@property (nonatomic, copy) NSString *taskKey;
@property (nonatomic, copy) NSString *drafterOrgName;
@property (nonatomic, copy) NSString *drafterName;
@property (nonatomic, copy) NSString *preHandler;
@property (nonatomic, copy) NSString *bizType;

@property (nonatomic, copy) NSString *noticeType;
@property (nonatomic, copy) NSString *noticeTypeName;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSString *sendTime;
@property(nonatomic,assign) Boolean isNoty;
@property (nonatomic, copy) NSString *bizId;
@property (nonatomic, copy) NSString *doUrl1;
@end
