//
//  WHUCalendarView.h
//  TEST_Calendar
//
//  Created by SuperNova(QQ:422596694) on 15/11/5.
//  Copyright (c) 2015年 SuperNova(QQ:422596694). All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WHUCalendarView : UIView
//用户选择的日期.
@property(nonatomic,strong,readonly)  NSDate* selectedDate;
//用户选择日期后的操作.
@property(nonatomic,copy) void(^onDateSelectBlk)(NSDate*);
//当前日历的显示月份,默认显示为当前月份的日历.
@property(nonatomic,strong) NSDate* currentDate;

//判断当前是否有选中日期
- (BOOL)isSelected;

@end
