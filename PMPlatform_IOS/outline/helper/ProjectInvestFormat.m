//
//  ProjectInvestFormat.m
//  PMPlatform_IOS
//
//  Created by vxg on 2017/09/06.
//  Copyright © 2017年 com.atide. All rights reserved.
//

#import "ProjectInvestFormat.h"
@interface ProjectInvestFormat (){
    NSArray *yValues;
}
@end
@implementation ProjectInvestFormat
- (instancetype)initWith:(NSArray *)values{
    yValues = [values copy];
    return self;
}

- (NSString * _Nonnull)stringForValue:(double)value axis:(ChartAxisBase * _Nullable)axis
{
    
    int index = (int)(value/10) % (int)yValues.count;

    return yValues[index];
}
@end
