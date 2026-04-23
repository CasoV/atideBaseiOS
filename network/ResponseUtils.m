//
//  ResponseUtils.m
//  YNXYJTXXPT
//
//  Created by 末末班车 on 2017/6/28.
//  Copyright © 2017年 末末班车. All rights reserved.
//

#import "ResponseUtils.h"

static NSDictionary *responseData;

@implementation ResponseUtils

+ (BOOL)success:(NSData *)data {
    NSError *error;
    id result = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
    if ([result isKindOfClass:[NSDictionary class]]) {
        responseData = (NSDictionary *)result;
        if ([[responseData[@"succeed"] stringValue] isEqualToString:@"1"] || [[responseData[@"success"] stringValue] isEqualToString:@"1"]) {
            return YES;
        }
    }
    return NO;
}

+ (NSString *)getMsg {
    NSString *msg = responseData[@"msg"];
    if (msg != nil) {
        return msg;
    }
    return @"服务器错误";
}

+ (id)getData:(NSString *)key {
    id data = responseData[key];
    if (data != nil) {
        return data;
    }
    return [[NSNull alloc] init];
}

@end
