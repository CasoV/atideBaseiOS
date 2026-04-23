//
//  NewHomeController.m
//  PMPlatform_IOS
//
//  Created by 末末班车 on 2022/6/13.
//  Copyright © 2022 com.atide. All rights reserved.
//

#import "NewHomeController.h"
#import "WeakScriptMessageDelegate.h"
#import <WebKit/WebKit.h>
#import "FileModel.h"

@interface NewHomeController ()<WKNavigationDelegate, WKUIDelegate, UIDocumentPickerDelegate>

@property (nonatomic, strong) UIProgressView *progressView;

@end

@implementation NewHomeController {
    WKWebView *_webView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, kStatusBarH, kScreen_Width, kScreen_Height - kStatusBarH)];
    _webView.multipleTouchEnabled = YES;
    _webView.UIDelegate = self;
    _webView.navigationDelegate = self;
    NSString *userName = [[NSUserDefaults standardUserDefaults] objectForKey:@"user"];
    NSString *password = [[NSUserDefaults standardUserDefaults] objectForKey:@"password"];
    [_webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
    NSString *url = [NSString stringWithFormat:@"%@?user=%@&pwd=%@", [UrlConfig URL:@"/officialApp/dealtInfo"], [userName stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]], [password stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]];
    [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]]];
    [_webView.configuration.userContentController addScriptMessageHandler:[[WeakScriptMessageDelegate alloc] initWithDelegate:self] name:@"downloadFile"];
    [self.view addSubview:_webView];
    [self.view addSubview:self.progressView];
}

- (UIProgressView *)progressView {
    if(!_progressView) {
        _progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(0,  kStatusBarH , kScreen_Width, 2)];
        _progressView.hidden = YES;
        _progressView.tintColor = [UIColor greenColor];
        _progressView.trackTintColor = [UIColor whiteColor];
    }
    return _progressView;
}

- (void)dealloc {
    [_webView stopLoading];
    [[_webView configuration].userContentController removeScriptMessageHandlerForName:@"downloadFile"];
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

-(void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    NSString *injectionJSString = @"var script = document.createElement('meta');"
    "script.name = 'viewport';"
    "script.content='width=device-width, user-scalable=no';"
    "document.getElementsByTagName('head')[0].appendChild(script);";
    [webView evaluateJavaScript:injectionJSString completionHandler:nil];
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

#pragma mark - WKScriptMessageHandler
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message {
    if ([message.name isEqualToString:@"downloadFile"]) {
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
            [weakSelf presentViewController:documentPickerVC animated:YES completion:nil];
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
