//
//  FormBase1Controller.m
//  ycxm
//
//  Created by 高小伟 on 2021/4/19.
//  Copyright © 2021 末末班车. All rights reserved.
//

#import "FormBase1Controller.h"
#import "WeakScriptMessageDelegate.h"
#import "NSDate+Timestamp.h"
#import "DocumentTabView.h"
#import "FilesScanView.h"
#import "ApiUpload.h"
#import <YTKNetwork/YTKNetwork.h>
#import <WebKit/WebKit.h>
#import "ToolBar.h"
#import "PopoverAction.h"
#import "PopoverView.h"
#import "PassViewController.h"
#import "UserTaskModel.h"

#define tabHeight 40

@interface FormBase1Controller ()<UIScrollViewDelegate, WKNavigationDelegate, WKUIDelegate, WKScriptMessageHandler>

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) DocumentTabView *tabView;
@property (nonatomic, strong) WKWebView *webView;
@property (nonatomic, strong) UIProgressView *progressView;
@property (nonatomic, strong) FilesScanView *annexFV;
@property (nonatomic, strong) SectionInfo *sectionInfo;
@property (nonatomic, copy) NSArray <ToolBar *>*toolArray;
@property (nonatomic,copy) NSString *mTaskId;
//@property (nonatomic, strong) IFlyHelper *iflyHelper;
@end

@implementation FormBase1Controller {
    YTKBatchRequest *_batchRequest;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setupUI];
    [self setupContentView];
    [self  initWebView];
//    [self loadToolBar];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationItem.title = self.reTitle;
}
#pragma mark - 获取标段信息
//- (void)getSectionInfo {
//    NSString *url = [UrlConfig URL:getSingleContentSectionInfo];
//    NSString *sectionId = [UserAgent DefaultAgent].sectionId ? [UserAgent DefaultAgent].sectionId : @"";
//    __weak typeof(self) weakSelf = self;
//    [[HttpManager manager] post:url param:@{@"sectionId": sectionId} success:^(NSData *data) {
//        if ([ResponseUtils success:data]) {
//            weakSelf.sectionInfo = [SectionInfo mj_objectWithKeyValues:[ResponseUtils getData:@"data"]];
//            [weakSelf initWebView];
//        } else {
//            [SVProgressHUD showErrorWithStatus:[ResponseUtils getMsg]];
//        }
//    } faild:^(NSString *msg) {
//        [SVProgressHUD showErrorWithStatus:msg];
//    }];
//}

#pragma mark - 懒加载
- (DocumentTabView *)tabView {
    if (!_tabView) {
        __weak typeof(self) weakSelf = self;
        NSArray *titles;
        if (self.attachment) {
            titles = @[@"基本信息", @"附件"];
        } else {
            titles = @[@"基本信息"];
        }
        _tabView = [[DocumentTabView alloc] initWithFrame:CGRectMake(0, kStatusBarH + kNavBarH, kScreen_Width, tabHeight) titles:titles];
        _tabView.callBack = ^(NSInteger selectIndex) {
            [weakSelf.scrollView setContentOffset:CGPointMake(selectIndex * kScreen_Width, 0) animated:YES];
        };
        
        if (!self.attachment) {
            _tabView.hidden = YES;
        }
    }
    return _tabView;
}

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        CGRect frame;
        if (self.attachment) {
            frame = CGRectMake(0, tabHeight + kStatusBarH + kNavBarH, kScreen_Width, kScreen_Height - kStatusBarH - kNavBarH - tabHeight);
        } else {
            frame = CGRectMake(0, kStatusBarH + kNavBarH, kScreen_Width, kScreen_Height - kStatusBarH - kNavBarH);
        }
        
        _scrollView = [[UIScrollView alloc] initWithFrame:frame];
        _scrollView.contentSize = CGSizeMake(kScreen_Width * self.tabView.titleCount, _scrollView.frame.size.height);
        _scrollView.delegate = self;
        _scrollView.pagingEnabled = YES;
        _scrollView.bounces = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        
        if (IS_IPHONE_X) {
            _scrollView.contentInset = UIEdgeInsetsMake(0, 0, -34, 0);
        }
    }
    return _scrollView;
}

- (WKWebView *)webView {
    if (!_webView) {
        WKWebViewConfiguration*config = [[WKWebViewConfiguration alloc]init];
        config.selectionGranularity = WKSelectionGranularityCharacter;
        _webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, self.scrollView.frame.size.height) configuration:config];
        _webView.UIDelegate = self;
        _webView.navigationDelegate = self;
        [_webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
        [_webView.configuration.userContentController addScriptMessageHandler:[[WeakScriptMessageDelegate alloc] initWithDelegate:self] name:@"toIOS"];
        [_webView.configuration.userContentController addScriptMessageHandler:[[WeakScriptMessageDelegate alloc] initWithDelegate:self] name:@"voiceClick"];
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

- (FilesScanView *)annexFV {
    if (!_annexFV) {
//        __weak typeof(self) weakSelf = self;
        _annexFV = [[FilesScanView alloc] initWithFrame:CGRectMake(kScreen_Width + 5, 0, kScreen_Width - 10, self.scrollView.frame.size.height) isHandle:YES];
        _annexFV.annexPushBlock = ^{
//            weakSelf.isAnnexPush = YES;
        };
    }
    return _annexFV;
}

#pragma mark - 初始化界面
- (void)setupUI {
    [self.view addSubview:self.tabView];
    [self.view addSubview:self.scrollView];
    //    右上方按钮
    if(_isReadOnly){
        return;
    }
    if(!self.id){
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(save)];
    }else{
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"icon_add"] style:UIBarButtonItemStylePlain target:self action:@selector(rightClicked:)];
    }
   
//    self.iflyHelper = [[IFlyHelper alloc] initWithView:self.view delegate:self];
}
#pragma mark - 保存
- (void)save {
    [SVProgressHUD showWithStatus:@"保存中"];
    [self.webView evaluateJavaScript:[NSString stringWithFormat:@"save()"] completionHandler:^(id result, NSError * _Nullable error) {
        if (error) {
        }
    }];
}

#pragma mark - 初始化内容界面
- (void)setupContentView {
    //加载附件
    if (self.attachment) {
        [self.scrollView addSubview:self.annexFV];
        if (self.id) {
            self.annexFV.markId = self.id;
            [self.annexFV updateData];
        } else {
            [self.annexFV setDefault];
        }
    }
}

#pragma mark - 初始化webView
- (void)initWebView {
    [self.scrollView addSubview:self.webView];
    [self.scrollView addSubview:self.progressView];

    NSMutableString *urlStr = [NSMutableString stringWithString:[UrlConfig URL:temMobile]];
    [urlStr appendFormat:@"%@", self.typeUrl];
    NSString *userName = [[NSUserDefaults standardUserDefaults] objectForKey:USER_DEFAULT_USER_NAME];
    NSString *password = [[NSUserDefaults standardUserDefaults] objectForKey:USER_DEFAULT_PASSWORD];
    [urlStr appendFormat:@"?projectId=%@", [UserAgent DefaultAgent].projectId];
    if (self.id) {
        [urlStr appendFormat:@"/&id=%@", self.id];
    }
    [urlStr appendFormat:@"&sectionId=%@",[UserAgent DefaultAgent].sectionId];
    [urlStr appendFormat:@"&sectionCode=%@",[UserAgent DefaultAgent].sectionCode];
    [urlStr appendFormat:@"&user=%@", [userName stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]];
    [urlStr appendFormat:@"&pwd=%@", [password stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]];
    [urlStr appendFormat:@"&mainSectionName=%@",[UserAgent DefaultAgent].sectionName];
   
    NSURL *url = [urlStr mj_url];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    [self.webView loadRequest:request];
}
#pragma mark - 点击事件
- (void)loadToolBar {
    __weak typeof(self) weakSelf = self;
    if(!self.bizPk){
        return;
    }
    [[HttpManager manager] post:[UrlConfig URL:getFlowToolbar] param:@{@"bizPk":self.bizPk} success:^(NSData *data) {
        if ([ResponseUtils success:data]) {
            weakSelf.toolArray = [ToolBar mj_objectArrayWithKeyValuesArray:[ResponseUtils getData:@"data"]];
            if(weakSelf.toolArray.count >0 ){
                self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"icon_add"] style:UIBarButtonItemStylePlain target:self action:@selector(rightClicked:)];
            }
        } else {
            [SVProgressHUD showErrorWithStatus:[ResponseUtils getMsg]];
            weakSelf.navigationItem.rightBarButtonItem = nil;
        }
    } faild:^(NSString *msg) {
        [SVProgressHUD showErrorWithStatus:msg];
        weakSelf.navigationItem.rightBarButtonItem = nil;
    }];
}
- (void)rightClicked:(UIBarButtonItem *)sender {
    NSMutableArray <PopoverAction *>*actionArr = [NSMutableArray array];
//    for (ToolBar *tool in self.toolArray) {
//        if([tool.name isEqualToString:@"通过"]){
            [self getTaskId];
            PopoverAction *action = [PopoverAction actionWithTitle:self.submitText handler:^(PopoverAction *action) {
//                PassViewController *vc = [[UIStoryboard storyboardWithName:@"Flow" bundle:nil] instantiateViewControllerWithIdentifier:@"pass"];
//                vc.instanceId = self.id;
//                vc.bizKey = @"";
//                vc.checkTitle = self.submitText;
//                vc.taskId = self.mTaskId;
//                vc.url = pass;
//                vc.title = [NSString stringWithFormat:@"%@-%@",self.reTitle,self.submitText];;
//                vc.callBack = ^(BOOL success) {
//                    if(success){
//                        [self getStatus];
//                    }
//                    [SVProgressHUD showErrogetStatusrWithStatus:@"通过操作失败！"];
//                };
//                [self.navigationController pushViewController:vc animated:YES];
                [self submit];
                
            }];
            [actionArr addObject:action];
//        }
//    }
    PopoverAction *action1 = [PopoverAction actionWithTitle:@"保存" handler:^(PopoverAction *action) {
        [SVProgressHUD showWithStatus:@"保存中"];
        [self.webView evaluateJavaScript:[NSString stringWithFormat:@"save()"] completionHandler:^(id result, NSError * _Nullable error) {
            if (error) {
            }
        }];
        
    }];
    [actionArr addObject:action1];
    
    
    
    PopoverView *popoverView = [PopoverView popoverView];
    popoverView.showShade = YES; // 显示阴影背景
    popoverView.style = PopoverViewStyleDark; // 设置为黑色风格
    // 有两种显示方法
    [popoverView showToPoint:CGPointMake(kScreen_Width - 20, kStatusBarH + 44) withActions:actionArr];
}
-(void)submit{
    if([self.typeUrl isEqualToString:@"sideStationRecord"] || [self.typeUrl isEqualToString:@"tourRecord"]){
        NSString *url = [self.typeUrl isEqualToString:@"sideStationRecord"]?[UrlConfig URL:sideStationRecordCommitFlow]:[UrlConfig URL:patrolInspectRecordCommitFlow];
        [SVProgressHUD showWithStatus:nil];
        [[HttpManager manager] jsonPut:[NSString stringWithFormat:@"%@?id=%@",url,self.id] data:nil success:^(NSData *data) {
            [SVProgressHUD dismiss];
            NSDictionary *dic = [data mj_JSONObject];
            if(dic[@"success"]){
                PassViewController *vc = [[UIStoryboard storyboardWithName:@"Flow" bundle:nil] instantiateViewControllerWithIdentifier:@"pass"];
                vc.taskId = self.mTaskId;
                vc.instanceId = dic[@"data"];
                vc.bizKey = @"DETECT_TEST_BASIC_INFO";
                vc.url = pass;
                vc.callBack = ^(BOOL success) {
                    if(success){
                        [self getStatus:dic[@"data"]];
                    }
                    [SVProgressHUD showErrorWithStatus:@"通过操作失败！"];
                };
                vc.title = [NSString stringWithFormat:@"%@-提交",self.reTitle];
                
                [self.navigationController pushViewController:vc animated:YES];
            }
        } faild:^(NSString *msg) {
            [SVProgressHUD dismiss];
        }];
        
        
    }
}


#pragma mark - 获取状态
- (void)getStatus:(NSString *)bizPk {
    [[HttpManager manager] get:[UrlConfig URL:getInstBizByBizPk] param:@{@"bizPk":bizPk} success:^(NSData *data) {
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
    if([self.typeUrl isEqualToString:@"tourRecord"]){
        url = [UrlConfig URL:patrolInspectRecordSave];
        [params setValue:self.id forKey:@"id"];
        [params setValue:status forKey:@"status"];
        [[HttpManager manager]jsonPost:url param:params success:^(NSData *data) {
            [self.navigationController popViewControllerAnimated:YES];
        } faild:^(NSString *msg) {
            [SVProgressHUD showErrorWithStatus:msg];
        }];
        return;
    }else{
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
}
#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    NSInteger index = (NSInteger)(scrollView.contentOffset.x / kScreen_Width);
    if (self.attachment) {
        [self.tabView selectBtn:index];
    }
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
            if (datas[0].endTime == nil) {
                self.mTaskId = datas[1].id;
            }
        } else if (datas.count == 1) {
            self.mTaskId = datas[0].id;
        }
    } faild:^(NSString *msg) {
        [SVProgressHUD showErrorWithStatus:msg];
    }];
}



#pragma mark - 保存文件
- (void)saveFiles:(NSString *)markId {
    NSMutableArray <BIMFile *>*files = [NSMutableArray array];
    [files addObjectsFromArray:[self.annexFV addFiles]];
    if (files.count == 0) {
        [SVProgressHUD showSuccessWithStatus:@"保存成功!"];
        [self.navigationController popViewControllerAnimated:YES];
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
            [weakSelf.navigationController popViewControllerAnimated:YES];
        } failure:^(YTKBatchRequest * _Nonnull batchRequest) {
           
        }];
    }
}

#pragma mark - 销毁
- (void)dealloc {
    [_batchRequest stop];
    [[_webView configuration].userContentController removeScriptMessageHandlerForName:@"toIOS"];
    [[_webView configuration].userContentController removeScriptMessageHandlerForName:@"voiceClick"];
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
        NSDictionary *dic = [message.body mj_JSONObject];
        NSNumber *success = dic[@"success"];
        if (success.boolValue) {
            if(self.attachment){
                NSDictionary *data = dic[@"data"];
                NSString *ID = [data objectForKey:@"id"];
                [self saveFiles:ID];
            }else{
                [SVProgressHUD showSuccessWithStatus:@"保存成功"];
                [self.navigationController  popViewControllerAnimated:YES];
            }
        } else {
            [SVProgressHUD showErrorWithStatus:dic[@"message"]];
        }
    } else if ([message.name isEqualToString:@"voiceClick"]) {
//        [self.iflyHelper speech];
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
-(void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    NSString *injectionJSString = @"var script = document.createElement('meta');"
    "script.name = 'viewport';"
    "script.content='width=device-width, user-scalable=no';"
    "document.getElementsByTagName('head')[0].appendChild(script);";
    [webView evaluateJavaScript:injectionJSString completionHandler:nil];
}

#pragma mark - 语音协议
//- (void)onError:(IFlySpeechError *)error {
//    NSString *result = [self.iflyHelper onError:error];
//    NSString *jsString = [NSString stringWithFormat:@"setVoiceText('%@')", result];
//    [_webView evaluateJavaScript:jsString completionHandler:^(id result, NSError * _Nullable error) {
//        if (error) {
//        }
//    }];
//}
//
//- (void)onResult:(NSArray *)resultArray isLast:(BOOL)isLast {
//    [self.iflyHelper onResult:resultArray isLast:isLast];
//}

@end
