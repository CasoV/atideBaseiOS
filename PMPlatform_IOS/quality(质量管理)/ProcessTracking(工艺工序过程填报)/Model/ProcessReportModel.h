//
//  ProcessReportModel.h
//  ConstructionApp
//
//  Created by 末末班车 on 2018/1/17.
//  Copyright © 2018年 atide. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ProcessReportModel : NSObject

@property (nonatomic, copy) NSString * id;
@property (nonatomic, copy) NSString * registerName;
@property (nonatomic, copy) NSString * director;
@property (nonatomic, copy) NSString * supvervisor;
@property (nonatomic, copy) NSString * modelName;
@property (nonatomic, copy) NSString * supvervisorCode;
@property (nonatomic, copy) NSString * userId;
@property (nonatomic, copy) NSString * userName;
@property (nonatomic, copy) NSString * orgId;
@property (nonatomic, copy) NSString * projectId;
@property (nonatomic, copy) NSString * sectId;
@property (nonatomic, copy) NSString * page;
@property (nonatomic, copy) NSString * pid;
@property (nonatomic, copy) NSString * modelId;
@property (nonatomic, copy) NSString * directorCode;
@property (nonatomic, copy) NSString * orgName;
@property (nonatomic, assign) NSInteger createTime;

@property (nonatomic, copy) NSString * remarks;
@property (nonatomic, copy) NSString * modelCode;
@property (nonatomic, copy) NSString * modelType;
@property (nonatomic, copy) NSString * partCode;

@end
