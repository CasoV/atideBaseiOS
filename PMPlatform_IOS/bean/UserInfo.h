//
//  UserInfo.h
//  PMPlatform_IOS
//
//  Created by 末末班车 on 2017/9/4.
//  Copyright © 2017年 com.atide. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OrgModel : NSObject

@property (nonatomic, copy) NSString *isPrimary;
@property (nonatomic, copy) NSString *categoryId;
@property (nonatomic, copy) NSString *type;
@property (nonatomic, copy) NSString *superId;
@property (nonatomic, copy) NSString *ID;
@property (nonatomic, copy) NSString *categoryName;
@property (nonatomic, copy) NSString *orderNo;
@property (nonatomic, copy) NSString *level;
@property (nonatomic, copy) NSString *name;

@end

@interface UserInfo : NSObject

@property (nonatomic, copy) NSString *sex;
@property (nonatomic, copy) NSString *phone;
@property (nonatomic, copy) NSString *remark;
@property (nonatomic, copy) NSString *certType;
@property (nonatomic, copy) NSString *addr;
@property (nonatomic, copy) NSString *password;
@property (nonatomic, copy) NSString *ID;
@property (nonatomic, copy) NSString *orgId;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *userName;
@property (nonatomic, copy) NSString *topOrgId;
@property (nonatomic, copy) NSString *birthDate;
@property (nonatomic, copy) NSString *qq;
@property (nonatomic, copy) NSString *occupation;
@property (nonatomic, copy) NSString *post;
@property (nonatomic, copy) NSString *status;
@property (nonatomic, copy) NSString *corpAddr;
@property (nonatomic, copy) NSString *code;
@property (nonatomic, copy) NSString *bankName;
@property (nonatomic, copy) NSString *orgName;
@property (nonatomic, copy) NSString *bankCard;
@property (nonatomic, copy) NSString *imgId;
@property (nonatomic, copy) NSString *corpPhone;
@property (nonatomic, copy) NSString *email;
@property (nonatomic, copy) NSString *imgType;
@property (nonatomic, copy) NSString *certNo;
@property (nonatomic, copy) NSString *topOrgName;
@property (nonatomic, copy) NSString *userFunc;

@property (nonatomic, copy) NSArray <OrgModel *>*orgs;
@property (nonatomic, copy) NSArray <OrgModel *>*topOrgs;
@property (nonatomic, copy) NSArray <NSString *>*orgIds;
@property (nonatomic, copy) NSArray <NSString *>*functionInfos;
@property (nonatomic, copy) NSArray <NSString *>*roleIds;

+ (UserInfo *)getInstance;

+ (void)initUserWithDic:(NSDictionary *)dic;

+ (BOOL)isLogin;

+ (void)signOut;

@end
