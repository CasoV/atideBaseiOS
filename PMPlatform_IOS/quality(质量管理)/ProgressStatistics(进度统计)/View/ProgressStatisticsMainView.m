//
//  ProgressStatisticsMainView.m
//  HBConstructionApp
//
//  Created by 末末班车 on 2018/4/13.
//  Copyright © 2018年 atide. All rights reserved.
//

#import "ProgressStatisticsMainView.h"
#import "ProgressStatisticsTableHeaderView.h"
#import "ProgressStatisticsCell.h"
#import <Charts/Charts-Swift.h>
//#import "ChartsHelper.h"

@interface ProgressStatisticsMainView ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UISegmentedControl *segmentedControl;

@property (nonatomic, strong) ProgressStatisticsTableHeaderView *headerView;

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) BarChartView *chartView;

@end

@implementation ProgressStatisticsMainView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.segmentedControl];
        [self addSubview:self.headerView];
        [self addSubview:self.tableView];
        [self addSubview:self.chartView];
        
        [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.left.bottom.equalTo(self);
            make.top.equalTo(self).offset(80);
        }];
    }
    return self;
}

#pragma mark - 懒加载
- (UISegmentedControl *)segmentedControl {
    if (!_segmentedControl) {
        _segmentedControl = [[UISegmentedControl alloc] initWithItems:@[@"统计图", @"数据列表"]];
        _segmentedControl.frame = CGRectMake(10, 6, kScreen_Width - 20, 28);
        _segmentedControl.selectedSegmentIndex = 0;
        _segmentedControl.tintColor = UIColorFromRGB(0x0096FF);
        [_segmentedControl addTarget:self action:@selector(segmentedControlChanged:) forControlEvents:UIControlEventValueChanged];
    }
    return _segmentedControl;
}

- (ProgressStatisticsTableHeaderView *)headerView {
    if (!_headerView) {
        _headerView = [[ProgressStatisticsTableHeaderView alloc] initWithFrame:CGRectMake(0, 40, kScreen_Width, 40)];
        _headerView.hidden = YES;
    }
    return _headerView;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = 40;
        _tableView.bounces = NO;
        _tableView.hidden = YES;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    }
    return _tableView;
}

- (BarChartView *)chartView {
    if (!_chartView) {
        _chartView = [[BarChartView alloc] initWithFrame:CGRectMake(0, 40, kScreen_Width, kScreen_Height / 2)];
    }
    return _chartView;
}

- (NSArray<ProgressStatisticsModel *> *)data {
    if (!_data) {
        _data = [NSArray array];
    }
    return _data;
}

#pragma mark - UITableViewDelegate, UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ProgressStatisticsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ProgressStatisticsCell"];
    if (!cell) {
        cell = [[ProgressStatisticsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ProgressStatisticsCell"];
        if (!self.canClicked) {
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
    }
    self.data[indexPath.row].canClicked = self.canClicked;
    cell.model = self.data[indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (!self.canClicked) {
        return;
    }
    
    if (self.callBack) {
        self.callBack(self.data[indexPath.row]);
    }
}

#pragma mark - 点击事件
- (void)segmentedControlChanged:(UISegmentedControl *)sender {
    if (self.block) {
        CGFloat height = 40;
        switch (sender.selectedSegmentIndex) {
            case 0:
                self.chartView.hidden = NO;
                self.headerView.hidden = YES;
                self.tableView.hidden = YES;
                height = kScreen_Height / 2 + 40;
                break;
            case 1:
                self.chartView.hidden = YES;
                self.headerView.hidden = NO;
                self.tableView.hidden = NO;
                height = (self.data.count + 2) * 40;
                break;
            default:
                break;
        }
        self.block(height);
        
        CGRect frame = self.frame;
        frame.size.height = height;
        self.frame = frame;
    }
}

- (void)updateData:(NSArray<ProgressStatisticsModel *> *)data {
    self.data = data;
//    [ChartsHelper initBarChartDataProgressStatisticsData:self.chartView dataSource:data];
    [self.tableView reloadData];
    [self segmentedControlChanged:self.segmentedControl];
}

@end
