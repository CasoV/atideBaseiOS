//
//  UUBarChart.m
//  UUChartDemo
//
//  Created by shake on 14-7-24.
//  Copyright (c) 2014年 uyiuyao. All rights reserved.
//

#import "UUBarChart.h"
#import "UUChartLabel.h"
#import "UUBar.h"

@interface UUBarChart ()
{
    UIScrollView *myScrollView;
    NSInteger barNum;
    float barWidth;
}
@end

@implementation UUBarChart
@synthesize yBarLableWidth;
@synthesize itemSepWidth;

#pragma mark sep表示左侧label的宽度
-(id)initWithFrameAndSep:(CGRect)frame barLableSep:(CGFloat)width{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.clipsToBounds = YES;
        myScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(width, 0, frame.size.width-width, frame.size.height)];
        [myScrollView setShowsVerticalScrollIndicator:NO];
        [myScrollView setShowsHorizontalScrollIndicator:NO];
        [self addSubview:myScrollView];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.clipsToBounds = YES;
        myScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(60, 0, frame.size.width-yBarLableWidth, frame.size.height)];
        [myScrollView setShowsVerticalScrollIndicator:NO];
        [myScrollView setShowsHorizontalScrollIndicator:NO];
        [self addSubview:myScrollView];
    }
    return self;
}

-(void)setYValues:(NSArray *)yValues
{
    _yValues = yValues;
    [self setYLabels:yValues];
}

-(void)setYLabels:(NSArray *)yLabels
{
    NSInteger max = 0;
    NSInteger min = 1000000000;
    for (NSArray * ary in yLabels) {
        for (NSString *valueString in ary) {
            NSInteger value = [valueString integerValue];
            if (value > max) {
                max = value;
            }
            if (value < min) {
                min = value;
            }
        }
    }
    if (max < 5) {
        max = 5;
    }
    if (self.showRange) {
        _yValueMin = (int)min;
    }else{
        _yValueMin = 0;
    }
    _yValueMax = (int)max;
    
    if (_chooseRange.max!=_chooseRange.min) {
        _yValueMax = _chooseRange.max;
        _yValueMin = _chooseRange.min;
    }
    
    if (_yValueMax == _yValueMin) {
        return;
    }

    float level = (_yValueMax-_yValueMin) /10.0;
    level = [self calcLevel:level];
    CGFloat chartCavanHeight = self.frame.size.height - UULabelHeight*3;
    CGFloat levelHeight = chartCavanHeight /10.0;
    
    for (int i=0; i<11; i++) {
        UUChartLabel * label = [[UUChartLabel alloc] initWithFrame:CGRectMake(0.0,chartCavanHeight-i*levelHeight+5, yBarLableWidth, UULabelHeight)];

        label.font = [label.font fontWithSize:8.0f];
        if (0 == i) {
            label.text = [NSString stringWithFormat:@"%.0f",level * i+_yValueMin];
        }else{
            label.text = [NSString stringWithFormat:@"%.0f",level * i+_yValueMin];
        }
		
		[self addSubview:label];
    }
	
}

-(void)setXLabels:(NSArray *)xLabels
{
    _xLabels = xLabels;
    NSInteger num;
    if (xLabels.count>=8) {
        num = 8;
    }else if (xLabels.count<=4){
        num = 4;
    }else{
        num = xLabels.count;
    }
//    _xLabelWidth = myScrollView.frame.size.width/num;
    _xLabelWidth = barWidth;
    
    for (int i=0; i<xLabels.count; i++) {
        CGRect labelRect = CGRectMake((i *  _xLabelWidth ), self.frame.size.height - UULabelHeight, _xLabelWidth, UULabelHeight);
        UUChartLabel * label = [[UUChartLabel alloc] initWithFrame:labelRect];
        label.text = xLabels[i];
        [myScrollView addSubview:label];
    }
    
    float max = (([xLabels count]-1)*_xLabelWidth + chartMargin)+_xLabelWidth;
    if (myScrollView.frame.size.width < max-10) {
        myScrollView.contentSize = CGSizeMake(max, self.frame.size.height);
    }
}
-(void)setColors:(NSArray *)colors
{
	_colors = colors;
}
- (void)setChooseRange:(CGRange)chooseRange
{
    _chooseRange = chooseRange;
}

-(void)strokeChart
{
    
    CGFloat chartCavanHeight = self.frame.size.height - UULabelHeight*3;
	
    for (int i=0; i<_yValues.count; i++) {
        if (i==_yValues.count)
            return;
        NSArray *childAry = _yValues[i];
        for (int j=0; j<childAry.count; j++) {
            NSString *valueString = childAry[j];
            float value = [valueString floatValue];
            float grade = ((float)value-_yValueMin) / ((float)_yValueMax-_yValueMin);
            float width = UUYBarWidth;
            CGRect rect = CGRectMake(j*(_xLabelWidth)+(i+1)*UUYSeparatorWidth+i*width, UULabelHeight, width, chartCavanHeight);
            UUBar * bar = [[UUBar alloc] initWithFrame:rect];
            bar.barColor = [_colors objectAtIndex:i];
            bar.grade = grade;
            [myScrollView addSubview:bar];
            
        }
    }
}


-(void)setBarNum:(NSInteger)num
{
    barNum = num ;
    barWidth = (int)barNum * (UUYBarWidth+UUYSeparatorWidth+itemSepWidth);
}

-(float)calcLevel:(float)level
{
    NSString *strLevel = [NSString stringWithFormat:@"%.0f",level];
    int lenth = (int)[strLevel length];
    NSString *zero = @"1";
    for (int k=0; k<lenth-1; k++) {
        zero = [zero stringByAppendingString:@"0"];
    }
    int uint = [zero intValue];
    int iff = (level / uint);
    iff = iff * uint ;
    return iff;
}

@end
