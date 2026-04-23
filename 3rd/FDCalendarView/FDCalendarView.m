//
//  FDCalendarView.m
//  CalendarViewTest
//
//  Created by 末末班车 on 2017/8/3.
//  Copyright © 2017年 末末班车. All rights reserved.
//

#import "FDCalendarView.h"
#import "WHUCalendarView.h"
#import "FDTimePickerView.h"
#import "MBManager.h"

#define ScreenWidth [UIScreen mainScreen].bounds.size.width
#define ScreenHeight [UIScreen mainScreen].bounds.size.height
#define RGBA(r, g, b, a) ([UIColor colorWithRed:(r / 255.0) green:(g / 255.0) blue:(b / 255.0) alpha:a])
#define Width 300
#define Height 305

@interface FDCalendarView()

/**
 容器view
 */
@property(nonatomic,strong)UIView *contentView;
@property(nonatomic,strong)UIView *dateView;

/**
 时间选择按钮
 */
@property(nonatomic,strong)UIButton *cancelButton;
@property(nonatomic,strong)UIButton *okButton;
@property(nonatomic,strong)UIButton *timeButton;
/**
 日历控件
 */
@property(nonatomic,strong)WHUCalendarView *calendarView;
/**
 时间选择器
 */
@property(nonatomic,strong)FDTimePickerView *timePickerView;

//当前日历的显示月份,默认显示为当前月份的日历.
@property(nonatomic,copy) NSString* currentDateStr;

@end

@implementation FDCalendarView {
    NSDate *_selectDate;
    NSDate *_minimumDate;
    UIDatePickerMode _mode;
}

- (instancetype)initWithFrame:(CGRect)frame andCurrentDateStr:(NSString *)currentDateStr minimumDate:(NSDate *)minimumDate datePickerMode:(UIDatePickerMode)mode{
    self=[super initWithFrame:frame];
    if (self) {
        _currentDateStr = currentDateStr;
        _minimumDate = minimumDate;
        _mode = mode;
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    self.contentView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    self.contentView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
    [self addSubview:self.contentView];
    
    CGFloat extraHeight = 0;
    if (_mode == UIDatePickerModeDateAndTime) {
        extraHeight = 30;
    }
    
    self.dateView = [[UIView alloc] initWithFrame:CGRectMake((ScreenWidth - Width) / 2, (ScreenHeight - Height - 25 - extraHeight) / 2, Width, Height + 25 + extraHeight)];
    self.dateView.backgroundColor=[UIColor colorWithRed:0.93 green:0.92 blue:0.95 alpha:1];
    [self.contentView addSubview:self.dateView];
    
    self.calendarView = [[WHUCalendarView alloc] initWithFrame:CGRectMake(0, 0, Width, Height)];
    if (_currentDateStr) {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.locale = [NSLocale currentLocale];
        formatter.timeZone = [NSTimeZone localTimeZone];
        if (_mode == UIDatePickerModeDateAndTime) {
            formatter.dateFormat = @"yyyy-MM-dd HH:mm";
        } else {
            formatter.dateFormat = @"yyyy-MM-dd";
        }
        
        self.calendarView.currentDate = [formatter dateFromString:_currentDateStr];
    }
    self.calendarView.onDateSelectBlk = ^(NSDate *date) {
        _selectDate = date;
    };
    [self.dateView addSubview:self.calendarView];
    
    self.cancelButton=[UIButton buttonWithType:UIButtonTypeSystem];
    [self.cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    [self.cancelButton setTintColor:[UIColor grayColor]];
    self.cancelButton.titleLabel.font=[UIFont systemFontOfSize:14];
    self.cancelButton.frame=CGRectMake(0, Height - 5 + extraHeight, Width / 2, 30);
    self.cancelButton.tag = 100;
    [self.cancelButton addTarget:self action:@selector(selectButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.dateView addSubview:self.cancelButton];
    
    
    self.okButton=[UIButton buttonWithType:UIButtonTypeSystem];
    [self.okButton setTitle:@"确定" forState:UIControlStateNormal];
    [self.okButton setTintColor:RGBA(210, 55, 61, 1.0)];
    self.okButton.titleLabel.font=[UIFont systemFontOfSize:14];
    self.okButton.frame=CGRectMake(Width / 2, Height - 5 + extraHeight, Width / 2, 30);
    [self.dateView addSubview:self.okButton];
    self.okButton.tag = 101;
    [self.okButton addTarget:self action:@selector(selectButton:) forControlEvents:UIControlEventTouchUpInside];
    
    if (_mode == UIDatePickerModeDateAndTime) {
        self.timeButton=[UIButton buttonWithType:UIButtonTypeSystem];
        self.timeButton.titleLabel.font=[UIFont systemFontOfSize:14];
        self.timeButton.frame=CGRectMake(0, Height - 5, Width, 30);
        [self.timeButton setTintColor:[UIColor blackColor]];
        [self.dateView addSubview:self.timeButton];
        [self.timeButton addTarget:self action:@selector(timeButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        
        NSString *btnTitle;

        if (_currentDateStr) {
            btnTitle = [_currentDateStr substringFromIndex:11];
        } else {
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            formatter.locale = [NSLocale currentLocale];
            formatter.timeZone = [NSTimeZone localTimeZone];
            formatter.dateFormat = @"HH:mm";
            btnTitle = [formatter stringFromDate:[NSDate date]];
            
            formatter.dateFormat = @"yyyy-MM-dd";
            _currentDateStr = [formatter stringFromDate:[NSDate date]];
        }
        [self.timeButton setTitle:btnTitle forState:UIControlStateNormal];
    }
}

- (void)fadeIn{
    self.alpha = 0;
    [UIView animateWithDuration:.35 animations:^{
        self.alpha = 1;
    }];
    
}
- (void)fadeOut{
    [UIView animateWithDuration:.35 animations:^{
        self.alpha = 0.0;
    }completion:^(BOOL finished) {
        if (finished){
            [self removeFromSuperview];
        }
    }];
}

-(void)selectButton:(UIButton *)sender{
    if (sender.tag == 101) {
        if (_selectDate && [self.calendarView isSelected]) {
            NSDate *finalDate;
            if (_mode == UIDatePickerModeDateAndTime) {
                NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                formatter.locale = [NSLocale currentLocale];
                formatter.timeZone = [NSTimeZone localTimeZone];
                formatter.dateFormat = @"yyyy-MM-dd";
                NSString *selectDate = [formatter stringFromDate:_selectDate];
                
                formatter.dateFormat = @"yyyy-MM-dd HH:mm";
                finalDate = [formatter dateFromString:[NSString stringWithFormat:@"%@ %@", selectDate, self.timeButton.currentTitle]];
            } else {
                finalDate = _selectDate;
            }
            
            if (_minimumDate) {
                if ([finalDate timeIntervalSinceDate:_minimumDate] < 0) {
                    [MBManager showBriefAlert:@"选择时间不得早于开始时间"];
                    return;
                }
            }
            self.block(finalDate);
        }
    }
    [self fadeOut];
}

- (void)timeButtonClicked {
    if (!_timePickerView) {
        __weak typeof(self) weakself = self;
        _timePickerView = [[FDTimePickerView alloc] initWithFrame:CGRectMake(0, ScreenHeight, ScreenWidth, 233)];
        _timePickerView.timeBlock = ^(NSDate *date) {
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            formatter.locale = [NSLocale currentLocale];
            formatter.timeZone = [NSTimeZone localTimeZone];
            formatter.dateFormat = @"HH:mm";
            [weakself.timeButton setTitle:[formatter stringFromDate:date] forState:UIControlStateNormal];
        };
        [self.contentView addSubview:_timePickerView];
    }
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.locale = [NSLocale currentLocale];
    formatter.timeZone = [NSTimeZone localTimeZone];
    formatter.dateFormat = @"yyyy-MM-dd HH:mm";
    [_timePickerView showDateInPicker:[formatter dateFromString:[NSString stringWithFormat:@"%@ %@", [_currentDateStr substringToIndex:10], self.timeButton.currentTitle]]];
    [UIView animateWithDuration:0.25 animations:^{
        _timePickerView.frame = CGRectMake(0, ScreenHeight - 233, ScreenWidth, 233);
    }];
}

@end
