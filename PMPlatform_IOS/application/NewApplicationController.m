//
//  NewApplicationController.m
//  PMPlatform_IOS
//
//  Created by 末末班车 on 2022/6/13.
//  Copyright © 2022 com.atide. All rights reserved.
//

#import "NewApplicationController.h"
#import "ChooseProjectController.h"
#import "FDScanViewController.h"
#import "WeakScriptMessageDelegate.h"
#import <WebKit/WebKit.h>
#import "FunctionClickUtil.h"

@interface NewApplicationController ()<WKNavigationDelegate, WKUIDelegate,WKScriptMessageHandler>

@property (nonatomic, strong) UIProgressView *progressView;

@end

@implementation NewApplicationController {
    WKWebView *_webView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setNav];
    if ([self isLoadedProjectsAndSections]) {
        [self setProjectAndSiteName];
    } else {
        [self loadProjectInfos];
    }
    [self initWebView];
}

#pragma mark -  初始化页面
-(void)setNav{
    self.navigationItem.title = @"";
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button addTarget:self action:@selector(scan) forControlEvents:UIControlEventTouchUpInside];
    button.frame = CGRectMake(0, 0, 44, 44);
    [button setImage:[UIImage imageNamed:@"icon_scan_white"] forState:UIControlStateNormal];
    [self.view addSubview:button];
    // 设置rightBarButtonItem
    UIBarButtonItem *rightItem =[[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.rightBarButtonItem = rightItem;

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self setProjectAndSiteName];
}

- (void)setProjectAndSiteName {
    NSString *title = @"";
    if ([[UserAgent DefaultAgent].sectionName isEqualToString:@""]) {
        title = [UserAgent DefaultAgent].prjName;
    } else {
        title = [UserAgent DefaultAgent].sectionName;
    }
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:title style:UIBarButtonItemStylePlain target:self action:@selector(chooseSiteBtnClicked)];
    self.navigationItem.leftBarButtonItem.tintColor = UIColor.whiteColor;
    [self.navigationItem.leftBarButtonItem setTitleTextAttributes:@{NSForegroundColorAttributeName:UIColor.whiteColor,NSFontAttributeName:[UIFont boldSystemFontOfSize:16.0f]} forState:UIControlStateNormal];
}

#pragma mark - 切换项目公司
- (void)chooseSiteBtnClicked {
    ChooseProjectController *vc = [[ChooseProjectController alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - 扫一扫
- (void)scan {
    FDScanViewController *fdvc = [[FDScanViewController alloc] init];
    UINavigationController * nVC = [[UINavigationController alloc]initWithRootViewController:fdvc];
    [self presentViewController:nVC animated:YES completion:nil];
}

#pragma mark - 数据验证
- (BOOL)isLoadedProjectsAndSections {
    if ([UserAgent DefaultAgent].projectInfos) {
        for (ProjectInfo *info in [UserAgent DefaultAgent].projectInfos) {
            if (!info.children) {
                return NO;
            }
        }
        return YES;
    } else {
        return NO;
    }
}

- (void)loadProjectInfos {
    __weak typeof(self) weakSelf = self;
    [[HttpManager manager] post:[UrlConfig URL:getProjects] param:@{@"async":@0,@"topKey":@"project",@"keyPrefix":@"project,section"} success:^(NSData *data) {
        [ProjectInfo mj_setupObjectClassInArray:^NSDictionary *{
            return @{@"children":@"ProjectInfo"};
        }];
        NSMutableArray <ProjectInfo *>*dataCollection = [ProjectInfo mj_objectArrayWithKeyValuesArray:data];
        [UserAgent DefaultAgent].projectInfos = dataCollection;
        ProjectInfo *projectInfo = nil;
        ProjectInfo *sectionInfo = nil;
        for (ProjectInfo *info in dataCollection) {
            NSMutableArray <ProjectInfo *>*childArr = [NSMutableArray array];
            [weakSelf getProjectDataChildren:info.children rootChildren:childArr];
            info.tempChildren = childArr;
            if ([info.id isEqualToString:[UserAgent DefaultAgent].projectId]) {
                projectInfo = info;
            }
        }
        if (!projectInfo) {
            projectInfo = dataCollection.firstObject;
        }
        projectInfo.selected = YES;
        [UserAgent DefaultAgent].sectionInfos = projectInfo.tempChildren;

        for (ProjectInfo *sect in projectInfo.tempChildren) {
            if ([sect.id isEqualToString:[UserAgent DefaultAgent].sectionId]) {
                sectionInfo = sect;
                break;
            }
        }

        [UserAgent DefaultAgent].projectId = projectInfo.id;
        [UserAgent DefaultAgent].projectCode = projectInfo.otherInfo[@"projectCode"];
        [UserAgent DefaultAgent].typeKey = projectInfo.attributes[@"key"];
        [UserAgent DefaultAgent].projectPlanSn = projectInfo.otherInfo[@"projectPlanSn"];
        if (!sectionInfo) {
            [UserAgent DefaultAgent].sectionId = @"";
            [UserAgent DefaultAgent].sectionCode = @"";
        } else {
            sectionInfo.selected = YES;
            [UserAgent DefaultAgent].sectionId = sectionInfo.id;
            [UserAgent DefaultAgent].sectionCode = sectionInfo.otherInfo[@"sectCode"];
        }
        [[UserAgent DefaultAgent] saveValuesToCache];
        [weakSelf setSeviceProjectInfo:projectInfo section:sectionInfo];
        if ([weakSelf isLoadedProjectsAndSections]) {
            [weakSelf setProjectAndSiteName];
        }
    } faild:^(NSString *msg) {
    }];
}

- (void)getProjectDataChildren:(NSArray <ProjectInfo *>*)children rootChildren:(NSMutableArray <ProjectInfo *>*)rootChildren {
    for (ProjectInfo *sect in children) {
        [rootChildren addObject:sect];
        
        if (sect.children && sect.children.count > 0) {
            [self getProjectDataChildren:sect.children rootChildren:rootChildren];
        }
    }
}

-(void)setSeviceProjectInfo:(ProjectInfo *)project section:(ProjectInfo *)sectionInfo{
    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithDictionary:@{
        @"typeKey":project.attributes[@"key"],
        @"projectId": project.id,
        @"mainPrjName": project.text,
        @"mainPrjCode": project.otherInfo[@"projectCode"],
        @"projectPlanSn": project.otherInfo[@"projectPlanSn"]
    }];
    if (sectionInfo) {
        [param setObject:sectionInfo.id forKey:@"mainSectionId"];
        [param setObject:sectionInfo.text forKey:@"mainSectionName"];
        [param setObject:sectionInfo.otherInfo[@"sectCode"] forKey:@"mainSectionCode"];
        [param setObject:sectionInfo.otherInfo[@"stdVersion"] forKey:@"stdVersion"];
        [param setObject:sectionInfo.otherInfo[@"sectMajor"] forKey:@"sectionMajor"];
    }
    //切换服务器项目
    [[HttpManager manager]post:[UrlConfig URL:setPrjInfo] param:param success:^(NSData *data) {} faild:^(NSString *msg) {}];
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

#pragma mark - 初始化webView
-(void)initWebView {
    CGFloat bottomH = [self safeDistanceBottom];
    
    _webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, kStatusBarH + kNavBarH, kScreen_Width, kScreen_Height - kStatusBarH - kNavBarH - bottomH - 49)];
    _webView.multipleTouchEnabled = YES;
    _webView.UIDelegate = self;
    _webView.navigationDelegate = self;
    [_webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
    NSString *userName = [[NSUserDefaults standardUserDefaults] objectForKey:@"user"];
    NSString *password = [[NSUserDefaults standardUserDefaults] objectForKey:@"password"];
    NSString *url = [NSString stringWithFormat:@"%@?user=%@&pwd=%@&mobileType=all,ios", [UrlConfig URL:@"/mobileHome/mhome"], [userName stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]], [password stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]];
    [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]]];
    [_webView.configuration.userContentController addScriptMessageHandler:[[WeakScriptMessageDelegate alloc] initWithDelegate:self] name:@"functionClicked"];
    [self.view addSubview:self.progressView];
    [self.view addSubview:_webView];
}

- (void)dealloc {
    [_webView stopLoading];
    [[_webView configuration].userContentController removeScriptMessageHandlerForName:@"functionClicked"];
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

#pragma mark - WKScriptMessageHandler
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message {
    if ([message.name isEqualToString:@"functionClicked"]) {
        NSDictionary *dic = [message.body mj_JSONObject];
        [PermissionModel mj_setupObjectClassInArray:^NSDictionary *{
            return @{@"children":@"PermissionModel"};
        }];
        PermissionModel *functionData = [PermissionModel mj_objectWithKeyValues:dic];
        if (functionData) {
            [FunctionClickUtil handleFunctionClick:self functionData:functionData];
        }
    }
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


@end
