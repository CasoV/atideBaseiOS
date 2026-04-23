//
//  MiddleMeasureReportPdfController.m
//  ycxm
//
//  Created by 末末班车 on 2020/3/25.
//  Copyright © 2020 末末班车. All rights reserved.
//

#import "MiddleMeasureReportPdfController.h"
#import "OpinionsModel.h"
#import <WebKit/WebKit.h>
#import "PartModel.h"
#import "BIMFile.h"

@interface MiddleMeasureReportPdfController ()<WKNavigationDelegate, WKUIDelegate>

@property (nonatomic, strong) WKWebView *webView;

@property (nonatomic, strong) UIProgressView *progressView;

@property (nonatomic, copy) NSString *treeCode;

@property (nonatomic, copy) NSString *bizPk;

@property (nonatomic, copy) NSString *periodId;

@property (nonatomic, copy) NSString *periodNum;

@property (nonatomic, copy) NSString *url;

@property (nonatomic, copy) NSString *pdfId;

@property (nonatomic, strong) NSMutableDictionary *signMap;

@property (nonatomic, copy) NSDictionary *infoMap;

@end

@implementation MiddleMeasureReportPdfController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.treeCode = @"pentaho";
    self.bizPk = self.info[@"id"] ? self.info[@"id"] : @"";
    self.periodId = self.info[@"periodId"] ? self.info[@"periodId"] : @"";
    self.periodNum = self.info[@"periodNum"] ? self.info[@"periodNum"] : @"";
    [self initUI];
    [self getContents];
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

#pragma mark - 获取模版目录
- (void)getContents {
    [SVProgressHUD showWithStatus:nil];
    __weak typeof(self) weakSelf = self;
    NSString *url = [UrlConfig URL:getChildrenFilter];
    NSDictionary *params = @{
        @"treeCode":self.treeCode,
        @"sectId":self.sectionId,
        @"periodId":self.periodId
    };
    [[HttpManager manager] post:url param:params success:^(NSData *data) {
        [SVProgressHUD dismiss];
        NSArray *datas = [PartModel mj_objectArrayWithKeyValuesArray:data];
        for (PartModel *item in datas) {
            if ([item.text isEqualToString:@"中期支付证书报表"]) {
                weakSelf.url = item.sedId;
                weakSelf.pdfId = item.id;
                
                [weakSelf setProcessData];
                return ;
            //                            url = item.sedId ?: ""
            //                            pdfId = item.id ?: ""
            //                            setProcessData()
            //                            return
            }
        }
    } faild:^(NSString *msg) {
        [SVProgressHUD showErrorWithStatus:msg];
    }];
}

#pragma mark - 获取流程审核信息
- (void)setProcessData {
    [SVProgressHUD showWithStatus:nil];
    __weak typeof(self) weakSelf = self;
    NSString *url = [UrlConfig URL:getIntermediateProcess];
    [[HttpManager manager] post:url param:@{@"bizPk":self.bizPk} success:^(NSData *data) {
        if ([ResponseUtils success:data]) {
            weakSelf.signMap = nil;
            
            NSArray <OpinionsModel *>*datas = [OpinionsModel mj_objectArrayWithKeyValuesArray:[ResponseUtils getData:@"data"]];
            for (OpinionsModel *item in datas) {
                if (weakSelf.signMap == nil) {
                    weakSelf.signMap = [NSMutableDictionary dictionary];
                }
                
                [weakSelf.signMap setObject:[NSString stringWithFormat:@"%@://%@:%@/workflow/commonFlow/getCommentByte?commentId=%@&type=2", protocolStr, serverHost, serverPort, item.id] forKey:[NSString stringWithFormat:@"%@_img", item.activeId]];
                [weakSelf.signMap setObject:[NSString stringWithFormat:@"%@://%@:%@/workflow/commonFlow/getCommentByte?commentId=%@&type=1", protocolStr, serverHost, serverPort, item.id] forKey:[NSString stringWithFormat:@"%@_seal", item.activeId]];
                [weakSelf.signMap setObject:item.message forKey:[NSString stringWithFormat:@"%@_message", item.activeId]];
                [weakSelf.signMap setObject:item.time forKey:[NSString stringWithFormat:@"%@_time", item.activeId]];
            }
        } else {
            [SVProgressHUD showErrorWithStatus:[ResponseUtils getMsg]];
        }
        [weakSelf loadInfo];
    } faild:^(NSString *msg) {
        [SVProgressHUD showErrorWithStatus:msg];
    }];
}

#pragma mark - 加载项目数据
- (void)loadInfo {
    [SVProgressHUD showWithStatus:nil];
    
    __weak typeof(self) weakSelf = self;
    NSString *url = [UrlConfig URL:mpSheetData];
    NSDictionary *params = @{
        @"index":@"0",
        @"bizPk":self.bizPk,
        @"projectId":self.projectId,
        @"sectId":self.sectionId,
        @"periodId":self.periodId,
        @"ppp":self.sectionId
    };

    [[HttpManager manager] post:url param:params success:^(NSData *data) {
        if ([ResponseUtils success:data]) {
            weakSelf.infoMap = [ResponseUtils getData:@"data"];
            [weakSelf getTotalData];
        } else {
            [SVProgressHUD showErrorWithStatus:[ResponseUtils getMsg]];
        }
    } faild:^(NSString *msg) {
        [SVProgressHUD showErrorWithStatus:msg];
    }];
}

#pragma mark - 获取表格数据
- (void)getTotalData {
    [self loadPdf];
//    OkGo.post<DataCollectionA<Map<String, Any>>>(MeterageApi.sheetData)
//    .params("sheetNo", 100)
//    .params("bizPk", bizPk)
//    .params("projectId",proBean?.id ?: "")
//    .params("sectId",sectBean?.id ?: "")
//    .params("periodId", periodId)
//    .execute(object : DialogCallback<DataCollectionA<Map<String, Any>>>(activity) {
//        override fun onSuccess(response: Response<DataCollectionA<Map<String, Any>>>) {
//            val body = response.body()
//            if (body.isSucceed) {
//                _totalData = mutableMapOf()
//                for ((key, value) in body.data) {
//                    if (value != null) {
//                        _totalData!!.put(key, value.toString())
//                    }
//                }
//                loadPdf()
//            } else {
//                App.instance.toast(body?.msg ?: "数据获取失败")
//            }
//        }
//    })
}

#pragma mark - 下载pdf文件
- (void)loadPdf {
    [SVProgressHUD showWithStatus:nil];
    
    __weak typeof(self) weakSelf = self;
    NSString *fileName = [NSString stringWithFormat:@"%@.pdf", self.pdfId];
    NSString *url = [NSString stringWithFormat:@"%@://%@:%@%@", protocolStr, serverHost, serverPort, self.url];
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:self.infoMap];
    [params setObject:self.projectId forKey:@"projectId"];
    [params setObject:self.sectionId forKey:@"sectId"];
    [params setObject:@"0" forKey:@"newFormFlag"];
    [params setObject:self.bizPk forKey:@"bizPk"];
    [params setObject:self.periodId forKey:@"periodId"];
    [params setObject:self.periodNum forKey:@"periodNum"];
    [params setObject:self.treeCode forKey:@"treeCode"];
    [params setObject:self.sectionId forKey:@"ppp"];
    [params setObject:self.sectionId forKey:@"dataFrom"];
    [[HttpManager manager] downloadWithUrl:url params:params fileName:fileName progress:^(NSProgress *downloadProgress) {
        
    } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
        [SVProgressHUD dismiss];
        [weakSelf.webView loadRequest:[NSURLRequest requestWithURL:filePath]];
    }];
}

@end
