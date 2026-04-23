//
//  PentahoPageViewController.m
//  ycxm
//
//  Created by 高小伟 on 2021/8/18.
//  Copyright © 2021 末末班车. All rights reserved.
//

#import "PentahoPageViewController.h"
#import <WebKit/WebKit.h>
#import "RightTreePentaViewController.h"
@interface PentahoPageViewController ()<WKNavigationDelegate, WKUIDelegate>

@property (nonatomic, strong) NSDictionary *mReportData;
@property (nonatomic, strong) WKWebView *webView;
@property (nonatomic, strong) UIProgressView *progressView;
@property (nonatomic,strong)RightTreePentaViewController *rightVc;
@property (nonatomic,strong)UIView *backColorView;

@end

@implementation PentahoPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initWebView];
    [self initChildVc];
    [self loadData];
}
- (void)viewWillAppear:(BOOL)animated{
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nav_seciton"] style:UIBarButtonItemStylePlain target:self action:@selector(tapCondition)];
    
}

- (void)tapCondition {
    self.navigationItem.rightBarButtonItem.enabled = NO;
    [self.view bringSubviewToFront:_backColorView];
    [self.view bringSubviewToFront:_rightVc.view];
    /* 出现的动画 */
    [UIView animateWithDuration:0.5 animations:^{
        self->_backColorView.alpha = 0.3;
        self->_rightVc.view.frame = CGRectMake(50, kStatusBarH + kNavBarH, kScreen_Width - 50, kScreen_Height - kStatusBarH - kNavBarH);
    }];
}

//#pragma mark - 加载数据
- (void)loadData {
    NSString *projectId = [UserAgent DefaultAgent].projectId;
    NSString *sectId = [UserAgent DefaultAgent].sectionId;
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:@{
        @"projectId": projectId ? projectId : @"",
        @"sectId": sectId ? sectId : @"",
        @"periodId": @"",
        @"treeCode": self.treeCode
    }];
    if(self.otherInfo){
        for (NSString *key in self.otherInfo.allKeys) {
            [params setValue:[self.otherInfo[key] mj_JSONString]  forKey:key];
        }
    }
    __weak typeof(self) weakSelf = self;
    [SVProgressHUD showWithStatus:@""];
    [[HttpManager manager] post:[UrlConfig URL:getReportData] param:params success:^(NSData *data) {
        [DatumModel mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
            return @{@"text":@"name"};
        }];
        [DatumModel mj_setupObjectClassInArray:^NSDictionary *{
               return @{@"children":@"DatumModel"};
           }];
        NSArray <DatumModel *>*datas = [DatumModel mj_objectArrayWithKeyValuesArray:[data mj_JSONObject][@"data"][@"repData"]];
        weakSelf.mReportData = [data mj_JSONObject][@"data"];
        NSArray  <DatumModel *>*dataSource = [NSArray array];
        if (datas.count > 0) {
            dataSource = datas;
            for (DatumModel *item in dataSource) {
                item.isExpanded = YES;
            }
            weakSelf.rightVc.dataSource = dataSource;
            [self downLoadFileWithModel:dataSource[0]];
        }else{
            [SVProgressHUD showErrorWithStatus:@"网络请求失败！"];
            weakSelf.rightVc.dataSource = [NSArray array];
        }
    } faild:^(NSString *msg) {
        [SVProgressHUD showErrorWithStatus:msg];
    }];
}
-(void)downLoadFileWithModel:(DatumModel *)model{
    self.navigationItem.title = model.text;
    [SVProgressHUD showWithStatus:nil];
    __weak typeof(self) weakSelf = self;
    NSString *fileName = [NSString stringWithFormat:@"%@.pdf",[self currentTimeStr]];
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:@{
        @"sectId":self.chooseSectionId?self.chooseSectionId:[UserAgent DefaultAgent].sectionId,
        @"treeCode":self.treeCode,
        @"fileUri":[model.url stringByRemovingPercentEncoding],
        @"fileName":model.text,
        @"pdfId":@(-1),
        @"nodeId":model.id
        
    }];
    for (NSString *key in [self.mReportData[@"mapUrlParems"] allKeys]) {
        [params setObject:self.mReportData[@"mapUrlParems"][key] forKey:key];
    }
    for (NSString *key in [self.mReportData[@"projectInfoData"] allKeys]) {
        [params setObject:self.mReportData[@"projectInfoData"][key] forKey:key];
    }
    for (NSString *key in [self.mReportData[@"sectInfoData"] allKeys]) {
        [params setObject:self.mReportData[@"sectInfoData"][key] forKey:key];
    }
    
    [[HttpManager manager]post:[UrlConfig URL:reportGenerateKey] param:params success:^(NSData *data) {
        NSDictionary *resp = [data mj_JSONObject];
        if(![[resp[@"success"] stringValue] isEqualToString:@"1"]){
            [SVProgressHUD showErrorWithStatus:@"数据加载失败!"];
            return;
        }
        NSString *url = [NSString stringWithFormat:@"%@%@",[UrlConfig URL:reportDownload],resp[@"data"]];
        [[HttpManager manager] downloadWithUrl:url params:nil fileName:fileName progress:^(NSProgress *downloadProgress) {
            
        } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
            [SVProgressHUD dismiss];
            [weakSelf.webView loadRequest:[NSURLRequest requestWithURL:filePath]];
        }];
        
        } faild:^(NSString *msg) {
            [SVProgressHUD showErrorWithStatus:@"网络请求失败！"];
        }];
    
}
//获取当前时间戳
- (NSString *)currentTimeStr{
    NSDate* date = [NSDate dateWithTimeIntervalSinceNow:0];//获取当前时间0秒后的时间
    NSTimeInterval time=[date timeIntervalSince1970]*1000;// *1000 是精确到毫秒，不乘就是精确到秒
    NSString *timeString = [NSString stringWithFormat:@"%.0f", time];
    return timeString;
}
#pragma mark - 初始化webView
- (void)initWebView {
    [self.view addSubview:self.webView];
    [self.view addSubview:self.progressView];
}
-(void)initChildVc{
      __weak typeof(self) weakSelf = self;
    /* 创建一个阴影 */
    _backColorView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    _backColorView.backgroundColor = [UIColor blackColor];
    _backColorView.alpha = 0;   //开始透明度为0,后面通过动画逐渐变黑
    UITapGestureRecognizer *tapG = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeTap)];
    [_backColorView addGestureRecognizer:tapG]; //加入触摸手势,点阴影区域时关闭右侧导航栏
    [self.view addSubview:_backColorView];
    
    /* 创建第二页对象 */
    _rightVc = [RightTreePentaViewController new];
    _rightVc.callBack = ^(DatumModel *model) {
        if(model){
            [weakSelf downLoadFileWithModel:model];
            [weakSelf closeTap];
        }
    };
    _rightVc.view.frame = CGRectMake(kScreen_Width, kNavBarH + kStatusBarH,kScreen_Width - 50 , kScreen_Height - kNavBarH - kStatusBarH);
    [self addChildViewController:_rightVc];
    [self.view addSubview:_rightVc.view];
}
- (void)closeTap {
    self.navigationItem.rightBarButtonItem.enabled = YES;
    /* 关闭操作,先动画后移除 */
    [UIView animateWithDuration:0.5 animations:^{
        self->_backColorView.alpha = 0;
        self->_rightVc.view.frame = CGRectMake(kScreen_Width, kStatusBarH + kNavBarH, kScreen_Width - 50, kScreen_Height - kStatusBarH - kNavBarH);
    }];
}

- (WKWebView *)webView {
    if (!_webView) {
        WKWebViewConfiguration*config = [[WKWebViewConfiguration alloc]init];
        config.selectionGranularity = WKSelectionGranularityCharacter;
        _webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, self.view.frame.size.height) configuration:config];
        _webView.UIDelegate = self;
        _webView.navigationDelegate = self;
        [_webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];

    }
    return _webView;
}

- (UIProgressView *)progressView {
    if(!_progressView) {
        _progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, 1)];
        _progressView.hidden = YES;
        _progressView.tintColor = [UIColor greenColor];
        _progressView.trackTintColor = [UIColor whiteColor];
    }
    return _progressView;
}

#pragma mark - 计算wkWebView进度条
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if (object == _webView && [keyPath isEqualToString:@"estimatedProgress"]) {
        CGFloat newprogress = [[change objectForKey:NSKeyValueChangeNewKey] doubleValue];
        if (newprogress == 1) {
            [UIView animateWithDuration:2.0 animations:^{
                self.progressView.progress = newprogress;
            } completion:^(BOOL finished) {
                self.progressView.hidden = YES;
            }];
        }else {
            self.progressView.hidden = NO;
            [self.progressView setProgress:newprogress animated:YES];
        }
    }
}
@end
