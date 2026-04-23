//
//  TLFeedbackViewController.m
//  ZegoRoomkitDemo
//
//  Created by xia on 2021/5/27.
//  Copyright © 2021 zego. All rights reserved.
//

#import "TLFeedbackViewController.h"
#import <WebKit/WebKit.h>

static NSString * const kUploadLogCommand = @"uploadLog";
static NSString * const kCallbackCommand = @"callback";

@interface TLFeedbackViewController ()<WKNavigationDelegate, WKScriptMessageHandler>

@property (nonatomic, strong) WKWebView *webView;
@property (nonatomic, weak) WKUserContentController *userVC;

@end
@interface NSURLRequest (IgnoreSSL)
+(BOOL)allowsAnyHTTPSCertificateForHost:(NSString*)host;
@end
@implementation NSURLRequest (IgnoreSSL)
+(BOOL)allowsAnyHTTPSCertificateForHost:(NSString*)host {return YES;}
@end
@implementation TLFeedbackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self configNavigationBar];
    [self.view addSubview:self.webView];
    [self loadURLString:self.urlString];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.userVC addScriptMessageHandler:self name:kUploadLogCommand];
    [self.userVC addScriptMessageHandler:self name:kCallbackCommand];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.userVC removeScriptMessageHandlerForName:kUploadLogCommand];
    [self.userVC removeScriptMessageHandlerForName:kCallbackCommand];
}

- (void)dealloc {
    _webView = nil;
    NSLog(@"%s dealloc", __FUNCTION__);
}

- (void)configNavigationBar {
    self.navigationItem.title = self.webTitle;
    UIBarButtonItem *left = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nav_back"] style:UIBarButtonItemStylePlain target:self action:@selector(onLeftBarButtonClicked:)];
    self.navigationItem.leftBarButtonItems = @[left];
}

- (void)onLeftBarButtonClicked:(UIButton *)sender {
    if (self.presentingViewController) {
        [self dismissViewControllerAnimated:YES completion:nil];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)loadURLString:(NSString *)urlStr {
    NSURL *url = [NSURL URLWithString:[urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:request];
}

#pragma mark - WKScriptMessageHandler
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message {
    NSLog(@"didReceiveScriptMessage, name: %@, body: %@", message.name, message.body);
    if ([message.name isEqualToString:kUploadLogCommand]) {
        // message.body 即为消息内容
//        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//        hud.label.text = TLLocalizedString(setting_upload_log_ing);
        
        @ZegoWeak(self);
        [ZegoRoomKit uploadLog:self.logFileName
                    completion:^(ZegoRoomKitError error) {
            NSLog(@"uploadLog, error: %lu", (unsigned long)error);
//            @ZegoStrong(self);
//            [MBProgressHUD hideHUDForView:self.view];
//            if (error == ZegoRoomKitSuccess) {
//                [MBProgressHUD showSuccess:TLLocalizedString(setting_upload_log_succeeded) withFinishBlock:nil];
//                [self.navigationController popViewControllerAnimated:YES];
//            } else {
//                NSString *message = [NSString stringWithFormat:TLLocalizedString(setting_upload_log_failed), (long)error];
//                [MBProgressHUD showSuccess:message withFinishBlock:nil];
//            }
        }];
    } else if ([message.name isEqualToString:kCallbackCommand]) {
        [self.navigationController popViewControllerAnimated:YES];
//        NSNumber *body = message.body;
//        [MBProgressHUD showSuccess:body.intValue == 1 ? TLLocalizedString(setting_feedback_succeed) : TLLocalizedString(setting_feedback_fail) withFinishBlock:nil];
    } else {
        NSLog(@"received script message, but name not matched");
    }
}

#pragma mark - WKNavigationDelegate
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    decisionHandler(WKNavigationActionPolicyAllow);
}

- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(null_unspecified WKNavigation *)navigation {
}

- (void)webView:(WKWebView *)webView didReceiveServerRedirectForProvisionalNavigation:(null_unspecified WKNavigation *)navigation {
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    // 不允许 webview 缩放
    NSString *injectionJSString = @"var script = document.createElement('meta');"
    "script.name = 'viewport';"
    "script.content=\"width=device-width, user-scalable=no\";"
    "document.getElementsByTagName('head')[0].appendChild(script);";
    [webView evaluateJavaScript:injectionJSString completionHandler:nil];
}

- (void)webView:(WKWebView *)webView didFailNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error {
}

- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error {
}

#pragma mark -- 横竖屏设置
- (BOOL)shouldAutorotate {
    return NO;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

#pragma mark - Getter
- (WKWebView *)webView {
    if (!_webView) {
        WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
        WKUserContentController *userVC = [[WKUserContentController alloc] init];
        config.userContentController = userVC;
        self.userVC = userVC;
        _webView = [[WKWebView alloc] initWithFrame:self.view.bounds configuration:config];
        _webView.scrollView.directionalLockEnabled = YES;
        _webView.scrollView.bounces = NO;
        _webView.navigationDelegate = self;
    }
    return _webView;
}

@end

