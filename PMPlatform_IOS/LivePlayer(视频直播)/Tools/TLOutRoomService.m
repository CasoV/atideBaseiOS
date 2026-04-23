//
//  TLOutRoomService.m
//  ZegoRoomkitDemo
//
//  Created by xia on 2021/6/9.
//  Copyright © 2021 zego. All rights reserved.
//

#import "TLOutRoomService.h"
#import <AFNetworking/AFNetworking.h>

static NSString * const kCreateRoomPath = @"/room/create";
static NSString * const kListRoomPath = @"/room/query";
static NSString * const kDeleteRoomPath = @"/room/cancel";
static NSString * const kQueryRoomPath = @"/room/get";

@interface TLOutRoomService()

@end

@implementation TLOutRoomService
+ (void)createRoomWithDict:(NSDictionary *)dict
                completion:(void(^)(NSInteger errorCode, NSDictionary * _Nullable data))completion {
#ifdef ZEGO_ENVIROMENT_FLAG
    NSString *domain = [ZegoEnviromentManager getOutRoomServiceDomain];
#else
    NSString *domain = kInternalOutRoomServiceDomain;
#endif
    [self postToURL:[NSString stringWithFormat:@"%@%@", domain, kCreateRoomPath] param:dict completion:completion];
}

+ (void)deleteRoomWithDict:(NSDictionary *)dict
                completion:(void(^)(NSInteger errorCode, NSDictionary * _Nullable data))completion {
#ifdef ZEGO_ENVIROMENT_FLAG
    NSString *domain = [ZegoEnviromentManager getOutRoomServiceDomain];
#else
    NSString *domain = kInternalOutRoomServiceDomain;
#endif
    [self postToURL:[NSString stringWithFormat:@"%@%@", domain, kDeleteRoomPath] param:dict completion:completion];
}

+ (void)listRoomWithDict:(NSDictionary *)dict
              completion:(void(^)(NSInteger errorCode, NSDictionary * _Nullable data))completion {
#ifdef ZEGO_ENVIROMENT_FLAG
    NSString *domain = [ZegoEnviromentManager getOutRoomServiceDomain];
#else
    NSString *domain = kInternalOutRoomServiceDomain;
#endif
    [self postToURL:[NSString stringWithFormat:@"%@%@", domain, kListRoomPath] param:dict completion:completion];
}

+ (void)queryRoomWithDict:(NSDictionary *)dict
               completion:(void(^)(NSInteger errorCode, NSDictionary * _Nullable data))completion {
#ifdef ZEGO_ENVIROMENT_FLAG
    NSString *domain = [ZegoEnviromentManager getOutRoomServiceDomain];
#else
    NSString *domain = kInternalOutRoomServiceDomain;
#endif
    [self postToURL:[NSString stringWithFormat:@"%@%@", domain, kQueryRoomPath] param:dict completion:completion];
}

#pragma mark - Private
+ (void)postToURL:(NSString *)url
            param:(NSDictionary *)param
       completion:(void(^)(NSInteger errorCode, NSDictionary * _Nullable result))completion {
    NSLog(@"\n----------------------------------\noutRoomService, postToURL: %@\nparam: %@\n----------------------------------", url, param);
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    [securityPolicy setValidatesDomainName:NO];
    securityPolicy.allowInvalidCertificates = YES; //还是必须设成YES
    manager.securityPolicy = securityPolicy;

    [manager POST:url
       parameters:param
          headers:nil
         progress:nil
          success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"\n----------------------------------\npost succeed, url: %@, response: %@\n----------------------------------", url, responseObject);
        NSDictionary *dataJson = nil;
        NSDictionary *retJson = nil;
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            dataJson = responseObject[@"data"];
            retJson = responseObject[@"ret"];
        }
        if([url isEqualToString:@"https://roomkit-edu-api.zego.im/room/create"]){
            //创建直播间
            NSLog(@"room_id = %@,room_id==%@",responseObject[@"data"][@"begin_timestamp"],responseObject[@"data"][@"room_id"]);
        }
        completion([retJson[@"code"] integerValue], dataJson);
        }
          failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"----------------------------------\npost fail, url: %@, error: %@\n----------------------------------", url, error);
        completion(error.code, nil);
    }];
}


@end
