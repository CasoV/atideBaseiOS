//
//  SupervisionPunishmentFlowController.m
//  ycxm
//
//  Created by 末末班车 on 2020/3/19.
//  Copyright © 2020 末末班车. All rights reserved.
//

#import "WebFlowBaseViewController.h"
#import "WeakScriptMessageDelegate.h"
#import "SupervisionPunishmentDetailController.h"
#import "FlowApprovalCommentView.h"
#import "ApiGeneralManagement.h"
#import "PassViewController.h"
#import "UIView+BorderLine.h"
#import "HandleController.h"
#import "DocumentTabView.h"
#import "FilesScanView.h"
#import "HandleModel.h"
#import "ApiUpload.h"
#import "FlowApprovalToolBar.h"
#import <YTKNetwork/YTKNetwork.h>
#import <WebKit/WebKit.h>
#import "Panel.h"
#import "UserTaskModel.h"

#define tabHeight 40
#define bottomHeight 40

@interface WebFlowBaseViewController ()<UIScrollViewDelegate, WKNavigationDelegate, WKUIDelegate, WKScriptMessageHandler>

@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, strong) UIScrollView *commentScrollView;

@property (nonatomic, strong) FilesScanView *annexFV;

@property (nonatomic, copy) NSArray <Panel *>*toolBarDatas;

@property (nonatomic, copy) NSString *bizKey;

@property (nonatomic, assign) BOOL haveSave;

@property (nonatomic, copy) NSString *ID;

@property (nonatomic, strong) WKWebView *webView;

@property (nonatomic, strong) UIProgressView *progressView;

@property (nonatomic, copy) NSString *mTaskId;

@end

@implementation WebFlowBaseViewController {
    SupervisionPunishmentDetailController *_detailVc;
    HandleController *_handleVC;
    DocumentTabView *_tabView;
    UIView *_toolView;
    
    YTKBatchRequest *_batchRequest;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.ID = self.id;
    self.bizKey = @"DETECT_TEST_BASIC_INFO";
    [self setupUI];
    [self setupContentView];
    [self getFlowToolbar];
    
//    if(([self.typeUrl isEqualToString:@"sideStationRecord"] || [self.typeUrl isEqualToString:@"tourRecord"]) && self.bizPk){
            [self getTaskId];
//    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationItem.title = self.navTitle;
    self.tabBarController.tabBar.hidden = YES;
    [self getFlowToolbar];
}

#pragma mark - 初始化界面
- (void)setupUI {
    __weak typeof(self) weakSelf = self;
    NSArray *titles;
    titles = @[@"基本信息", @"审核意见", @"办理过程", @"附件信息"];
    _tabView = [[DocumentTabView alloc] initWithFrame:CGRectMake(0, kStatusBarH + kNavBarH, kScreen_Width, tabHeight) titles:titles];
    _tabView.callBack = ^(NSInteger selectIndex) {
        [weakSelf.scrollView setContentOffset:CGPointMake(selectIndex * kScreen_Width, 0) animated:YES];
    };
    [self.view addSubview:_tabView];
    
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, tabHeight + kStatusBarH + kNavBarH, kScreen_Width, kScreen_Height - kStatusBarH - kNavBarH - tabHeight - bottomHeight)];
    _scrollView.contentSize = CGSizeMake(kScreen_Width * titles.count, _scrollView.frame.size.height);
    _scrollView.delegate = self;
    _scrollView.pagingEnabled = YES;
    _scrollView.bounces = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:_scrollView];
    if (IS_IPHONE_X) {
        _scrollView.contentInset = UIEdgeInsetsMake(0, 0, -34, 0);
    }
    
    _toolView = [[UIView alloc] initWithFrame:CGRectMake(0, kScreen_Height - bottomHeight, kScreen_Width, bottomHeight)];
    _toolView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_toolView];
}

- (void)setupContentView {
    //加载第一个视图
    [self initWebView];
    
    //加载第二个视图
    [self setupMidView];
    
    //加载第三个视图
    [self setupHandleView];
    
}

#pragma mark - 初始化webView
- (void)initWebView {
    [self.scrollView addSubview:self.webView];
    [self.scrollView addSubview:self.progressView];
    NSString *userName = [[NSUserDefaults standardUserDefaults] objectForKey:USER_DEFAULT_USER_NAME];
    NSString *password = [[NSUserDefaults standardUserDefaults] objectForKey:USER_DEFAULT_PASSWORD];
    NSMutableString *urlStr = [NSMutableString stringWithString:[UrlConfig URL:temMobile]];
    [urlStr appendFormat:@"%@", self.typeUrl];
    [urlStr appendFormat:@"?projectId=%@", self.projectId];
    [urlStr appendFormat:@"&id=%@", self.ID];
    if(self.mid)[urlStr appendFormat:@"&mid=%@", self.mid];
    [urlStr appendFormat:@"&sectionId=%@", self.sectionId];
    [urlStr appendFormat:@"&user=%@", [userName stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]];
    [urlStr appendFormat:@"&pwd=%@",[password stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]];
    NSURL *url = [urlStr mj_url];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    [self.webView loadRequest:request];
}
#pragma mark - 加载第二个视图
- (void)setupMidView {
    __weak typeof(self) weakSelf = self;
    
    _commentScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(kScreen_Width, 0, kScreen_Width, self.scrollView.frame.size.height)];
    _commentScrollView.contentSize = CGSizeMake(kScreen_Width, 0);
    _commentScrollView.backgroundColor = UIColorBackground;
    _commentScrollView.showsVerticalScrollIndicator = NO;
    _commentScrollView.showsHorizontalScrollIndicator = NO;
    [self.scrollView addSubview:_commentScrollView];
    
    FlowApprovalCommentView *commentView = [[FlowApprovalCommentView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, 0)];
    [commentView request:self.bizPk type:0 callback:^(CGFloat height) {
        weakSelf.commentScrollView.contentSize = CGSizeMake(kScreen_Width, height);
    }];
    [_commentScrollView addSubview:commentView];
}

#pragma mark - 加载第三个视图
- (void)setupHandleView {
    _handleVC = [[HandleController alloc] initWithNibName:@"HandleController" bundle:nil];
    _handleVC.view.frame = CGRectMake(kScreen_Width * 2, 0, kScreen_Width, self.scrollView.frame.size.height);
    _handleVC.view.backgroundColor = UIColorFromRGB(0xDCE2EA);
    [self addChildViewController:_handleVC];
    [self.scrollView addSubview:_handleVC.view];
    
    
    ApiGeneralManagement *api =[[ApiGeneralManagement alloc] initWithRequestParams:@{
                                                                                     @"bizPk":self.bizPk,
                                                                                     @"sectId":[UserAgent DefaultAgent].sectionId,
                                                                                     @"sectionId":self.sectionId,
                                                                                     @"projectId":self.projectId
                                                                                     } flag:HandleHis bizKey:self.bizKey];
    [SVProgressHUD showWithStatus:@"请求中..."];
    
    [api startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        [SVProgressHUD dismiss];
        if ([request resultIsSuccess]) {
            [HandleModel mj_setupObjectClassInArray:^NSDictionary *{
                return @{
                         @"taskAssignees":NSStringFromClass([TaskAssignees class]),
                         @"unFinishTaskAssignees":NSStringFromClass([UnFinishTaskAssignees class]),
                         @"opinions":NSStringFromClass([Opinions class]),
                         };
            }];
            self->_handleVC.data = [HandleModel mj_objectArrayWithKeyValuesArray:request.resultDataArray];
        }
    } failure:nil];
}

#pragma mark - 加载附件视图
- (void)setupAnnex {
    if (self.annexFV) {
        [self.annexFV removeFromSuperview];
        self.annexFV = nil;
    }
    
    CGRect frame = CGRectMake(kScreen_Width * 3 + 5, 0, kScreen_Width - 10, self.scrollView.frame.size.height);

    __weak typeof(self) weakSelf = self;
    self.annexFV = [[FilesScanView alloc] initWithFrame:frame isHandle:self.haveSave];
    self.annexFV.markId = self.ID;
    self.annexFV.annexPushBlock = ^{
//        weakSelf.isAnnexPush = YES;
    };
    
    [self.scrollView addSubview:self.annexFV];
    [self.annexFV updateData];
}


- (void)setHaveSave:(BOOL)haveSave {
    _haveSave = haveSave;
    _detailVc.canEdit = haveSave;
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    NSInteger index = (NSInteger)(scrollView.contentOffset.x / kScreen_Width);
    [_tabView selectBtn:index];
}

#pragma mark - 获取工具栏
- (void)getFlowToolbar {
    [SVProgressHUD showWithStatus:nil];
    __weak typeof(self) weakSelf = self;
    FlowApprovalToolBar *toolBar = [[FlowApprovalToolBar alloc] init];
    [toolBar request:self.bizPk bizKey:self
            .bizKey callback:^(NSArray<Panel *> *items) {
        NSMutableArray<Panel *> *paArr = [NSMutableArray arrayWithArray:items];
        for (Panel *item in paArr) {
            if([item.ID isEqualToString:@"button-submit"]){
                item.content = @"申报";
            }
        }
        [SVProgressHUD dismiss];
        weakSelf.toolBarDatas = items ? items : [NSArray array];
        weakSelf.haveSave = [weakSelf checkSave:items];
        [weakSelf setupAnnex];
        [weakSelf handleToolbarDatas];
        [weakSelf updateUI];
    }];
}

#pragma mark - 判断是否有保存按钮
- (BOOL)checkSave:(NSArray *)tools {
    BOOL save = NO;
    if (tools.count > 0) {
        for (Panel *tool in tools) {
            if ([tool.ID isEqualToString:@"button-save"]) {
                save = YES;
                break;
            }
        }
    }
    
    return save;
}

#pragma mark - 处理toolbar数据
- (void)handleToolbarDatas {
    _toolView.hidden = self.toolBarDatas.count == 0;
    CGRect frame = self.scrollView.frame;
    frame.size.height = self.toolBarDatas.count == 0 ? (kScreen_Height - kStatusBarH - kNavBarH - tabHeight) : (kScreen_Height - kStatusBarH - kNavBarH - tabHeight - bottomHeight);
    self.scrollView.frame = frame;
    for (UIView *view in self.scrollView.subviews) {
        CGRect fra = view.frame;
        fra.size.height = frame.size.height;
        view.frame = fra;
    }
    
    if (self.toolBarDatas.count > 0) {
        [_toolView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        
        CGFloat width = _toolView.frame.size.width / self.toolBarDatas.count;
        CGFloat height = (_toolView.frame.size.height == 0) ? 44 : _toolView.frame.size.height;
        
        for (int j = 0; j < self.toolBarDatas.count; j++) {
            UIButton *bottomItem = [[UIButton alloc] initWithFrame:CGRectMake(j * width, 0, width, height)];
            [bottomItem setTitle:self.toolBarDatas[j].content forState:UIControlStateNormal];
            [bottomItem setTitleColor:UIColorFromRGB(0x0096FF) forState:UIControlStateNormal];
            [bottomItem borderForColor:UIColorGrey_200 borderWidth:1 borderType:UIBorderSideTypeRight];
            bottomItem.titleLabel.font=[UIFont systemFontOfSize:12];
            bottomItem.tag = j + 100;
            [bottomItem addTarget:self action:@selector(bottomAction:) forControlEvents:UIControlEventTouchUpInside];
            [_toolView addSubview: bottomItem];
        }
        
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectZero];
        lineView.backgroundColor = UIColorGrey_200;
        [_toolView addSubview:lineView];
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.equalTo(self->_toolView);
            make.height.equalTo(@0.5);
        }];
    }
}

#pragma mark - 工具栏点击
- (void)bottomAction:(UIButton *)sender {
    Panel *item = self.toolBarDatas[sender.tag - 100];
    
    if ([item.ID isEqualToString:@"button-save"]) {
        if ([_detailVc verify]) {
//            [self save:[_detailVc params]];
        }
    } else if ([item.ID isEqualToString:@"button-remove"]) {
        __weak typeof(self) weakSelf = self;
        UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"删除提示" message:@"确定要删除吗？" preferredStyle:UIAlertControllerStyleAlert];
        [alertC addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [weakSelf deleteData];
        }]];
        [alertC addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
        [self presentViewController:alertC animated:YES completion:nil];
    } else if ([item.ID isEqualToString:@"button-submit"] || [item.ID isEqualToString:@"button-pass"]) {
        PassViewController *vc = [[UIStoryboard storyboardWithName:@"Flow" bundle:nil] instantiateViewControllerWithIdentifier:@"pass"];
//        if(![self.typeUrl isEqualToString:@"sideStationRecord"] && ![self.typeUrl isEqualToString:@"tourRecord"]){
//            vc.finalUrl = [UrlConfig URL:qualityRecordCompleteTask];
//        }else{
            vc.taskId = self.mTaskId;
//        }
        
        vc.instanceId = self.bizPk;
        vc.bizKey = self.bizKey;
        vc.url = pass;
        vc.callBack = ^(BOOL success) {
            if(success){
//                if([self.typeUrl isEqualToString:@"sideStationRecord"] || [self.typeUrl isEqualToString:@"tourRecord"]){
                        [self getStatus];
//                }
                return;
            }
            [SVProgressHUD showErrorWithStatus:@"通过操作失败！"];
        };
        if ([item.ID isEqualToString:@"button-submit"]) {
            vc.title = [NSString stringWithFormat:@"%@-提交",self.navTitle];
        } else {
            vc.title = [NSString stringWithFormat:@"%@-通过",self.navTitle];
        }
        [self.navigationController pushViewController:vc animated:YES];
    } else if ([item.ID isEqualToString:@"page-reject"]) {
        PassViewController *vc = [[UIStoryboard storyboardWithName:@"Flow" bundle:nil] instantiateViewControllerWithIdentifier:@"pass"];
        vc.finalUrl = [UrlConfig URL:qualityRecordRejectTask];
        vc.instanceId = self.bizPk;
        vc.bizKey = self.bizKey;
        vc.url = reject;
        vc.title = [NSString stringWithFormat:@"%@-退回",self.navTitle];
        vc.callBack = ^(BOOL success) {
            if(success){
                if(success){
//                    if([self.typeUrl isEqualToString:@"sideStationRecord"] || [self.typeUrl isEqualToString:@"tourRecord"]){
                            [self getStatus];
//                    }
                }
                return;
            }
            [SVProgressHUD showErrorWithStatus:@"通过操作失败！"];
        };
        [self.navigationController pushViewController:vc animated:YES];
        
    } else if ([item.ID isEqualToString:@"button-revoke"]) {
        __weak typeof(self) weakSelf = self;
        UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"撤回提示" message:@"确定要撤回吗？" preferredStyle:UIAlertControllerStyleAlert];
        [alertC addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [weakSelf revoke];
        }]];
        [alertC addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
        [self presentViewController:alertC animated:YES completion:nil];
    } else {
        [SVProgressHUD showInfoWithStatus:@"暂无法处理该操作!"];
    }
}



#pragma mark - 保存文件
- (void)saveFiles:(NSString *)markId {
    NSMutableArray <BIMFile *>*files = [NSMutableArray array];
    [files addObjectsFromArray:[self.annexFV addFiles]];
    if (files.count == 0) {
        [SVProgressHUD showSuccessWithStatus:@"保存成功!"];
    } else {
        if (_batchRequest) {
            [_batchRequest stop];
        }
        
        __weak typeof(self) weakSelf = self;
        NSMutableArray <YTKRequest *>*requests = [NSMutableArray array];
        for (BIMFile *file in files) {
            NSDictionary *params = @{
                                     @"metaData.formId":markId
                                     };
            ApiUpload *api = [[ApiUpload alloc] initWithFile:file params:params];
            api.url = filesUpload;
            [requests addObject:api];
        }
        
        _batchRequest = [[YTKBatchRequest alloc] initWithRequestArray:requests];
        [_batchRequest startWithCompletionBlockWithSuccess:^(YTKBatchRequest * _Nonnull batchRequest) {
            [SVProgressHUD showSuccessWithStatus:@"保存成功!"];

        } failure:^(YTKBatchRequest * _Nonnull batchRequest) {
            [SVProgressHUD showSuccessWithStatus:@"保存成功!"];
        }];
    }
}

#pragma mark - 刷新页面
- (void)updateUI {
    [self updateCommon];
}

- (void)updateCommon {
        [self.commentScrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        
        __weak typeof(self) weakSelf = self;
        FlowApprovalCommentView *commentView = [[FlowApprovalCommentView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, 0)];
        [commentView request:self.bizPk type:0 callback:^(CGFloat height) {
            weakSelf.commentScrollView.contentSize = CGSizeMake(kScreen_Width, height);
        }];
        [self.commentScrollView addSubview:commentView];
        
        ApiGeneralManagement *api =[[ApiGeneralManagement alloc] initWithRequestParams:@{
                                                                                         @"bizPk":self.bizPk,
                                                                                         @"sectId":self.sectionId,
                                                                                         @"sectionId":self.sectionId,
                                                                                         @"projectId":self.projectId
                                                                                         } flag:HandleHis bizKey:self.bizKey];
        [api startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
            if ([request resultIsSuccess]) {
                [HandleModel mj_setupObjectClassInArray:^NSDictionary *{
                    return @{
                             @"taskAssignees":NSStringFromClass([TaskAssignees class]),
                             @"unFinishTaskAssignees":NSStringFromClass([UnFinishTaskAssignees class]),
                             @"opinions":NSStringFromClass([Opinions class]),
                             };
                }];
                self->_handleVC.data = [HandleModel mj_objectArrayWithKeyValuesArray:request.resultDataArray];
            }
        } failure:nil];
    
    
    if (self.annexFV) {
        [self.annexFV updateData];
    }
}

#pragma mark - 删除
- (void)deleteData {
    __weak typeof(self) weakSelf = self;
    [SVProgressHUD showWithStatus:@"删除中"];
    NSString *url = [NSString stringWithFormat:@"%@/%@", [UrlConfig URL:qualityRecord], self.ID];
    [[HttpManager manager] del:url param:nil success:^(NSData *data) {
        if ([ResponseUtils success:data]) {
            [SVProgressHUD showSuccessWithStatus:@"删除成功!"];
            [weakSelf.navigationController popViewControllerAnimated:YES];
        } else {
            [SVProgressHUD showErrorWithStatus:[ResponseUtils getMsg]];
        }
    } faild:^(NSString *msg) {
        [SVProgressHUD showErrorWithStatus:msg];
    }];
}

#pragma mark - 撤回
- (void)revoke {
    __weak typeof(self) weakSelf = self;
    [SVProgressHUD showWithStatus:@"撤回中"];
    NSString *url = [UrlConfig URL:qualityRecordRevokeTask];
    NSDictionary *params = @{
        @"bizPk":self.bizPk,
        @"comment":@"撤回",
        @"flowType":@"finish"
    };
    
    [[HttpManager manager] post:url param:params success:^(NSData *data) {
        if ([ResponseUtils success:data]) {
            [SVProgressHUD showSuccessWithStatus:@"撤回成功!"];
//            if([self.typeUrl isEqualToString:@"sideStationRecord"] || [self.typeUrl isEqualToString:@"tourRecord"]){
                    [weakSelf getStatus];
//                return;
//            }
//            [weakSelf getFlowToolbar];
        } else {
            [SVProgressHUD showErrorWithStatus:[ResponseUtils getMsg]];
        }
    } faild:^(NSString *msg) {
        [SVProgressHUD showErrorWithStatus:msg];
    } headers:@{
        @"flow-token":@"REVOKE"
    }];
}
#pragma mark - 懒加载
- (WKWebView *)webView {
    if (!_webView) {
        WKWebViewConfiguration*config = [[WKWebViewConfiguration alloc]init];
        config.selectionGranularity = WKSelectionGranularityCharacter;
        _webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, self.scrollView.frame.size.height) configuration:config];
        _webView.UIDelegate = self;
        _webView.navigationDelegate = self;
        [_webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
        [_webView.configuration.userContentController addScriptMessageHandler:[[WeakScriptMessageDelegate alloc] initWithDelegate:self] name:@"toIOS"];
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


#pragma mark - 销毁
- (void)dealloc {
    [_batchRequest stop];
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
    [_batchRequest stop];
}

#pragma mark - WKScriptMessageHandler
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message {
    if ([message.name isEqualToString:@"toIOS"]) {
        NSDictionary *dic = [message.body mj_JSONObject];
        NSNumber *success = dic[@"success"];
        if (success.boolValue) {
            NSDictionary *data = dic[@"data"];
            [self saveFiles:data[@"id"]];
        } else {
            [SVProgressHUD showErrorWithStatus:dic[@"message"]];
        }
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
#pragma mark - 获取状态
- (void)getStatus {
    [[HttpManager manager] get:[UrlConfig URL:getInstBizByBizPk] param:@{@"bizPk": self.bizPk} success:^(NSData *data) {
        if ([ResponseUtils success:data]) {
            NSDictionary *dic  = [data mj_JSONObject];
            [self updateStatus:dic[@"data"][@"status"]];
        }
    } faild:^(NSString *msg) {
        [SVProgressHUD showErrorWithStatus:msg];
    }];
}

#pragma mark - 同步更新状态
- (void)updateStatus:(NSString *)status {
    NSString *url = @"";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if( [self.typeUrl isEqualToString:@"tourRecord"]){
        url = [UrlConfig URL:patrolInspectRecordSave];
        [params setValue:self.id forKey:@"id"];
        [params setValue:status forKey:@"status"];
        [[HttpManager manager]jsonPost:url param:params success:^(NSData *data) {
            [self.navigationController popViewControllerAnimated:YES];
        } faild:^(NSString *msg) {
            [SVProgressHUD showErrorWithStatus:msg];
        }];
        return;
    }
    if( [self.typeUrl isEqualToString:@"sideStationRecord"]){
        url = [UrlConfig URL:saveSideStationRecord];
        [params setValue:self.id forKey:@"id"];
        [params setValue:status forKey:@"status"];
        [[HttpManager manager]jsonPost:url param:params success:^(NSData *data) {
            [self.navigationController popViewControllerAnimated:YES];
        } faild:^(NSString *msg) {
            [SVProgressHUD showErrorWithStatus:msg];
        }];
        return;
    }
    if ([self.typeUrl isEqualToString:@"constructionLog"]){
        url = [UrlConfig URL:updateStatuV2];
        url = [NSString stringWithFormat:@"%@?instId=%@",url
               ,self.bizPk];
        [params setValue:@"QUALITY_RZ_SGRZ" forKey:@"table"];
        [params setValue:status forKey:@"statu"];
    }else{
        url = [UrlConfig URL:updateStatuV2];
        url = [NSString stringWithFormat:@"%@?instId=%@",url
               ,self.bizPk];
        [params setValue:@"QUALITY_RZ_JLRZ" forKey:@"table"];
        [params setValue:status forKey:@"statu"];
    }
    [[HttpManager manager]post:url param:params success:^(NSData *data) {
        [self.navigationController popViewControllerAnimated:YES];
    } faild:^(NSString *msg) {
        [SVProgressHUD showErrorWithStatus:msg];
    }];
   
}



#pragma mark - 获取taskId
- (void)getTaskId {
    NSString *url = [UrlConfig URL:queryUserTask];
    NSDictionary *params = @{
        @"bizPk": self.bizPk,
        @"userId": [AppUser sharedInstance].userId,
        @"forward": @"0"
    };
    [[HttpManager manager] get:url param:params success:^(NSData *data) {
        NSArray <UserTaskModel *>*datas = [UserTaskModel mj_objectArrayWithKeyValuesArray:data];
        if (datas.count >= 2) {
            self.mTaskId = datas[0].id;
//            if (datas[0].endTime == nil) {
//                self.mTaskId = datas[1].id;
//            }
        } else if (datas.count == 1) {
            self.mTaskId = datas[0].id;
        }
    } faild:^(NSString *msg) {
        [SVProgressHUD showErrorWithStatus:msg];
    }];
}

@end
