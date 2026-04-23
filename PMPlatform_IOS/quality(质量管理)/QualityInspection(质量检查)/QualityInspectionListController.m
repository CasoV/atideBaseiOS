//
//  QualityInspectionListController.m
//  ycxm
//
//  Created by 末末班车 on 2018/9/29.
//  Copyright © 2018年 末末班车. All rights reserved.
//

#import "QualityInspectionListController.h"
#import "BaseListViewController.h"
#import "ListTabView.h"

#define tabHeight 40

@interface QualityInspectionListController ()

@property (nonatomic, strong) UIScrollView *scrollView;

@end

@implementation QualityInspectionListController {
    ListTabView *_tabView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if ([self.resourceTitle isEqualToString:@"巡查整改"]) {
        self.resourceTitle = @"水保巡查整改";
    }
    [self setupUI];
    [self setupContentView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationItem.title = self.resourceTitle;
    [self loadCount];
}

#pragma mark - 初始化界面
- (void)setupUI {
    __weak typeof(self) weakSelf = self;
    NSArray *titles = @[@"未提交", @"待整改", @"待复查", @"已完结"];
    _tabView = [[ListTabView alloc] initWithFrame:CGRectMake(0, kStatusBarH + kNavBarH, kScreen_Width, tabHeight) titles:titles];
    _tabView.callBack = ^(NSInteger selectIndex) {
        [weakSelf.scrollView setContentOffset:CGPointMake(selectIndex * kScreen_Width, 0) animated:YES];
    };
    [self.view addSubview:_tabView];
    
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, tabHeight + kStatusBarH + kNavBarH, kScreen_Width, kScreen_Height - kStatusBarH - kNavBarH - tabHeight)];
    _scrollView.contentSize = CGSizeMake(kScreen_Width * titles.count, _scrollView.frame.size.height);
    _scrollView.scrollEnabled = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:_scrollView];
    if (IS_IPhoneX_All) {
        _scrollView.contentInset = UIEdgeInsetsMake(0, 0, -34, 0);
    }
}

- (void)setupContentView {
    CGFloat width = self.scrollView.frame.size.width;
    CGFloat height = self.scrollView.frame.size.height;
    for (int i = 0; i < 4; i++) {
        BaseListViewController *vc = [[BaseListViewController alloc] init];
        vc.resourceTitle = self.resourceTitle;
        switch (i) {
            case 0:
                vc.type = FunctionTypeQualityInspectionUnsubmitted;
                break;
            case 1:
                vc.type = FunctionTypeQualityInspectionWaitRectification;
                break;
            case 2:
                vc.type = FunctionTypeQualityInspectionWaitReview;
                break;
            case 3:
                vc.type = FunctionTypeQualityInspectionFinished;
                break;
        }
        vc.view.frame = CGRectMake(i * width, 0, width, height);
        [self addChildViewController:vc];
        [self.scrollView addSubview:vc.view];
    }
}

#pragma mark - 加载count
- (void)loadCount {

    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithDictionary:@{@"projectId":[UserAgent DefaultAgent].projectId,@"sectId":[UserAgent DefaultAgent].sectionId}];
    NSString *url = [UrlConfig URL:getQualityProblemCount];
    if ([self.resourceTitle isEqualToString:@"环保问题整改"]) {
        url = [UrlConfig URL:greeProblemCount];
    }else if ([self.resourceTitle isEqualToString:@"水保巡查整改"]) {
        url = [UrlConfig URL:greeWaterProblemCount];
    }else if ([self.resourceTitle isEqualToString:@"安全隐患"]||[self.resourceTitle isEqualToString:@"安全检查"]) {
        url = [UrlConfig URL:riskCount];
    }else{
        [param setValue:[self.resourceTitle isEqualToString:@"质量问题"]?@"1":@"2" forKey:@"partId"];
    }
    [[HttpManager manager] get:url param:param success:^(NSData *data) {
        if ([ResponseUtils success:data]) {
            NSDictionary *dic = [ResponseUtils getData:@"data"];
            [self->_tabView setNum:@[dic[@"totalWtj"], dic[@"totalDzg"], dic[@"totalDfc"], dic[@"totalYwj"]]];
        } else {
            [SVProgressHUD showErrorWithStatus:[ResponseUtils getMsg]];
        }
    } faild:^(NSString *msg) {
        [SVProgressHUD showErrorWithStatus:msg];
    }];
}

@end
