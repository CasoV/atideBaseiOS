//
//  QDPdfController.m
//  ycxm
//
//  Created by 末末班车 on 2020/3/17.
//  Copyright © 2020 末末班车. All rights reserved.
//

#import "QDPdfController.h"
#import <WebKit/WebKit.h>
#import "BIMFile.h"

@interface QDPdfController ()<WKNavigationDelegate, WKUIDelegate>

@property (nonatomic, strong) WKWebView *webView;

@property (nonatomic, strong) UIProgressView *progressView;

@property (nonatomic, copy) NSString *taskId;

@end

@implementation QDPdfController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initUI];
    [self refresh];
}

#pragma mark - 初始化页面
- (void)initUI {
    WKWebViewConfiguration*config = [[WKWebViewConfiguration alloc]init];
    config.selectionGranularity = WKSelectionGranularityCharacter;
    self.webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, 0) configuration:config];
    self.webView.UIDelegate = self;
    self.webView.navigationDelegate = self;
    [self.webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
    [self.view addSubview:self.webView];
    [self.view addSubview:self.progressView];
    
    [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.left.right.equalTo(self.view);
    }];
    
    self.line.hidden = YES;
}

#pragma mark - 懒加载
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

#pragma mark - 传递taskId
- (void)setTaskId:(NSString *)taskId {
    _taskId = taskId;
    [self refresh];
}

#pragma mark - 刷新
- (void)refresh {
    if (self.taskId != nil && ![self.taskId isEqualToString:@""]) {
        [self loadFileList];
    }
}

#pragma mark - 加载文件列表
- (void)loadFileList {
    NSString *url = [UrlConfig URL:searchFiles];
    NSDictionary *params = @{
        @"metaData.bizPk" : self.bizPk,
        @"metaData.taskId" : self.taskId
    };
    __weak typeof(self) weakSelf = self;
    [[HttpManager manager] post:url param:params success:^(NSData *data) {
        NSArray <BIMFile *>*fileList = [BIMFile mj_objectArrayWithKeyValuesArray:data];
        if (fileList.count > 0) {
            [weakSelf loadPdf:fileList[0].id];
        } else {
            [SVProgressHUD showErrorWithStatus:@"未找到对应文件!"];
        }
    } faild:^(NSString *msg) {
        [SVProgressHUD showErrorWithStatus:msg];
    }];
}

#pragma mark - 下载pdf文件
- (void)loadPdf:(NSString *)ID {
    NSString *fileName = [NSString stringWithFormat:@"%@.pdf", ID];
    __weak typeof(self) weakSelf = self;
    [[HttpManager manager] downloadWithFileid:ID fileName:fileName progress:^(NSProgress *downloadProgress) {
        
    } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
        
//        加载本地文件某些老机型加载不出
//        [weakSelf.webView loadRequest:[NSURLRequest requestWithURL:filePath]];
        
//       加载本地文件
        [weakSelf.webView loadFileURL:filePath allowingReadAccessToURL:filePath];
           
    }];
}
@end
