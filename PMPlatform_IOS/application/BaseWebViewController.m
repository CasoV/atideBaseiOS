//
//  BaseWebViewController.m
//  ycxm
//
//  Created by 末末班车 on 2018/9/19.
//  Copyright © 2018年 末末班车. All rights reserved.
//

#import "BaseWebViewController.h"
#import "WeakScriptMessageDelegate.h"
#import "FileModel.h"
#import <WebKit/WebKit.h>

@interface BaseWebViewController ()<WKNavigationDelegate, WKUIDelegate,WKScriptMessageHandler, UIDocumentPickerDelegate>
@property (nonatomic, strong) UIProgressView *progressView;
@end

@implementation BaseWebViewController {
    WKWebView *_webView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    if (self.filePath) {
        self.title = @"文件浏览";
    }
    
    _webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, kStatusBarH + kNavBarH + 2, kScreen_Width, kScreen_Height - kStatusBarH - kNavBarH - 2)];
    _webView.multipleTouchEnabled = YES;
    _webView.UIDelegate = self;
    _webView.navigationDelegate = self;
    [_webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
    if (self.filePath) {
        NSURL *url = [NSURL fileURLWithPath:self.filePath];
        [_webView loadFileURL:url allowingReadAccessToURL:url];
    }
    if (self.url) {
        [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.url]]];
    }
    [_webView.configuration.userContentController addScriptMessageHandler:[[WeakScriptMessageDelegate alloc] initWithDelegate:self] name:@"toIOSPdfUrl"];
    [_webView.configuration.userContentController addScriptMessageHandler:[[WeakScriptMessageDelegate alloc] initWithDelegate:self] name:@"downloadFile"];
    [_webView.configuration.userContentController addScriptMessageHandler:[[WeakScriptMessageDelegate alloc] initWithDelegate:self] name:@"sendTitle"];
    [self.view addSubview:self.progressView];
    [self.view addSubview:_webView];
    
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back"] style:UIBarButtonItemStylePlain target:self action:@selector(leftItemClick:)];
    self.navigationItem.leftBarButtonItems = @[leftItem];
}
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error{



}

- (void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error{



}
-(void)leftItemClick:(UIBarButtonItem *)bar{
    if ([self.url containsString:@"dynAppRender"]) {
        __weak typeof(self)weakSelf = self;
        [_webView evaluateJavaScript:@"getCurPageStr()" completionHandler:^(NSString * result, NSError * _Nullable error) {
            if (error) {
    
            } else {
                if ([result isEqualToString:@"ApiList"]) {
                    [weakSelf.view resignFirstResponder];
                    [weakSelf.navigationController popViewControllerAnimated:YES];
                } else {
                    NSString *methods = [NSString stringWithFormat:@"clickLeft%@()", result];
                    [self->_webView evaluateJavaScript:methods completionHandler:^(id _Nullable, NSError * _Nullable error) {
                        if (error) {
                          
                        }
                    }];
                }
            }
        }];
    } else {
        if ([_webView canGoBack]) {
            [_webView goBack];
        }else{
            [self.view resignFirstResponder];
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if(self.title){
        self.navigationItem.title = self.title;
    }
    self.navigationController.navigationBar.hidden = NO;
}
- (UIProgressView *)progressView {
    if(!_progressView) {
        _progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(0,  kStatusBarH + kNavBarH , kScreen_Width, 2)];
        _progressView.hidden = YES;
        _progressView.tintColor = [UIColor greenColor];
        _progressView.trackTintColor = [UIColor whiteColor];
    }
    return _progressView;
}

- (void)dealloc {
    [_webView stopLoading];
    [[_webView configuration].userContentController removeScriptMessageHandlerForName:@"toIOSPdfUrl"];
    [[_webView configuration].userContentController removeScriptMessageHandlerForName:@"downloadFile"];
    [[_webView configuration].userContentController removeScriptMessageHandlerForName:@"sendTitle"];
    [_webView removeFromSuperview];
    _webView = nil;
    
//    NSSet *websiteDataTypes = [WKWebsiteDataStore allWebsiteDataTypes];
//
//    //// Date from
//
//    NSDate *dateFrom = [NSDate dateWithTimeIntervalSince1970:0];
//
//    //// Execute
//
//    [[WKWebsiteDataStore defaultDataStore] removeDataOfTypes:websiteDataTypes modifiedSince:dateFrom completionHandler:^{
//
//        // Done
//
//    }];
}

-(void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    NSString *injectionJSString = @"var script = document.createElement('meta');"
    "script.name = 'viewport';"
    "script.content='width=device-width, user-scalable=no';"
    "document.getElementsByTagName('head')[0].appendChild(script);";
    [webView evaluateJavaScript:injectionJSString completionHandler:nil];
}
#pragma mark - 计算wkWebView进度条
- (void)webView:(WKWebView *)webView didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition, NSURLCredential * _Nullable))completionHandler {
    
    if ([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust]) {
        
        NSURLCredential *credential = [[NSURLCredential alloc]initWithTrust:challenge.protectionSpace.serverTrust];
        
        completionHandler(NSURLSessionAuthChallengeUseCredential,credential);
        
    }
    

  

}
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


#pragma mark - WKScriptMessageHandler
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message {
    if ([message.name isEqualToString:@"toIOSPdfUrl"]) {
        NSString *url = message.body;
        if(![url containsString:@".pdf"]){
            [MBManager showBriefAlert:@"pdf地址无效！"];
            return;
        }
        BaseWebViewController *vc = [[BaseWebViewController alloc] init];
        vc.title = @"PDF详情";
        NSCharacterSet *set = [NSCharacterSet URLQueryAllowedCharacterSet];
        NSString *uncodeString = [url stringByRemovingPercentEncoding];
        NSString *encodedString = [uncodeString stringByAddingPercentEncodingWithAllowedCharacters:set];
        vc.url = encodedString;
        [self.navigationController pushViewController:vc animated:YES];
      
    }else if([message.name isEqualToString:@"sendTitle"]){
        NSString *url = message.body;
        self.navigationItem.title = url;
    } else if ([message.name isEqualToString:@"downloadFile"]) {
        float version = [[[UIDevice currentDevice] systemVersion] floatValue];
        if (version >= 11) {
            [self getFileInfo:[message.body stringByReplacingOccurrencesOfString:@"\"" withString:@""]];
        } else {
            [MBManager showBriefAlert:@"下载文件要求手机系统版本在11.0以上"];
        }
    }
}

#pragma mark - 获取文件信息
- (void)getFileInfo:(NSString *)fileId {
    [MBManager showLoading:@"文件下载中"];
    __weak typeof(self) weakSelf = self;
    [[HttpManager manager] post:[UrlConfig URL:searchFiles] param:@{@"id":fileId} success:^(NSData *data) {
        NSArray *files = [FileModel mj_objectArrayWithKeyValuesArray:data];
        if (files.count > 0) {
            [weakSelf downLoadFile:files.firstObject];
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
- (void)downLoadFile:(FileModel *)file {
    __weak typeof(self) weakSelf = self;
    [[HttpManager manager] downloadWithFileid:file.id fileName:[file name] progress:^(NSProgress *downloadProgress) {
        
    } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
        if (error) {
            [MBManager hideAlert];
            [MBManager showBriefAlert:@"文件下载失败！"];
        } else {
            [MBManager hideAlert];
            UIDocumentPickerViewController *documentPickerVC = [[UIDocumentPickerViewController alloc] initWithURL:filePath inMode:UIDocumentPickerModeExportToService];
            // 设置代理
            documentPickerVC.delegate = weakSelf;
            // 设置模态弹出方式
            documentPickerVC.modalPresentationStyle = UIModalPresentationFormSheet;
            [weakSelf.navigationController presentViewController:documentPickerVC animated:YES completion:nil];
        }
    }];
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

@end
