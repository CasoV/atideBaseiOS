//
//  ProgressStatisticsSiteCell.m
//  HBConstructionApp
//
//  Created by 末末班车 on 2018/4/13.
//  Copyright © 2018年 atide. All rights reserved.
//

#import "ProgressStatisticsSiteCell.h"
#import "ProgressStatisticsModel.h"

@interface ProgressStatisticsSiteCell ()

@property (nonatomic, strong) UILabel *titleLabel1;
@property (nonatomic, strong) UILabel *titleLabel2;
@property (nonatomic, strong) UILabel *titleLabel3;
@property (nonatomic, strong) UILabel *titleLabel4;
@property (nonatomic, strong) UILabel *titleLabel5;

@end


@implementation ProgressStatisticsSiteCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = [UIColor whiteColor];
        
        self.titleLabel1 = [[self class] titleLabel];
        [self addSubview:self.titleLabel1];
        
        UIView *lineView1 = [UIView lineViewWithPointYY:0 andColor:UIColorFromRGB(0xD8D8D8)];
        [self.titleLabel1 addSubview:lineView1];
        
        self.titleLabel2 = [[self class] titleLabel];
        [self addSubview:self.titleLabel2];
        UIView *lineView2 = [UIView lineViewWithPointYY:0 andColor:UIColorFromRGB(0xD8D8D8)];
        [self.titleLabel2 addSubview:lineView2];
        
        self.titleLabel3 = [[self class] titleLabel];
        [self addSubview:self.titleLabel3];
        UIView *lineView3 = [UIView lineViewWithPointYY:0 andColor:UIColorFromRGB(0xD8D8D8)];
        [self.titleLabel3 addSubview:lineView3];
        
        self.titleLabel4 = [[self class] titleLabel];
        [self addSubview:self.titleLabel4];
        UIView *lineView4 = [UIView lineViewWithPointYY:0 andColor:UIColorFromRGB(0xD8D8D8)];
        [self.titleLabel4 addSubview:lineView4];
        
        self.titleLabel5 = [[self class] titleLabel];
        [self addSubview:self.titleLabel5];
        
        UIView *lineBottomView = [UIView lineViewWithPointYY:0 andColor:UIColorFromRGB(0xD8D8D8)];
        [self addSubview:lineBottomView];
        
        CGFloat width = kScreen_Width / 5;
        [self.titleLabel1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self);
            make.width.equalTo(@(width));
            make.top.equalTo(self);
            make.bottom.equalTo(self);
        }];
        
        [lineView1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.titleLabel1.mas_right).offset(-1);
            make.width.equalTo(@(0.5));
            make.top.equalTo(self.titleLabel1);
            make.bottom.equalTo(self.titleLabel1);
        }];
        
        
        [self.titleLabel2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.titleLabel1.mas_right);
            make.width.equalTo(@(width));
            make.top.equalTo(self);
            make.bottom.equalTo(self);
        }];
        
        [lineView2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.titleLabel2.mas_right).offset(-1);
            make.width.equalTo(@(0.5));
            make.top.equalTo(self.titleLabel2);
            make.bottom.equalTo(self.titleLabel2);
        }];
        
        [self.titleLabel3 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.titleLabel2.mas_right);
            make.width.equalTo(@(width));
            make.top.equalTo(self);
            make.bottom.equalTo(self);
        }];
        
        [lineView3 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.titleLabel3.mas_right).offset(-1);
            make.width.equalTo(@(0.5));
            make.top.equalTo(self.titleLabel3);
            make.bottom.equalTo(self.titleLabel3);
        }];
        
        [self.titleLabel4 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.titleLabel3.mas_right);
            make.width.equalTo(@(width));
            make.top.equalTo(self);
            make.bottom.equalTo(self);
        }];
        
        [lineView4 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.titleLabel4.mas_right).offset(-1);
            make.width.equalTo(@(0.5));
            make.top.equalTo(self.titleLabel4);
            make.bottom.equalTo(self.titleLabel4);
        }];
        
        [self.titleLabel5 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.titleLabel4.mas_right);
            make.width.equalTo(@(width));
            make.top.equalTo(self);
            make.bottom.equalTo(self);
        }];
        
        [lineBottomView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(self);
            make.height.equalTo(@0.5);
        }];
    }
    return self;
}

+ (UILabel *)titleLabel{
    UILabel *label = [[UILabel alloc] init];
    
    [label setFont:[UIFont systemFontOfSize:13]];
    [label setTextColor:UIColorTextNormal];
    [label setTextAlignment:(NSTextAlignmentCenter)];
    [label setNumberOfLines:0];
    return label;
}

- (void)setModel:(ProgressStatisticsModel *)model {
    if (_model != model) {
        _model = model;
        
        self.titleLabel1.text = model.part_name;
        self.titleLabel2.text = model.type_name;
        self.titleLabel3.text = model.start_time;
        self.titleLabel4.text = model.end_time;

        if ([model.status isEqualToString:@"un"]) {
            self.titleLabel5.text = @"未开工";
            self.titleLabel5.textColor = [UIColor whiteColor];
            self.titleLabel5.backgroundColor = [UIColor redColor];
        } else {
            self.titleLabel5.text = @"已开工";
            self.titleLabel5.textColor = UIColorTextNormal;
            self.titleLabel5.backgroundColor = [UIColor whiteColor];
        }
        
    }
}

@end
