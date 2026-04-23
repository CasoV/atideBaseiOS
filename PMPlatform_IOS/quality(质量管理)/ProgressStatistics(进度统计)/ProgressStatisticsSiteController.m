//
//  ProgressStatisticsSiteController.m
//  HBConstructionApp
//
//  Created by 末末班车 on 2018/4/13.
//  Copyright © 2018年 atide. All rights reserved.
//

#import "ProgressStatisticsSiteController.h"
#import "ApiQualityDatumSelectPartDetail.h"
#import "ProgressStatisticsSiteHeaderView.h"
#import "ProgressStatisticsSiteCell.h"
//#import "ChooseSitesController.h"
#import <Charts/Charts-Swift.h>
#import "ChooseUnitBtn.h"
//#import "ChartsHelper.h"

#define kMenu_Height 40

@interface ProgressStatisticsSiteController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, strong) BarChartView *chartView;

@property (nonatomic, strong) ProgressStatisticsSiteHeaderView *headerView;

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, copy) NSArray <ProgressStatisticsModel *>*data;

@property (nonatomic, strong) ChooseUnitBtn *btn;

@end

@implementation ProgressStatisticsSiteController {
    ApiQualityDatumSelectPartDetail *_request;
    
    NSString *_partCode;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view addSubview:self.scrollView];
    [self.scrollView addSubview:self.chartView];
    [self.scrollView addSubview:self.headerView];
    [self.scrollView addSubview:self.tableView];
    [self setupMenu];
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(kMenu_Height + kStatusBarH + kNavBarH);
        make.right.left.bottom.equalTo(self.view);
    }];
    
    [self fetchPart];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.navigationItem.title = @"进度统计(工程部位)";
}

- (void)dealloc {
    [_request stop];
}

#pragma mark - 懒加载
- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectZero];
        _scrollView.backgroundColor = [UIColor whiteColor];
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.bounces = NO;
    }
    return _scrollView;
}

- (BarChartView *)chartView {
    if (!_chartView) {
        _chartView = [[BarChartView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, kScreen_Height / 3 * 1)];
    }
    return _chartView;
}

- (ProgressStatisticsSiteHeaderView *)headerView {
    if (!_headerView) {
        _headerView = [[ProgressStatisticsSiteHeaderView alloc] initWithFrame:CGRectMake(0, kScreen_Height / 3 * 1, kScreen_Width, 40)];
    }
    return _headerView;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, kScreen_Height / 3 * 1 + 40, kScreen_Width, 0) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = 40;
        _tableView.bounces = NO;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    }
    return _tableView;
}

- (NSArray<ProgressStatisticsModel *> *)data {
    if (!_data) {
        _data = [NSArray array];
    }
    return _data;
}

#pragma mark - 初始化
- (void)setupMenu {
    _partCode = @"";
    
    UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, kStatusBarH + kNavBarH, kScreen_Width, kMenu_Height)];
    [self.view addSubview:contentView];
    
    self.btn = [[NSBundle mainBundle] loadNibNamed:@"ChooseUnitBtn" owner:nil options:nil].firstObject;
    self.btn.frame = contentView.bounds;
    [self.btn setTitle:@"工程部位"];
    [self.btn.titleBtn setTitle:@"请选择工程部位" forState:UIControlStateNormal];
    [self.btn.titleBtn addTarget:self action:@selector(chooseBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [contentView addSubview:self.btn];
}

#pragma mark -- 网络请求
- (void)fetchPart{
    __weak __typeof(self) weakSelf = self;
    [SVProgressHUD showWithStatus:@"加载中..."];
    [[HttpManager manager] post:[UrlConfig URL:getProjectListTree] param:@{@"id":[UserAgent DefaultAgent].sectionCode} success:^(NSData *data) {
        [SVProgressHUD dismiss];
        
        NSArray <SiteModel *>*temp = [SiteModel mj_objectArrayWithKeyValuesArray:data];
        if (temp && temp.count != 0) {
            SiteModel *model = [temp objectAtIndex:0];
            if (model) {
                [weakSelf.btn.titleBtn setTitle:model.text forState:UIControlStateNormal];
                self->_partCode = model.id;
                [weakSelf loadData];
            }
        }
    } faild:^(NSString *msg) {
        [SVProgressHUD dismiss];
    }];
}

#pragma mark - 加载数据
- (void)loadData {
    if ([_partCode isEqualToString:@""]) {
        [self chooseBtnClicked:nil];
        [SVProgressHUD showInfoWithStatus:@"请先选择工程部位"];
        return;
    }
    
    if (_request) {
        [_request stop];
    }
    
    __weak typeof(self) weakSelf = self;
    [SVProgressHUD showWithStatus:@"加载中..."];
    _request = [[ApiQualityDatumSelectPartDetail alloc] initWithRequestParams:[self param]];
    [_request startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        [SVProgressHUD dismiss];
//        NSArray <ProgressStatisticsModel *>*dataArr = [ProgressStatisticsModel mj_objectArrayWithKeyValuesArray:[[request responseJSON] objectForKey:@"topTotals"]];
//        weakSelf.data = [ProgressStatisticsModel mj_objectArrayWithKeyValuesArray:[[request responseJSON] objectForKey:@"partTotals"]];
//        if (dataArr) {
//            [ChartsHelper initBarChartDataProgressStatisticsData:weakSelf.chartView dataSource:dataArr];
//        }
        [weakSelf updateFrame];
        [weakSelf.tableView reloadData];
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        [SVProgressHUD dismiss];
    }];
}

- (NSDictionary *)param {
    return @{@"partCode":_partCode, @"flag":@"part"};
}

#pragma mark - UITableViewDelegate, UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ProgressStatisticsSiteCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ProgressStatisticsSiteCell"];
    if (!cell) {
        cell = [[ProgressStatisticsSiteCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ProgressStatisticsSiteCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    cell.model = self.data[indexPath.row];
    
    return cell;
}

#pragma mark - 更新frame
- (void)updateFrame {
    CGFloat height = self.data.count * 40;
    
    self.tableView.frame = CGRectMake(0, kScreen_Height / 3 * 1 + 40, kScreen_Width, height);
    self.scrollView.contentSize = CGSizeMake(kScreen_Width, height + kScreen_Height / 3 * 1 + 40);
}

#pragma mark - 点击事件
- (void)chooseBtnClicked:(UITapGestureRecognizer *)sender {
//    __weak typeof(self) weakSelf = self;
//    ChooseSitesController *vc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"ChooseSites"];
//    vc.block = ^(SiteModel *site) {
//        [weakSelf.btn.titleBtn setTitle:site.text forState:UIControlStateNormal];
//        self->_partCode = site.id;
//        [weakSelf loadData];
//    };
//    [self.navigationController pushViewController:vc animated:YES];
}

@end
