//
//  BarChartsHelper.h
//  PMPlatform_IOS
//
//  Created by vxg on 2017/09/06.
//  Copyright © 2017年 com.atide. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Charts/Charts-Swift.h>
#import "ProjectInvestFormat.h"

@interface BarChartsHelper : NSObject
+ (void)setupBarLineChartView:(HorizontalBarChartView *)chartView;
+ (void)initCharts:(HorizontalBarChartView *)_chartView xValue:(NSArray *)xValue yValue:(NSArray *)yValue divison:(double)divison color:(UIColor *)color;
@end
