//
//  ProjectInvestFormat.h
//  PMPlatform_IOS
//
//  Created by vxg on 2017/09/06.
//  Copyright © 2017年 com.atide. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Charts/Charts-Swift.h>

@interface ProjectInvestFormat : NSObject<IChartAxisValueFormatter>
- (instancetype)initWith:(NSArray *)values;
@end
