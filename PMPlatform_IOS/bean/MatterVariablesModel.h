//
//  MatterVariableModel.h
//  HBConstructionApp
//
//  Created by 末末班车 on 2018/4/2.
//  Copyright © 2018年 atide. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MatterVariablesModel : NSObject

@property (nonatomic , assign) NSInteger              result;
@property (nonatomic , copy) NSString              * initiator;
@property (nonatomic , copy) NSString              * own_user_id;
@property (nonatomic , assign) NSInteger              skip;
@property (nonatomic , copy) NSString              * biz_type_key;
@property (nonatomic , copy) NSString              * tableUrlStr;
@property (nonatomic , copy) NSString              * biz_type_id;
@property (nonatomic , assign) BOOL              _ACTIVITI_SKIP_EXPRESSION_ENABLED;
@property (nonatomic , copy) NSString              * own_org_id;
@property (nonatomic , copy) NSString              * numId;
@property (nonatomic , copy) NSString              * partCode;
@property (nonatomic , copy) NSString              * own_project_id;
@property (nonatomic , copy) NSString              * own_section_id;
@property (nonatomic , copy) NSString              * own_section_code;

@end
