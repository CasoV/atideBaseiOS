//
//  MeaMidTableHeaderView.m
//  ycxm
//
//  Created by 末末班车 on 2019/2/26.
//  Copyright © 2019 末末班车. All rights reserved.
//

#import "MeaMidTableHeaderView.h"

@implementation MeaMidTableHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        CGFloat width = (frame.size.width - 30) / 5;
        CGFloat height = frame.size.height;
        
        [self addSubview:[self setupLabelWith:CGRectMake(0, 0, width, height) title:@"名称"]];
        [self addSubview:[self setupLabelWith:CGRectMake(width, 0, 30, height) title:@"单位"]];
        [self addSubview:[self setupLabelWith:CGRectMake(width + 30, 0, width, height) title:@"单价"]];
        [self addSubview:[self setupLabelWith:CGRectMake(width * 2 + 30, 0, width, height) title:@"计划量"]];
        [self addSubview:[self setupLabelWith:CGRectMake(width * 3 + 30, 0, width, height) title:@"实际量"]];
        [self addSubview:[self setupLabelWith:CGRectMake(width * 4 + 30, 0, width, height) title:@"总金额"]];
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, height - 1, frame.size.width, 1)];
        line.backgroundColor = [UIColor colorWithRed:216.0/255 green:216.0/255 blue:216.0/255 alpha:1];
        [self addSubview:line];
    }
    return self;
}

- (UILabel *)setupLabelWith:(CGRect)frame title:(NSString *)title {
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.font = [UIFont systemFontOfSize:13.f];
    label.textAlignment = NSTextAlignmentCenter;
    label.text = title;
    return label;
}

@end
