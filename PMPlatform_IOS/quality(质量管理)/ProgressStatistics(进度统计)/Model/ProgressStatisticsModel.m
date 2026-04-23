//
//  ProgressStatisticsModel.m
//  HBConstructionApp
//
//  Created by 末末班车 on 2018/4/13.
//  Copyright © 2018年 atide. All rights reserved.
//

#import "ProgressStatisticsModel.h"

@implementation ProgressStatisticsModel

- (NSString *)ratio {
    if (self.percent) {
        return self.percent;
    }
    
    CGFloat result;
    result = (CGFloat)(self.total - self.unstart) / self.total;
    
    return [NSString stringWithFormat:@"%.02f%%", isnan(result) ? 0 : result * 100];
}

@end
