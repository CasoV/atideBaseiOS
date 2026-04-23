//
//  FDTimePickerView.m
//  AtideOA
//
//  Created by 末末班车 on 2017/8/8.
//  Copyright © 2017年 com.atidesoft. All rights reserved.
//

#import "FDTimePickerView.h"

#define ScreenWidth [UIScreen mainScreen].bounds.size.width
#define ScreenHeight [UIScreen mainScreen].bounds.size.height
#define RGBA(r, g, b, a) ([UIColor colorWithRed:(r / 255.0) green:(g / 255.0) blue:(b / 255.0) alpha:a])

@implementation FDTimePickerView {
    UIDatePicker *_pickerView;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    self.backgroundColor = [UIColor whiteColor];
    
    CGFloat btnWidth = 100;
    CGFloat btnHeigt = 40;
    
    UIButton *canelBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    canelBtn.frame = CGRectMake(0, 0, btnWidth, btnHeigt);
    [canelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [canelBtn setTintColor:[UIColor grayColor]];
    [canelBtn addTarget:self action:@selector(cancelButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:canelBtn];
    
    UIButton *okBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    okBtn.frame = CGRectMake(ScreenWidth - btnWidth, 0, btnWidth, btnHeigt);
    [okBtn setTitle:@"确定" forState:UIControlStateNormal];
    [okBtn setTintColor:RGBA(210, 55, 61, 1.0)];
    [okBtn addTarget:self action:@selector(okButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:okBtn];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, btnHeigt - 1, [UIScreen mainScreen].bounds.size.width, 1)];
    line.backgroundColor = [UIColor colorWithRed:214 / 255.0 green:214 / 255.0 blue:214 / 255.0 alpha:1];
    [self addSubview:line];
    
    _pickerView = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 30, ScreenWidth, 193)];
    _pickerView.datePickerMode = UIDatePickerModeTime;
    _pickerView.date = [NSDate date];
    [self addSubview:_pickerView];
}

- (void)cancelButtonClicked {
    [self dismiss];
}

- (void)okButtonClicked {
    [self dismiss];
    if (self.timeBlock) {
        self.timeBlock(_pickerView.date);
    }
}

- (void)showDateInPicker:(NSDate *)date {
    [_pickerView setDate:date animated:YES];
}

- (void)dismiss {
    [UIView animateWithDuration:0.25 animations:^{
        self.frame = CGRectMake(0, ScreenHeight, ScreenWidth, 233);
    }];
}

@end
