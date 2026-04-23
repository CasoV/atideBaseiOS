//
//  Panel.m
//  PMPlatform_IOS
//
//  Created by 末末班车 on 2017/9/12.
//  Copyright © 2017年 com.atide. All rights reserved.
//

#import "Panel.h"

@implementation Panel

- (instancetype)init:(NSString *)ID text:(NSString *)text icon:(NSString *)icon {
    if (self = [super init]) {
        _ID = ID;
        _content = text;
        _iconName = icon;
    }
    return self;
}

@end
