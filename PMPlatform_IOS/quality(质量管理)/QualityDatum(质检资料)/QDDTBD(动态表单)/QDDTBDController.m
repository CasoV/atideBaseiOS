//
//  QDDTBDController.m
//  ycxm
//
//  Created by 末末班车 on 2020/3/17.
//  Copyright © 2020 末末班车. All rights reserved.
//

#import "QDDTBDController.h"
#import "WeakScriptMessageDelegate.h"
#import "FlowManagermentFactory.h"
#import "PassViewController.h"
#import <WebKit/WebKit.h>
#import "UserTaskModel.h"
#import "PopoverView.h"
#import "ToolBar.h"

@interface QDDTBDController ()<WKNavigationDelegate, WKUIDelegate, WKScriptMessageHandler>

@property (nonatomic, strong) WKWebView *webView;

@property (nonatomic, strong) UIProgressView *progressView;

@property (nonatomic, strong) SectionInfo *sectionInfo;

@property (nonatomic, copy) NSArray <ToolBar *>*toolArray;

@property (nonatomic, copy) NSString *taskId;

@property (nonatomic, assign) BOOL submitSuccess;

@end

@implementation QDDTBDController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initUI];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.navigationItem.title = self.model.name ? self.model.name : @"质检资料表单";
    if (self.submitSuccess) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark - 初始化页面
- (void)initUI {
    WKWebViewConfiguration*config = [[WKWebViewConfiguration alloc]init];
    config.selectionGranularity = WKSelectionGranularityCharacter;
    self.webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, 0) configuration:config];
    self.webView.UIDelegate = self;
    self.webView.navigationDelegate = self;
    [self.webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
    [self.webView.configuration.userContentController addScriptMessageHandler:[[WeakScriptMessageDelegate alloc] initWithDelegate:self] name:@"toIOS"];
    [self.view addSubview:self.webView];
    [self.view addSubview:self.progressView];
    
    [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.left.right.equalTo(self.view);
    }];
    
 
    
    [self initWebView];
    
//    if(!self.model.instId){
//        [self initWebView];
//        return;
//    }
//    [self getSectionInfo];
//    [self getTaskId];
//    [self getFlowToolbar];
}

- (void)initWebView {
    NSMutableString *urlStr = [NSMutableString stringWithString:[UrlConfig URL:showPdfView]];
    [urlStr appendFormat:@"/%@", self.model.excelId];
    
//    [urlStr appendFormat:@"/%@/%@", self.model.templateCode, self.model.instId];
//    [urlStr appendFormat:@"?CONTRACTOR_=%@", self.sectionInfo.constractorUnitName ? self.sectionInfo.constractorUnitName : @""];
//    [urlStr appendFormat:@"&SUPERVISOR_=%@", self.sectionInfo.designSectionName ? self.sectionInfo.designSectionName : @""];
//    [urlStr appendFormat:@"&CONSTRUCT_NUM=%@", self.sectionInfo.contractCode ? self.sectionInfo.contractCode : @""];
//    [urlStr appendFormat:@"&USER_ID_=%@", [AppUser sharedInstance].userId ? [AppUser sharedInstance].userId : @""];
//    [urlStr appendFormat:@"&ORG_ID_=%@", [AppUser sharedInstance].orgId ? [AppUser sharedInstance].orgId : @""];
//    [urlStr appendFormat:@"&PROJECT_ID_=%@", [UserAgent DefaultAgent].projectId ? [UserAgent DefaultAgent].projectId : @""];
//    [urlStr appendString:@"&STATUS_=1&callOds=1"];

    NSURL *url = [urlStr mj_url];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    [self.webView loadRequest:request];
}

#pragma mark - 懒加载
- (UIProgressView *)progressView {
    if(!_progressView) {
        _progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(0, kStatusBarH + kNavBarH, kScreen_Width, 1)];
        _progressView.hidden = YES;
        _progressView.tintColor = [UIColor greenColor];
        _progressView.trackTintColor = [UIColor whiteColor];
    }
    return _progressView;
}

#pragma mark - 销毁
- (void)dealloc {
    [[_webView configuration].userContentController removeScriptMessageHandlerForName:@"toIOS"];
    [_webView removeObserver:self forKeyPath:@"estimatedProgress"];
    
    [_webView stopLoading];
    [_webView removeFromSuperview];
    _webView = nil;

    NSSet *websiteDataTypes = [WKWebsiteDataStore allWebsiteDataTypes];
    
    //// Date from
    
    NSDate *dateFrom = [NSDate dateWithTimeIntervalSince1970:0];
    
    //// Execute
    
    [[WKWebsiteDataStore defaultDataStore] removeDataOfTypes:websiteDataTypes modifiedSince:dateFrom completionHandler:^{
        // Done
    }];
}

#pragma mark - WKScriptMessageHandler
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message {
    if ([message.name isEqualToString:@"toIOS"]) {
        NSDictionary *body = [message.body mj_JSONObject];
    }
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

#pragma mark - 点击事件
- (void)rightClicked:(UIBarButtonItem *)sender {
    NSMutableArray <PopoverAction *>*actionArr = [NSMutableArray array];
    NSMutableArray <NSString *>*titles = [NSMutableArray new];
    for (ToolBar *item in self.toolArray) {
        [titles addObject:item.name];
    }
    
    __weak typeof(self) weakSelf = self;

    for (NSString *title in titles) {
        PopoverAction *action = [PopoverAction actionWithTitle:title handler:^(PopoverAction *action) {
            if ([title isEqualToString:@"保存"]) {
                [weakSelf save];
            } else if ([title isEqualToString:@"提交"] || [title isEqualToString:@"通过"] || [title isEqualToString:@"申报"]) {
                [weakSelf submit:title];
            }
        }];
        [actionArr addObject:action];
    }
    PopoverView *popoverView = [PopoverView popoverView];
    popoverView.showShade = YES; // 显示阴影背景
    popoverView.style = PopoverViewStyleDark; // 设置为黑色风格
    // 有两种显示方法
    [popoverView showToPoint:CGPointMake(kScreen_Width - 20, kStatusBarH + 44) withActions:actionArr];
}

#pragma mark - 获取标段信息
- (void)getSectionInfo {
    NSString *url = [UrlConfig URL:getSingleContentSectionInfo];
    NSString *sectionId = [UserAgent DefaultAgent].sectionId ? [UserAgent DefaultAgent].sectionId : @"";

    __weak typeof(self) weakSelf = self;
    [[HttpManager manager] post:url param:@{@"sectionId": sectionId} success:^(NSData *data) {
        if ([ResponseUtils success:data]) {
            weakSelf.sectionInfo = [SectionInfo mj_objectWithKeyValues:[ResponseUtils getData:@"data"]];
            [weakSelf initWebView];
        } else {
            [SVProgressHUD showErrorWithStatus:[ResponseUtils getMsg]];
        }
    } faild:^(NSString *msg) {
        [SVProgressHUD showErrorWithStatus:msg];
    }];
}

#pragma mark - 获取流程id
- (void)getTaskId {
    NSString *url = [UrlConfig URL:queryUserTask];
    NSDictionary *params = @{
        @"bizPk": self.model.instId,
        @"userId": [AppUser sharedInstance].userId,
        @"forward": @"0"
    };
    __weak typeof(self) weakSelf = self;
    [[HttpManager manager] get:url param:params success:^(NSData *data) {
        NSArray <UserTaskModel *>*datas = [UserTaskModel mj_objectArrayWithKeyValuesArray:data];
        if (datas.count > 0) {
            weakSelf.taskId = datas[0].id;
        }
    } faild:^(NSString *msg) {
        [SVProgressHUD showErrorWithStatus:msg];
    }];
}

#pragma mark - 获取工具栏
- (void)getFlowToolbar {
    [SVProgressHUD showWithStatus:@"加载中"];
    
    NSString *url = [UrlConfig URL:getFlowToolbar];
    NSDictionary *params = @{
        @"bizPk": self.model.instId,
        @"bizKey": self.model.processCode? self.model.processCode:@""
    };
    __weak typeof(self) weakSelf = self;
    [[HttpManager manager] post:url param:params success:^(NSData *data) {
        if ([ResponseUtils success:data]) {
            weakSelf.toolArray = [weakSelf handleTools:[ToolBar mj_objectArrayWithKeyValuesArray:[ResponseUtils getData:@"data"]]];
            if(self.toolArray && self.toolArray.count > 0){
                self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"icon_add"] style:UIBarButtonItemStylePlain target:self action:@selector(rightClicked:)];
            }
        } else {
            [SVProgressHUD showErrorWithStatus:[ResponseUtils getMsg]];
            weakSelf.navigationItem.rightBarButtonItem = nil;
        }
    } faild:^(NSString *msg) {
        [SVProgressHUD showErrorWithStatus:msg];
    }];
}

#pragma mark - 处理工具栏
- (NSArray <ToolBar *>*)handleTools:(NSArray <ToolBar *>*)tools {
    NSMutableArray <ToolBar *>*finalTools = [NSMutableArray array];
    BOOL haveSave = NO;
    for (ToolBar *item in tools) {
        if ([item.name isEqualToString:@"保存"]) {
            haveSave = YES;
            [finalTools addObject:item];
        } else if ([item.name isEqualToString:@"通过"] || [item.name isEqualToString:@"提交"] || [item.name isEqualToString:@"申报"]) {
            [finalTools addObject:item];
        }
    }
//    if (!haveSave) {
//        ToolBar *item = [ToolBar new];
//        item.name = @"保存";
//        [finalTools insertObject:item atIndex:0];
//    }
    
    return [finalTools copy];
}

#pragma mark - 保存
- (void)save {
    [self.webView evaluateJavaScript:[NSString stringWithFormat:@"handleTest()"] completionHandler:^(id result, NSError * _Nullable error) {
        if (error) {
        }
    }];
}

#pragma mark - 提交
- (void)submit:(NSString *)title {
    __weak typeof(self) weakSelf = self;
    PassViewController *vc = [[UIStoryboard storyboardWithName:@"Flow" bundle:nil] instantiateViewControllerWithIdentifier:@"pass"];
    vc.instanceId = self.model.instId;
    vc.bizKey = self.model.processCode;
    vc.checkTitle = title;
    vc.taskId = self.taskId;
    vc.url = pass;
    vc.title = [NSString stringWithFormat:@"%@-%@", self.model.name, title];
    vc.callBack = ^(BOOL success) {
        weakSelf.submitSuccess = success;
    };
    [self.navigationController pushViewController:vc animated:YES];
}

@end
