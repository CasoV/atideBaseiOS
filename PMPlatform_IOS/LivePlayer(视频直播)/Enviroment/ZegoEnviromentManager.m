//
//  ZegoEnviromentManager.m
//  ZegoRoomkitDemo
//
//  Created by Kael Ding on 2020/11/30.
//  Copyright © 2020 zego. All rights reserved.
//

#import "ZegoEnviromentManager.h"

static NSInteger accessEnv = 0;

@implementation ZegoEnviromentManager

#ifdef ZEGO_ENVIROMENT_FLAG

+ (NSInteger)getSecretID {
    NSInteger flag = ZEGO_ENVIROMENT_FLAG;
    NSInteger secretID = [self.secretIDDict[@(flag)] integerValue];
    return secretID;
}

+ (NSString *)getSecretSign {
    NSInteger flag = ZEGO_ENVIROMENT_FLAG;
    NSString *secretSign = self.secretSignDict[@(flag)];
    return secretSign;
}

+ (NSString *)getAppDomain {
    NSInteger flag = ZEGO_ENVIROMENT_FLAG;
    NSString *appDomain = self.appDomainDict[@(flag)];
    return appDomain;
}

+ (NSString *)getOutRoomServiceDomain {
    NSInteger flag = ZEGO_ENVIROMENT_FLAG;
    NSString *serviceDomain = self.outRoomServiceDomainDict[@(flag)];
    return serviceDomain;
}
    
#pragma mark - getter
+ (NSDictionary *)secretIDDict {
    return @{
        @(0) : @(kReleaseSecretID),
        @(1) : @(kTestSecretID),
        @(2) : @(kAlphaSecretID)
    };
}
+ (NSDictionary *)secretSignDict {
    return @{
        @(0) : kReleaseSecretSign,
        @(1) : kTestSecretSign,
        @(2) : kAlphaSecretSign
    };
}

+ (NSDictionary *)outRoomServiceDomainDict {
    return @{
        @(0) : kReleaseOutRoomServiceDomain,
        @(1) : kTestOutRoomServiceDomain,
        @(2) : kAlphaOutRoomServiceDomain
    };
}

+ (NSDictionary *)appDomainDict {
    return @{
        @(0) : kReleaseDomain,
        @(1) : kTestDomain,
        @(2) : kAlphaDomain
    };
}

#endif

#ifdef ZEGO_ACCESS_ENV_FLAG
+ (NSInteger)getProductIDOfRoomType:(NSInteger)roomType {
    NSInteger flag = ZEGO_ACCESS_ENV_FLAG;
    NSInteger productID = [self.productIDDict[@(flag)][@(roomType)] integerValue];
    return productID;
}

+ (NSDictionary *)productIDDict {
    return @{
        @(1) : @{
            @(1) : @(kProductID_smallRoom_mainland),
            @(3) : @(kProductID_1v1_mainland),
            @(5) : @(kProductID_largeRoom_mainland),
            @(6) : @(kProductID_largeRoom_L3_mainland),
        },
        @(2) : @{
            @(1) : @(kProductID_smallRoom_overseas),
            @(3) : @(kProductID_1v1_overseas),
            @(5) : @(kProductID_largeRoom_overseas),
            @(6) : @(kProductID_largeRoom_L3_overseas),
        },
    };
}
+ (void)setAccessEnv:(NSInteger)env {
    accessEnv = env;
    [[NSUserDefaults standardUserDefaults] setInteger:env forKey:@"ZEGO_ACCESS_ENV_FLAG"];
}

+ (NSInteger)getAccessEnv {
    accessEnv = [[NSUserDefaults standardUserDefaults] integerForKey:@"ZEGO_ACCESS_ENV_FLAG"];
    if (accessEnv <= 0) {
        [ZegoEnviromentManager setAccessEnv:1];
    }
    return accessEnv;
}
#endif

@end
