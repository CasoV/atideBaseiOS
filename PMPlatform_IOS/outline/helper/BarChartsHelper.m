//
//  BarChartsHelper.m
//  PMPlatform_IOS
//
//  Created by vxg on 2017/09/06.
//  Copyright © 2017年 com.atide. All rights reserved.
//

#import "BarChartsHelper.h"

@implementation BarChartsHelper
+ (void)setupBarLineChartView:(HorizontalBarChartView *)chartView
{
    chartView.chartDescription.enabled = NO;
    chartView.noDataText = @"暂无数据";
    chartView.drawGridBackgroundEnabled = NO;
    
    chartView.dragEnabled = YES;
    [chartView setScaleEnabled:YES];
    chartView.pinchZoomEnabled = YES;
    
    // ChartYAxis *leftAxis = chartView.leftAxis;
    
    ChartXAxis *xAxis = chartView.xAxis;
    xAxis.labelPosition = XAxisLabelPositionBottom;
    
    chartView.rightAxis.enabled = NO;
}
+ (void)initCharts:(HorizontalBarChartView *)_chartView xValue:(NSArray *)xValue yValue:(NSArray *)yValue divison:(double)divison color:(UIColor *)color{
    //_chartView.delegate = self;
    
    _chartView.drawBarShadowEnabled = NO;
    _chartView.drawValueAboveBarEnabled = YES;
    
    _chartView.maxVisibleCount = 60;
    
    ChartXAxis *xAxis = _chartView.xAxis;
    xAxis.labelPosition = XAxisLabelPositionBottom;
    xAxis.labelFont = [UIFont systemFontOfSize:10.f];
    xAxis.drawAxisLineEnabled = YES;
    xAxis.drawGridLinesEnabled = NO;
    xAxis.granularity = 10.0f;
    xAxis.valueFormatter = [[ProjectInvestFormat alloc] initWith:yValue];
    
    ChartYAxis *leftAxis = _chartView.leftAxis;
    leftAxis.labelFont = [UIFont systemFontOfSize:10.f];
    leftAxis.drawAxisLineEnabled = YES;
    leftAxis.drawGridLinesEnabled = YES;
    leftAxis.drawLabelsEnabled = YES;
    leftAxis.enabled = YES;
    leftAxis.granularity = 10.0f;
    leftAxis.labelPosition = YAxisLabelPositionOutsideChart;
    leftAxis.axisMinimum = 0.0; // this replaces startAtZero = YES
    
    ChartLegend *l = _chartView.legend;
    l.horizontalAlignment = ChartLegendHorizontalAlignmentLeft;
    l.verticalAlignment = ChartLegendVerticalAlignmentTop;
    l.orientation = ChartLegendOrientationHorizontal;
    l.drawInside = NO;
    l.form = ChartLegendFormSquare;
    l.formSize = 8.0;
    l.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:11.f];
    l.xEntrySpace = 4.0;
    
    _chartView.fitBars = YES;
    [self setDataCount:_chartView xValue:xValue divison:divison color:color];
    [_chartView animateWithYAxisDuration:1];
}
+ (void)setDataCount:(HorizontalBarChartView *)_chartView  xValue:(NSArray *)xValue divison:(double)divison color:(UIColor *)color
{
    double barWidth = 9.0;
    double spaceForBar = 10.0;
    
    NSMutableArray *yVals = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < xValue.count; i++)
    {
        double val = [xValue[i] doubleValue] / divison;
        [yVals addObject:[[BarChartDataEntry alloc] initWithX:i*spaceForBar y:val icon: [UIImage imageNamed:@"icon"]]];
    }
    
    BarChartDataSet *set1 = nil;
    if (_chartView.data.dataSetCount > 0)
    {
        set1 = (BarChartDataSet *)_chartView.data.dataSets[0];
//        set1.entries = yVals;
        [_chartView.data notifyDataChanged];
        [_chartView notifyDataSetChanged];
    }
    else
    {
        set1 = [[BarChartDataSet alloc] initWithEntries:yVals label:@"(万元)"];
        
        set1.drawIconsEnabled = YES;
        // 显示坐标点的数据
        [set1 setDrawValuesEnabled:YES];
        // 显示定位线
        [set1 setHighlightEnabled:YES];
        if (color == nil) {
           [set1 setColor:[UIColor hex:@"d5bfab"]]; 
        }else{
            [set1 setColor:color];
        }
        
        NSMutableArray *dataSets = [[NSMutableArray alloc] init];
        [dataSets addObject:set1];
        
        BarChartData *data = [[BarChartData alloc] initWithDataSets:dataSets];
        
        [data setValueFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:10.f]];
    
        data.barWidth = barWidth;
        
        _chartView.data = data;
    }
}
@end
