//
//  AppUser.h
//  ycxm
//
//  Created by 末末班车 on 2018/9/17.
//  Copyright © 2018年 末末班车. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  用户
 */
@interface AppUser : NSObject

@property (nonatomic, copy) NSString *userId;
@property (nonatomic, copy) NSArray<NSString *> *orgIds;
@property (nonatomic, copy) NSString *status;
@property (nonatomic, copy) NSString *imgId;
@property (nonatomic, copy) NSString *code;
@property (nonatomic, copy) NSString *imgType;
@property (nonatomic, copy) NSString *post;
@property (nonatomic, copy) NSString *bankCard;
@property (nonatomic, copy) NSString *sex;
@property (nonatomic, copy) NSString *birthDate;
@property (nonatomic, copy) NSString *corpPhone;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *userName;
@property (nonatomic, copy) NSString *certNo;
@property (nonatomic, copy) NSString *topOrgName;
@property (nonatomic, copy) NSArray<NSString *> *roleIds;
@property (nonatomic, copy) NSString *occupation;
@property (nonatomic, copy) NSString *topOrgId;
@property (nonatomic, copy) NSString *email;
@property (nonatomic, copy) NSString *corpAddr;
@property (nonatomic, copy) NSString *phone;
@property (nonatomic, copy) NSString *certType;
@property (nonatomic, copy) NSString *bankName;
@property (nonatomic, copy) NSString *orgName;
@property (nonatomic, copy) NSString *addr;
@property (nonatomic, copy) NSString *remark;
@property (nonatomic, copy) NSString *password;
@property (nonatomic, copy) NSString *orgId;
@property (nonatomic, copy) NSString *qq;
@property (nonatomic, copy) NSString *id;

@property (nonatomic, readonly) NSString *sexName;

+ (instancetype)sharedInstance;
-(void)updateWithUser:(AppUser *)user;

@end
