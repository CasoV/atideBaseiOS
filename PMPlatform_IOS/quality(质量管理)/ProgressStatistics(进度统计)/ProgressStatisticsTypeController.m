//
//  ProgressStatisticsTypeController.m
//  HBConstructionApp
//
//  Created by 末末班车 on 2018/4/13.
//  Copyright © 2018年 atide. All rights reserved.
//

#import "ProgressStatisticsTypeController.h"
#import "ApiQualityDatumSelectPartDetail.h"
#import "ProgressStatisticsMainView.h"
//#import "ChooseSitesController.h"
#import "ChooseUnitBtn.h"

#define kMenu_Height 40

@interface ProgressStatisticsTypeController ()

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) ProgressStatisticsMainView *mainView;

@property (nonatomic, strong) ChooseUnitBtn *btn;

@end

@implementation ProgressStatisticsTypeController {
    ApiQualityDatumSelectPartDetail *_request;
    
    NSString *_partCode;
    
    BOOL _isOpen;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _partCode = [UserAgent DefaultAgent].sectionCode;
    _isOpen = NO;
    
    [self.view addSubview:self.scrollView];
    [self.scrollView addSubview:self.mainView];
    [self setupMenu];
    
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(kMenu_Height + kStatusBarH + kNavBarH);
        make.right.left.bottom.equalTo(self.view);
    }];
    
    [self loadData];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.navigationItem.title = @"进度统计(工程类型)";
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

- (ProgressStatisticsMainView *)mainView {
    if (!_mainView) {
        __weak typeof(self) weakSelf = self;
        _mainView = [[ProgressStatisticsMainView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, kScreen_Height)];
        _mainView.canClicked = NO;
        _mainView.block = ^(CGFloat viewHeight) {
            weakSelf.scrollView.contentSize = CGSizeMake(kScreen_Width, viewHeight);
        };
    }
    return _mainView;
}

#pragma mark - 初始化
- (void)setupMenu {
    UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, kStatusBarH + kNavBarH, kScreen_Width, kMenu_Height)];
    [self.view addSubview:contentView];
    
    self.btn = [[NSBundle mainBundle] loadNibNamed:@"ChooseUnitBtn" owner:nil options:nil].firstObject;
    self.btn.frame = contentView.bounds;
    [self.btn setTitle:@"工程类型"];
    [self.btn.titleBtn setTitle:@"请选择工程类型" forState:UIControlStateNormal];
    [self.btn.titleBtn addTarget:self action:@selector(chooseBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [contentView addSubview:self.btn];
}

#pragma mark - 加载数据
- (void)loadData {
    if ([_partCode isEqualToString:@""]) {
        [self chooseBtnClicked:nil];
        [SVProgressHUD showInfoWithStatus:@"请先选择工程类型"];
        return;
    }
    
    if (_request) {
        [_request stop];
    }
    
    __weak typeof(self) weakSelf = self;
    [SVProgressHUD showWithStatus:@"加载中..."];
    _request = [[ApiQualityDatumSelectPartDetail alloc] initWithRequestParams:[self param]];
    _request.isType = YES;
    [_request startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        [SVProgressHUD dismiss];
        NSArray <ProgressStatisticsModel *>*dataArr = [ProgressStatisticsModel mj_objectArrayWithKeyValuesArray:[[request responseJSON] objectForKey:@"topTotals"]];
        if (dataArr) {
            [weakSelf setDataModel:dataArr];
        }
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        [SVProgressHUD dismiss];
    }];
}

- (NSDictionary *)param {
    return @{@"parent_code":_partCode};
}

- (void)setDataModel:(NSArray <ProgressStatisticsModel *>*)dataModel {
    [self.mainView updateData:dataModel];
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
