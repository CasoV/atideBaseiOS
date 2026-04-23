//
//  NoDataView.m
//  ycTest
//
//  Created by 末末班车 on 2018/9/12.
//  Copyright © 2018年 末末班车. All rights reserved.
//

#import "NoDataView.h"

@implementation NoDataView

+ (NoDataView *)viewWithTableView:(UITableView *)tableView {
    NoDataView *view = [[NoDataView alloc] initWithFrame:tableView.bounds];
    [tableView addSubview:view];
    view.hidden = YES;
    return view;
}

+ (NoDataView *)viewWithView:(UIView *)view {
    NoDataView *noDataView = [[NoDataView alloc] initWithFrame:view.bounds];
    [view addSubview:noDataView];
    noDataView.hidden = YES;
    return noDataView;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        
        UIImageView *iv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"no_data"]];
        iv.center = CGPointMake(kScreen_Width / 2, 125);
        [self addSubview:iv];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, iv.frame.origin.y + iv.frame.size.height + 45, kScreen_Width, 16)];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:16.0];
        label.textColor = UIColorFromRGB(0xCCCCCC);
        label.text = @"    暂无数据！";
        [self addSubview:label];
    }
    return self;
}

@end
