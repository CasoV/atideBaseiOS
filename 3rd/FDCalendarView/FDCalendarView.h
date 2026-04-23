//
//  FDCalendarView.h
//  CalendarViewTest
//
//  Created by 末末班车 on 2017/8/3.
//  Copyright © 2017年 末末班车. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FDCalendarView : UIView

//用户选择日期后的操作.
@property(nonatomic,copy) void(^block)(NSDate*date);

- (instancetype)initWithFrame:(CGRect)frame andCurrentDateStr:(NSString *)currentDateStr minimumDate:(NSDate *)minimumDate datePickerMode:(UIDatePickerMode)mode;

/**
 控件出现
 */
- (void)fadeIn;
/**
 控件显示
 */
- (void)fadeOut;

@end
