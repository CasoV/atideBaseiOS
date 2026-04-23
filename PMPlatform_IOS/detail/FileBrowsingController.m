//
//  FileBrowsingController.m
//  PMPlatform_IOS
//
//  Created by 末末班车 on 2017/9/12.
//  Copyright © 2017年 com.atide. All rights reserved.
//

#import "FileBrowsingController.h"
#import <WebKit/WebKit.h>

@interface FileBrowsingController ()

@end

@implementation FileBrowsingController {
    WKWebView *_webView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.title = @"文件浏览";
    _webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 64, ScreenWidth, ScreenHeight -64)];
    _webView.multipleTouchEnabled = YES;
    if (self.filePath) {
        NSURL *url = [NSURL fileURLWithPath:self.filePath];
        [_webView loadFileURL:url allowingReadAccessToURL:url];
    }
    
    [self.view addSubview:_webView];
}

@end
