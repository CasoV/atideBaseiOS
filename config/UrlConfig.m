//
//  UrlConfig.m
//  YNXYJTXXPT
//
//  Created by 末末班车 on 2017/6/26.
//  Copyright © 2017年 末末班车. All rights reserved.
//

#import "UrlConfig.h"

@implementation UrlConfig
    
+ (NSString *)URL:(NSString *)url {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *protocol = [userDefaults objectForKey:@"protocol"];
    NSString *ip = [userDefaults objectForKey:@"ip"];
    NSString *port = [userDefaults objectForKey:@"port"];
    NSString *temp = @":";
    if ([port isEqualToString:@""]) {
        temp = @"";
    }
    return [NSString stringWithFormat:@"%@://%@%@%@%@", protocol, ip, temp, port, url];
}

+ (NSString *)login {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *protocol = [userDefaults objectForKey:@"protocol"];
    NSString *ip = [userDefaults objectForKey:@"ip"];
    NSString *port = [userDefaults objectForKey:@"port"];
    NSString *temp = @":";
    if ([port isEqualToString:@""]) {
        temp = @"";
    }
    return [NSString stringWithFormat:@"%@://%@%@%@%@", protocol, ip, temp, port, loginUrl];
}

+ (NSString *)showImg {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *protocol = [userDefaults objectForKey:@"protocol"];
    NSString *ip = [userDefaults objectForKey:@"ip"];
    NSString *port = [userDefaults objectForKey:@"port"];
    NSString *temp = @":";
    if ([port isEqualToString:@""]) {
        temp = @"";
    }
    return [NSString stringWithFormat:@"%@://%@%@%@%@", protocol, ip, temp, port, getImg];
}

+ (NSString *)MeteringURL:(NSString *)url {
    
    return [NSString stringWithFormat:@"http://220.165.247.79:8090%@", url];
//    return [UrlConfig URL:url];
}

+ (NSString *)MeteringLogin {
    return @"http://220.165.247.90:8080/tcmsQuery/compPayBizService/login";
}

@end
