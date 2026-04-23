//
//  CheckListBean.h
//  HBConstructionApp
//
//  Created by vxg on 2018/03/28.
//  Copyright © 2018年 atide. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CheckListBean : NSObject

@property (nonatomic, copy) NSString *id;
@property (nonatomic, copy) NSString *pid;
@property (nonatomic, copy) NSString *partName;
@property (nonatomic, copy) NSString *partType;
@property (nonatomic, copy) NSString *tableName;
@property (nonatomic, copy) NSString *dateName;
@property (nonatomic, copy) NSString *wordUrl;
@property (nonatomic, copy) NSString *approvalUrl;
@property (nonatomic, copy) NSString *isMust;
@property (nonatomic, assign) NSInteger orderNum;
@property (nonatomic, copy) NSString *userId;
@property (nonatomic, copy) NSString *userName;
@property (nonatomic, copy) NSString *orgId;
@property (nonatomic, copy) NSString *orgName;
@property (nonatomic, assign) NSInteger createTime;
@property (nonatomic, copy) NSString *projectId;
@property (nonatomic, copy) NSString *sectId;
@property (nonatomic, copy) NSString *status;
@property (nonatomic, copy) NSString *partTypeName;
@property (nonatomic, copy) NSString *partTypeCode;
@property (nonatomic, copy) NSString *isFiles;
@property (nonatomic, copy) NSString *tableViewUrl;
@property (nonatomic, copy) NSString *tableCountUrl;
@property (nonatomic, copy) NSString *partCode;
@property (nonatomic, copy) NSString *sqlStr;
@property (nonatomic, copy) NSString *_parentId;
@property (nonatomic, copy) NSString *mainTableId;
@property (nonatomic, copy) NSString *relationTitle;

@property (nonatomic , copy) NSString              * excelId;
@property (nonatomic , copy) NSString              * controllerName;
@property (nonatomic , copy) NSString              * type;
@property (nonatomic , copy) NSString              * processCode;
@property (nonatomic , copy) NSString              * CREATE_TIME;
@property (nonatomic , copy) NSString              * numId;
@property (nonatomic , copy) NSString              * PNAME;
@property (nonatomic , copy) NSString              * tid;
@property (nonatomic , copy) NSString              * typeName;
@property (nonatomic , copy) NSString              * name;

@end
