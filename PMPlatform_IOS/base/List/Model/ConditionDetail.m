//
//  ConditionDetail.m
//  ycxm
//
//  Created by 末末班车 on 2018/9/28.
//  Copyright © 2018年 末末班车. All rights reserved.
//

#import "ConditionDetail.h"

@implementation ConditionDetail

+ (ConditionDetail *)detailWith:(NSString *)ID text:(NSString *)text {
    ConditionDetail *detail = [[ConditionDetail alloc] init];
    detail.ID = ID;
    detail.text = text;
    return detail;
}

@end
