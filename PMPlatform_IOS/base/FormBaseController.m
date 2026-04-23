//
//  FormBaseController.m
//  ycxm
//
//  Created by 高小伟 on 2020/7/2.
//  Copyright © 2020 末末班车. All rights reserved.
//

#import "FormBaseController.h"
#import "WeakScriptMessageDelegate.h"
#import "NSDate+Timestamp.h"
#import "DocumentTabView.h"
#import "FilesScanView.h"
#import "ApiUpload.h"
#import <YTKNetwork/YTKNetwork.h>
#import "PopoverView.h"
#import "NSString+encryptionMD5.h"
#import "PassViewController.h"
#import "PentahoPageViewController.h"

#define tabHeight 40


@interface FormBaseController ()<UIScrollViewDelegate, WKNavigationDelegate, WKUIDelegate, WKScriptMessageHandler>

@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, strong) DocumentTabView *tabView;

@property (nonatomic, strong) UIProgressView *progressView;

@property (nonatomic, strong) FilesScanView *annexFV;

//@property (nonatomic, strong) IFlyHelper *iflyHelper;

@end

@implementation FormBaseController {
    YTKBatchRequest *_batchRequest;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setupUI];
    [self setupContentView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.navigationItem.title = self.resourceTitle;

}

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
        
        //督查督办查看
        BOOL isHandle = YES;
        if([self.urlStr rangeOfString:@"userViewMsgLine"].location != NSNotFound || [self.urlStr rangeOfString:@"taskViewMsg"].location != NSNotFound){
            isHandle = false;
        }
        _annexFV = [[FilesScanView alloc] initWithFrame:CGRectMake(kScreen_Width + 5, 0, kScreen_Width - 10, self.scrollView.frame.size.height) isHandle:isHandle];
        _annexFV.isHandle = !self.isReadOnly;
        _annexFV.annexPushBlock = ^{
//            weakSelf.isAnnexPush = YES;
        };
    }
    return _annexFV;
}
-(void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
NSString *injectionJSString = @"var script = document.createElement('meta');"
"script.name = 'viewport';"
"script.content='width=device-width, user-scalable=no';"
"document.getElementsByTagName('head')[0].appendChild(script);";
[webView evaluateJavaScript:injectionJSString completionHandler:nil];
}

#pragma mark - 初始化界面
- (void)setupUI {
    [self.view addSubview:self.tabView];
    
    [self.view addSubview:self.scrollView];
}

#pragma mark - 初始化内容界面
- (void)setupContentView {
    //加载第一个视图
    [self initWebView];
    
    //加载附件
    if (self.attachment) {
        [self.scrollView addSubview:self.annexFV];
    
        if (self.markId) {
            self.annexFV.markId = self.markId;
            [self.annexFV updateData];
        } else {
            [self.annexFV setDefault];
        }
    }
    //    右上方按钮
    if(_isReadOnly){
        return;
    }
    if(_justReport){
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"报表" style:UIBarButtonItemStylePlain target:self action:@selector(report)];
        return;
    }
    if(_hasReport){
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"icon_add"] style:UIBarButtonItemStylePlain target:self action:@selector(rightClicked:)];
            return;
    }
    if( [self.urlStr rangeOfString:@"sendMsg"].location != NSNotFound || [self.urlStr rangeOfString:@"taskViewMsg"].location != NSNotFound || (([self.resourceTitle isEqualToString:@"检查记录"] ||[self.resourceTitle isEqualToString:@"整改通知"]) && _markId) || (([self.resourceTitle isEqualToString:@"施工日志"] ||[self.resourceTitle isEqualToString:@"监理日志"])&& _entityId)
       ){
         self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"icon_add"] style:UIBarButtonItemStylePlain target:self action:@selector(rightClicked:)];
    }else if( [self.urlStr rangeOfString:@"userViewMsgLine"].location == NSNotFound ){
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(save)];
    }
    
//    self.iflyHelper = [[IFlyHelper alloc] initWithView:self.view delegate:self];
}

#pragma mark - 点击事件
- (void)rightClicked:(UIBarButtonItem *)sender {
    __weak typeof(self) weakSelf = self;
    NSMutableArray <PopoverAction *>*actionArr = [NSMutableArray array];
    NSArray *titles = @[@"保存", @"提交"];
    if(_hasReport){
        titles = @[@"保存", @"报表"];
    }
    if(_hasReport && _hasSubmit){
        titles = @[@"保存", @"提交",@"报表"];
    }
    if ([self.urlStr rangeOfString:@"sendMsgNew"].location != NSNotFound) {
        titles = @[@"保存并发送",@"存草稿"];
    } else if([self.urlStr rangeOfString:@"sendMsg"].location != NSNotFound) {
        titles = @[@"发送",@"存草稿"];
    }
    if ([self.urlStr rangeOfString:@"taskViewMsg"].location != NSNotFound) {
        if (self.showComplete) {
            titles = @[@"督查记录",@"完成"];
        } else {
            titles = @[@"督查记录"];
        }
    }
    if ([self.resourceTitle isEqualToString:@"施工日志"] ||[self.resourceTitle isEqualToString:@"监理日志"]) {
        titles = @[@"保存", @"进入流程"];
    }
    for (NSString *title in titles) {
        PopoverAction *action = [PopoverAction actionWithTitle:title handler:^(PopoverAction *action) {
            if ([title isEqualToString:@"保存"] || [title isEqualToString:@"发送"] || [title isEqualToString:@"保存并发送"]) {
                [weakSelf save];
            } else if ([title isEqualToString:@"提交"]) {
                [weakSelf submit];
            }else if([title isEqualToString:@"存草稿"]){
                [weakSelf saveDraft];
            }else if([title isEqualToString:@"报表"]){
                [weakSelf report];
            } else if ([title isEqualToString:@"进入流程"]) {
                [weakSelf createFlow];
            } else if ([title isEqualToString:@"督查记录"]) {
                [weakSelf goReplyMsg:@"0"];
            } else if ([title isEqualToString:@"完成"]) {
                [weakSelf goReplyMsg:@"1"];
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
-(void)report{
    PentahoPageViewController *vc = [PentahoPageViewController new];
    vc.treeCode = self.treeCode;
    vc.otherInfo = self.otherInfo;
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)createFlow {
    NSString *url = [UrlConfig URL:sgrzCreatProcess];
    if ([self.resourceTitle isEqualToString:@"监理日志"]) {
        url = [UrlConfig URL:jlrzCreatProcess];
    }
    [SVProgressHUD showWithStatus:@"操作进行中..."];
    __weak typeof(self) weakSelf = self;
    [[HttpManager manager] get:url param:@{
        @"id": self.markId,
        @"_": [self currentTimeStr]
    } success:^(NSData *data) {
        [SVProgressHUD showSuccessWithStatus:@"进入流程成功!"];
        [weakSelf.navigationController popViewControllerAnimated:YES];
    } faild:^(NSString *msg) {
        [SVProgressHUD dismiss];
    }];
}
-(void)submit{
    [SVProgressHUD showWithStatus:@"加载中..."];
    if( [self.urlStr rangeOfString:@"mainMechanical"].location != NSNotFound){
        PassViewController *vc = [[UIStoryboard storyboardWithName:@"Flow" bundle:nil] instantiateViewControllerWithIdentifier:@"pass"];
        vc.instanceId = self.markId;
        vc.bizKey = @"";
        vc.checkTitle = @"提交";
        if([self.treeCode isEqualToString:@"ME_ENTER_LEAVE"]){
            vc.bizUrl = @"mechanical/meEnterLeave";
        }else{
            vc.bizUrl = @"mechanical/meMechanics";
        }
        vc.url = pass;
        vc.title = [NSString stringWithFormat:@"%@-提交",self.resourceTitle];;
        vc.callBack = ^(BOOL success) {
            if(success){
                [self.navigationController popViewControllerAnimated:YES];
            }
            [SVProgressHUD showErrorWithStatus:@"通过操作失败！"];
        };
        [self.navigationController pushViewController:vc animated:YES];
        return;
    }
    if(self.entityId){
        [self mergeTemplates:self.entityId];
    }else{
        [self getEntity];
    }
    
}
-(void)getEntity{
    [SVProgressHUD showWithStatus:@"加载中..."];
    [[HttpManager manager]post:[UrlConfig URL:getTableExcelId] param:nil success:^(NSData *data) {
        NSDictionary *dic = [data mj_JSONObject];
        NSString *entityId = dic[self.entityName];
        [self mergeTemplates:entityId];
    } faild:^(NSString *msg) {
        [SVProgressHUD dismiss];
    }];
}
#pragma mark - 未填写表单需进行操作1
- (void)mergeTemplates:(NSString *)entityId {
    NSString *projectId = [UserAgent DefaultAgent].projectId ? [UserAgent DefaultAgent].projectId : @"";
    NSString *projectCode = [UserAgent DefaultAgent].projectCode ? [UserAgent DefaultAgent].projectCode : @"";
    NSString *sectionId = [UserAgent DefaultAgent].sectionId ? [UserAgent DefaultAgent].sectionId : @"";
    NSString *sectionCode = [UserAgent DefaultAgent].sectionCode ? [UserAgent DefaultAgent].sectionCode : @"";
    
    NSString *url = [UrlConfig URL:mergeTemplates];
    NSString *reportCode = [NSString stringWithFormat:@"%@%@", @"tdr-partCode-", [NSDate nowDateStringYYMMddHHmmss]];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:@(YES) forKey:@"hasFlow"];
    [params setObject:_entityName forKey:@"name"];
    [params setObject:@"999999" forKey:@"categoryId"];
    [params setObject:@{
        @"reportName": _entityName,
        @"reportCode": [NSString stringMD5:reportCode]
    } forKey:@"extJson"];
    [params setObject:@{
        @"partCode": ([UserAgent DefaultAgent].sectionCode ? [UserAgent DefaultAgent].sectionCode : @"")
    } forKey:@"jsonBizProps"];
    [params setObject:@[@{
        @"isFlow": @"1",
        @"sheetName": _entityName,
        @"bizId": entityId
    }] forKey:@"files"];
    [params setObject:@{
        @"own_project_id": projectId,
        @"own_project_code": projectCode,
        @"own_section_id": sectionId,
        @"own_section_code": sectionCode
    } forKey:@"variablesJson"];
    
    [[HttpManager manager] jsonPost:url param:params success:^(NSData *data) {
        if ([ResponseUtils success:data]) {
            NSDictionary *dic = [ResponseUtils getData:@"data"];
            [self getTableInfo:dic[@"bizId"]];
        } else {
            [SVProgressHUD showErrorWithStatus:[ResponseUtils getMsg]];
        }
    } faild:^(NSString *msg) {
        [SVProgressHUD showErrorWithStatus:msg];
    }];
}

#pragma mark - 未填写表单需进行操作2
-(void)getTableInfo:(NSString *)bizPk{
    [[HttpManager manager]post:[UrlConfig URL:safecheckTableInfo] param:@{
        @"id":self.markId,
        @"table":_tableName,
        @"instId":bizPk
    } success:^(NSData *data) {
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        [dic setValue:self->_entityName forKey:@"entityName"];
        [dic setValue:[data mj_JSONObject] forKey:@"fields"];
        [self callFillOds:bizPk params:dic];
    } faild:^(NSString *msg) {
        [SVProgressHUD dismiss];
    }];
}
-(void)callFillOds:(NSString *)bizPk params:(NSDictionary *)params{
    [[HttpManager manager]jsonPost: [NSString stringWithFormat:@"%@%@",[UrlConfig URL:developEntity],bizPk] param:params success:^(NSData *data) {
        if ([ResponseUtils success:data]) {
            
            if([self.navigationItem.title containsString:@"日志"]){
                [SVProgressHUD dismiss];
                //日志审核需要生成pdf
                PassViewController *vc = [[UIStoryboard storyboardWithName:@"Flow" bundle:nil] instantiateViewControllerWithIdentifier:@"pass"];
                vc.finalUrl = nil;
                vc.instanceId = bizPk;
                vc.bizKey = @"DETECT_TEST_BASIC_INFO";
                vc.useJsonParams = YES;
                vc.url = pass;
                vc.title = [NSString stringWithFormat:@"%@-提交",self.navigationItem.title];
                vc.callBack = ^(BOOL success) {
                    if (success) {
                        [SVProgressHUD showWithStatus:@"加载中..."];
                        [self getStatus:bizPk];
                    }
                };
                [self.navigationController pushViewController:vc animated:YES];
                
            }else{
                [SVProgressHUD showSuccessWithStatus:@"保存成功!"];
                if (self.saveSuccess) {
                    self.saveSuccess();
                }
                [self.navigationController popViewControllerAnimated:YES];
            }
            
        } else {
            [SVProgressHUD showErrorWithStatus:[ResponseUtils getMsg]];
        }
    } faild:^(NSString *msg) {
        [SVProgressHUD showErrorWithStatus:msg];
    }];
}
#pragma mark - 获取状态
- (void)getStatus:(NSString *)bizPk {
    [[HttpManager manager] get:[UrlConfig URL:getInstBizByBizPk] param:@{@"bizPk":bizPk} success:^(NSData *data) {
        if ([ResponseUtils success:data]) {
            NSDictionary *dic  = [data mj_JSONObject];
            [self updateStatus:bizPk status:dic[@"data"][@"status"]];
        }
    } faild:^(NSString *msg) {
        [SVProgressHUD showErrorWithStatus:msg];
    }];
}

#pragma mark - 同步更新状态
- (void)updateStatus:(NSString *)bizPk  status:(NSString *)status{
    [[HttpManager manager]post: [NSString stringWithFormat:@"%@?instId=%@",[UrlConfig URL:updateStatuV2]
                                 ,bizPk] param: @{
                                     @"table":_entityName,
                                     @"statu":status
                                 } success:^(NSData *data) {
        [SVProgressHUD showSuccessWithStatus:@"提交成功!"];
        [self.navigationController popViewControllerAnimated:YES];
    } faild:^(NSString *msg) {
        [SVProgressHUD showErrorWithStatus:msg];
    }];
}
#pragma mark - 初始化webView
- (void)initWebView {
    [self.scrollView addSubview:self.webView];
    [self.scrollView addSubview:self.progressView];

    NSURL *url = [self.urlStr mj_url];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [self.webView loadRequest:request];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    NSInteger index = (NSInteger)(scrollView.contentOffset.x / kScreen_Width);
    if (self.attachment) {
        [self.tabView selectBtn:index];
    }
}

#pragma mark - 保存
- (void)save {
    if(!_hidenLoading){
        [SVProgressHUD showWithStatus:@"保存中"];
    }
    [self.webView evaluateJavaScript:[NSString stringWithFormat:@"save()"] completionHandler:^(id result, NSError * _Nullable error) {
        if (error) {
        }
    }];
}
-(void)saveDraft{
    [SVProgressHUD showWithStatus:@"保存中"];
    [self.webView evaluateJavaScript:[NSString stringWithFormat:@"save(2)"] completionHandler:^(id result, NSError * _Nullable error) {
        if (error) {
        }
    }];
}

#pragma mark - 保存文件
- (void)saveFiles:(NSString *)markId {
    NSMutableArray <BIMFile *>*files = [NSMutableArray array];
    [files addObjectsFromArray:[self.annexFV addFiles]];
    if (files.count == 0) {
        [SVProgressHUD showSuccessWithStatus:@"保存成功!"];
        if (self.saveSuccess) {
            self.saveSuccess();
        }
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
            if (self.saveSuccess) {
                self.saveSuccess();
            }
            [weakSelf.navigationController popViewControllerAnimated:YES];
        } failure:^(YTKBatchRequest * _Nonnull batchRequest) {
            [SVProgressHUD showSuccessWithStatus:@"保存成功!"];
            if (self.saveSuccess) {
                self.saveSuccess();
            }
            [weakSelf.navigationController popViewControllerAnimated:YES];
        }];
    }
}

#pragma mark - 督查督办完成
- (void)goReplyMsg:(NSString *)isCompleted {
    NSString *userName = [[NSUserDefaults standardUserDefaults] objectForKey:@"user"];
    NSString *password = [[NSUserDefaults standardUserDefaults] objectForKey:USER_DEFAULT_PASSWORD];
    NSMutableString *urlStr = [NSMutableString stringWithString:[UrlConfig URL:replyMsgNew]];
    [urlStr appendFormat:@"?mainId=%@",self.mId];
    [urlStr appendFormat:@"&isCompleted=%@", isCompleted];
    [urlStr appendFormat:@"&user=%@", [userName stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]];
    [urlStr appendFormat:@"&pwd=%@", [password stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]];
    
    __weak typeof(self) weakSelf = self;
    FormBaseController *vc = [FormBaseController new];
    vc.urlStr = urlStr;
    vc.resourceTitle = @"督查记录";
    vc.attachment = YES;
    vc.saveSuccess = ^{
        [weakSelf.webView reload];
    };
    [self.navigationController pushViewController:vc animated:YES];
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
            NSDictionary *data = dic[@"data"];
            if([self.resourceTitle isEqualToString:@"选择期数"] || [data isKindOfClass:[NSNull class]] ){
                [SVProgressHUD showSuccessWithStatus:@"保存成功!"];
                [self.navigationController popViewControllerAnimated:YES];
                return;
            }
            NSString *fileld = [data.allKeys containsObject:@"reportId"]?data[@"reportId"]:data[@"id"];
            if([self.resourceTitle isEqualToString:@"影像资料"]){
                fileld = [data.allKeys containsObject:@"datumId"]?data[@"datumId"]:data[@"id"];
            }else if([self.resourceTitle isEqualToString:@"督查督办"]){
                fileld = data[@"noticeId"];
            }else if([self.resourceTitle isEqualToString:@"消息中心"]){
                fileld = data[@"replyId"];
            }else if([self.resourceTitle isEqualToString:@"外委试验详情"]){
                fileld = data[@"ID"];
            }
            if(self.attachment){
                [self saveFiles:fileld];
            }else{
                [SVProgressHUD showSuccessWithStatus:@"保存成功!"];
                if (self.saveSuccess) {
                    self.saveSuccess();
                }
                [self.navigationController popViewControllerAnimated:YES];
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

//获取当前时间戳
- (NSString *)currentTimeStr{
    NSDate* date = [NSDate dateWithTimeIntervalSinceNow:0];//获取当前时间0秒后的时间
    NSTimeInterval time=[date timeIntervalSince1970]*1000;// *1000 是精确到毫秒，不乘就是精确到秒
    NSString *timeString = [NSString stringWithFormat:@"%.0f", time];
    return timeString;
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
