//
//  UserInfo.m
//  PMPlatform_IOS
//
//  Created by 末末班车 on 2017/9/4.
//  Copyright © 2017年 com.atide. All rights reserved.
//

#import "UserInfo.h"

@implementation OrgModel

@end

@implementation UserInfo

static UserInfo *instance = nil;

+ (UserInfo *)getInstance {
    return instance;
}

+ (void)initUserWithDic:(NSDictionary *)dic {
    [OrgModel mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
        return @{@"ID":@"orgId"};
    }];
    [UserInfo mj_setupObjectClassInArray:^NSDictionary *{
        return @{@"orgs":[OrgModel class], @"topOrgs":[OrgModel class]};
    }];
    [UserInfo mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
        return @{@"ID":@"userId"};
    }];
    
    instance = [UserInfo mj_objectWithKeyValues:dic];
}

+ (BOOL)isLogin {
    if (instance == nil) {
        return NO;
    } else {
        return YES;
    }
}

+ (void)signOut {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:@"" forKey:@"password"];
    [userDefaults synchronize];
    
    instance = nil;
}

@end
