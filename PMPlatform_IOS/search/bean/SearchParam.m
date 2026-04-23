//
//  SearchParam.m
//  PMPlatform_IOS
//
//  Created by 末末班车 on 2017/9/6.
//  Copyright © 2017年 com.atide. All rights reserved.
//

#import "SearchParam.h"

@implementation SearchParam

- (NSString *)orderKey {
    return @"jsonOrderBies";
}

- (NSString *)orderFormat {
    return @"[{\"name\":\"createTime\",\"type\":\"%@\",\"orderNo\":\"0\"}]";
}

@end
