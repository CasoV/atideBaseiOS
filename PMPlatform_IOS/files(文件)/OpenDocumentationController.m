//
//  OpenDocumentationController.m
//  ycxm
//
//  Created by 末末班车 on 2018/9/27.
//  Copyright © 2018年 末末班车. All rights reserved.
//

#import "OpenDocumentationController.h"
#import <WebKit/WebKit.h>

@interface OpenDocumentationController ()

@end

@implementation OpenDocumentationController {
    WKWebView *_webView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.title = @"文件浏览";
    _webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, kStatusBarH + kNavBarH, kScreen_Width, kScreen_Height - kStatusBarH - kNavBarH)];
    _webView.multipleTouchEnabled = YES;
    
    if (self.filepath) {
        if (@available(iOS 11.0, *)) {
            NSURL *url = [NSURL fileURLWithPath:self.filepath];
            [_webView loadFileURL:url allowingReadAccessToURL:url];
        } else {
            if ([self isMp4File]) {
                NSData *data = [NSData dataWithContentsOfFile:self.filepath];
                NSString *newFilepath = [self.filepath stringByReplacingOccurrencesOfString:@"Documents" withString:@"tmp"];
                if (data) {
                    BOOL isSuccess = [data writeToFile:newFilepath atomically:YES];
                    if (isSuccess) {
                        NSURL *url = [NSURL fileURLWithPath:newFilepath];
                        [_webView loadFileURL:url allowingReadAccessToURL:url];
                    } else {
                        [SVProgressHUD showInfoWithStatus:@"视频文件打开失败！"];
                    }
                } else {
                    [SVProgressHUD showInfoWithStatus:@"视频文件打开失败！"];
                }
            } else {
                NSURL *url = [NSURL fileURLWithPath:self.filepath];
                [_webView loadFileURL:url allowingReadAccessToURL:url];
            }
        }
    }
    
    [self.view addSubview:_webView];
}

- (BOOL)isMp4File {
    NSString *suffixStr = [self.filepath componentsSeparatedByString:@"."].lastObject;
    
    return [suffixStr isEqualToString:@"mp4"];
}

@end
