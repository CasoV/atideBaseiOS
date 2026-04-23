//
//  ProgressStatisticsMainController.m
//  HBConstructionApp
//
//  Created by 末末班车 on 2018/4/13.
//  Copyright © 2018年 atide. All rights reserved.
//

#import "ProgressStatisticsMainController.h"
#import "ProgressStatisticsTypeController.h"
#import "ProgressStatisticsSiteController.h"
#import "ApiQualityDatumSelectTopTotal.h"
#import "ProgressStatisticsMainView.h"

#define kButton_Height 40

@interface ProgressStatisticsMainController ()

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) ProgressStatisticsMainView *mainView;
@property (nonatomic, strong) UIView *bottomView;

@end

@implementation ProgressStatisticsMainController {
    ApiQualityDatumSelectTopTotal *_request;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view addSubview:self.scrollView];
    [self.view addSubview:self.bottomView];
    [self.scrollView addSubview:self.mainView];
    
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.right.left.equalTo(self.view);
        make.height.equalTo(@kButton_Height);
    }];
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view);
        make.right.left.equalTo(self.view);
        make.bottom.equalTo(self.bottomView.mas_top);
    }];
    
    [self loadData];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationItem.title = @"进度统计";
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

- (UIView *)bottomView {
    if (!_bottomView) {
        _bottomView = [[UIView alloc] initWithFrame:CGRectZero];
        
        NSArray *titleArr = @[@"按部位查看", @"按类型查看"];
        CGFloat width = kScreen_Width / titleArr.count;
        
        for (NSInteger i = 0; i < titleArr.count; i++) {
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.frame = CGRectMake(i * width, 0, width, kButton_Height);
            [btn setTitle:titleArr[i] forState:UIControlStateNormal];
            [btn setTitleColor:UIColorTextBlue forState:UIControlStateNormal];
            [btn addTarget:self action:@selector(bottomBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
            btn.titleLabel.font = [UIFont systemFontOfSize:13];
            btn.tag = 100 + i;
            [_bottomView addSubview:btn];
        }
        
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectZero];
        lineView.backgroundColor = UIColorFromRGB(0xD8D8D8);
        [_bottomView addSubview:lineView];
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.equalTo(_bottomView);
            make.height.equalTo(@0.5);
        }];
        
        for (NSInteger i = 1; i < titleArr.count; i++) {
            UIView *line = [[UIView alloc] initWithFrame:CGRectMake(i * width, 0, 0.5, kButton_Height)];
            line.backgroundColor = UIColorFromRGB(0xD8D8D8);
            [_bottomView addSubview:line];
        }
    }
    return _bottomView;
}

#pragma mark - 加载数据
- (void)loadData {
    if (_request) {
        [_request stop];
    }
    
    __weak typeof(self) weakSelf = self;
    [SVProgressHUD showWithStatus:@"加载中..."];
    _request = [[ApiQualityDatumSelectTopTotal alloc] initWithRequestParams:[self param]];
    [_request startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        [SVProgressHUD dismiss];
        NSArray <ProgressStatisticsModel *>*dataArr = [ProgressStatisticsModel mj_objectArrayWithKeyValuesArray:[request responseJSON]];
        if (dataArr) {
            [weakSelf setDataModel:dataArr];
        }
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        [SVProgressHUD dismiss];
    }];
}

- (NSDictionary *)param {
    NSString *prjCode = @"";
    for (SectionInfo *info in [UserAgent DefaultAgent].sectionInfos) {
        if ([info.sectionId isEqualToString:[UserAgent DefaultAgent].sectionId]) {
            prjCode = info.prjCode;
            break;
        }
    }
    
    return @{@"partCode":prjCode ? prjCode : @""};
}

- (void)setDataModel:(NSArray <ProgressStatisticsModel *>*)dataModel {
    [self.mainView updateData:dataModel];
}

#pragma mark - 点击事件
- (void)bottomBtnClicked:(UIButton *)sender {
    if (sender.tag == 100) {
        ProgressStatisticsSiteController *vc = [[ProgressStatisticsSiteController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    } else {
        ProgressStatisticsTypeController *vc = [[ProgressStatisticsTypeController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

@end
