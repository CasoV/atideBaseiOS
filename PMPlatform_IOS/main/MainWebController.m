//
//  MainWebController.m
//  PMPlatform_IOS
//
//  Created by 末末班车 on 2022/7/15.
//  Copyright © 2022 com.atide. All rights reserved.
//

#import "MainWebController.h"
#import "WeakScriptMessageDelegate.h"
#import <SDWebImage/SDImageCache.h>
#import "BaseWebViewController.h"
#import "FDScanViewController.h"
#import "LoginViewController.h"
#import <WebKit/WebKit.h>
#import "AppDelegate.h"
#import "FileModel.h"
#import "BIMFile.h"
#import "FunctionClickUtil.h"
#import "JYBDIDCardVC.h"
#import <AipOcrSdk/AipOcrSdk.h>
#import "OpenDocumentationController.h"
#import "UIViewController+bd_present.h"
#import "ZGVideoChatViewController.h"
#import "QDReportDetailController.h"
#import "TZImagePickerController.h"
#import "PassViewController.h"
#import "LogFlowController.h"
#import "MatterModel.h"
#import "UserTaskModel.h"
#import "PMPlatform_IOS-Swift.h"
#import "XGPush.h"

#import <MBProgressHUD.h>


#import <objc/message.h>
#import "NSObject+NSURLRequest_IgnoreSSL.h"
#import "ZGZIMManager.h"
#import "KeyCenter.h"
#import "CallInviteView.h"

#import <AMapFoundationKit/AMapFoundationKit.h>
#import <AMapLocationKit/AMapLocationKit.h>

@interface MainWebController ()<WKNavigationDelegate, WKUIDelegate, WKScriptMessageHandler, UIDocumentPickerDelegate, UIScrollViewDelegate ,ZIMEventDelegate,AMapLocationManagerDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (nonatomic, strong) UIProgressView *progressView;

@property (nonatomic, strong) UIDocumentInteractionController *documentInteraction;

@property (nonatomic, assign) BOOL needLogin;

@property (nonatomic, assign) BOOL needReload;

@property (nonatomic, assign) BOOL isFirst;

@property (nonatomic, assign) BOOL devTokenLoaded;

@property (nonatomic, copy) NSString *cookie;

//@property (nonatomic, strong) IFlyHelper *iflyHelper;

@property (nonatomic, strong) UIView *tempStatusBar;

@property (nonatomic, assign) CGFloat s_w;
@property (nonatomic, assign) CGFloat s_h;
@property (nonatomic, assign) CGFloat s_h_1;
@property (nonatomic, assign) CGFloat s_h_2;
@property (nonatomic, assign) NSInteger tempOrientation;

//直播
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *minimizeView;
@property (nonatomic, weak) UIViewController *ocrVC;
@property (nonatomic, strong) UIImage *ocrResultImg;
@property (nonatomic, copy) NSString *formId;
@property (nonatomic, copy) NSString *fileType;
@property (nonatomic, copy) NSString *videoName;
@property (nonatomic, copy) NSString *ipPort;
@property (nonatomic, assign) NSInteger imageUploadCount;
@property (nonatomic, assign) NSInteger imageUploadedCount;
@property (nonatomic, weak) NSTimer *timer;
@property (nonatomic, copy) NSString *videoLimitMin;
@property (nonatomic, copy) NSString *videoLimitMax;
@property (nonatomic, copy) NSString *groupCode;
@property (nonatomic, copy) NSString *recordId;
@property (nonatomic, copy) NSString *processId;
@property (nonatomic, copy) NSString *tableCode;
@property (nonatomic, copy) NSString *callbackKey; // fFileType，用于回调 H5 的方法名

@property (nonatomic, strong) AMapLocationManager *locationManager;
@property (nonatomic, strong) CLLocation *location;
@property (nonatomic, copy) NSString *locationAddress;

@property (nonatomic, copy) NSString *faceMark;
@property (nonatomic, copy) NSString *tempFaceToken;

@end

@implementation MainWebController {
    // 身份证回调
    // 默认的识别成功的回调
    void (^_successHandler)(id);
    // 默认的识别失败的回调
    void (^_failHandler)(NSError *);
    
    // 银行卡回调
    // 默认的识别成功的回调
    void (^_successHandlerBank)(id);
    // 默认的识别失败的回调
    void (^_failHandlerBank)(NSError *);
    
    WKWebView *_webView;
}
- (instancetype)init {
    self = [super init];
    if (self) {
#ifdef ZEGO_ACCESS_ENV_FLAG
        [ZegoEnviromentManager setAccessEnv:1];
#endif
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"";
    self.isFirst = YES;
    self.tempOrientation = UIDeviceOrientationPortrait;
    CGFloat safeBottom = [self safeDistanceBottom];
    self.s_w = kScreen_Width;
    self.s_h = kScreen_Height;
    self.s_h_1 = kStatusBarH;
    self.s_h_2 = safeBottom;
    
    if (kScreen_Height < kScreen_Width) {
        self.tempOrientation = UIDeviceOrientationLandscapeRight;
        self.s_w = kScreen_Height;
        self.s_h = kScreen_Width;
    }
    
    WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
    // 允许内联播放 video，防止自动全屏（核心配置）
    config.allowsInlineMediaPlayback = YES;
    // 不强制要求用户手势才能启动媒体
    config.mediaTypesRequiringUserActionForPlayback = WKAudiovisualMediaTypeNone;

    _webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, kStatusBarH, kScreen_Width, kScreen_Height - kStatusBarH - safeBottom) configuration:config];
    _webView.multipleTouchEnabled = YES;
    _webView.UIDelegate = self;
    _webView.navigationDelegate = self;
    [NSURLRequest setAllowsAnyHTTPSCertificate:YES forHost:@"https"];
    [_webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
    [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.url]]];
    [_webView.configuration.userContentController addScriptMessageHandler:[[WeakScriptMessageDelegate alloc] initWithDelegate:self] name:@"downloadOfficialDocument"];
    [_webView.configuration.userContentController addScriptMessageHandler:[[WeakScriptMessageDelegate alloc] initWithDelegate:self] name:@"downloadFile"];
    [_webView.configuration.userContentController addScriptMessageHandler:[[WeakScriptMessageDelegate alloc] initWithDelegate:self] name:@"downloadFileByUrl"];
    [_webView.configuration.userContentController addScriptMessageHandler:[[WeakScriptMessageDelegate alloc] initWithDelegate:self] name:@"openOCR"];
    [_webView.configuration.userContentController addScriptMessageHandler:[[WeakScriptMessageDelegate alloc] initWithDelegate:self] name:@"openOCR2"];
    [_webView.configuration.userContentController addScriptMessageHandler:[[WeakScriptMessageDelegate alloc] initWithDelegate:self] name:@"openOCRBank"];
    [_webView.configuration.userContentController addScriptMessageHandler:[[WeakScriptMessageDelegate alloc] initWithDelegate:self] name:@"addYbgcYxzl"];
    [_webView.configuration.userContentController addScriptMessageHandler:[[WeakScriptMessageDelegate alloc] initWithDelegate:self] name:@"openCameraOrAlbumByType"];
    [_webView.configuration.userContentController addScriptMessageHandler:[[WeakScriptMessageDelegate alloc] initWithDelegate:self] name:@"openVideoAlbumByType"];
    [_webView.configuration.userContentController addScriptMessageHandler:[[WeakScriptMessageDelegate alloc] initWithDelegate:self] name:@"openCameraByType"];
    [_webView.configuration.userContentController addScriptMessageHandler:[[WeakScriptMessageDelegate alloc] initWithDelegate:self] name:@"openAllCameraByType"];
    [_webView.configuration.userContentController addScriptMessageHandler:[[WeakScriptMessageDelegate alloc] initWithDelegate:self] name:@"openCameraVideoByType"];
    [_webView.configuration.userContentController addScriptMessageHandler:[[WeakScriptMessageDelegate alloc] initWithDelegate:self] name:@"scan"];
    [_webView.configuration.userContentController addScriptMessageHandler:[[WeakScriptMessageDelegate alloc] initWithDelegate:self] name:@"logout"];
    [_webView.configuration.userContentController addScriptMessageHandler:[[WeakScriptMessageDelegate alloc] initWithDelegate:self] name:@"cellTel"];
    [_webView.configuration.userContentController addScriptMessageHandler:[[WeakScriptMessageDelegate alloc] initWithDelegate:self] name:@"clearCache"];
    [_webView.configuration.userContentController addScriptMessageHandler:[[WeakScriptMessageDelegate alloc] initWithDelegate:self] name:@"functionClicked"];
    [_webView.configuration.userContentController addScriptMessageHandler:[[WeakScriptMessageDelegate alloc] initWithDelegate:self] name:@"todoDataClicked"];
    [_webView.configuration.userContentController addScriptMessageHandler:[[WeakScriptMessageDelegate alloc] initWithDelegate:self] name:@"openPdf"];
    [_webView.configuration.userContentController addScriptMessageHandler:[[WeakScriptMessageDelegate alloc] initWithDelegate:self] name:@"getCookie"];
    [_webView.configuration.userContentController addScriptMessageHandler:[[WeakScriptMessageDelegate alloc] initWithDelegate:self] name:@"startLiving"];
    [_webView.configuration.userContentController addScriptMessageHandler:[[WeakScriptMessageDelegate alloc] initWithDelegate:self] name:@"createConver"];
    [_webView.configuration.userContentController addScriptMessageHandler:[[WeakScriptMessageDelegate alloc] initWithDelegate:self] name:@"setProInfo"];
    [_webView.configuration.userContentController addScriptMessageHandler:[[WeakScriptMessageDelegate alloc] initWithDelegate:self] name:@"goLive"];
    [_webView.configuration.userContentController addScriptMessageHandler:[[WeakScriptMessageDelegate alloc] initWithDelegate:self] name:@"updateLocalInfo"];
    [_webView.configuration.userContentController addScriptMessageHandler:[[WeakScriptMessageDelegate alloc] initWithDelegate:self] name:@"viewVideo"];
    [_webView.configuration.userContentController addScriptMessageHandler:[[WeakScriptMessageDelegate alloc] initWithDelegate:self] name:@"qdSubmit"];
    [_webView.configuration.userContentController addScriptMessageHandler:[[WeakScriptMessageDelegate alloc] initWithDelegate:self] name:@"toQDCheck"];
    [_webView.configuration.userContentController addScriptMessageHandler:[[WeakScriptMessageDelegate alloc] initWithDelegate:self] name:@"voiceClick"];
    [_webView.configuration.userContentController addScriptMessageHandler:[[WeakScriptMessageDelegate alloc] initWithDelegate:self] name:@"logFlow"];
    [_webView.configuration.userContentController addScriptMessageHandler:[[WeakScriptMessageDelegate alloc] initWithDelegate:self] name:@"changeOrientation"];
    [_webView.configuration.userContentController addScriptMessageHandler:[[WeakScriptMessageDelegate alloc] initWithDelegate:self] name:@"registerFace"];
    [_webView.configuration.userContentController addScriptMessageHandler:[[WeakScriptMessageDelegate alloc] initWithDelegate:self] name:@"comparisonFace"];
    
    [self.view addSubview:_webView];
    [self.view addSubview:self.progressView];
    
//    self.iflyHelper = [[IFlyHelper alloc] initWithView:self.view delegate:self];
    
    if ([self.ipPort isEqualToString:@"11680"] || [self.ipPort isEqualToString:@"11684"]) {
        if (safeBottom > 0) {
            UIView *bottom = [[UIView alloc] initWithFrame:CGRectMake(0, kScreen_Height - safeBottom, kScreen_Width, safeBottom)];
            bottom.backgroundColor = [UIColor hex:@"#EDEDF3"];
            [self.view addSubview:bottom];
        }
    }
    
    //即时通讯
    [[ZGZIMManager shared] addZIMEventDelegate:self];
    
    [AMapLocationManager updatePrivacyAgree:AMapPrivacyAgreeStatusDidAgree];
    [AMapLocationManager updatePrivacyShow:AMapPrivacyShowStatusDidShow privacyInfo:AMapPrivacyInfoStatusDidContain];
    
    
    [self configCallback];
    
    __weak typeof(self) weakSelf = self;
    self.timer = [NSTimer scheduledTimerWithTimeInterval:30 repeats:YES block:^(NSTimer * _Nonnull timer) {
        [weakSelf setBadge];
    }];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(localLogin) name:UIApplicationWillEnterForegroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orientationChanged:) name:UIDeviceOrientationDidChangeNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
//    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDarkContent;
//    [self setStatusBarBackgroundColor:[UIColor hex:@"FFFFFF"]];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
    // 白屏的时候，另个现象会webView.title会被置空
    //    if(_webView.title == nil){
    //        [_webView reload];
    //    }
    
    [self startLocation];
#ifdef ZEGO_ACCESS_ENV_FLAG
    [self.selectEnvView selectEnv:[ZegoEnviromentManager getAccessEnv]];
#endif
    if ([self.ipPort isEqualToString:@"11680"] || [self.ipPort isEqualToString:@"11684"]) {
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDarkContent;
        self.navigationController.navigationBar.barTintColor = [UIColor hex:@"#FFFFFF"];
        [self setStatusBarBackgroundColor:[UIColor hex:@"FFFFFF"]];
    } else {
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
        self.navigationController.navigationBar.barTintColor = [UIColor hex:@"#3868E7"];
        [self setStatusBarBackgroundColor:[UIColor hex:@"#3868E7"]];
    }
}

-(void)setStatusBarBackgroundColor:(UIColor *)color {
    if(@available(iOS 13.0, *)) {
        static UIView*statusBar =nil;
        if(!statusBar) {
            static dispatch_once_t onceToken;
            dispatch_once(&onceToken, ^{
                statusBar = [[UIView alloc] initWithFrame:[UIApplication sharedApplication].keyWindow.windowScene.statusBarManager.statusBarFrame] ;
                [[UIApplication sharedApplication].keyWindow addSubview:statusBar];
                statusBar.backgroundColor= color;
            });
        }else{
            [[UIApplication sharedApplication].keyWindow bringSubviewToFront:statusBar];
            statusBar.backgroundColor= color;
        }
        self.tempStatusBar = statusBar;
    }else{
        UIView *statusBar = [[[UIApplication sharedApplication] valueForKey:@"statusBarWindow"] valueForKey:@"statusBar"];
        if([statusBar respondsToSelector:@selector(setBackgroundColor:)]) {
            statusBar.backgroundColor= color;
        }
    }
}

- (void)changeStatusBarState:(BOOL)hidden {
    if (self.tempStatusBar) {
        self.tempStatusBar.hidden = hidden;
    }
}

- (void)orientationChanged:(NSNotification *)notification {
    UIDevice *device = [notification object];
    UIDeviceOrientation orientation = [device orientation];
    
    if (orientation == UIDeviceOrientationPortrait || orientation == UIDeviceOrientationLandscapeLeft || orientation == UIDeviceOrientationLandscapeRight) {
        if (orientation == UIDeviceOrientationPortrait) {
            [self changeStatusBarState:NO];
            _webView.frame = CGRectMake(0, self.s_h_1, self.s_w, self.s_h - self.s_h_1 - self.s_h_2);
        } else if (orientation == UIDeviceOrientationLandscapeLeft || orientation == UIDeviceOrientationLandscapeRight) {
            [self changeStatusBarState:YES];
            _webView.frame = CGRectMake(0, 0, self.s_h, self.s_w);
        }
        
//        if (self.tempOrientation != orientation) {
//            [_webView reload];
//        }
        
        self.tempOrientation = orientation;
    }
}

//- (void)getWKCompositingViewCount:(UIView *)view withCount:(NSInteger *)count{
//    for (UIView *subview in view.subviews) {
//        if ([subview isKindOfClass:NSClassFromString(@"WKCompositingView")]) {
//            *count += 1;
//        }
//        if (subview.subviews.count) {
//            [self getWKCompositingViewCount:subview withCount:count];
//        }
//    }
//}

- (void)setBadge {
    NSString *userId = [UserInfo getInstance].ID;
    [[HttpManager manager] post:[UrlConfig URL:getTodoList] param:@{@"page":@"1", @"rows":@"1", @"userId": userId} success:^(NSData *data) {
        DataCollection *tempData = [DataCollection mj_objectWithKeyValues:data];
        [UIApplication sharedApplication].applicationIconBadgeNumber = [tempData.total integerValue];
    } faild:^(NSString *msg) {
        
    }];
}

//开始定位
- (void)startLocation {
    if (!self.locationManager) {
        [self configLocationManager];
    }else{
        [self.locationManager startUpdatingLocation];
    }
}
- (void)configLocationManager {
    self.locationManager = [[AMapLocationManager alloc] init];
    [self.locationManager setDelegate:self];
    [self.locationManager setLocatingWithReGeocode:YES];
    [self.locationManager startUpdatingLocation];
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (self.needLogin) {
        [self localLogin];
        self.needLogin = NO;
    }
    if (self.needReload) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [_webView evaluateJavaScript:@"reloadFuncList()" completionHandler:^(id _Nullable, NSError * _Nullable error) {
                if (error) {
                }
            }];
        });
        self.needReload = NO;
    }
    [self setBadge];
}
#pragma MARK LoalManagerDelegate
- (void)amapLocationManager:(AMapLocationManager *)manager didUpdateLocation:(CLLocation *)location reGeocode:(AMapLocationReGeocode *)reGeocode
{
    if (reGeocode) {
        self.locationAddress = reGeocode.formattedAddress;
    }
    if (location) {
        self.location = location;
    }
}
- (UIProgressView *)progressView {
    if(!_progressView) {
        _progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(0,  kStatusBarH , kScreen_Width, 1)];
        _progressView.hidden = YES;
        _progressView.tintColor = [UIColor greenColor];
        _progressView.trackTintColor = [UIColor whiteColor];
    }
    return _progressView;
}

- (UIDocumentInteractionController *)documentInteraction{
    if (!_documentInteraction) {
        _documentInteraction = [[UIDocumentInteractionController alloc] init];
        _documentInteraction.delegate = self;
    }
    return _documentInteraction;
}

- (void)dealloc {
    [self preDealloc];
}

- (void)preDealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationWillEnterForegroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIDeviceOrientationDidChangeNotification object:nil];
    
    [_timer invalidate];
    _timer = nil;
    
    [_webView stopLoading];
    [[_webView configuration].userContentController removeScriptMessageHandlerForName:@"downloadOfficialDocument"];
    [[_webView configuration].userContentController removeScriptMessageHandlerForName:@"downloadFile"];
    [[_webView configuration].userContentController removeScriptMessageHandlerForName:@"downloadFileByUrl"];
    [[_webView configuration].userContentController removeScriptMessageHandlerForName:@"scan"];
    [[_webView configuration].userContentController removeScriptMessageHandlerForName:@"openOCR"];
    [[_webView configuration].userContentController removeScriptMessageHandlerForName:@"openOCR2"];
    [[_webView configuration].userContentController removeScriptMessageHandlerForName:@"openOCRBank"];
    [[_webView configuration].userContentController removeScriptMessageHandlerForName:@"addYbgcYxzl"];
    [[_webView configuration].userContentController removeScriptMessageHandlerForName:@"openCameraOrAlbumByType"];
    [[_webView configuration].userContentController removeScriptMessageHandlerForName:@"openVideoAlbumByType"];
    [[_webView configuration].userContentController removeScriptMessageHandlerForName:@"openCameraByType"];
    [[_webView configuration].userContentController removeScriptMessageHandlerForName:@"openAllCameraByType"];
    [[_webView configuration].userContentController removeScriptMessageHandlerForName:@"openCameraVideoByType"];
    [[_webView configuration].userContentController removeScriptMessageHandlerForName:@"logout"];
    [[_webView configuration].userContentController removeScriptMessageHandlerForName:@"cellTel"];
    [[_webView configuration].userContentController removeScriptMessageHandlerForName:@"clearCache"];
    [[_webView configuration].userContentController removeScriptMessageHandlerForName:@"functionClicked"];
    [[_webView configuration].userContentController removeScriptMessageHandlerForName:@"todoDataClicked"];
    [[_webView configuration].userContentController removeScriptMessageHandlerForName:@"openPdf"];
    [[_webView configuration].userContentController removeScriptMessageHandlerForName:@"getCookie"];
    [[_webView configuration].userContentController removeScriptMessageHandlerForName:@"startLiving"];
    [[_webView configuration].userContentController removeScriptMessageHandlerForName:@"createConver"];
    [[_webView configuration].userContentController removeScriptMessageHandlerForName:@"setProInfo"];
    [[_webView configuration].userContentController removeScriptMessageHandlerForName:@"goLive"];
    [[_webView configuration].userContentController removeScriptMessageHandlerForName:@"updateLocalInfo"];
    [[_webView configuration].userContentController removeScriptMessageHandlerForName:@"viewVideo"];
    [[_webView configuration].userContentController removeScriptMessageHandlerForName:@"qdSubmit"];
    [[_webView configuration].userContentController removeScriptMessageHandlerForName:@"toQDCheck"];
    [[_webView configuration].userContentController removeScriptMessageHandlerForName:@"voiceClick"];
    [[_webView configuration].userContentController removeScriptMessageHandlerForName:@"logFlow"];
    [[_webView configuration].userContentController removeScriptMessageHandlerForName:@"changeOrientation"];
    [[_webView configuration].userContentController removeScriptMessageHandlerForName:@"registerFace"];
    [[_webView configuration].userContentController removeScriptMessageHandlerForName:@"comparisonFace"];
    
    [_webView removeFromSuperview];
    _webView = nil;
}

-(void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    NSString *injectionJSString = @"var script = document.createElement('meta');"
    "script.name = 'viewport';"
    "script.content='width=device-width, user-scalable=no';"
    "document.getElementsByTagName('head')[0].appendChild(script);";
    [webView evaluateJavaScript:injectionJSString completionHandler:nil];
}
//解决白屏
- (void)webViewWebContentProcessDidTerminate:(WKWebView *)webView {
    [webView reload];
}
-(void)gzJoinLivingRoom:(NSDictionary *)jsonParams{
    
    NSDictionary *dic = [jsonParams mj_JSONObject];
    //接受邀请 开启即时语音
    ZGVideoChatViewController *vc = [[UIStoryboard  storyboardWithName:@"VideoChat" bundle:nil] instantiateViewControllerWithIdentifier:@"VideoChat"];
    vc.roomID = dic[@"roomId"];
    vc.navTitle = dic[@"title"];
    vc.userID =  [UserInfo getInstance].ID;//dic[@"userId"];
    vc.publishStreamID =  [UserInfo getInstance].ID;
    [self.navigationController pushViewController:vc animated:YES];
}


-(void)zim:(ZIM *)zim callUserStateChanged:(ZIMCallUserStateChangeInfo *)info callID:(nonnull NSString *)callID{
    //查询直播间进入直播
    if(info.callUserList && info.callUserList[0].state == ZIMCallUserStateAccepted && ![info.callUserList[0].userID isEqualToString:[UserInfo getInstance].ID]){
        //        [SVProgressHUD showWithStatus:@"正在加入..."];
        
        NSDictionary *dic = [info.callUserList[0].extendedData mj_JSONObject];
        //接受邀请 开启即时语音
        ZGVideoChatViewController *vc = [[UIStoryboard  storyboardWithName:@"VideoChat" bundle:nil] instantiateViewControllerWithIdentifier:@"VideoChat"];
        vc.roomID = dic[@"roomId"];
        vc.navTitle = dic[@"title"];
        vc.isGz = true;
        vc.userID =  [UserInfo getInstance].ID;//dic[@"userId"];
        vc.publishStreamID =  [UserInfo getInstance].ID;
        [self.navigationController pushViewController:vc animated:YES];
        
    }else if(info.callUserList && info.callUserList[0].state  == ZIMCallUserStateRejected && ![info.callUserList[0].userID isEqualToString:[UserInfo getInstance].ID]){
        [SVProgressHUD showErrorWithStatus:@"用户拒绝接受邀请"];
    }
}

- (NSString *)ipPort {
    if (_ipPort == nil) {
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        _ipPort = [userDefaults objectForKey:@"port"];
    }
    return _ipPort;
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
            AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
            if (delegate.doUrl != nil) {
                NSString *url = delegate.doUrl;
                delegate.doUrl = nil;
                __weak typeof(self) weakSelf = self;
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [weakSelf handleTodoWithUrl:url];
                });
            }
            
            [self getDevToken];
            //            if (self.isFirst) {
            //                self.isFirst = NO;
            //                [self checkClear];
            //            }
        } else {
            self.progressView.hidden = NO;
            [self.progressView setProgress:newprogress animated:YES];
        }
    }
}

#pragma mark - 获取并设置devToken
- (void)getDevToken {
    if (!self.devTokenLoaded && self.localUC) {
        self.devTokenLoaded = YES;
        __weak typeof(self) weakSelf = self;
        [[HttpManager manager] get:[UrlConfig URL:@"/api/login/dev/token"] param:@{} success:^(NSData *data) {
            if ([ResponseUtils success:data]) {
                [weakSelf setDevToken:[ResponseUtils getData:@"data"]];
            } else {
//                [MBManager showBriefAlert:[ResponseUtils getMsg]];
            }
        } faild:^(NSString *msg) {
//            [MBManager showBriefAlert:msg];
        }];
    }
}

- (void)setDevToken:(NSString *)devToken {
    NSString *str = [NSString stringWithFormat:@"sessionStorage.setItem(\"%@\", \"%@\")", @"devToken", devToken];
    [_webView evaluateJavaScript:str completionHandler:^(id _Nullable, NSError * _Nullable error) {
        if (error) {
        }
    }];
}

#pragma mark - 判断是否自动清理缓存
- (void)checkClear {
    __weak typeof(self) weakSelf = self;
    NSString *version = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
    [[HttpManager manager] post:[UrlConfig URL:getPhoneVersion] param:@{
        @"userId": [UserInfo getInstance].ID,
        @"version": version
    } success:^(NSData *data) {
        if (![ResponseUtils success:data]) {
            [weakSelf clearCacheWithFilePath:[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject]];
        }
    } faild:^(NSString *msg) {
    }];
}

#pragma mark - WKScriptMessageHandler
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message {
    if ([message.name isEqualToString:@"downloadFile"] || [message.name isEqualToString:@"downloadOfficialDocument"] || [message.name isEqualToString:@"downloadFileByUrl"]) {
        float version = [[[UIDevice currentDevice] systemVersion] floatValue];
        if (version >= 11) {
            if ([message.name isEqualToString:@"downloadFileByUrl"]) {
                NSDictionary *dic = [message.body mj_JSONObject];
                [self downLoadFileByUrl:dic[@"url"] fileName:dic[@"fileName"]];
            } else if ([message.name isEqualToString:@"downloadOfficialDocument"]) {
                NSDictionary *dic = [message.body mj_JSONObject];
                [self getFileInfo:dic[@"id"] fileName:dic[@"fileName"]];
            } else {
                [self getFileInfo:[message.body stringByReplacingOccurrencesOfString:@"\"" withString:@""] fileName:nil];
            }
        } else {
            [MBManager showBriefAlert:@"下载文件要求手机系统版本在11.0以上"];
        }
    } else if([message.name isEqualToString:@"scan"]){
        FDScanViewController *fdvc = [[FDScanViewController alloc] init];
        __weak typeof(self) weakSelf = self;
        fdvc.scanResult = ^(NSString *result) {
            [weakSelf handleTodoWithUrl2:result];
        };
        UINavigationController * nVC = [[UINavigationController alloc] initWithRootViewController:fdvc];
        [self presentViewController:nVC animated:YES completion:nil];
    }else if([message.name isEqualToString:@"openOCR"]){
        //js 入参
        NSDictionary *dic = [message.body mj_JSONObject];
        if(dic.allKeys.count == 0 || dic[@"formId"] == nil){
            return;
        }
        self.formId = dic[@"formId"];
        
        __weak typeof(self) weakSelf = self;
        UIViewController * vc =
        [AipCaptureCardVC ViewControllerWithCardType:CardTypeLocalIdCardFont
                                     andImageHandler:^(UIImage *image) {
            weakSelf.ocrResultImg = image;
            [[AipOcrService shardService] detectIdCardFrontFromImage:image
                                                         withOptions:nil
                                                      successHandler:^(id result){
                _successHandler(result);
            }
                                                         failHandler:_failHandler];
        }];
        self.ocrVC = vc;
        [self bd_presentViewControllerWithFullScreen:vc animated:YES completion:nil];
    } else if([message.name isEqualToString:@"openOCR2"]) {
        //js 入参
        NSDictionary *dic = [message.body mj_JSONObject];
        if(dic.allKeys.count == 0 || dic[@"formId"] == nil){
            return;
        }
        self.formId = dic[@"formId"];
        
        __weak typeof(self) weakSelf = self;
        UIViewController * vc =
        [AipCaptureCardVC ViewControllerWithCardType:CardTypeLocalIdCardBack
                                     andImageHandler:^(UIImage *image) {
            weakSelf.ocrResultImg = image;
            [[AipOcrService shardService] detectIdCardBackFromImage:image
                                                        withOptions:nil
                                                     successHandler:^(id result){
                _successHandler(result);
            }
                                                        failHandler:_failHandler];
        }];
        self.ocrVC = vc;
        [self bd_presentViewControllerWithFullScreen:vc animated:YES completion:nil];
    } else if([message.name isEqualToString:@"openOCRBank"]) {
        UIViewController * vc =
        [AipCaptureCardVC ViewControllerWithCardType:CardTypeBankCard
                                     andImageHandler:^(UIImage *image) {
            
            [[AipOcrService shardService] detectBankCardFromImage:image
                                                   successHandler:_successHandlerBank
                                                      failHandler:_failHandlerBank];
            
        }];
        self.ocrVC = vc;
        [self bd_presentViewControllerWithFullScreen:vc animated:YES completion:nil];
    } else if([message.name isEqualToString:@"addYbgcYxzl"]) {
        self.formId = message.body;
        __weak typeof(self) weakSelf = self;
        TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:9 delegate:nil];
        [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
            [weakSelf uploadYxzlImages:photos];
        }];
        [imagePickerVc setDidFinishPickingVideoHandle:^(UIImage *coverImage, PHAsset *asset) {
            [weakSelf uploadYxzlVideoPre:asset];
        }];
        [self presentViewController:imagePickerVc animated:YES completion:nil];
    } else if ([message.name isEqualToString:@"logout"]) {
        [[XGPushTokenManager defaultTokenManager] clearAccounts];
        [self preDealloc];
        //解除绑定alias
        //        [JPUSHService setTags:nil alias:nil fetchCompletionHandle:^(int iResCode, NSSet *iTags, NSString *iAlias) {}];
        LoginViewController *vc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"login"];
        vc.notAutoLogin = YES;
        UINavigationController *nVc = [[UINavigationController alloc] initWithRootViewController:vc];
        AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        delegate.window.rootViewController = nVc;
        //IM退出登陆
        [[ZGZIMManager shared] logout];
    } else if ([message.name isEqualToString:@"cellTel"]) {
        NSMutableString * str=[[NSMutableString alloc]initWithFormat:@"telprompt://%@", message.body];
        UIApplication *application = [UIApplication sharedApplication];
        [application openURL:[NSURL URLWithString:str] options:@{} completionHandler:nil];
    } else if ([message.name isEqualToString:@"clearCache"]) {
        [MBManager showLoading:@"清理缓存中！"];
        if ([self clearCacheWithFilePath:[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject]]) {
            [MBManager hideAlert];
            [MBManager showBriefAlert:@"缓存清理成功"];
            [self localLogin];
        } else {
            [MBManager hideAlert];
            [MBManager showBriefAlert:@"缓存清理失败"];
        }
    } else if ([message.name isEqualToString:@"functionClicked"]) {
        NSDictionary *dic = [message.body mj_JSONObject];
        [PermissionModel mj_setupObjectClassInArray:^NSDictionary *{
            return @{@"children":@"PermissionModel"};
        }];
        PermissionModel *functionData = [PermissionModel mj_objectWithKeyValues:dic];
        if (functionData) {
            [FunctionClickUtil handleFunctionClick:self functionData:functionData];
        }
    } else if ([message.name isEqualToString:@"todoDataClicked"]) {
        NSDictionary *dic = [message.body mj_JSONObject];
        [MatterModel mj_setupObjectClassInArray:^NSDictionary *{
            return @{@"variables":@"MatterVariablesModel"};
        }];
        MatterModel *todoData = [MatterModel mj_objectWithKeyValues:dic];
        [self handleTodoData:todoData];
    } else if ([message.name isEqualToString:@"openPdf"]) {
        NSDictionary *dic = [message.body mj_JSONObject];
        NSString *fileId = dic[@"fileId"];
        NSString *title = dic[@"title"];
        
        NSString *url = [NSString stringWithFormat:@"%@/%@?waterMarkerText=%@", [UrlConfig URL:@"/api/fs/files/download"], fileId, [[UserInfo getInstance].name stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]];
        BaseWebViewController *vc = [[BaseWebViewController alloc] init];
        vc.title = title;
        NSCharacterSet *set = [NSCharacterSet URLQueryAllowedCharacterSet];
        NSString *uncodeString = [url stringByRemovingPercentEncoding];
        NSString *encodedString = [uncodeString stringByAddingPercentEncodingWithAllowedCharacters:set];
        vc.url = encodedString;
        
        self.needLogin = YES;
        
        [self.navigationController pushViewController:vc animated:YES];
    }else if ([message.name isEqualToString:@"getCookie"]) {
        NSDictionary *dic = [message.body mj_JSONObject];
        //        [[HttpManager manager]post:[UrlConfig URL:validate] param:@{} success:^(NSData *data) {
        //            if ([ResponseUtils success:data]) {
        //
        //            }else{
        //                [MBManager showBriefAlert:[ResponseUtils getMsg]];
        //                LoginViewController *vc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"login"];
        //                vc.notAutoLogin = YES;
        //                AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        //                delegate.window.rootViewController = vc;
        //            }
        //        } faild:^(NSString *msg) {
        //
        //        } headers:@{@"Cookie":[NSString stringWithFormat:@"SESSION=%@",self.cookie]}];
        
    }else if ([message.name isEqualToString:@"startLiving"]) {
        
        //        NSDictionary *dic = [message.body mj_JSONObject];
        //        [self createRoom:dic];
        
    }else if ([message.name isEqualToString:@"createConver"]) {
        
        NSMutableDictionary *dic =  [NSMutableDictionary dictionaryWithDictionary:[message.body mj_JSONObject]];
        dic[@"callInvitor"] = [UserInfo getInstance].name;
        [self createConver:dic];
    }else if([message.name isEqualToString:@"setProInfo"]){
        NSDictionary *dic = [message.body mj_JSONObject];
        [UserAgent DefaultAgent].projectId = dic[@"projectId"];
        [UserAgent DefaultAgent].sectionId = dic[@"mainSectionId"];
        [UserAgent DefaultAgent].prjName = dic[@"projectShortName"];
        [UserAgent DefaultAgent].sectionName = dic[@"mainSectionName"];
        [UserAgent DefaultAgent].engShortName = dic[@"engShortName"];
        
    }else if([message.name isEqualToString:@"goLive"]){
        NSDictionary *dic = [message.body mj_JSONObject];
        NSString *roomId = dic[@"roomId"];
        [SVProgressHUD showWithStatus:@"正在加入..."];
        //以观众身份进入直播间
    }else if([message.name isEqualToString:@"getLocation"]){
        
        NSString *str = [NSString stringWithFormat:@"postLocation(\"%f\", \"%f\")", _location.coordinate.latitude, _location.coordinate.longitude];
        [_webView evaluateJavaScript:str completionHandler:^(id _Nullable, NSError * _Nullable error) {
            if (error) {
            }
        }];
    } else if([message.name isEqualToString:@"openCameraOrAlbumByType"]) {
        NSDictionary *dic = [message.body mj_JSONObject];
        if(dic.allKeys.count == 0 || dic[@"formId"] == nil){
            return;
        }
        if(dic[@"videoLimitMin"] != nil){
            self.videoLimitMin = dic[@"videoLimitMin"];
        }
        if(dic[@"videoLimitMax"] != nil){
            self.videoLimitMax = dic[@"videoLimitMax"];
        }
        self.formId = dic[@"formId"];
        self.fileType = dic[@"fileType"];       // 纯 fileType，写入 metaData.fileType
        self.callbackKey = dic[@"callbackKey"] ?: dic[@"fileType"]; // 回调 key，兼容旧调用
        self.groupCode = dic[@"groupCode"];
        self.recordId = dic[@"recordId"];
        self.processId = dic[@"processId"];
        self.tableCode = dic[@"tableCode"];
        __weak typeof(self) weakSelf = self;
        TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:9 delegate:nil];
        // 同时允许选图片和视频（混选）
        imagePickerVc.allowPickingImage = YES;
        imagePickerVc.allowPickingVideo = YES;
        imagePickerVc.allowPickingMultipleVideo = YES;  // 允许图片和视频混选，不互斥
        imagePickerVc.allowPickingGif = NO;
        // 使用带完整 asset 信息的回调，支持混选图片+视频
        [imagePickerVc setDidFinishPickingPhotosWithInfosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto, NSArray *infos) {
            NSInteger total = assets.count;
            if (total == 0) return;

            // 用 dispatch_group 追踪所有上传任务，全部完成后统一回调
            dispatch_group_t uploadGroup = dispatch_group_create();
            NSMutableArray *resultList = [NSMutableArray array];
            for (NSInteger i = 0; i < total; i++) {
                [resultList addObject:[NSNull null]];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [MBManager showLoading:@"正在上传..."];
            });

            __block NSString *uploadErrorMsg = nil; // 收集上传过程中的错误信息
            __block NSInteger photoIndex = 0;       // photos 数组只含图片，单独计数

            for (NSInteger i = 0; i < total; i++) {
                PHAsset *asset = assets[i];
                NSInteger idx = i;
                dispatch_group_enter(uploadGroup);

                if (asset.mediaType == PHAssetMediaTypeVideo) {
                    PHAssetResource *resource = [[PHAssetResource assetResourcesForAsset:asset] firstObject];
                    NSString *videoName = resource.originalFilename ?: [NSString stringWithFormat:@"VIDEO_%lld.mp4", (long long)[[NSDate date] timeIntervalSince1970]];
                    NSString *tmpPath = [NSTemporaryDirectory() stringByAppendingPathComponent:
                                        [NSString stringWithFormat:@"upload_video_%lld_%ld.mp4",
                                         (long long)[[NSDate date] timeIntervalSince1970], (long)idx]];
                    [[NSFileManager defaultManager] removeItemAtPath:tmpPath error:nil];

                    PHVideoRequestOptions *videoOptions = [[PHVideoRequestOptions alloc] init];
                    videoOptions.version = PHVideoRequestOptionsVersionCurrent;
                    videoOptions.deliveryMode = PHVideoRequestOptionsDeliveryModeHighQualityFormat;
                    videoOptions.networkAccessAllowed = YES;

                    [[PHImageManager defaultManager] requestAVAssetForVideo:asset options:videoOptions resultHandler:^(AVAsset * _Nullable avAsset, AVAudioMix * _Nullable audioMix, NSDictionary * _Nullable info) {
                        if (!avAsset) {
                            NSError *err = info[PHImageErrorKey];
                            uploadErrorMsg = err.localizedDescription ?: @"视频获取失败，请重试";
                            dispatch_group_leave(uploadGroup);
                            return;
                        }
                        AVAssetExportSession *exportSession = [[AVAssetExportSession alloc] initWithAsset:avAsset presetName:AVAssetExportPresetHighestQuality];
                        exportSession.outputURL = [NSURL fileURLWithPath:tmpPath];
                        exportSession.outputFileType = AVFileTypeMPEG4;
                        exportSession.shouldOptimizeForNetworkUse = YES;
                        [exportSession exportAsynchronouslyWithCompletionHandler:^{
                            if (exportSession.status != AVAssetExportSessionStatusCompleted) {
                                [[NSFileManager defaultManager] removeItemAtPath:tmpPath error:nil];
                                uploadErrorMsg = exportSession.error.localizedDescription ?: @"视频导出失败，请重试";
                                dispatch_group_leave(uploadGroup);
                                return;
                            }
                            NSData *videoData = [NSData dataWithContentsOfFile:tmpPath];
                            if (!videoData) {
                                [[NSFileManager defaultManager] removeItemAtPath:tmpPath error:nil];
                                uploadErrorMsg = @"视频读取失败，请重试";
                                dispatch_group_leave(uploadGroup);
                                return;
                            }
                            NSDictionary *params = [weakSelf buildUploadParams];
                            [[HttpManager manager] uploadTask:[UrlConfig URL:filesUpload2] data:videoData name:@"file" fileName:videoName mimeType:@"video/mp4" param:params callback:^(NSURLResponse *response, id data, NSError *error) {
                                [[NSFileManager defaultManager] removeItemAtPath:tmpPath error:nil];
                                NSString *serverMsg = nil;
                                NSDictionary *dic = nil;
                                if ([data isKindOfClass:[NSDictionary class]]) dic = data;
                                else if ([data isKindOfClass:[NSData class]]) dic = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                                serverMsg = dic[@"message"];
                                if (!serverMsg && !error) {
                                    BIMFile *resultFile = [BIMFile mj_objectWithKeyValues:data];
                                    if (resultFile.id.length > 0) {
                                        resultList[idx] = @{@"id": resultFile.id, @"contentType": resultFile.contentType ?: @"video/mp4"};
                                    } else {
                                        uploadErrorMsg = @"视频上传失败";
                                    }
                                } else {
                                    uploadErrorMsg = serverMsg ?: @"视频上传失败，请重试";
                                }
                                dispatch_group_leave(uploadGroup);
                            }];
                        }];
                    }];
                } else {
                    NSInteger currentPhotoIndex = photoIndex;
                    photoIndex++;

                    if (currentPhotoIndex >= (NSInteger)photos.count || !photos[currentPhotoIndex]) {
                        uploadErrorMsg = @"图片读取失败";
                        dispatch_group_leave(uploadGroup);
                        continue;
                    }

                    UIImage *image = photos[currentPhotoIndex];
                    NSData *imageData = UIImageJPEGRepresentation(image, 1);
                    if (!imageData) {
                        uploadErrorMsg = @"图片压缩失败";
                        dispatch_group_leave(uploadGroup);
                        continue;
                    }
                    NSString *fileName = [NSString stringWithFormat:@"IMAGE_%lld_%ld.png", (long long)[[NSDate date] timeIntervalSince1970], (long)idx];
                    NSDictionary *params = [weakSelf buildUploadParams];
                    [[HttpManager manager] uploadTask:[UrlConfig URL:filesUpload2] data:imageData name:@"file" fileName:fileName mimeType:@"image/png" param:params callback:^(NSURLResponse *response, id data, NSError *error) {
                        if (!error && data) {
                            BIMFile *resultFile = [BIMFile mj_objectWithKeyValues:data];
                            if (resultFile.id.length > 0) {
                                resultList[idx] = @{@"id": resultFile.id, @"contentType": resultFile.contentType ?: @"image/png"};
                            } else {
                                uploadErrorMsg = @"图片上传失败";
                            }
                        } else {
                            uploadErrorMsg = @"图片上传失败，请重试";
                        }
                        dispatch_group_leave(uploadGroup);
                    }];
                }
            }

            // 所有任务完成后统一处理：先 hide loading，再显示错误（如有），最后回调 H5
            dispatch_group_notify(uploadGroup, dispatch_get_main_queue(), ^{
                UIView *keyWindow = [UIApplication sharedApplication].keyWindow;
                NSArray *subviews = [keyWindow.subviews copy];
                for (UIView *subview in subviews) {
                    if ([subview isKindOfClass:[MBProgressHUD class]]) {
                        [(MBProgressHUD *)subview hideAnimated:NO];
                    }
                }
                [MBManager hideAlert];
                if (uploadErrorMsg) {
                    [MBManager showBriefAlert:uploadErrorMsg];
                }
                [weakSelf callBatchUploadedCallback:resultList];
            });
        }];
        [self presentViewController:imagePickerVc animated:YES completion:nil];
    } else if([message.name isEqualToString:@"openVideoAlbumByType"]) {
        NSDictionary *dic = [message.body mj_JSONObject];
        if(dic.allKeys.count == 0 || dic[@"formId"] == nil){
            return;
        }
        if(dic[@"videoLimitMin"] != nil){
            self.videoLimitMin = dic[@"videoLimitMin"];
        }
        if(dic[@"videoLimitMax"] != nil){
            self.videoLimitMax = dic[@"videoLimitMax"];
        }
        self.formId = dic[@"formId"];
        self.fileType = dic[@"fileType"];
        __weak typeof(self) weakSelf = self;
        TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:9 delegate:nil];
        imagePickerVc.allowPickingImage = NO;
        imagePickerVc.allowPickingVideo = YES;
        imagePickerVc.allowPickingGif = NO;
        imagePickerVc.allowPickingOriginalPhoto = NO;
        [imagePickerVc setDidFinishPickingVideoHandle:^(UIImage *coverImage, PHAsset *asset) {
            [weakSelf uploadVideoPre:asset];
        }];
        [self presentViewController:imagePickerVc animated:YES completion:nil];
    } else if([message.name isEqualToString:@"openAllCameraByType"] || [message.name isEqualToString:@"openCameraByType"] || [message.name isEqualToString:@"openCameraVideoByType"]) {
        NSDictionary *dic = [message.body mj_JSONObject];
        if(dic.allKeys.count == 0 || dic[@"formId"] == nil){
            return;
        }
        if(dic[@"videoLimitMin"] != nil){
            self.videoLimitMin = dic[@"videoLimitMin"];
        }
        if(dic[@"videoLimitMax"] != nil){
            self.videoLimitMax = dic[@"videoLimitMax"];
        }
        self.formId = dic[@"formId"];
        self.fileType = dic[@"fileType"];
        self.callbackKey = dic[@"callbackKey"] ?: dic[@"fileType"];
        self.groupCode = dic[@"groupCode"];
        self.recordId = dic[@"recordId"];
        self.processId = dic[@"processId"];
        self.tableCode = dic[@"tableCode"];
        self.faceMark = nil;
        UIImagePickerController *imagePickerVc = [UIImagePickerController new];
        imagePickerVc.delegate = self;
        imagePickerVc.sourceType = UIImagePickerControllerSourceTypeCamera;
        if ([message.name isEqualToString:@"openCameraVideoByType"]) {
            imagePickerVc.mediaTypes = @[@"public.movie"];
        } else if ([message.name isEqualToString:@"openAllCameraByType"]) {
            imagePickerVc.mediaTypes = @[@"public.image", @"public.movie"];
        }
        [self presentViewController:imagePickerVc animated:YES completion:nil];
    } else if ([message.name isEqualToString:@"updateLocalInfo"]) {
        NSString *str = [NSString stringWithFormat:@"receiveLocalInfo(\"%f\", \"%f\")", _location.coordinate.longitude, _location.coordinate.latitude];
        [_webView evaluateJavaScript:str completionHandler:^(id _Nullable, NSError * _Nullable error) {
            if (error) {
            }
        }];
        if (self.locationAddress) {
            str = [NSString stringWithFormat:@"receiveLocalInfoAndDress(\"%f\", \"%f\", '%@')", _location.coordinate.longitude, _location.coordinate.latitude, self.locationAddress];
            [_webView evaluateJavaScript:str completionHandler:^(id _Nullable, NSError * _Nullable error) {
                if (error) {
               
                }
            }];
        }
    } else if ([message.name isEqualToString:@"viewVideo"]) {
        [self viewVideoByFileId:message.body];
    } else if ([message.name isEqualToString:@"qdSubmit"]) {
        NSDictionary *dic = [message.body mj_JSONObject];
        [self handleQdSubmit:[NewQDKeyModel mj_objectWithKeyValues:dic]];
    } else if ([message.name isEqualToString:@"toQDCheck"]) {
        NSDictionary *dic = [message.body mj_JSONObject];
        QDReportDetailController *vc = [[QDReportDetailController alloc] init];
        vc.model = [NewQDKeyModel mj_objectWithKeyValues:dic];
        self.needReload = YES;
        self.navigationController.navigationBar.hidden = NO;
        [self.navigationController pushViewController:vc animated:YES];
    } else if ([message.name isEqualToString:@"voiceClick"]) {
//        [self.iflyHelper speech];
    } else if ([message.name isEqualToString:@"logFlow"]) {
        NSDictionary *dic = [message.body mj_JSONObject];
        LogFlowController *vc = [[LogFlowController alloc] init];
        vc.id = dic[@"id"];
        vc.numId = dic[@"id"];
        vc.bizPk = dic[@"bizPk"];
        vc.flowType = dic[@"type"];
        vc.title = dic[@"title"];
        self.needReload = YES;
        self.navigationController.navigationBar.hidden = NO;
        [self.navigationController pushViewController:vc animated:YES];
    } else if ([message.name isEqualToString:@"changeOrientation"]) {
        
    } else if ([message.name isEqualToString:@"registerFace"] || [message.name isEqualToString:@"comparisonFace"]) {
        self.faceMark = message.name;
        if ([message.name isEqualToString:@"comparisonFace"]) {
            self.tempFaceToken = message.body;
        }
        UIImagePickerController *imagePickerVc = [UIImagePickerController new];
        imagePickerVc.delegate = self;
        imagePickerVc.sourceType = UIImagePickerControllerSourceTypeCamera;
        imagePickerVc.mediaTypes = @[@"public.image"];
        imagePickerVc.cameraDevice = UIImagePickerControllerCameraDeviceFront;
        [self presentViewController:imagePickerVc animated:YES completion:nil];
    }
}

//待办数据处理
- (void)handleTodoData:(MatterModel *)model {
    __weak typeof(self) weakSelf = self;
    
    //质检资料
    if ([model.bizType containsString:@"Quality"] || [model.bizType containsString:@"quality"]) {
        QDReportDetailController *vc = [[QDReportDetailController alloc] init];
        NewQDKeyModel *temp = [NewQDKeyModel new];
        temp.instId = model.bizPk;
        temp.name = model.bizTypeName;
        temp.numId = model.variables.numId;
        temp.testStatus = [NSString stringWithFormat:@"%ld", (long)model.flowStatus];
        temp.processCode = model.bizType;
        temp.partCode = model.variables.partCode;
        vc.model = temp;
        self.needLogin = YES;
        self.needReload = YES;
        self.navigationController.navigationBar.hidden = NO;
        [self.navigationController pushViewController:vc animated:YES];
    }
    
    //中间计量单
    if ([model.bizType isEqualToString:@"intermediate_measurement"]) {
        [SVProgressHUD showWithStatus:@"加载中"];
        [[HttpManager manager] post:[UrlConfig URL:getMeterageIntermediate] param:@{
            @"bizPk": model.bizPk
        } success:^(NSData *data) {
            NSDictionary *dic = [data mj_JSONObject][@"data"];
            [[NSUserDefaults standardUserDefaults] setObject:dic[@"periodId"]  forKey:@"periodId"];
            DetailMainVc *dvc = [[UIStoryboard storyboardWithName:@"DetailMain" bundle:nil] instantiateViewControllerWithIdentifier:@"DetailMainVc"];
            dvc.info = model.mj_keyValues;
            dvc.type = 0;
            dvc.isWorkBen = true;
            weakSelf.navigationController.navigationBar.hidden = NO;
            [weakSelf.navigationController pushViewController:dvc animated:YES];
        } faild:^(NSString *msg) {
            [SVProgressHUD showErrorWithStatus:@"加载失败"];
        }];
    }
    
    //中期支付报表（工区）4 中期支付报表（总包） 9
    if ([model.bizType isEqualToString:@"YX_TWO"]) {
        [SVProgressHUD showWithStatus:@"加载中"];
        [[HttpManager manager] post:[UrlConfig URL:selectPayByInfo] param:@{ @"bizPk":model.bizPk } success:^(NSData *data) {
            NSDictionary *dic = [data mj_JSONObject];
            DetailMainVc *dvc = [[UIStoryboard storyboardWithName:@"DetailMain" bundle:nil]instantiateViewControllerWithIdentifier:@"DetailMainVc"];
            NSMutableDictionary *info = [NSMutableDictionary dictionaryWithDictionary:dic[@"data"]];
            NSNumberFormatter *numFormatter = [[NSNumberFormatter alloc] init];
            info[@"status"] =  [numFormatter stringFromNumber:info[@"status"]];
            info[@"bizPk"] = model.bizPk;
            [[NSUserDefaults standardUserDefaults]setObject:info[@"periodId"]  forKey:@"periodId"];
            dvc.info = info;
            dvc.type = [info[@"reyType"] isEqualToNumber:@1]?4:9;
            dvc.isWorkBen = true;
            weakSelf.navigationController.navigationBar.hidden = NO;
            [weakSelf.navigationController pushViewController:dvc animated:YES];
        } faild:^(NSString *msg) {
            [SVProgressHUD showErrorWithStatus:@"加载失败"];
        }];
    }
    
    //监理计量支付审核
    if ([model.bizType isEqualToString:@"supervisorPayFlow"]) {
        [SVProgressHUD showWithStatus:nil];
        [[HttpManager manager] post:[UrlConfig URL:getParamsForTask] param:@{@"bizPk":model.bizPk} success:^(NSData *data) {
            if ([ResponseUtils success:data]) {
                NSDictionary *dic  = [data mj_JSONObject];
                DetailMainVc *dvc = [[UIStoryboard storyboardWithName:@"DetailMain" bundle:nil]instantiateViewControllerWithIdentifier:@"DetailMainVc"];
                NSMutableDictionary *infoDic = [NSMutableDictionary dictionaryWithDictionary:model.mj_keyValues];
                [infoDic setValue:dic[@"data"][@"SECT_ID_"] forKey:@"sectId"];
                [infoDic setValue:dic[@"data"][@"PERIOD_ID_"]  forKey:@"periodId"];
                dvc.info = infoDic;
                dvc.type = 5;
                dvc.isWorkBen = true;
                weakSelf.navigationController.navigationBar.hidden = NO;
                [weakSelf.navigationController pushViewController:dvc animated:YES];
            } else {
                [SVProgressHUD showErrorWithStatus:[ResponseUtils getMsg]];
            }
        } faild:^(NSString *msg) {
            [SVProgressHUD showErrorWithStatus:msg];
        }];
    }
}

//创建对话
-(void)createConver:(NSMutableDictionary *)params{
    NSArray *userlist = @[params[@"userId"]];
    ZIMUsersInfoQueryConfig *config = [[ZIMUsersInfoQueryConfig alloc] init];
    config.isQueryFromServer = true;
    [[ZGZIMManager shared] queryUsersInfo:userlist config:config callback:^(NSArray<ZIMUserFullInfo *> * _Nonnull userList, NSArray<ZIMErrorUserInfo *> * _Nonnull errorUserList, ZIMError * _Nonnull errorInfo) {
        if(errorInfo.code == 0 && userlist.count == 1){
            //创建会话成功
            //打语音
            ZIMCallInviteConfig *inviteConfig = [[ZIMCallInviteConfig alloc] init];
            inviteConfig.timeout = 90;
            inviteConfig.mode = ZIMCallInvitationModeGeneral;
            inviteConfig.extendedData = [params mj_JSONString];
            ZIMPushConfig *pushConfig = [[ZIMPushConfig alloc] init];
            pushConfig.resourcesID = KeyCenter.resourceID;
            pushConfig.title = [ZGZIMManager shared].myUserID;
            pushConfig.content = @"邀请你开启直播";
            inviteConfig.pushConfig = pushConfig;
            [[ZGZIMManager shared] callInviteWithInvitees:userlist config:inviteConfig callback:^(NSString * _Nonnull callID, ZIMCallInvitationSentInfo * _Nonnull info, ZIMError * _Nonnull errorInfo) {
                if(errorInfo.code == 0){
                    [CallInviteView show:Caller userID:params[@"userName"] callID:callID mode:ZIMCallInvitationModeGeneral extendedData:[params mj_JSONString]];
                }else{
                    [SVProgressHUD showErrorWithStatus:@"呼叫失败，未找到用户！"];
                }
            }];
        }
        else if (errorInfo.code == 6000011){
            [SVProgressHUD showErrorWithStatus:@"用户不存在！"];
        }
        else{
            [SVProgressHUD showErrorWithStatus:@"创建会话失败！"];
            
        }
    }];
}
#pragma mark - WKUIDelegate
- (void)webView:(WKWebView *)webView
    requestMediaCapturePermissionForOrigin:(WKSecurityOrigin *)origin
    initiatedByFrame:(WKFrameInfo *)frame
    type:(WKMediaCaptureType)type
    decisionHandler:(void (^)(WKPermissionDecision))decisionHandler
    API_AVAILABLE(ios(15.0)) {
    decisionHandler(WKPermissionDecisionGrant);
}
- (void)webView:(WKWebView *)webView didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition, NSURLCredential * _Nullable))completionHandler {
    
    if ([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust]) {
        
        NSURLCredential *credential = [[NSURLCredential alloc]initWithTrust:challenge.protectionSpace.serverTrust];
        
        completionHandler(NSURLSessionAuthChallengeUseCredential,credential);
        
    }
    
    
    
    
}
- (WKWebView *)webView:(WKWebView *)webView createWebViewWithConfiguration:(WKWebViewConfiguration *)configuration forNavigationAction:(WKNavigationAction *)navigationAction windowFeatures:(WKWindowFeatures *)windowFeatures {
    NSString *url = navigationAction.request.URL.absoluteString;
    if (url != nil && [url containsString:@"/api/fs/files/download/"]) {
        NSArray <NSString *>* tempArr1 = [url componentsSeparatedByString:@"/api/fs/files/download/"];
        if (tempArr1.count > 1) {
            NSArray <NSString *>* tempArr2 = [tempArr1[1] componentsSeparatedByString:@"."];
            [self getFileInfo:tempArr2[0] fileName:nil];
        }
    }
    if (!navigationAction.targetFrame.isMainFrame) {
        [_webView loadRequest:navigationAction.request];
    }
    return nil;
}

// 根据路径删除路径下缓存
- (BOOL)clearCacheWithFilePath:(NSString *)path{
    //获取所有子路径
    NSArray *subPathArr = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:path error:nil];
    NSString *filePath = @"";
    NSError *error = nil;
    for (NSString *subPath in subPathArr) {
        filePath = [NSString stringWithFormat:@"%@/%@", path, subPath];
        //删除子文件
        [[NSFileManager defaultManager]removeItemAtPath:filePath error:&error];
        if (error) {
            return NO;
        }
    }
    [[SDImageCache sharedImageCache] clearDiskOnCompletion:nil];
    
    NSSet *websiteDataTypes = [WKWebsiteDataStore allWebsiteDataTypes];
    
    //// Date from
    
    NSDate *dateFrom = [NSDate dateWithTimeIntervalSince1970:0];
    
    //// Execute
    
    [[WKWebsiteDataStore defaultDataStore] removeDataOfTypes:websiteDataTypes modifiedSince:dateFrom completionHandler:^{
        
        // Done
        
    }];
    
    return YES;
}

#pragma mark - 获取文件信息
- (void)getFileInfo:(NSString *)fileId fileName:(NSString *)fileName {
    if (fileId == nil) {
        [MBManager showBriefAlert:@"文件id为空！"];
        return;
    }
    
    [MBManager showLoading:@"文件下载中"];
    __weak typeof(self) weakSelf = self;
    [[HttpManager manager] post:[UrlConfig URL:searchFiles] param:@{@"id":fileId} success:^(NSData *data) {
        NSArray *files = [FileModel mj_objectArrayWithKeyValuesArray:data];
        if (files.count > 0) {
            NSString *fName = [files.firstObject name];
            if (fileName) {
                fName = [NSString stringWithFormat:@"%@.%@", fileName, [files.firstObject extName]];
            }
            [weakSelf downLoadFile:files.firstObject fileName:fName];
        } else {
            [MBManager hideAlert];
            [MBManager showBriefAlert:@"文件获取失败！"];
        }
    } faild:^(NSString *msg) {
        [MBManager hideAlert];
        [MBManager showBriefAlert:msg];
    }];
}

#pragma mark - 下载文件
- (void)downLoadFile:(FileModel *)file fileName:(NSString *)fileName {
    __weak typeof(self) weakSelf = self;
    [[HttpManager manager] downloadWithFileid:file.id fileName:fileName progress:^(NSProgress *downloadProgress) {
        
    } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
        if (error) {
            [MBManager hideAlert];
            [MBManager showBriefAlert:@"文件下载失败！"];
        } else {
            [MBManager hideAlert];
            weakSelf.documentInteraction.URL = filePath;
            [weakSelf.documentInteraction presentOpenInMenuFromRect:weakSelf.view.bounds inView:weakSelf.view animated:YES];
        }
    }];
}

- (void)downLoadFileByUrl:(NSString *)url fileName:(NSString *)fileName {
    __weak typeof(self) weakSelf = self;
    [[HttpManager manager] downloadWithUrl:url params:@{} fileName:fileName progress:^(NSProgress *downloadProgress) {
        
    } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
        if (error) {
            [MBManager hideAlert];
            [MBManager showBriefAlert:@"文件下载失败！"];
        } else {
            [MBManager hideAlert];
            weakSelf.documentInteraction.URL = filePath;
            [weakSelf.documentInteraction presentOpenInMenuFromRect:weakSelf.view.bounds inView:weakSelf.view animated:YES];
        }
    }];
}

#pragma mark - 浏览视频
- (void)viewVideoByFileId:(NSString *)fileId {
    __weak typeof(self) weakSelf = self;
    [[HttpManager manager] post:[UrlConfig URL:searchFiles] param:@{@"id":fileId} success:^(NSData *data) {
        NSArray *files = [BIMFile mj_objectArrayWithKeyValuesArray:data];
        if (files.count > 0) {
            BIMFile *file = files.firstObject;
       
            if ([file isDownload]) {
                [weakSelf openVideoFile:file];
            } else {
                [weakSelf downloadVideoFile:file];
            }
        } else {
            [MBManager hideAlert];
            [MBManager showBriefAlert:@"文件获取失败！"];
        }
    } faild:^(NSString *msg) {
        [MBManager hideAlert];
        [MBManager showBriefAlert:msg];
    }];
}

#pragma mark - 下载视频文件
- (void)downloadVideoFile:(BIMFile *)file {
    __weak typeof(self) weakSelf = self;
    [MBManager showLoading:@"下载中..."];
    [[HttpManager manager] downloadVideoWithFileid:file.id fileName:file.filename progress:nil completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
        [MBManager hideAlert];
        if (!error) {
            [weakSelf openVideoFile:file];
        } else {
            [MBManager showBriefAlert:@"下载失败！"];
        }
    }];
}

#pragma mark - 打开视频文件
- (void)openVideoFile:(BIMFile *)file {
    if ([file isDownload]) {
        OpenDocumentationController *vc = [[OpenDocumentationController alloc] init];
        vc.filepath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:file.filePath];
        self.navigationController.navigationBar.hidden = NO;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark - UIDocumentPickerDelegate
- (void)documentPicker:(UIDocumentPickerViewController *)controller didPickDocumentsAtURLs:(NSArray<NSURL *> *)urls {
    // 获取授权
    BOOL fileUrlAuthozied = [urls.firstObject startAccessingSecurityScopedResource];
    if (fileUrlAuthozied) {
        // 通过文件协调工具来得到新的文件地址，以此得到文件保护功能
        NSFileCoordinator *fileCoordinator = [[NSFileCoordinator alloc] init];
        NSError *error;
        
        [fileCoordinator coordinateReadingItemAtURL:urls.firstObject options:0 error:&error byAccessor:^(NSURL *newURL) {
            // 读取文件
            NSString *fileName = [newURL lastPathComponent];
            NSError *error = nil;
            if (error) {
                // 读取出错
            } else {
                // 上传
            }
        }];
        [urls.firstObject stopAccessingSecurityScopedResource];
    } else {
        // 授权失败
    }
}

#pragma mark - 底部安全区高度
- (CGFloat)safeDistanceBottom {
    if (@available(iOS 13.0, *)) {
        NSSet *set = [UIApplication sharedApplication].connectedScenes;
        UIWindowScene *windowScene = [set anyObject];
        UIWindow *window = windowScene.windows.firstObject;
        return window.safeAreaInsets.bottom;
    } else if (@available(iOS 11.0, *)) {
        UIWindow *window = [UIApplication sharedApplication].windows.firstObject;
        return window.safeAreaInsets.bottom;
    }
    return 0;
}





//回调方法
//- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
//    if([keyPath isEqualToString:@"progressHidden"] && object == self.viewModel){
//        if([[change valueForKey:@"new"] boolValue])
//            [MBProgressHUD hideHUDForView:self.view animated:YES];
//        else
//            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//        return;
//    }
//
//    if (!keyPath || keyPath.length==0) return;
//
//    NSString *dealString = [keyPath stringByReplacingCharactersInRange:NSMakeRange(0,1) withString:[[keyPath substringToIndex:1] capitalizedString]];
//    NSString *methodName = [NSString stringWithFormat:@"set%@:",dealString];
//    SEL setSEL = NSSelectorFromString(methodName);
//
//    if (object == self.quickJoinView || object == self.testLoginView) {
//        if(![self.viewModel respondsToSelector:setSEL]) return;
//        ((void(*)(id, SEL, id))objc_msgSend)(self.viewModel, setSEL, [change valueForKey:@"new"]);
//    } else if (object == self.viewModel) {
//        if([self.mainView respondsToSelector:setSEL] && [keyPath isEqualToString:@"meetings"])
//            ((void(*)(id, SEL, id))objc_msgSend)(self.mainView, setSEL, [change valueForKey:@"new"]);
//        else if ([self.arrangeView respondsToSelector:setSEL] && [keyPath isEqualToString:@"arrangeData"]){
//            ((void(*)(id, SEL, id))objc_msgSend)(self.arrangeView, setSEL, [change valueForKey:@"new"]);
//        }
//    }
//
//    NSArray *tmp = @[@"quickJoinRoomID", @"quickJoinName", @"roomType", @"role"];
//    if ([tmp containsObject:keyPath]) {
//        BOOL haveRoomType = YES;
//#ifdef ZEGO_ACCESS_ENV_FLAG
//        haveRoomType = self.viewModel.roomType;
//#endif
//        BOOL isJoinButtonEnabled = self.quickJoinView.quickJoinName.length > 0 && self.quickJoinView.quickJoinRoomID.length > 0 && haveRoomType > 0 && self.viewModel.role > 0;
//        [self.quickJoinView updateJoinButtonToEnable:isJoinButtonEnabled];
//    }
//}



//
//- (void)bindViewModel {
//    [self addObservers];
//    NSArray *data = self.viewModel.arrangeData;
//    self.viewModel.arrangeData = data;
//
//    @ZegoWeak(self)
//    //快速加入
//    self.quickJoinView.quickJoinBlock = ^{
//        @ZegoStrong(self)
//        if (!self.viewModel.quickJoinName.length || !self.viewModel.quickJoinRoomID.length) {
//            [MBProgressHUD showError:TLLocalizedString(quick_join_failed_id_nickname_empty) withFinishBlock:nil];
//            return;
//        }
//        [self.view endEditing:YES];
//        TLManager.sharedInstance.userName = [UserInfo getInstance].name;
//        [self quickJoinMeeting];
//    };
//
//    //测试登录
//    self.testLoginView.testLoginBlock = ^{
//        @ZegoStrong(self)
//        if (self.viewModel.testLoginId.length == 0) {
//            [MBProgressHUD showError:TLLocalizedString(quick_join_failed_id_nickname_empty) withFinishBlock:nil];
//            return;
//        }
//        [self.view endEditing:YES];
//        [self startTestLoginWithUserID:self.viewModel.testLoginId];
//    };
//
//    //自动登录
//    self.quickJoinView.createBlock = ^{
//        @ZegoStrong(self)
//        [self startLogin:NO];
//    };
//
//    //安排会议
//    self.arrangeView.arrangeblock = ^(NSDictionary * _Nonnull selectedData){
//        @ZegoStrong(self)
//#ifdef ZEGO_ENVIROMENT_FLAG
//        [self showCreateMeetingAlertWithData:selectedData];
//#else
//        NSMutableDictionary *tmp = [selectedData mutableCopy];
//        [tmp setObject:@(2) forKey:@"maxOnStageCount"];
//        [self createMeeting:tmp];
//#endif
//    };
//
//    //删除会议
//    self.mainView.closeMeetingBlock = ^(NSDictionary * _Nullable x) {
//        @ZegoStrong(self)
//        [self deleteMeeting:x];
//    };
//
//    //加入会议
//    self.mainView.joinMeetingBlock = ^(NSDictionary * _Nullable x) {
//        @ZegoStrong(self)
//        if(![[TLManager sharedInstance] isLogin]){
//            TLManager.sharedInstance.userName = [UserInfo getInstance].name;
//            self.viewModel.quickJoinRoomID = x[@"room_id"];
//            self.viewModel.roomType = 3;
//            [self quickJoinMeeting];
//            return;
//        }
//        TLManager.sharedInstance.userName = [UserInfo getInstance].name;
//        [self joinMeeting:x];
//    };
//
//    //下拉刷新
//    self.mainView.refreshMeetingsBlock = ^{
//        @ZegoStrong(self)
//        [self getMeetingList];
//    };
//
//    // 选择房间类型
//    self.quickJoinView.selectTypeBlock = ^{
//        @ZegoStrong(self)
//        TLPopupSettingView *setting = [TLPopupSettingView addPopupSettingViewWithTitle:TLLocalizedString(quick_join_select_room_type_title)
//                                                                               options:[self selectTypeOptions]
//                                                                                onView:self.navigationController.view];
//        setting.actionBlock = ^(NSInteger index) {
//            self.viewModel.roomType = index;
//            [self.quickJoinView setRoomTypeTitle:[self typeTitleOfIndex:index]];
//        };
//    };
//
//    // 选择角色
//    self.quickJoinView.selectRoleBlock = ^{
//        @ZegoStrong(self)
//        TLPopupSettingView *setting = [TLPopupSettingView addPopupSettingViewWithTitle:TLLocalizedString(quick_join_select_role_title)
//                                                                               options:[self selectRoleOptions]
//                                                                                onView:self.navigationController.view];
//        setting.actionBlock = ^(NSInteger index) {
//            self.viewModel.role = index;
//            [self.quickJoinView setRoleTitle:[self roleTitleOfIndex:index]];
//        };
//    };
//
//#ifdef ZEGO_ACCESS_ENV_FLAG
//    // 选择接入环境
//    self.selectEnvView.selectEnvBlock = ^(NSInteger env) {
//        @ZegoStrong(self)
//        self.viewModel.env = env;
//        [ZegoEnviromentManager setAccessEnv:env];
//    };
//#endif
//}




//
//- (void)getMeetingListWithNeedScrollToBottom:(BOOL)needScrollToBottom  isCreate:(BOOL)isCreate param:(NSDictionary *)param isJoin:(Boolean)isJoin{
//    //未登录
//    if (![[TLManager sharedInstance] isLogin]){
//        [self.viewModel getMeetingNoLoginList:needScrollToBottom showHUD:NO success:^(BOOL needScroll) {
//            [self.mainView endRefresh];
//            [LEEAlert closeWithCompletionBlock:^{}];
//        } failure:^(NSError * _Nonnull error) {
//            [self.mainView endRefresh];
//            [MBProgressHUD showSuccess:@"请求失败！" withFinishBlock:nil];
//        }];
//        return;
//    }
//    TLManager.sharedInstance.userID = [[UserInfo getInstance].ID intValue];
//    [self.viewModel getMeetingList:needScrollToBottom showHUD:NO success:^(BOOL needScroll) {
//        [self.mainView endRefresh];
//        [LEEAlert closeWithCompletionBlock:^{}];
//        if (needScroll) {
//            [self.mainView scrollToBottom];
//        }
//        if(isJoin){
//            NSDictionary *info = self.viewModel.meetings[self.viewModel.meetings.count - 1];
//            [self joinMeeting:info];
//        }
//        if(isCreate && param){
//            NSDictionary *info = self.viewModel.meetings[self.viewModel.meetings.count - 1];
//            NSMutableDictionary *createDic = [NSMutableDictionary dictionaryWithDictionary:@{
//                @"title":param[@"title"],
//                @"remark":param[@"sm"],
//                @"classifyCode":param[@"themeType"],
//                @"roomId":info[@"room_id"],
//                @"projectId":param[@"projectId"],
//                @"sectionId":param[@"sectionId"]
//            }];
//            if(param[@"taskId"]){
//                createDic[@"taskId"] = param[@"taskId"];
//            }
//            //创建直播间，保存到服务器
//            [[HttpManager manager]jsonPost:[UrlConfig URL:liveAdd] param:createDic success:^(NSData *data) {
//                //进入直播间
//                NSDictionary *dic = [data mj_JSONObject];
//                                if([[dic[@"succeed"] stringValue] isEqualToString:@"1"]){
//                [self joinMeeting:info];
//                //开启直播
//                [[HttpManager manager]jsonPost:[NSString stringWithFormat:@"%@/%@",[UrlConfig URL:liveStart],dic[@"data"]] param:@{}success:^(NSData *data) {
//
//                    //开启录播
//                    [[HttpManager manager]jsonPost:[NSString stringWithFormat:@"%@/%@",[UrlConfig URL:recordStart],dic[@"data"]] param:@{}success:^(NSData *data) {
//
//
//                    } faild:^(NSString *msg) {
//
//                    }];
//
//
//                } faild:^(NSString *msg) {
//
//                }];
//                                }
//
//            } faild:^(NSString *msg) {
//
//            }];
//
//
//
//        }
//
//    } failure:^(NSError * _Nonnull error) {
//        [self.mainView endRefresh];
//        if (error.code == 4000007) {
//            [self showLoginExpiredAlert];
//            return;
//        }
//        NSString *message = TLLocalizedString(room_list_failed);
//        [MBProgressHUD showSuccess:message withFinishBlock:nil];
//    }];
//}

//
//主播退出 删除直播间
//[[HttpManager manager]get:[UrlConfig URL:liveList] param:@{} success:^(NSData *data) {
//    NSDictionary *dic = [data mj_JSONObject];
//    NSArray *arr = dic[@"data"][@"rows"];
//    if(!arr || arr.count  == 0){
//        return;
//    }
//        for (NSDictionary *dic in arr) {
//            if([dic[@"roomId"] isEqualToString:roomID]){
//                //删除直播间
//
//                [[HttpManager manager]jsonPost:[NSString stringWithFormat:@"%@/%@",[UrlConfig URL:liveDelete],dic[@"id"]] param:@{}success:^(NSData *data) {
//                } faild:^(NSString *msg) {
//
//                }];
//
//            }
//        }
//
//
//} faild:^(NSString *msg) {
//
//}];

#pragma mark - 百度OCR回调设置
- (void)configCallback {
    __weak typeof(self) weakSelf = self;
    
    // 这是默认的识别成功的回调
    _successHandler = ^(id result){
        
        NSMutableString *message = [NSMutableString string];
        
        __block NSString *num = @"";
        __block NSString *name = @"";
        __block NSString *gender = @"";
        __block NSString *nation = @"";
        __block NSString *address = @"";
        __block NSString *issue = @"";
        __block NSString *valid1 = @"";
        __block NSString *valid2 = @"";
        
        if (result[@"words_result"]){
            if ([result[@"words_result"] isKindOfClass:[NSDictionary class]]){
                [result[@"words_result"] enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
                    NSString *temp = @"";
                    if ([obj isKindOfClass:[NSDictionary class]] && [obj objectForKey:@"words"]){
                        temp = obj[@"words"];
                    } else {
                        temp = obj;
                    }
                    if ([key isEqualToString:@"姓名"]) {
                        name = temp;
                    } else if ([key isEqualToString:@"公民身份号码"]) {
                        num = temp;
                    } else if ([key isEqualToString:@"性别"]) {
                        gender = temp;
                    } else if ([key isEqualToString:@"民族"]) {
                        nation = temp;
                    } else if ([key isEqualToString:@"住址"]) {
                        address = temp;
                    } else if ([key isEqualToString:@"签发机关"]) {
                        issue = temp;
                    } else if ([key isEqualToString:@"签发日期"]) {
                        valid1 = temp;
                    } else if ([key isEqualToString:@"失效日期"]) {
                        valid2 = temp;
                    }
                }];
                
                if (![name isEqualToString:@""]) {
                    if (weakSelf.ocrVC) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [weakSelf.ocrVC dismissViewControllerAnimated:YES completion:nil];
                            [MBManager showLoading:@"正在上传..."];
                        });
                    }
                    NSDictionary *params = @{
                        @"metaData.formId": weakSelf.formId,
                        @"metaData.type": @"4",
                        @"metaData.code": @"zheng",
                        @"metaData.tableCode": @"NMG_PERSON_FILEINFO"
                    };
                    [[HttpManager manager] uploadTask:[UrlConfig URL:filesUpload] data: UIImageJPEGRepresentation(weakSelf.ocrResultImg, 1) name:@"file" fileName:@"身份证正面.png" mimeType:@"image/png" param:params callback:^(NSURLResponse *response, id data, NSError *error) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [MBManager hideAlert];
                        });
                        NSString *jsString = [NSString stringWithFormat:@"ocrResult(%d,'%@','%@','%@','%@','%@','%@','')", 2, name, num, gender, nation, address, issue];
                        [_webView evaluateJavaScript:jsString completionHandler:^(id result, NSError * _Nullable error) {
                            if (error) {
                            }
                        }];
                        if (error) {
                        }
                    }];
                } else if (![issue isEqualToString:@""]) {
                    if (weakSelf.ocrVC) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [weakSelf.ocrVC dismissViewControllerAnimated:YES completion:nil];
                            [MBManager showLoading:@"正在上传..."];
                        });
                    }
                    NSDictionary *params = @{
                        @"metaData.formId": weakSelf.formId,
                        @"metaData.type": @"3",
                        @"metaData.code": @"fan",
                        @"metaData.tableCode": @"NMG_PERSON_FILEINFO"
                    };
                    [[HttpManager manager] uploadTask:[UrlConfig URL:filesUpload] data: UIImageJPEGRepresentation(weakSelf.ocrResultImg, 1) name:@"file" fileName:@"身份证反面.png" mimeType:@"image/png" param:params callback:^(NSURLResponse *response, id data, NSError *error) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [MBManager hideAlert];
                        });
                        NSString *jsString = [NSString stringWithFormat:@"ocrResult(%d,'','','','','','%@','%@-%@')", 2, issue, valid1, valid2];
                        [_webView evaluateJavaScript:jsString completionHandler:^(id result, NSError * _Nullable error) {
                            if (error) {
                            }
                        }];
                        if (error) {
                        }
                    }];
                }
            } else if ([result[@"words_result"] isKindOfClass:[NSArray class]]){
                for(NSDictionary *obj in result[@"words_result"]){
                    if ([obj isKindOfClass:[NSDictionary class]] && [obj objectForKey:@"words"]){
                        [message appendFormat:@"%@\n", obj[@"words"]];
                    } else {
                        [message appendFormat:@"%@\n", obj];
                    }
                }
            }
        } else if (result[@"codes_result"]){
            if ([result[@"codes_result"] isKindOfClass:[NSArray class]]){
                for (id dict in result[@"codes_result"]) {
                    if ([dict isKindOfClass:[NSDictionary class]]) {
                        NSArray *array = dict[@"text"];
                        for (int i=0; i<array.count; i++) {
                            [message appendFormat:@"%@\n", array[i]];
                        }
                    }
                }
            }
        } else {
            NSError*parseError =nil;
            NSData *jsonData = [NSJSONSerialization dataWithJSONObject:result options:NSJSONWritingPrettyPrinted error:&parseError];
            [message appendFormat:@"%@", [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding]];
        }
        if ([[result allKeys] containsObject:@"risk_type"]){
            
            [message appendFormat:@"%@:%@\n", @"risk_type", result[@"risk_type"]];
        }
    };
    
    _failHandler = ^(NSError *error){
        NSString *msg = [NSString stringWithFormat:@"%li:%@", (long)[error code], [error localizedDescription]];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
            UIAlertController * alertCon = [UIAlertController alertControllerWithTitle:@"识别失败" message:msg preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction * ok =[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            [alertCon addAction:ok];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [weakSelf dismissViewControllerAnimated:YES completion:^{
                    [weakSelf bd_presentViewControllerWithFullScreen:alertCon animated:YES completion:nil];
                }];
                
            });
            
        });
    };
    
    // 银行卡
    // 这是默认的识别成功的回调
    _successHandlerBank = ^(id result){
        NSString *title = @"识别结果";
        NSMutableString *message = [NSMutableString string];
        __block NSString *bankName = @"";
        __block NSString *number = @"";
        
        if (result[@"result"]){
            if ([result[@"result"] isKindOfClass:[NSDictionary class]]){
                [result[@"result"] enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
                    NSString *temp = @"";
                    if ([obj isKindOfClass:[NSDictionary class]] && [obj objectForKey:@"words"]){
                        temp = obj[@"words"];
                    } else {
                        temp = obj;
                    }
                    
                    if ([key isEqualToString:@"bank_name"]) {
                        bankName = temp;
                    } else if ([key isEqualToString:@"bank_card_number"]) {
                        number = temp;
                    }
                }];
                if (![bankName isEqualToString:@""] && ![number isEqualToString:@""]) {
                    if (weakSelf.ocrVC) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [weakSelf.ocrVC dismissViewControllerAnimated:YES completion:nil];
                            
                        });
                    }
                    
                    NSString *jsString = [NSString stringWithFormat:@"bankResult('%@','%@')", number, bankName];
                    [_webView evaluateJavaScript:jsString completionHandler:^(id result, NSError * _Nullable error) {
                        if (error) {
                        }
                    }];
                }
            } else if ([result[@"result"] isKindOfClass:[NSArray class]]){
                for (NSDictionary *obj in result[@"result"]){
                    if ([obj isKindOfClass:[NSDictionary class]] && [obj objectForKey:@"words"]){
                        [message appendFormat:@"%@\n", obj[@"words"]];
                    } else {
                        [message appendFormat:@"%@\n", obj];
                    }
                }
            }
        } else if (result[@"codes_result"]){
            if ([result[@"codes_result"] isKindOfClass:[NSArray class]]){
                for (id dict in result[@"codes_result"]) {
                    if ([dict isKindOfClass:[NSDictionary class]]) {
                        NSArray *array = dict[@"text"];
                        for (int i=0; i<array.count; i++) {
                            [message appendFormat:@"%@\n", array[i]];
                        }
                    }
                }
            }
        } else {
            
            NSError*parseError =nil;
            NSData *jsonData = [NSJSONSerialization dataWithJSONObject:result options:NSJSONWritingPrettyPrinted error:&parseError];
            
            NSMutableString *jsStr = [[NSMutableString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
            [jsStr replaceOccurrencesOfString:@"\\" withString:@"" options:1 range:NSMakeRange(0, jsStr.length)];
            [message appendFormat:@"%@", jsStr];
            
        }
    };
    
    _failHandlerBank = ^(NSError *error){
        NSString *msg = [NSString stringWithFormat:@"%li:%@", (long)[error code], [error localizedDescription]];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
            UIAlertController * alertCon = [UIAlertController alertControllerWithTitle:@"识别失败" message:msg preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction * ok =[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            [alertCon addAction:ok];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [weakSelf dismissViewControllerAnimated:YES completion:^{
                    [weakSelf bd_presentViewControllerWithFullScreen:alertCon animated:YES completion:nil];
                }];
                
            });
            
        });
    };
}

#pragma mark - 构建上传参数
- (NSDictionary *)buildUploadParams {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if (self.formId) {
        params[@"metaData.formId"] = self.formId;
    }
    if (self.fileType) {
        params[@"metaData.fileType"] = self.fileType;
    }
    if (self.groupCode && self.groupCode.length > 0) {
        params[@"metaData.groupCode"] = self.groupCode;
    }
    if (self.recordId && self.recordId.length > 0) {
        params[@"metaData.recordId"] = self.recordId;
    }
    if (self.processId && self.processId.length > 0) {
        params[@"metaData.processId"] = self.processId;
    }
    if (self.tableCode && self.tableCode.length > 0) {
        params[@"metaData.tableCode"] = self.tableCode;
    }
    if (self.videoLimitMax) {
        params[@"videoLimitMax"] = self.videoLimitMax;
    }
    if (self.videoLimitMin) {
        params[@"videoLimitMin"] = self.videoLimitMin;
    }
    return [params copy];
}

#pragma mark - 批量上传完成后统一回调 H5
- (void)callBatchUploadedCallback:(NSArray *)resultList {
    NSMutableArray *validResults = [NSMutableArray array];
    for (id item in resultList) {
        if (![item isKindOfClass:[NSNull class]]) {
            [validResults addObject:item];
        }
    }
    if (validResults.count == 0) return;

    NSError *jsonError = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:validResults options:0 error:&jsonError];
    if (jsonError || !jsonData) return;

    NSString *jsonStr = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    jsonStr = [jsonStr stringByReplacingOccurrencesOfString:@"'" withString:@"\\'"];

    // 用 callbackKey（即 fFileType）拼方法名，与 H5 注册的 window["filesUploaded"+fFileType] 对应
    NSString *key = self.callbackKey ?: self.fileType;
    NSString *jsString = [NSString stringWithFormat:@"filesUploaded%@('%@')", key, jsonStr];
    [_webView evaluateJavaScript:jsString completionHandler:^(id result, NSError * _Nullable error) {}];
}

#pragma mark - 上传照片
- (void)uploadImages:(NSArray <UIImage *>*)images {
    self.imageUploadCount = images.count;
    self.imageUploadedCount = 0;
    dispatch_async(dispatch_get_main_queue(), ^{
        [MBManager showLoading:@"正在上传..."];
    });

    // 每张图片独立构建 params，避免共享字典的并发问题
    __block NSMutableArray *resultList = [NSMutableArray array];
    for (NSInteger i = 0; i < images.count; i++) {
        [resultList addObject:[NSNull null]];
    }
    __weak typeof(self) weakSelf = self;
    for (NSInteger i = 0; i < images.count; i++) {
        NSInteger idx = i;
        UIImage *image = images[i];
        NSString *fileName = [NSString stringWithFormat:@"IMAGE_%lld_%ld.png", (long long)[[NSDate date] timeIntervalSince1970], (long)idx];
        NSDictionary *params = [self buildUploadParams]; // 每次调用返回新字典
        [[HttpManager manager] uploadTask:[UrlConfig URL:filesUpload2] data:UIImageJPEGRepresentation(image, 1) name:@"file" fileName:fileName mimeType:@"image/png" param:params callback:^(NSURLResponse *response, id data, NSError *error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                weakSelf.imageUploadedCount++;
                if (!error && data) {
                    BIMFile *resultFile = [BIMFile mj_objectWithKeyValues:data];
                    if (resultFile.id.length > 0) {
                        resultList[idx] = @{@"id": resultFile.id, @"contentType": resultFile.contentType ?: @"image/png"};
                    } else {
                        [MBManager showBriefAlert:@"图片上传失败"];
                    }
                } else {
                    [MBManager showBriefAlert:@"图片上传失败，请重试"];
                }
                if (weakSelf.imageUploadedCount >= weakSelf.imageUploadCount) {
                    [MBManager hideAlert];
                    [weakSelf callBatchUploadedCallback:resultList];
                }
            });
        }];
    }
}

#pragma mark - 上传影像资料图片
- (void)uploadYxzlImages:(NSArray <UIImage *>*)images {
    self.imageUploadCount = images.count;
    self.imageUploadedCount = 0;
    dispatch_async(dispatch_get_main_queue(), ^{
        [MBManager showLoading:@"正在上传..."];
    });
    
    __weak typeof(self) weakSelf = self;
    for (UIImage *image in images) {
        NSString *fileName = [NSString stringWithFormat:@"IMAGE_%lld.png", (long long)[[NSDate date] timeIntervalSince1970]];
        [[HttpManager manager] uploadTask:[UrlConfig URL:yxzlFileUpload] data:UIImageJPEGRepresentation(image, 1) name:@"file" fileName:fileName mimeType:@"image/png" param:@{ @"fid": self.formId, @"fileName": fileName } callback:^(NSURLResponse *response, id data, NSError *error) {
            weakSelf.imageUploadedCount++;
            if (weakSelf.imageUploadedCount >= weakSelf.imageUploadCount) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [MBManager hideAlert];
                });
                [_webView evaluateJavaScript:@"yxzlReload()" completionHandler:^(id result, NSError * _Nullable error) {
                    if (error) {
                    }
                }];
            }
            if (error) {
            }
        }];
    }
}

#pragma mark - 上传视频
- (void)uploadVideoPre:(PHAsset *)asset {
    PHAssetResource *resource = [[PHAssetResource assetResourcesForAsset:asset] firstObject];
    NSString *videoName = resource.originalFilename ?: [NSString stringWithFormat:@"VIDEO_%lld.mp4", (long long)[[NSDate date] timeIntervalSince1970]];
    NSString *tmpPath = [NSTemporaryDirectory() stringByAppendingPathComponent:
                         [NSString stringWithFormat:@"upload_video_%lld.mp4", (long long)[[NSDate date] timeIntervalSince1970]]];
    [[NSFileManager defaultManager] removeItemAtPath:tmpPath error:nil];

    dispatch_async(dispatch_get_main_queue(), ^{
        [MBManager showLoading:@"正在上传..."];
    });

    PHVideoRequestOptions *videoOptions = [[PHVideoRequestOptions alloc] init];
    videoOptions.version = PHVideoRequestOptionsVersionCurrent;
    videoOptions.deliveryMode = PHVideoRequestOptionsDeliveryModeHighQualityFormat;
    videoOptions.networkAccessAllowed = YES;

    __weak typeof(self) weakSelf = self;
    [[PHImageManager defaultManager] requestAVAssetForVideo:asset options:videoOptions resultHandler:^(AVAsset * _Nullable avAsset, AVAudioMix * _Nullable audioMix, NSDictionary * _Nullable info) {
        if (!avAsset) {
            NSError *err = info[PHImageErrorKey];
            dispatch_async(dispatch_get_main_queue(), ^{
                [MBManager hideAlert];
                [MBManager showBriefAlert:err.localizedDescription ?: @"视频获取失败，请重试"];
            });
            return;
        }
        AVAssetExportSession *exportSession = [[AVAssetExportSession alloc] initWithAsset:avAsset presetName:AVAssetExportPresetHighestQuality];
        exportSession.outputURL = [NSURL fileURLWithPath:tmpPath];
        exportSession.outputFileType = AVFileTypeMPEG4;
        exportSession.shouldOptimizeForNetworkUse = YES;
        [exportSession exportAsynchronouslyWithCompletionHandler:^{
            if (exportSession.status == AVAssetExportSessionStatusCompleted) {
                [weakSelf uploadVideoFromPath:tmpPath fileName:videoName];
            } else {
                [[NSFileManager defaultManager] removeItemAtPath:tmpPath error:nil];
                NSString *errMsg = exportSession.error.localizedDescription ?: @"视频导出失败，请重试";
                dispatch_async(dispatch_get_main_queue(), ^{
                    [MBManager hideAlert];
                    [MBManager showBriefAlert:errMsg];
                });
            }
        }];
    }];
}

- (void)uploadVideoFromPath:(NSString *)filePath fileName:(NSString *)fileName {
    NSData *videoData = [NSData dataWithContentsOfFile:filePath];
    if (!videoData) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBManager hideAlert];
            [MBManager showBriefAlert:@"视频读取失败，请重试"];
        });
        [[NSFileManager defaultManager] removeItemAtPath:filePath error:nil];
        return;
    }
    NSDictionary *params = [self buildUploadParams];
    __weak typeof(self) weakSelf = self;
    [[HttpManager manager] uploadTask:[UrlConfig URL:filesUpload2] data:videoData name:@"file" fileName:fileName mimeType:@"video/mp4" param:params callback:^(NSURLResponse *response, id data, NSError *error) {
        [[NSFileManager defaultManager] removeItemAtPath:filePath error:nil];
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBManager hideAlert];

            // 从 data 里解析服务端返回的 message（500 时 error 有值但错误信息在 data 里）
            NSString *(^parseMsg)(id) = ^NSString *(id d) {
                if (!d) return nil;
                NSDictionary *dic = nil;
                if ([d isKindOfClass:[NSDictionary class]]) {
                    dic = d;
                } else if ([d isKindOfClass:[NSData class]]) {
                    dic = [NSJSONSerialization JSONObjectWithData:d options:0 error:nil];
                }
                return dic[@"message"];
            };

            NSString *serverMsg = parseMsg(data);
            if (serverMsg) {
                [MBManager showBriefAlert:serverMsg];
                return;
            }
            if (error) {
                [MBManager showBriefAlert:@"视频上传失败，请重试"];
                return;
            }
            BIMFile *resultFile = [BIMFile mj_objectWithKeyValues:data];
            if (resultFile.id.length == 0) {
                [MBManager showBriefAlert:@"视频上传失败，请重试"];
                return;
            }
            NSArray *resultList = @[@{@"id": resultFile.id, @"contentType": resultFile.contentType ?: @"video/mp4"}];
            [weakSelf callBatchUploadedCallback:resultList];
        });
    }];
}

#pragma mark - 上传影像资料视频
- (void)uploadYxzlVideoPre:(PHAsset *)asset {
    PHAssetResource *resource = [[PHAssetResource assetResourcesForAsset:asset] firstObject];
    self.videoName = resource.originalFilename;
    PHVideoRequestOptions *options = [[PHVideoRequestOptions alloc] init];
    options.version = PHImageRequestOptionsVersionCurrent;
    options.deliveryMode = PHVideoRequestOptionsDeliveryModeAutomatic;
    __weak typeof(self) weakSelf = self;
    [[PHImageManager defaultManager] requestAVAssetForVideo:asset options:options resultHandler:^(AVAsset * _Nullable asset, AVAudioMix * _Nullable audioMix, NSDictionary * _Nullable info) {
        AVURLAsset *urlAsset = (AVURLAsset *)asset;
        [weakSelf uploadYxzlVideo:urlAsset.URL fileName:weakSelf.videoName];
    }];
}

- (void)uploadYxzlVideo:(NSURL *)url fileName:(NSString *)fileName {
    dispatch_async(dispatch_get_main_queue(), ^{
        [MBManager showLoading:@"正在上传..."];
    });
    NSDictionary *params = @{
        @"fileName": fileName,
        @"fid": self.formId
    };
    if(self.videoLimitMax != nil){
        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:params];
        dic[@"videoLimitMax"] = self.videoLimitMax;
        params = [NSMutableDictionary dictionaryWithDictionary:dic];
    }
    if(self.videoLimitMin != nil){
        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:params];
        dic[@"videoLimitMin"] = self.videoLimitMin;
        params = [NSMutableDictionary dictionaryWithDictionary:dic];
    }
    __weak typeof(self) weakSelf = self;
    [[HttpManager manager] uploadTask:[UrlConfig URL:yxzlFileUpload] data:[NSData dataWithContentsOfURL:url] name:@"file" fileName:fileName mimeType:@"video/mp4" param:params callback:^(NSURLResponse *response, id data, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBManager hideAlert];
        });
        NSHTTPURLResponse *httpResponse = (id) response;
        NSInteger statusCode = httpResponse.statusCode;
        if(statusCode == 500 && error){
            NSString * const AFNetworkingOperationFailingURLResponseDataErrorKey = @"com.alamofire.serialization.response.error.data";
            NSData *errorData = error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey];
            NSDictionary *serializedData = [NSJSONSerialization JSONObjectWithData:errorData
                                                                               options:kNilOptions
                                                                                 error:nil];
            dispatch_async(dispatch_get_main_queue(), ^{
                [MBManager showBriefAlert:serializedData[@"message"]];
            });
            return;
        }
        
        [_webView evaluateJavaScript:@"yxzlReload()" completionHandler:^(id result, NSError * _Nullable error) {
            if (error) {
            }
        }];
        if (error) {
        }
    }];
}

- (void)localLogin {
    NSString *userName = [[NSUserDefaults standardUserDefaults] objectForKey:@"user"];
    NSString *password = [[NSUserDefaults standardUserDefaults] objectForKey:@"password2"];
    NSString *str = [NSString stringWithFormat:@"localLogin(\"%@\", \"%@\")", userName, password];
    [_webView evaluateJavaScript:str completionHandler:^(id _Nullable, NSError * _Nullable error) {
        if (error) {
        }
    }];
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    NSURL *url = [info objectForKey:UIImagePickerControllerMediaURL];
    if (image != nil) {
        if (self.faceMark) {
            if ([self.faceMark isEqualToString:@"registerFace"]) {
                [self registerFace:image];
            } else if ([self.faceMark isEqualToString:@"comparisonFace"]) {
                [self comparisonFace:image];
            }
        } else {
            [self uploadImages:@[image]];
        }
    } else if (url != nil) {
        NSString *fileName = [NSString stringWithFormat:@"VIDEO_%lld.MOV", (long long)[[NSDate date] timeIntervalSince1970]];
        [self uploadVideoFromPath:url.path fileName:fileName];
    }
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

#pragma mark - 人脸识别打卡-注册人脸信息
- (void)registerFace:(UIImage *)image {
    dispatch_async(dispatch_get_main_queue(), ^{
        [MBManager showLoading:@"操作进行中..."];
    });
    __weak typeof(self) weakSelf = self;
    [[HttpManager manager] post:[UrlConfig URL:[NSString stringWithFormat:@"/api/sjgcold/check/in/addUser/%@", [AppUser sharedInstance].userId]] param:@{
        @"image": [self imageToBase64:image]
    } success:^(NSData *data) {
        if ([ResponseUtils success:data]) {
            NSString *resStr = [ResponseUtils getData:@"data"];
            NSDictionary *res = [resStr mj_JSONObject];
            if ([res[@"error_msg"] isEqualToString:@"SUCCESS"]) {
                [weakSelf uploadRegisterFace:image];
                [_webView evaluateJavaScript:@"registerFaceSuccess()" completionHandler:^(id result, NSError * _Nullable error) {
                    if (error) {
                    }
                }];
            } else {
                [_webView evaluateJavaScript:@"registerFaceFail()" completionHandler:^(id result, NSError * _Nullable error) {
                    if (error) {
                    }
                }];
            }
        } else {
            [_webView evaluateJavaScript:@"registerFaceFail()" completionHandler:^(id result, NSError * _Nullable error) {
                if (error) {
                }
            }];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBManager hideAlert];
        });
    } faild:^(NSString *msg) {
        [_webView evaluateJavaScript:@"registerFaceFail()" completionHandler:^(id result, NSError * _Nullable error) {
            if (error) {
            }
        }];
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBManager hideAlert];
        });
    }];
}

- (void)uploadRegisterFace:(UIImage *)image {
    NSString *fileName = [NSString stringWithFormat:@"IMAGE_%lld.jpeg", (long long)[[NSDate date] timeIntervalSince1970]];
    [[HttpManager manager] uploadTask:[UrlConfig URL:filesUpload2] data:UIImageJPEGRepresentation(image, 0.3) name:@"file" fileName:fileName mimeType:@"image/jpeg" param:@{
        @"metaData.userId": [AppUser sharedInstance].userId,
        @"metaData.type": @"kq"
    } callback:^(NSURLResponse *response, id data, NSError *error) {}];
}

#pragma mark - 人脸识别打卡-比对人脸信息
- (void)comparisonFace:(UIImage *)image {
    dispatch_async(dispatch_get_main_queue(), ^{
        [MBManager showLoading:@"操作进行中..."];
    });
    __weak typeof(self) weakSelf = self;
    [[HttpManager manager] jsonPost:[UrlConfig URL:[NSString stringWithFormat:@"/api/sjgcold/check/in/checkUser/%@", [AppUser sharedInstance].userId]] arrayParam:@[
        @{ @"image_type": @"BASE64", @"image": [self imageToBase64:image] },
        @{ @"image_type": @"FACE_TOKEN", @"image": self.tempFaceToken }
    ] success:^(NSData *data) {
        if ([ResponseUtils success:data]) {
            NSString *resStr = [ResponseUtils getData:@"data"];
            NSDictionary *res = [resStr mj_JSONObject];
            if ([res[@"error_msg"] isEqualToString:@"SUCCESS"]) {
                NSDictionary *result = res[@"result"];
                NSNumber *score = result[@"score"];
                if ([score doubleValue] >= 90) {
                    [weakSelf uploadComparisonFace:[ResponseUtils getData:@"errMsg"]];
//                    [weakSelf uploadComparisonFace:image];
                } else {
                    [_webView evaluateJavaScript:@"comparisonFaceFail()" completionHandler:^(id result, NSError * _Nullable error) {
                        if (error) {
                        }
                    }];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [MBManager hideAlert];
                    });
                }
            } else {
                [_webView evaluateJavaScript:@"comparisonFaceFail()" completionHandler:^(id result, NSError * _Nullable error) {
                    if (error) {
                    }
                }];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [MBManager hideAlert];
                });
            }
        } else {
            [_webView evaluateJavaScript:@"comparisonFaceFail()" completionHandler:^(id result, NSError * _Nullable error) {
                if (error) {
                }
            }];
            dispatch_async(dispatch_get_main_queue(), ^{
                [MBManager hideAlert];
            });
        }
    } faild:^(NSString *msg) {
        [_webView evaluateJavaScript:@"comparisonFaceFail()" completionHandler:^(id result, NSError * _Nullable error) {
            if (error) {
            }
        }];
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBManager hideAlert];
        });
    }];
}

- (void)uploadComparisonFace:(NSString *)fileId {
    dispatch_async(dispatch_get_main_queue(), ^{
        [MBManager hideAlert];
    });
    [_webView evaluateJavaScript:[NSString stringWithFormat:@"comparisonFaceSuccess('%@')", fileId] completionHandler:^(id result, NSError * _Nullable error) {
        if (error) {
        }
    }];
//    NSString *fileName = [NSString stringWithFormat:@"IMAGE_%lld.jpeg", (long long)[[NSDate date] timeIntervalSince1970]];
//    [[HttpManager manager] uploadTask:[UrlConfig URL:filesUpload2] data:UIImageJPEGRepresentation(image, 0.3) name:@"file" fileName:fileName mimeType:@"image/jpeg" param:@{
//        @"metaData.userId": [AppUser sharedInstance].userId,
//        @"metaData.type": @"dk"
//    } callback:^(NSURLResponse *response, id data, NSError *error) {
//        dispatch_async(dispatch_get_main_queue(), ^{
//            [MBManager hideAlert];
//        });
//        BIMFile *resultFile = [BIMFile mj_objectWithKeyValues:data];
//        [_webView evaluateJavaScript:[NSString stringWithFormat:@"comparisonFaceSuccess('%@')", resultFile.id] completionHandler:^(id result, NSError * _Nullable error) {
//            if (error) {
//            }
//        }];
//    }];
}

#pragma mark - UIImage转base64
- (NSString *)imageToBase64:(UIImage *)image {
    NSData *imageData = UIImageJPEGRepresentation(image, 0.33);
    return [imageData base64EncodedString];
}

#pragma mark - 处理推送点击待办信息
- (void)handleTodoWithUrl:(NSString *)url {
    NSString *urlF = [UrlConfig URL:url];
    [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[urlF stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]]]];
}

- (void)handleTodoWithUrl2:(NSString *)url {
    NSString *urlF = url;
    if (![url containsString:@"http"]) {
        urlF = [UrlConfig URL:url];
    }
    [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]]]];
}

#pragma mark - 处理质检资料提交
- (void)handleQdSubmit:(NewQDKeyModel *)bean {
    __weak typeof(self) weakSelf = self;
    [[HttpManager manager] get:[UrlConfig URL:queryUserTask] param:@{
        @"bizPk": bean.instId,
        @"userId": [AppUser sharedInstance].userId,
        @"forward": @"0"
    } success:^(NSData *data) {
        NSArray <UserTaskModel *>*datas = [UserTaskModel mj_objectArrayWithKeyValuesArray:data];
        NSString *taskId = @"";
        for (UserTaskModel *item in datas) {
            if ([taskId isEqualToString:@""]) {
                taskId = item.id;
                break;
            }
        }
        if (![taskId isEqualToString:@""]) {
            PassViewController *vc = [[UIStoryboard storyboardWithName:@"Flow" bundle:nil] instantiateViewControllerWithIdentifier:@"pass"];
            vc.instanceId = bean.instId;
            vc.bizKey = bean.processCode;
            vc.bizUrl = @"";
            vc.url = pass;
            vc.title = @"提交";
            vc.taskId = taskId;
            [weakSelf.navigationController pushViewController:vc animated:YES];
        }
    } faild:^(NSString *msg) {
        [SVProgressHUD showErrorWithStatus:msg];
    }];
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
