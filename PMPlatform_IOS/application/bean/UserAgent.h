//
//  UserAgent.h
//  ycxm
//
//  Created by 末末班车 on 2018/9/17.
//  Copyright © 2018年 末末班车. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ApprovalPartModel.h"
#import "PermissionModel.h"
#import "ProjectInfo.h"

@interface UserAgent : NSObject<NSCoding>

@property (nonatomic, copy) NSString *projectId; //当前项目ID

@property (nonatomic, copy) NSString *projectCode; //当前项目code

@property (nonatomic, copy) NSString *sectionId; //当前标段ID

@property (nonatomic, copy) NSString *sectionCode; //当前标段code

@property (nonatomic, copy) NSString *prjName;//当前项目名称

@property (nonatomic, copy) NSString *sectionName;//当前标段名称

@property (nonatomic, copy) NSString *engShortName;//当前项目名称

@property (nonatomic, copy) NSString *typeKey;
@property (nonatomic, copy) NSString *projectPlanSn;
@property (nonatomic, copy) NSString *stdVersion;
@property (nonatomic, copy) NSString *sectionMajor;



@property (nonatomic, copy) NSString *sectMajor; //当前标段ID

@property (nonatomic, copy) NSArray <NSString *>*resourceKeys; //按钮权限key

@property (nonatomic, strong) NSMutableArray <ProjectInfo *>*projectInfos; //当前项目数组

@property (nonatomic, copy) NSArray <ProjectInfo *>*sectionInfos; //当前项目标段数组

@property (nonatomic, copy) NSArray <PermissionModel *>*permissions;//当前功能树

@property (nonatomic, strong) ApprovalPartModel *approvalPartModel;

+ (UserAgent *) DefaultAgent;

- (void)saveValuesToCache;

//变换项目标段
-(BOOL)authorityChangeProAndSect:(PermissionModel*)perModel;

//变换项目标段
- (void)authorityChangeProAndSect:(PermissionModel *)perModel callBack:(void (^)(Boolean isChange))callBack;

@end
