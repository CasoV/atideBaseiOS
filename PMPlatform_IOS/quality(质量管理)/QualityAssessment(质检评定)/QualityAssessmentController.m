//
//  QualityAssessmentController.m
//  ycxm
//
//  Created by 末末班车 on 2018/10/31.
//  Copyright © 2018年 末末班车. All rights reserved.
//

#import "QualityAssessmentController.h"
#import "FlowApprovalToolBar.h"
#import "DocumentToolView.h"
#import "ChooseUnitBtn.h"
//#import "PartSeleterVc.h"
#import <WebKit/WebKit.h>

#define kMenu_Height 40

@interface QualityAssessmentController ()<WKNavigationDelegate>

@property (nonatomic, strong) ChooseUnitBtn *btn;

@property (nonatomic, strong) UIProgressView *progressView;

@property (nonatomic, strong) DocumentToolView *toolView;

@property (nonatomic, strong) SiteModel *partModel;

@property (nonatomic, assign) BOOL chooseSite;

@property (nonatomic, copy) NSString *ret;
@property (nonatomic, copy) NSString *ssjson;
@property (nonatomic, copy) NSString *baseDataStr;

@end

@implementation QualityAssessmentController {
    WKWebView *_webView;
    
    NSHTTPCookie *_cookie;
    
    BOOL _isFirst;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _isFirst = YES;
    [self setupMenu];
    [self setupWebView];
    if (!self.partModel) {
        [self fetchPart];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationItem.title = @"质检评定";
    
    if (_isFirst) {
        _isFirst = NO;
    } else {
        if (self.chooseSite) {
            self.chooseSite = NO;
        } else {
            [self reload];
        }
    }
}

- (void)dealloc {
    [_webView removeObserver:self forKeyPath:@"estimatedProgress"];
    
    [_webView stopLoading];
    [_webView removeFromSuperview];
    _webView = nil;
    
    // 清除所有
    if (@available(iOS 9.0, *)) {
        NSSet *websiteDataTypes = [WKWebsiteDataStore allWebsiteDataTypes];
        
        //// Date from
        
        NSDate *dateFrom = [NSDate dateWithTimeIntervalSince1970:0];
        
        //// Execute
        
        [[WKWebsiteDataStore defaultDataStore] removeDataOfTypes:websiteDataTypes modifiedSince:dateFrom completionHandler:^{
            
            // Done
            
        }];
    } else {
        // Fallback on earlier versions
    }
}

#pragma mark - 初始化
- (void)setupMenu {
    UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, kStatusBarH + kNavBarH, kScreen_Width, kMenu_Height)];
    [self.view addSubview:contentView];
    
    self.btn = [[NSBundle mainBundle] loadNibNamed:@"ChooseUnitBtn" owner:nil options:nil].firstObject;
    self.btn.frame = contentView.bounds;
    [self.btn setTitle:@"质检部位"];
    [self.btn.titleBtn setTitle:@"请选择质检部位" forState:UIControlStateNormal];
    [self.btn.titleBtn addTarget:self action:@selector(chooseBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [contentView addSubview:self.btn];
    
    __weak typeof(self) weakSelf = self;
    self.toolView = [[DocumentToolView alloc] initWithFrame:CGRectMake(0, kScreen_Height - kMenu_Height, kScreen_Width, kMenu_Height)];
    self.toolView.backgroundColor = [UIColor whiteColor];
    self.toolView.block = ^(BOOL isRemove) {
        if (!isRemove) {
            [weakSelf reload];
        }
    };
    [self.view addSubview:self.toolView];
}

- (void)setupWebView {
    NSHTTPCookieStorage *cookieJar = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (NSHTTPCookie *cookie in [cookieJar cookies]) {
        if ([cookie.name isEqualToString:@"SESSION"]) {
            _cookie = cookie;
        }
    }
    
    NSString *jScript = @"var meta = document.createElement('meta'); meta.setAttribute('name', 'viewport'); meta.setAttribute('content', 'width=device-width; initial-scale=0.5;'); document.getElementsByTagName('head')[0].appendChild(meta);";
    
    WKUserScript *wkUScript = [[WKUserScript alloc] initWithSource:jScript injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:YES];
    WKUserContentController *wkUController = [[WKUserContentController alloc] init];
    [wkUController addUserScript:wkUScript];
    
    WKWebViewConfiguration *wkWebConfig = [[WKWebViewConfiguration alloc] init];
    wkWebConfig.userContentController = wkUController;
    
    CGFloat tabHeight = 35;
    CGFloat bottomHeight = 40;
    _webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, kScreen_Height - kStatusBarH - kNavBarH - tabHeight - bottomHeight) configuration:wkWebConfig];
    _webView.navigationDelegate = self;
    [_webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
    
    [self.view addSubview:_webView];
    [self.view addSubview:self.progressView];
    
    [_webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.view).offset(kStatusBarH + kNavBarH + kMenu_Height);
        make.bottom.equalTo(self.toolView.mas_top);
    }];
}

#pragma mark - 懒加载
- (UIProgressView *)progressView {
    if(!_progressView)
    {
        _progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(0, kStatusBarH + kNavBarH + kMenu_Height, kScreen_Width, 1)];
        _progressView.tintColor = [UIColor greenColor];
        _progressView.trackTintColor = [UIColor whiteColor];
    }
    return _progressView;
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

#pragma mark - 点击事件
- (void)chooseBtnClicked {
//    self.chooseSite = YES;
//    __weak typeof(self) weakSelf = self;
//    PartSeleterVc *vc = [[UIStoryboard storyboardWithName:@"PartSeleter" bundle:nil] instantiateViewControllerWithIdentifier:@"PartSeleterVc"];
//    vc.type = SelectQD;
//    vc.block = ^(SiteModel *site) {
//        weakSelf.partModel = site;
//    };
//    [self.navigationController pushViewController:vc animated:YES];
}

- (void)setPartModel:(SiteModel *)partModel {
    _partModel = partModel;
    [self.btn.titleBtn setTitle:_partModel.text forState:UIControlStateNormal];
    
    self.toolView.bizUrl = @"inspectSummary";
    self.toolView.bizKey = @"Quality_Checklist";
    self.toolView.bizPk = _partModel.id;
    [self loadToolBar];
    
    __weak typeof(self) weakSelf = self;
    [[HttpManager manager] post:[UrlConfig URL:inspectSummaryEvalDetailExcel] param:[self evalDetailExcelParams] success:^(NSData *data) {
        NSError *error;
        id result = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
        if (error) {
            [SVProgressHUD showErrorWithStatus:@"数据加载失败!"];
        } else {
            if ([result isKindOfClass:[NSDictionary class]]) {
                NSMutableDictionary *resultDic = [NSMutableDictionary dictionaryWithDictionary:result];
                if (!resultDic[@"newFormFlag"]) {
                    resultDic[@"newFormFlag"] = @"1";
                }
                weakSelf.baseDataStr = resultDic.mj_JSONString;
                [weakSelf loadExcelTemplate:[resultDic[@"newFormFlag"] isEqualToString:@"1"] type:resultDic[@"type"] ID:resultDic[@"id"]];
            } else {
                [SVProgressHUD showErrorWithStatus:@"数据加载失败!"];
            }
        }
    } faild:^(NSString *msg) {
        [SVProgressHUD showErrorWithStatus:msg];
    }];
}

- (NSDictionary *)evalDetailExcelParams {
    UserAgent *user = [UserAgent DefaultAgent];
    return @{
             @"partId":_partModel.id,
             @"projectName":user.prjName,
             @"partName":_partModel.text,
             @"sectId":user.sectionId,
             @"projectId":user.projectId,
             @"type":_partModel.type
             };
}

#pragma mark -- 网络请求
- (void)fetchPart{
    __weak __typeof(self) weakSelf = self;
    [SVProgressHUD showWithStatus:@"加载中..."];
    [[HttpManager manager] post:[UrlConfig URL:getApprovalPartTree] param:@{@"id":[UserAgent DefaultAgent].sectionCode} success:^(NSData *data) {
        [SVProgressHUD dismiss];
        NSArray <SiteModel *>*temp = [SiteModel mj_objectArrayWithKeyValuesArray:data];
        if (temp && temp.count != 0) {
            weakSelf.partModel = [temp objectAtIndex:0];
        }
    } faild:^(NSString *msg) {
        [SVProgressHUD dismiss];
    }];
}

#pragma mark - 加载数据
- (void)loadExcelTemplate:(BOOL)isNew type:(NSString *)type ID:(NSString *)ID {
    __weak typeof(self) weakSelf = self;
    NSString *key = @"approvalInspectForm1";
    if ([type isEqualToString:@"U"] || [type isEqualToString:@"Z"]) {
        key = @"approvalInspectForm2";
    }

    [[HttpManager manager] post:[UrlConfig URL:getExcelTemplate] param:@{@"key":key} success:^(NSData *data) {
        [SVProgressHUD dismiss];
        if ([ResponseUtils success:data] && ![[ResponseUtils getData:@"data"] isKindOfClass:[NSNull class]]) {
            weakSelf.ssjson = [[ResponseUtils getData:@"data"] objectForKey:@"template"];
            if (weakSelf.ssjson) {
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
    
    
    NSString *url;
    NSDictionary *param;
    if (isNew) {
        url = [UrlConfig URL:inspectSummaryList];
        param = @{@"id":_partModel.id};
    } else {
        url = [UrlConfig URL:inspectSummarySingleContent];
        param = @{@"id":ID, @"newFormFlag":@"0"};
    }
    [[HttpManager manager] post:url param:param success:^(NSData *data) {
        NSError *error;
        id result = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
        if (error) {
            [SVProgressHUD showErrorWithStatus:@"数据加载失败!"];
        } else {
            NSString *retStr = @"";
            
            if ([result isKindOfClass:[NSDictionary class]]) {
                NSDictionary *retDic = (NSDictionary *)result;
                retStr = retDic.mj_JSONString;
            } else if ([result isKindOfClass:[NSArray class]]) {
                NSArray *retArr = (NSArray *)result;
                retStr = retArr.mj_JSONString;
            }
            
            weakSelf.ret = retStr;
            [weakSelf setUpNew];
        }
    } faild:^(NSString *msg) {
        [SVProgressHUD showErrorWithStatus:msg];
    }];
}

- (void)setUpNew {
    if (self.ssjson && self.ret) {
        [self loadWebView];
    }
}

#pragma mark - 加载webview
- (void)loadWebView{
    self.ssjson = [self.ssjson stringByReplacingOccurrencesOfString:@"/" withString:@""];

    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"GeneralPurpose" ofType:@"html"];
    NSString *htmlString = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
    htmlString = [htmlString stringByReplacingOccurrencesOfString:@"GeneralPurpose.js" withString:@"evalDetailExcel.js"];
    [_webView loadHTMLString:htmlString baseURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] bundlePath]]];
}

#pragma mark - WKNavigationDelegate
// 网页视图加载完毕会调用代理的这个方法
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    //取出cookie
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
    
    [webView evaluateJavaScript:[NSString stringWithFormat:@"initSpread(%@,%@,%@)", self.ssjson, self.baseDataStr, self.ret] completionHandler:^(id result, NSError * _Nullable error) {
        if (error) {
        }
    }];
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

#pragma mark - 获取工具栏
- (void)loadToolBar {
    __weak typeof(self) weakSelf = self;
    FlowApprovalToolBar *toolBar = [[FlowApprovalToolBar alloc] init];
    toolBar.isMatter = NO;
    
    [toolBar request:self.partModel.id bizKey:@"Quality_Checklist" callback:^(NSArray<Panel *> *items) {
        NSMutableArray *arr = [NSMutableArray array];
        for (Panel *panel in items) {
            if ([panel.content isEqualToString:@"保存"] || [panel.content isEqualToString:@"办理过程"]) {
                continue;
            }
            [arr addObject:panel];
        }
        
        weakSelf.toolView.data = arr;
        weakSelf.toolView.hidden = arr.count == 0;
        CGRect frame = weakSelf.toolView.frame;
        frame.origin.y = arr.count == 0 ? kScreen_Height : kScreen_Height - kMenu_Height ;
        frame.size.height = arr.count == 0 ? 0 : kMenu_Height ;
        weakSelf.toolView.frame = frame;
    }];
}

#pragma mark - 刷新
- (void)reload {
    self.ret = nil;
    self.ssjson = nil;
    if (self.partModel) {
        self.partModel = self.partModel;
    }
    [self loadToolBar];
}

@end
