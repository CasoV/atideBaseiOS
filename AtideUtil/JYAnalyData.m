//
//  JYAnalyData.m
//  TrafficMs
//
//  Created by apple on 2015/11/04.
//  Copyright © 2015年 com. All rights reserved.
//

#import "JYAnalyData.h"

@implementation JYAnalyData


+ (NSDictionary *)objectClassInArray{
    return @{@"monthData" : [Monthdata class], @"gatherData" : [Gatherdata class], @"sessionData" : [Sessiondata class]};
}


@end


@implementation Monthdata

- (void)setData:(NSDictionary *)nsd{
    
    self.ID = [nsd objectForKey:@"id"];
    self.parentId = [nsd objectForKey:@"parentId"];
    self.sectName = [nsd objectForKey:@"sectName"];
    self.name = [nsd objectForKey:@"name"];
    self.value1 = [nsd objectForKey:@"value1"];
    self.value2 = [nsd objectForKey:@"value2"];
    self.value3 = [nsd objectForKey:@"value3"];
}

@end


@implementation Gatherdata

- (void)setData:(NSDictionary *)nsd{
    self.mCode = [nsd objectForKey:@"mCode"];
    self.mJl = [nsd objectForKey:@"mJl"];
    self.mHt = [nsd objectForKey:@"mHt"];
    self.mName = [nsd objectForKey:@"mName"];
    self.mJlPercent = [nsd objectForKey:@"mJlPercent"];
}

@end


@implementation Sessiondata

- (void)setData:(NSDictionary *)nsd{
    
    self.ID = [nsd objectForKey:@"id"];
    self.parentId = [nsd objectForKey:@"parentId"];
    self.sectName = [nsd objectForKey:@"sectName"];
    self.name = [nsd objectForKey:@"name"];
    self.value1 = [nsd objectForKey:@"value1"];
    self.value2 = [nsd objectForKey:@"value2"];
    self.value3 = [nsd objectForKey:@"value3"];
}

@end



