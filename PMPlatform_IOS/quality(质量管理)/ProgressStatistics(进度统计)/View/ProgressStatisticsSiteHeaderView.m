//
//  ProgressStatisticsSiteHeaderView.m
//  HBConstructionApp
//
//  Created by 末末班车 on 2018/4/13.
//  Copyright © 2018年 atide. All rights reserved.
//

#import "ProgressStatisticsSiteHeaderView.h"

@implementation ProgressStatisticsSiteHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        
        UILabel *titleLabel1 = [[self class] titleLabel];
        [titleLabel1 setText:@"工程划分\n名称"];
        [self addSubview:titleLabel1];
        UIView *lineView1 = [UIView lineViewWithPointYY:0 andColor:UIColorFromRGB(0xD8D8D8)];
        [titleLabel1 addSubview:lineView1];
        
        UILabel *titleLabel2 = [[self class] titleLabel];
        [titleLabel2 setText:@"类型"];
        [self addSubview:titleLabel2];
        UIView *lineView2 = [UIView lineViewWithPointYY:0 andColor:UIColorFromRGB(0xD8D8D8)];
        [titleLabel2 addSubview:lineView2];
        
        UILabel *titleLabel3 = [[self class] titleLabel];
        [titleLabel3 setText:@"开始时间"];
        [self addSubview:titleLabel3];
        UIView *lineView3 = [UIView lineViewWithPointYY:0 andColor:UIColorFromRGB(0xD8D8D8)];
        [titleLabel3 addSubview:lineView3];
        
        UILabel *titleLabel4 = [[self class] titleLabel];
        [titleLabel4 setText:@"完成时间"];
        [self addSubview:titleLabel4];
        UIView *lineView4 = [UIView lineViewWithPointYY:0 andColor:UIColorFromRGB(0xD8D8D8)];
        [titleLabel4 addSubview:lineView4];
        
        UILabel *titleLabel5 = [[self class] titleLabel];
        [titleLabel5 setText:@"完成状态"];
        [self addSubview:titleLabel5];
        
        UIView *lineTopView = [UIView lineViewWithPointYY:0 andColor:UIColorFromRGB(0xD8D8D8)];
        [self addSubview:lineTopView];
        
        UIView *lineBottomView = [UIView lineViewWithPointYY:0 andColor:UIColorFromRGB(0xD8D8D8)];
        [self addSubview:lineBottomView];
        
        CGFloat width = frame.size.width / 5;
        
        [lineTopView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self);
            make.width.equalTo(self);
            make.top.equalTo(self);
            make.height.equalTo(@0.5);
        }];
        
        [titleLabel1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self);
            make.width.equalTo(@(width));
            make.top.equalTo(self);
            make.bottom.equalTo(self);
        }];
        
        [lineView1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(titleLabel1.mas_right).offset(-1);
            make.width.equalTo(@(0.5));
            make.top.equalTo(titleLabel1);
            make.bottom.equalTo(titleLabel1);
        }];
        
        [titleLabel2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(titleLabel1.mas_right);
            make.width.equalTo(@(width));
            make.top.equalTo(self);
            make.bottom.equalTo(self);
        }];
        
        [lineView2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(titleLabel2.mas_right).offset(-1);
            make.width.equalTo(@(0.5));
            make.top.equalTo(titleLabel2);
            make.bottom.equalTo(titleLabel2);
        }];
        
        [titleLabel3 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(titleLabel2.mas_right);
            make.width.equalTo(@(width));
            make.top.equalTo(self);
            make.bottom.equalTo(self);
        }];
        
        [lineView3 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(titleLabel3.mas_right).offset(-1);
            make.width.equalTo(@(0.5));
            make.top.equalTo(titleLabel3);
            make.bottom.equalTo(titleLabel3);
        }];
        
        [titleLabel4 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(titleLabel3.mas_right);
            make.width.equalTo(@(width));
            make.top.equalTo(self);
            make.bottom.equalTo(self);
        }];
        
        [lineView4 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(titleLabel4.mas_right).offset(-1);
            make.width.equalTo(@(0.5));
            make.top.equalTo(titleLabel4);
            make.bottom.equalTo(titleLabel4);
        }];
        
        [titleLabel5 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(titleLabel4.mas_right);
            make.width.equalTo(@(width));
            make.top.equalTo(self);
            make.bottom.equalTo(self);
        }];
        
        [lineBottomView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self);
            make.width.equalTo(self);
            make.bottom.equalTo(self);
            make.height.equalTo(@0.5);
        }];
    }
    return self;
}

+ (UILabel *)titleLabel{
    UILabel *label = [[UILabel alloc] init];
    
    [label setFont:[UIFont systemFontOfSize:12]];
    [label setTextColor:UIColorFromRGB(0x555555)];
    [label setTextAlignment:(NSTextAlignmentCenter)];
    label.numberOfLines = 2;
    
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width / 5, 40)];
    bgView.backgroundColor = UIColorFromRGB(0xf3faff);
    [label addSubview:bgView];
    
    return label;
}

@end
