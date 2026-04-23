//
//  QDOriginalRecordController.m
//  HBConstructionApp
//
//  Created by 末末班车 on 2018/4/12.
//  Copyright © 2018年 atide. All rights reserved.
//

#import "QDOriginalRecordController.h"
#import "WeakScriptMessageDelegate.h"
#import <YTKNetwork/YTKNetwork.h>
#import "MeaMidContentPopView.h"
#import <WebKit/WebKit.h>
//#import "AnnexPopView.h"
#import "ApiUpload.h"

@interface QDOriginalRecordController ()<WKNavigationDelegate, WKScriptMessageHandler, WKUIDelegate>

@property (nonatomic, strong) WKWebView *webView;

@property (nonatomic, strong) NSMutableDictionary *baseData;

@property (nonatomic, strong) UIProgressView *progressView;

@property (nonatomic, strong) UIButton *restoreBtn;

@property (nonatomic, copy) NSDictionary *codeDic;

@end

@implementation QDOriginalRecordController {
    NSString *_ssjson;
    NSArray *_approvalArr;
    NSString *_approvalList;
    
    NSHTTPCookie *_cookie;
    
//    AnnexPopView *_popView;
    
    NSArray <BIMFile *>*_files;
    
    YTKBatchRequest *_batchRequest;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [self reload];
    
    NSHTTPCookieStorage *cookieJar = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (NSHTTPCookie *cookie in [cookieJar cookies]) {
        if ([cookie.name isEqualToString:@"SESSION"]) {
            _cookie = cookie;
        }
    }
    
    WKWebViewConfiguration*config = [[WKWebViewConfiguration alloc]init];
    config.selectionGranularity = WKSelectionGranularityCharacter;
    self.webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, 0) configuration:config];
    self.webView.navigationDelegate = self;
    self.webView.UIDelegate = self;
    [self.webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
    [[self.webView configuration].userContentController addScriptMessageHandler:[[WeakScriptMessageDelegate alloc] initWithDelegate:self] name:@"showRestoreBtn"];
    [[self.webView configuration].userContentController addScriptMessageHandler:[[WeakScriptMessageDelegate alloc] initWithDelegate:self] name:@"showMiddleComOrMeaModal"];
    [[self.webView configuration].userContentController addScriptMessageHandler:[[WeakScriptMessageDelegate alloc] initWithDelegate:self] name:@"showFileListModal"];
    
    [self.view addSubview:self.webView];
    [self.view addSubview:self.progressView];
    
    [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.left.right.equalTo(self.view);
    }];
    self.line.hidden = YES;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
//    if (_popView) {
//        _popView.hidden = NO;
//    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
//    if (_popView) {
//        _popView.hidden = YES;
//    }
}

- (void)dealloc {
    [_batchRequest stop];
    [[_webView configuration].userContentController removeScriptMessageHandlerForName:@"showRestoreBtn"];
    [[_webView configuration].userContentController removeScriptMessageHandlerForName:@"showMiddleComOrMeaModal"];
    [[_webView configuration].userContentController removeScriptMessageHandlerForName:@"showFileListModal"];
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

#pragma mark - 懒加载
- (UIProgressView *)progressView {
    if(!_progressView)
    {
        _progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, 1)];
        _progressView.tintColor = [UIColor greenColor];
        _progressView.trackTintColor = [UIColor whiteColor];
    }
    return _progressView;
}

- (UIButton *)restoreBtn {
    if (!_restoreBtn) {
        _restoreBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _restoreBtn.frame = CGRectMake(kScreen_Width - 50, 10, 40, 40);
        _restoreBtn.titleLabel.font = [UIFont systemFontOfSize:13.f];
        _restoreBtn.backgroundColor = UIColorTextBlue;
        _restoreBtn.layer.cornerRadius = 40 / 2;
        _restoreBtn.clipsToBounds = YES;
        _restoreBtn.hidden = YES;
        [_restoreBtn setTitle:@"恢复" forState:UIControlStateNormal];
        [_restoreBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_restoreBtn addTarget:self action:@selector(restoreBtnClicked) forControlEvents:UIControlEventTouchUpInside];
        
        [self.view addSubview:_restoreBtn];
    }
    return _restoreBtn;
}

- (NSDictionary *)codeDic {
    if (!_codeDic) {
        _codeDic = @{
                     @"applicationMaterial?formType=1":@"applicationMaterial",
                     @"applicationMaterial?formType=2":@"applicationMaterial2",
                     @"appMassAcc?val=1":@"appMassAcc",
                     @"appMassAcc?val=2":@"appMassAccB",
                     @"ideaQulityHandle?val=1":@"ideaQulityHandle",
                     @"ideaQulityHandle?val=2":@"ideaQulityHandleB",
                     @"importantApproval?formType=important":@"importantApproval",
                     @"importantApproval?formType=ordinary":@"ordinaryApproval",
                     @"informUrByDay?formType=dayCount":@"dayCount",
                     @"middleComOrMea?formType=1":@"middleComOrMea",
                     @"middleComOrMea?formType=2":@"middleMea",
                     @"orderPauseOrReturn?formType=1":@"orderPauseOrReturn",
                     @"orderPauseOrReturn?formType=2":@"orderReturn",
                     };
    }
    return _codeDic;
}

- (void)restoreBtnClicked {
    [self.webView resignFirstResponder];
    self.restoreBtn.hidden = YES;
    [self.webView evaluateJavaScript:[NSString stringWithFormat:@"restore()"] completionHandler:^(id result, NSError * _Nullable error) {
        if (error) {
       
        }
    }];
}

#pragma mark - WKScriptMessageHandler
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message {
    if ([message.name isEqualToString:@"showRestoreBtn"]) {
        self.restoreBtn.hidden = NO;
    } else if ([message.name isEqualToString:@"showMiddleComOrMeaModal"]) {
        NSDictionary *body = [message.body mj_JSONObject];
        
        MeaMidContentPopView *popView = [[MeaMidContentPopView alloc] init];
        popView.list = body[@"list"];
        popView.partCode = self.partCode;
        popView.content1 = body[@"editAreaA"];
        popView.content2 = body[@"editAreaB"];
        popView.content3 = body[@"editAreaC"];
        
        __weak typeof(self) weakSelf = self;
        popView.callBack = ^(NSString * _Nonnull content1, NSString * _Nonnull content2, NSString * _Nonnull content3, NSArray<NSDictionary *> * _Nonnull list) {
            NSDictionary *dic = @{@"editAreaA":content1, @"editAreaB":content2, @"editAreaC":content3, @"list":list};
            [weakSelf.webView evaluateJavaScript:[NSString stringWithFormat:@"saveMsg(%@)", [dic mj_JSONString]] completionHandler:^(id result, NSError * _Nullable error) {
                if (error) {
                }
            }];
        };
        
        [popView show];
    } else if ([message.name isEqualToString:@"showFileListModal"]) {
        NSDictionary *body = [message.body mj_JSONObject];
        
//        _popView = [[AnnexPopView alloc] initWithID:self.bizPk fileType:body[@"fileType"] canEdit:YES];
//        _popView.title = body[@"text"];
//        _popView.controller = self;
//        [_popView show];
    }
}

// 计算wkWebView进度条
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

- (NSMutableDictionary *)baseData {
    if (!_baseData) {
        _baseData = [NSMutableDictionary dictionary];
    }
    return _baseData;
}

#pragma mark - 加载webview
- (void)setupWebView:(NSString *)ssjson approvalList:(NSArray *)approvalList {
    _ssjson = [ssjson stringByReplacingOccurrencesOfString:@"/" withString:@""];
    if (!approvalList) {
        approvalList = @[];
    }
    _approvalList = [approvalList mj_JSONString];
    
    NSString *jsStr = [NSString stringWithFormat:@"%@.js", self.bizUrl];
    
    if ([self.bizUrl isEqualToString:ORIGINALRECORD[@"id"]]) {
        NSString *htmlString = [NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"sp" ofType:@"html"] encoding:NSUTF8StringEncoding error:nil];
        [self.webView loadHTMLString:htmlString baseURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] bundlePath]]];
    } else {
        NSString *filePath = [[NSBundle mainBundle] pathForResource:@"GeneralPurpose" ofType:@"html"];
        NSString *htmlString = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
        htmlString = [htmlString stringByReplacingOccurrencesOfString:@"GeneralPurpose.js" withString:jsStr];
        [self.webView loadHTMLString:htmlString baseURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] bundlePath]]];
    }
}

#pragma mark - 加载数据
- (void)loadPlanItem {
    __weak typeof(self) weakSelf = self;
    [SVProgressHUD showWithStatus:@"加载中..."];
    [[HttpManager manager] post:[UrlConfig URL:[NSString stringWithFormat:@"/processapprovalnew/%@/getSingleContent", self.bizUrl]] param:[self param] success:^(NSData *data) {
        [SVProgressHUD dismiss];
        if ([ResponseUtils success:data]) {
            if ([self.bizUrl isEqualToString:ORIGINALRECORD[@"id"]]) {
                self->_approvalArr = [[ResponseUtils getData:@"data"] objectForKey:@"approvalList"];
            } else {
                self->_approvalArr = @[];
            }
            weakSelf.baseData = [[ResponseUtils getData:@"data"] mutableCopy];
            [weakSelf.baseData removeObjectForKey:@"ssjson"];
            [weakSelf.baseData removeObjectForKey:@"approvalList"];
            
            [weakSelf setUpNew];
        } else {
            [SVProgressHUD showErrorWithStatus:[ResponseUtils getMsg]];
        }
    } faild:^(NSString *msg) {
        [SVProgressHUD dismiss];
        [SVProgressHUD showErrorWithStatus:msg];
    }];
    
    [[HttpManager manager] post:[UrlConfig URL:getExcelJson] param:@{@"tabId":self.bizPk} success:^(NSData *data) {
        [SVProgressHUD dismiss];
        if ([ResponseUtils success:data]) {
            if (![[ResponseUtils getData:@"data"] isKindOfClass:[NSNull class]]) {
                self->_ssjson = [[ResponseUtils getData:@"data"] objectForKey:@"excelJson"];
                [self setUpNew];
            }
        } else {
            [SVProgressHUD showErrorWithStatus:[ResponseUtils getMsg]];
        }
    } faild:^(NSString *msg) {
        [SVProgressHUD dismiss];
        [SVProgressHUD showErrorWithStatus:msg];
    }];
}

- (void)getExcelTemplate {
    __weak typeof(self) weakSelf = self;
    UserAgent *userAgent = [UserAgent DefaultAgent];
    [self.baseData setValue:userAgent.prjName forKey:@"projectName"];
    [SVProgressHUD showWithStatus:@"加载中..."];
    
    NSDictionary *param = @{
                            @"mainId":self.bizPk,
                            @"sectId":self.sectionId,
                            @"projectId":self.projectId
                            };
    [[HttpManager manager] post:[UrlConfig URL:materialSectionInfoQueryOne] param:param success:^(NSData *data) {
        NSError *error;
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data
                                                            options:NSJSONReadingAllowFragments
                                                              error:&error];
        NSString *contractor = [dic objectForKey:@"unitNameName"];
        NSString *supervisor = [dic objectForKey:@"designName"];
        NSString *constructNum = [dic objectForKey:@"constructNum"];

        [weakSelf.baseData setValue:contractor ? contractor : @""  forKey:@"contractor"];
        [weakSelf.baseData setValue:supervisor ? supervisor : @""  forKey:@"supervisor"];
        [weakSelf.baseData setValue:constructNum ? constructNum : @""  forKey:@"constructNum"];
        [weakSelf.baseData setValue:weakSelf.bizPk forKey:@"id"];
        [weakSelf setUpNew];
    } faild:nil];
    
    if (self.formType) {
        NSString *key = self.codeDic[self.code];
        param = @{@"key":key ? key : @""};
    } else {
        param = @{@"key":self.code ? self.code : @""};
    }
    [[HttpManager manager] post:[UrlConfig URL:getExcelTemplate] param:param success:^(NSData *data) {
        [SVProgressHUD dismiss];
        if ([ResponseUtils success:data] && ![[ResponseUtils getData:@"data"] isKindOfClass:[NSNull class]]) {
            self->_ssjson = [[ResponseUtils getData:@"data"] objectForKey:@"template"];
            if (self->_ssjson) {
                [weakSelf setUpNew];
            } else {
                [SVProgressHUD showErrorWithStatus:@"数据获取失败"];
            }
        } else {
            [SVProgressHUD showErrorWithStatus:@"数据获取失败"];
        }
    } faild:^(NSString *msg) {
        [SVProgressHUD dismiss];
        [SVProgressHUD showErrorWithStatus:@"数据加载失败！"];
    }];
    
    if ([self.bizUrl isEqualToString:ORIGINALRECORD[@"id"]]) {
        [[HttpManager manager] post:[UrlConfig URL:getApprovalInfoList] param:@{@"code":param[@"key"],@"page":@"1",@"rows":@"100"} success:^(NSData *data) {
            [SVProgressHUD dismiss];
            [DataCollection mj_setupObjectClassInArray:^NSDictionary *{
                return @{@"rows":@"NSObject"};
            }];
            DataCollection *result = [DataCollection mj_objectWithKeyValues:data];
            if (result) {
                self->_approvalArr = result.rows ? result.rows : @[];
                [weakSelf setUpNew];
            } else {
                [SVProgressHUD showErrorWithStatus:@"数据获取失败"];
            }
        } faild:^(NSString *msg) {
            [SVProgressHUD dismiss];
            [SVProgressHUD showErrorWithStatus:@"数据加载失败！"];
        }];
    } else {
        _approvalArr = @[];
    }
}

- (void)setUpNew {
    if (_ssjson && _approvalArr && self.baseData.count != 1) {
        [self setupWebView:_ssjson approvalList:_approvalArr];
    }
}

- (NSDictionary *)param {
    return @{
             @"id":self.bizPk ? self.bizPk : @"",
             @"newFormFlag":@"0",
             @"sectId":self.sectionId,
             @"projectId":self.projectId
             };
}

#pragma mark - WKNavigationDelegate
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    
    //js函数
    NSString *JSFuncString =
    @"function setCookie(name,value,expires)\
    {\
    var oDate=new Date();\
    oDate.setDate(oDate.getDate()+expires);\
    document.cookie=name+'='+value+';expires='+oDate+';path=/'\
    }\
    function getCookie(name)\
    {\
    var arr = document.cookie.match(new RegExp('(^| )'+name+'=({FNXX==XXFN}*)(;|$)'));\
    if(arr != null) return unescape(arr[2]); return null;\
    }\
    function delCookie(name)\
    {\
    var exp = new Date();\
    exp.setTime(exp.getTime() - 1);\
    var cval=getCookie(name);\
    if(cval!=null) document.cookie= name + '='+cval+';expires='+exp.toGMTString();\
    }";
    
    //拼凑js字符串
    NSMutableString *JSCookieString = JSFuncString.mutableCopy;
    NSString *excuteJSString = [NSString stringWithFormat:@"setCookie('%@', '%@', 1);", _cookie.name, _cookie.value];
    [JSCookieString appendString:excuteJSString];
    //执行js
    [webView evaluateJavaScript:JSCookieString completionHandler:^(id obj, NSError * _Nullable error) {
    }];
    
    if (self.formType) {
        [webView evaluateJavaScript:[NSString stringWithFormat:@"initSpread(%@,%@,%@,%@,%@)", _ssjson, _approvalList, [self.baseData mj_JSONString], self.newFormFlag ? @"1" : @"0", self.formType] completionHandler:^(id result, NSError * _Nullable error) {
            if (error) {
            }
        }];
    } else {
        [webView evaluateJavaScript:[NSString stringWithFormat:@"initSpread(%@,%@,%@,%@)", _ssjson, _approvalList, [self.baseData mj_JSONString], self.newFormFlag ? @"1" : @"0"] completionHandler:^(id result, NSError * _Nullable error) {
            if (error) {
            }
        }];
    }
}

- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:message?:@"" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:([UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler();
    }])];
    [self presentViewController:alertController animated:YES completion:nil];
}

#pragma mark - 点击事件
- (void)save:(NSArray <BIMFile *>*)files {
    _files = files ? files : @[];
    
    __weak typeof(self) weakSelf = self;;
    
    [self.webView evaluateJavaScript:[NSString stringWithFormat:@"webToIOS()"] completionHandler:^(id result, NSError * _Nullable error) {
        if (error) {
        } else {
            [weakSelf saveOriginalRecord:result];
        }
    }];
    
    [self.webView evaluateJavaScript:[NSString stringWithFormat:@"saveJson()"] completionHandler:^(id result, NSError * _Nullable error) {
        if (error) {
        } else {
            NSData *jsonData = [result dataUsingEncoding:NSUTF8StringEncoding];
            NSError *err;
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&err];
            if (err) {
                return;
            }
            [[HttpManager manager] post:[UrlConfig URL:saveExcelJson] param:dic success:^(NSData *data) {
                
            } faild:^(NSString *msg) {
                
            }];
        }
    }];
}

- (void)saveOriginalRecord:(NSString *)ssjson {
    __weak typeof(self) weakSelf = self;
    [SVProgressHUD showWithStatus:@"保存中..."];
    
    if ([self.bizUrl isEqualToString:@"middleComOrMea"]) {
        [[HttpManager manager] jsonPost:[UrlConfig URL:[NSString stringWithFormat:@"/processapprovalnew/%@/saveContent", self.bizUrl]] param:[self params:ssjson] success:^(NSData *data) {
            if ([ResponseUtils success:data]) {
                [weakSelf saveFiles:weakSelf.bizPk];
            } else {
                [SVProgressHUD showErrorWithStatus:[ResponseUtils getMsg]];
            }
        } faild:^(NSString *msg) {
            [SVProgressHUD showErrorWithStatus:msg];
        }];
    } else {
        [[HttpManager manager] post:[UrlConfig URL:[NSString stringWithFormat:@"/processapprovalnew/%@/saveContent", self.bizUrl]] param:[self params:ssjson] success:^(NSData *data) {
            if ([ResponseUtils success:data]) {
                [weakSelf saveFiles:weakSelf.bizPk];
            } else {
                [SVProgressHUD showErrorWithStatus:[ResponseUtils getMsg]];
            }
        } faild:^(NSString *msg) {
            [SVProgressHUD showErrorWithStatus:msg];
        }];
    }
}

- (NSDictionary *)params:(NSString *)ssjson {
    NSData *jsonData = [ssjson dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSMutableDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&err];
    if (err) {
        return @{};
    }
    
    NSString *status = @"1";
    
    if (self.status && ![self.status isEqualToString:@""]) {
        status = self.status;
    }

    NSString *code = dic[@"code"] ? dic[@"code"] : ((self.code && ![self.bizUrl isEqualToString:@"approvalSafetyDangerNotify"] && ![self.bizUrl isEqualToString:@"approvalSafetyDangerNotify"]) ? self.code : @"");
    
    [dic setValue:[NSString stringWithFormat:@"/processapprovalnew/%@/editForm", self.bizUrl] forKey:@"tableUrlStr"];
    [dic setValue:self.partCode ? self.partCode : @"" forKey:@"partCode"];
    [dic setValue:self.newFormFlag ? @"1" : @"0" forKey:@"newFormFlag"];
    [dic setValue:self.numId ? self.numId : @"" forKey:@"numId"];
    [dic setValue:code forKey:@"code"];
    [dic setValue:self.projectId forKey:@"projectId"];
    [dic setValue:self.sectionId forKey:@"sectId"];
    [dic setValue:self.bizKey forKey:@"bizKey"];
    [dic setValue:self.bizPk forKey:@"id"];
    [dic setValue:status forKey:@"status"];
    
    NSString *boStr = dic[@"bo"];
    if (boStr) {
        NSError * error = nil;
        // 将json字符串转换成字典
        NSData * getJsonData = [boStr dataUsingEncoding:NSUTF8StringEncoding];
        NSMutableDictionary * bo = [NSJSONSerialization JSONObjectWithData:getJsonData options:NSJSONReadingMutableContainers error:&error];
        [bo setValue:self.projectId forKey:@"projectId"];
        [bo setValue:self.sectionId forKey:@"sectId"];
        [bo setValue:self.partCode ? self.partCode : @"" forKey:@"partCode"];
        if (!([self.bizUrl isEqualToString:@"dayworkSchedule"] || [self.bizUrl isEqualToString:@"legacyProject"] || [self.bizUrl isEqualToString:@"cecweekplan"] || [self.bizUrl isEqualToString:@"qualityMouthReport"] || [self.bizUrl isEqualToString:@"subpackage"])) {
            [bo setValue:self.newFormFlag ? @"1" : @"0" forKey:@"newFormFlag"];
        }
        
        [dic setValue:[bo mj_JSONString] forKey:@"bo"];
    }
    
    return [dic copy];
}

- (NSString *)toString:(NSHTTPCookie *)cookie {
    NSMutableString *result = [NSMutableString string];
    [result appendString:cookie.name];
    [result appendString:@"="];
    [result appendString:cookie.value];
    
    [result appendFormat:@"; path=%@", cookie.path];
    
    if (cookie.secure) {
        [result appendString:@"; secure"];
    }
    
    if (cookie.HTTPOnly) {
        [result appendString:@"; httponly"];
    }
    
    return [result copy];
}

#pragma mark - 刷新
- (void)reload {
    _ssjson = nil;
    _approvalArr = nil;
    self.baseData = nil;
    if (self.newFormFlag) {
        [self getExcelTemplate];
    } else {
        [self loadPlanItem];
    }
}

#pragma mark - 保存文件
- (void)saveFiles:(NSString *)markId {
    NSMutableArray <YTKRequest *>*requests = [NSMutableArray array];
    for (BIMFile *file in _files) {
        ApiUpload *api = [[ApiUpload alloc] initWithFile:file params:@{
                                                                       @"filename":file.filename,
                                                                       @"file.metaData.formId":markId
                                                                       }];
        api.url = zuulBatchUpload;
        [requests addObject:api];
    }
    
    if (requests.count == 0) {
        [SVProgressHUD showSuccessWithStatus:@"保存成功!"];
        if (self.newFormFlag) {
            self.newFormFlag = NO;
        }
        if (self.callBack) {
            self.callBack();
        }
        return;
    }
    
    if (_batchRequest) {
        [_batchRequest stop];
    }
    __weak typeof(self) weakSelf = self;
    _batchRequest = [[YTKBatchRequest alloc] initWithRequestArray:requests];
    [_batchRequest startWithCompletionBlockWithSuccess:^(YTKBatchRequest * _Nonnull batchRequest) {
        [SVProgressHUD showSuccessWithStatus:@"保存成功!"];
        if (weakSelf.newFormFlag) {
            weakSelf.newFormFlag = NO;
        }
        if (weakSelf.callBack) {
            weakSelf.callBack();
        }
    } failure:^(YTKBatchRequest * _Nonnull batchRequest) {
        [SVProgressHUD showSuccessWithStatus:@"保存成功!"];
        if (weakSelf.newFormFlag) {
            weakSelf.newFormFlag = NO;
        }
        if (self.callBack) {
            self.callBack();
        }
    }];
}

@end
