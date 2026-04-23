//
//  TLToken.m
//  ZegoRoomkitDemo
//
//  Created by Kael Ding on 2020/7/17.
//  Copyright © 2020 zego. All rights reserved.
//

#import "TLToken.h"
#import <AFNetworking/AFNetworking.h>
#import "NSString+Utility.h"

@implementation TLToken

+ (void)getAccessTokenWithCompletion:(void (^)(NSString * _Nullable))completion {
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    [securityPolicy setValidatesDomainName:NO];
    securityPolicy.allowInvalidCertificates = YES; //还是必须设成YES
    manager.securityPolicy = securityPolicy;
    
    NSString *deviceId = [[ZegoRoomKit deviceID] lowercaseString];
    long long timestamp = (long long)[[NSDate date] timeIntervalSince1970] * 1000;
    NSString *secretSign = [NSString getSecretSignWithDeviceId:deviceId timestamp:timestamp];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    dic[@"sign"] = secretSign;
    dic[@"secret_id"] = @(kSecretID);
    dic[@"device_id"] = deviceId;
    dic[@"timestamp"] = @(timestamp);
#ifdef ZEGO_ENVIROMENT_FLAG
    NSString *domain = [ZegoEnviromentManager getAppDomain];
#else
    NSString *domain = kInternalDomain;
#endif
    [manager POST:[NSString stringWithFormat:@"%@/auth/get_sdk_token", domain] parameters:dic headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //解析
        NSString *token = nil;
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            NSDictionary *dataJson = responseObject[@"data"];
            if ([dataJson isKindOfClass:[NSDictionary class]]) {
                token = dataJson[@"sdk_token"];
            }
        }
        completion(token);
        [self saveToken:token];
        
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"ZegoRoomkitDemo get token fail: %@", error);
            completion(nil);
    }];
}

+ (void)saveToken:(nullable NSString *)token {
    [[NSUserDefaults standardUserDefaults] setObject:token forKey:@"token"];
}
+ (NSString *)getToken {
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"token"] ? :@"";
}
@end
