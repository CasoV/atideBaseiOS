//
//  SysConfig.m
//  PMPlatform_IOS
//
//  Created by vxg on 2017/09/06.
//  Copyright © 2017年 com.atide. All rights reserved.
//

#import "SysConfig.h"
static SysConfig *instance = nil;
@implementation SysConfig
+ (SysConfig *)getInstance{
    @synchronized (self) {
        if (!instance) {
            [[self alloc] init];
        }
    }
    return instance;
}
+ (id)allocWithZone:(struct _NSZone *)zone{
    @synchronized (self) {
        if (!instance) {
            instance = [super allocWithZone:zone];
            return instance;
        }
    }
    return nil;
}
- (id)copy{
    return self;
}
@end
