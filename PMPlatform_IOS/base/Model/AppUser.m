//
//  AppUser.m
//  ycxm
//
//  Created by 末末班车 on 2018/9/17.
//  Copyright © 2018年 末末班车. All rights reserved.
//

#import "AppUser.h"

@implementation AppUser

+ (instancetype)sharedInstance {
    static id _sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[self alloc] init];
    });
    
    return _sharedInstance;
}

+ (NSDictionary *)mj_objectClassInArray {
    return @{@"orgs":@"OrgModel"};
}

-(void)updateWithUser:(AppUser *)user{
    if (user) {
        self.id = user.id;
        self.name = user.name;
        self.userName = user.userName;
        self.phone = user.phone;
        self.addr = user.addr;
        self.post = user.post;
        self.orgName = user.orgName;
        self.topOrgName = user.topOrgName;
//        self.orgs = user.orgs;
        self.userId = user.userId;
        self.orgId = user.orgId;
    }
}

- (NSString *)sexName{
    return [_sex isEqualToString:@"2"] ? @"男":@"女";
}

- (NSString *)password {
    NSString *password = [[NSUserDefaults standardUserDefaults] objectForKey:USER_DEFAULT_PASSWORD];
    return password ?  password : @"";
}

@end
