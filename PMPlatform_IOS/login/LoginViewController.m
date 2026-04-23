//
//  LoginViewController.m
//  EasyCost
//
//  Created by 末末班车 on 2017/8/21.
//  Copyright © 2017年 atide. All rights reserved.
//

#import "LoginViewController.h"
#import <AipOcrSdk/AipOcrSdk.h>
#import <SDWebImage/SDImageCache.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import <WebKit/WebKit.h>
#import "ProtocolModel.h"
#import "STPickerSingle.h"
#import "MainWebController.h"
#import "IpViewController.h"
#import "NSString+trim.h"
#import <ZIM/ZIM.h>
#import "ZGZIMManager.h"
#import "KeyCenter.h"
#import "XGPush.h"
#import "RSAUtil.h"
#import <LocalAuthentication/LocalAuthentication.h>
#import "PopoverView.h"
#import "CaRegistViewController.h"

@interface LoginViewController ()<STPickerSingleDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *bgImageView;
@property (weak, nonatomic) IBOutlet UIView *usernameView;
@property (weak, nonatomic) IBOutlet UIView *pwdView;
@property (weak, nonatomic) IBOutlet UIView *captchaView;
@property (weak, nonatomic) IBOutlet UITextField *userNameUI;
@property (weak, nonatomic) IBOutlet UITextField *pwdUI;
@property (weak, nonatomic) IBOutlet UITextField *captchaUI;
@property (weak, nonatomic) IBOutlet UIButton *rememberPwdUI;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *pwdConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rememberConstraint;
@property (weak, nonatomic) IBOutlet UIImageView *captchaIV;
@property (weak, nonatomic) IBOutlet UIButton *caBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomHeight;

@property (nonatomic, copy) NSString *baseUrl;
@property (nonatomic, copy) NSString *baseUrlCode;
@property (nonatomic, assign) BOOL encryptPwd;
@property (nonatomic, copy) NSString *encryptType;
@property (nonatomic, copy) NSString *publicKey;
@property (nonatomic, assign) NSInteger networkStatus;

@property (nonatomic, strong) PopoverView *popoverView;
@end

@implementation LoginViewController {
    NSArray <ProtocolModel *>*_dataSource;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    // 初始化百度OCR
    NSString *licenseFile = [[NSBundle mainBundle] pathForResource:@"aip" ofType:@"license"];
    NSData *licenseFileData = [NSData dataWithContentsOfFile:licenseFile];
    if (!licenseFileData) {
        [[[UIAlertView alloc] initWithTitle:@"授权失败" message:@"授权文件不存在" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil] show];
    }
    [[AipOcrService shardService] authWithLicenseFileData:licenseFileData];
    
    [_userNameUI addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    
    __weak typeof(self) weakSelf = self;
    AFNetworkReachabilityManager *networkReachManager = [AFNetworkReachabilityManager sharedManager];
    [networkReachManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        weakSelf.networkStatus = status;
        if (useCaptcha && (status == AFNetworkReachabilityStatusReachableViaWiFi || status == AFNetworkReachabilityStatusReachableViaWWAN)) {
            [weakSelf getCaptchaData];
        }
    }];
    [networkReachManager startMonitoring];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orientationChanged:) name:UIDeviceOrientationDidChangeNotification object:nil];
}

- (void)orientationChanged:(NSNotification *)notification {
    UIDevice *device = [notification object];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self changeUIByOrientation:[device orientation]];
    });
}

- (void)changeUIByOrientation:(UIDeviceOrientation)orientation {
    if (orientation == UIDeviceOrientationFaceUp || orientation == UIDeviceOrientationFaceDown) {
        return;
    }
    
    if (orientation == UIDeviceOrientationLandscapeLeft || orientation == UIDeviceOrientationLandscapeRight) {
        self.bgImageView.hidden = YES;
        self.bottomHeight.constant = SCREEN_HEIGHT - 21;
        if (@available(iOS 13.0, *)) {
            [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDarkContent;
        } else {
            // Fallback on earlier versions
        }
        [self setStatusBarBackgroundColor:[UIColor colorWithWhite:0 alpha:0]];
    } else {
        self.bgImageView.hidden = NO;
        self.bottomHeight.constant = SCREEN_HEIGHT - self.bgImageView.bounds.size.height - [[UIApplication sharedApplication] delegate].window.safeAreaInsets.top - [[UIApplication sharedApplication] delegate].window.safeAreaInsets.bottom;
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
        [self setStatusBarBackgroundColor:[UIColor navigationBgColor]];
    }
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (useCaptcha) {
            self.pwdConstraint.constant = -self.captchaView.bounds.size.height / 2;
            self.rememberConstraint.constant = self.captchaView.bounds.size.height;
        } else {
            self.pwdConstraint.constant = 0;
            self.rememberConstraint.constant = 0;
        }
    });
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

- (BOOL)shouldAutorotate {
    return NO;
}

- (void)textFieldDidChange:(UITextField * )sender {
    NSString *text =((UITextField *)sender).text;
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSMutableArray *userList = [NSMutableArray arrayWithArray:[userDefaults objectForKey:@"userList"]];
    NSMutableArray <PopoverAction *>*actionArr = [NSMutableArray array];
    for (NSDictionary *dic in userList) {
        if([dic[@"user"] rangeOfString:text].location!=NSNotFound){
            [actionArr addObject:[PopoverAction actionWithTitle:dic[@"user"] handler:^(PopoverAction *action) {
                _userNameUI.text = dic[@"user"];
                _pwdUI.text = dic[@"pwd"];
            }]];
        }
    }
    [_popoverView hide];
    _popoverView = [PopoverView popoverView];
    _popoverView.showShade = NO; // 显示阴影背景
    _popoverView.style = PopoverViewStyleDefault; // 设置为黑色风格
    if(actionArr.count >0){
        // 有两种显示方法
//        [_popoverView showToView:((UITextField *)sender) withActions:actionArr];
        CGRect fromRc = [self.view.window convertRect:sender.bounds fromView:sender];
        [_popoverView showToPoint:CGPointMake(fromRc.origin.x, fromRc.origin.y + fromRc.size.height) withActions:actionArr];
    }
}
- (IBAction)loginByFace:(id)sender {
    [self faceID];
}

- (void)faceID {
    //创建LAContext
    LAContext *context = [[LAContext alloc] init];
    context.localizedFallbackTitle = @"使用账号密码登陆";
    //错误信息
    NSError *error = nil;
    //判断设备是否支持Face ID或Touch ID
    BOOL isUseFaceOrTouchID = [context canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&error];
    if (isUseFaceOrTouchID) {
        //这个是用来验证TouchID的，会有弹出框出来
        //字符串参数为验证失败时提示语
        [context evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics localizedReason:@"验证失败！或许你...不是本人？" reply:^(BOOL success, NSError * _Nullable error) {
            if (success) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self login:nil];
                });
                
            } else {
                switch (error.code) {
                    case LAErrorSystemCancel: {
                        break;
                    }
                    case LAErrorUserCancel: {
                        break;
                    }
                    case LAErrorAuthenticationFailed: {
                        break;
                    }
                    case LAErrorPasscodeNotSet: {
                        break;
                    }
                    case LAErrorBiometryNotAvailable: {
                        break;
                    }
                    case LAErrorBiometryNotEnrolled: {
                        break;
                    }
                    case LAErrorUserFallback: {
                        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                        }];
                        break;
                    }
                    default: {
                        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                        }];
                        break;
                    }
                }
            }
        }];
    } else {
        switch (error.code) {
            case LAErrorBiometryNotEnrolled: {
                break;
            }
            case LAErrorPasscodeNotSet: {
                break;
            }
            default: {
                break;
            }
        }
    }
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.title = @"";
    self.navigationController.navigationBarHidden = YES;
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    [self setStatusBarBackgroundColor:[UIColor navigationBgColor]];
}

-(void)setStatusBarBackgroundColor:(UIColor *)color {
    if(@available(iOS 13.0, *)) {
        static UIView* statusBar = nil;
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
        if (color.alpha == 0.0) {
            statusBar.hidden = YES;
        } else {
            statusBar.hidden = NO;
        }
    }else{
        UIView *statusBar = [[[UIApplication sharedApplication] valueForKey:@"statusBarWindow"] valueForKey:@"statusBar"];
        if([statusBar respondsToSelector:@selector(setBackgroundColor:)]) {
            statusBar.backgroundColor= color;
        }
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    self.baseUrl = [userDefaults objectForKey:@"baseUrl"];
    self.baseUrlCode = [userDefaults objectForKey:@"baseUrlCode"];
    
    if (self.baseUrl == nil) {
        self.baseUrl = @"http://220.165.247.94:42780/";
        self.baseUrlCode = @"nxgscs";
        
        [userDefaults setObject:self.baseUrl forKey:@"baseUrl"];
        [userDefaults setObject:self.baseUrlCode forKey:@"baseUrlCode"];
        [userDefaults setObject:@(1) forKey:@"useCaptcha"];
    }
    
    if (self.baseUrl == nil) {
        [self changeIpClick:nil];
    } else {
        NSArray<NSString *> *temp = [self.baseUrl componentsSeparatedByString:@":"];
        if (temp.count == 2 || temp.count == 3) {
            NSString *ip = [temp[1] stringByReplacingOccurrencesOfString:@"/" withString:@""];
            NSString *port = @"";
            isCa = NO;
            if ([self.baseUrlCode containsString:@"jjt"] || [self.baseUrlCode containsString:@"nxgs"] || [self.baseUrlCode containsString:@"lzgs"]) {
                isCa = YES;
            }
            if (temp.count == 3) {
                port = [temp[2] stringByReplacingOccurrencesOfString:@"/" withString:@""];
            }
            [userDefaults setObject:@"" forKey:@"projectName"];
            [userDefaults setObject:temp[0] forKey:@"protocol"];
            [userDefaults setObject:ip forKey:@"ip"];
            [userDefaults setObject:port forKey:@"port"];
            [userDefaults synchronize];
            [self initUI];
        } else {
            [self changeIpClick:nil];
        }
    }
}

#pragma mark - 加载ip地址
- (void)loadIP {
    [[HttpManager manager] get:protocolStrIp param:nil success:^(NSData *data) {
        _dataSource = [ProtocolModel mj_objectArrayWithKeyValuesArray:data];
        if (_dataSource) {
            [self showProjectPicker];
        }
    } faild:^(NSString *msg) {
        
    }];
}

#pragma mark - 初始化视图
- (void)initUI {
    //配置记住密码按钮
    [_rememberPwdUI setImage:[UIImage imageNamed:@"check_normal_label"] forState:UIControlStateNormal];
    [_rememberPwdUI setImage:[UIImage imageNamed:@"check_selected_label"] forState:UIControlStateSelected];
    _rememberPwdUI.tintColor = [UIColor blueColor];
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    if (self.networkStatus == AFNetworkReachabilityStatusReachableViaWiFi || self.networkStatus == AFNetworkReachabilityStatusReachableViaWWAN) {
        [self.bgImageView sd_setImageWithURL:[NSURL URLWithString:[UrlConfig URL:loginBgUrl]] placeholderImage:[UIImage imageNamed:@"login_bg"]];
    } else {
        [self.bgImageView setImage:[UIImage imageNamed:@"login_bg"]];
    }
    
    //验证码
    NSNumber *useCaptchaStr = [userDefaults objectForKey:@"useCaptcha"];
    if (useCaptchaStr != nil && useCaptchaStr.intValue == 1) {
        useCaptcha = YES;
    } else {
        useCaptcha = NO;
    }
    
    if (useCaptcha) {
        self.captchaView.hidden = NO;
        if (self.networkStatus == AFNetworkReachabilityStatusReachableViaWiFi || self.networkStatus == AFNetworkReachabilityStatusReachableViaWWAN) {
            [self getCaptchaData];
        }
    } else {
        self.captchaView.hidden = YES;
    }
    
    UIDeviceOrientation orientation = UIDeviceOrientationPortrait;
    if (SCREEN_WIDTH > SCREEN_HEIGHT) {
        orientation = UIDeviceOrientationLandscapeRight;
    }

    [self changeUIByOrientation:orientation];
    
    //默认添加上次登录时的账号密码
    _userNameUI.text = [userDefaults objectForKey:@"user"];
    _pwdUI.text = [userDefaults objectForKey:@"pwd"];
    NSString *remember = [userDefaults objectForKey:@"remember"];
    
    self.caBtn.hidden = !isCa;
    if (isCa) {
        // Ca初始化
        NSString *username = [userDefaults objectForKey:@"user"];
        NSString *ip = [userDefaults objectForKey:@"ip"];
        NSString *port = [userDefaults objectForKey:@"port"];
        int ret = infosec_initialize_std([ip UTF8String], [port intValue], 0, nil, (unsigned char *)[@"" cStringUsingEncoding:NSUTF8StringEncoding], 0, (char *)[@"" cStringUsingEncoding:NSUTF8StringEncoding], (char *)[@"" cStringUsingEncoding:NSUTF8StringEncoding], (char *)[@"" cStringUsingEncoding:NSUTF8StringEncoding]);
        if (ret != 0) {
        }
        self.caBtn.hidden = username && [IMUser userWithUserName:username];
    }
    
    if (remember == nil || [remember isEqualToString:@"0"]) {
        _rememberPwdUI.selected = NO;
    } else {
        _rememberPwdUI.selected = YES;
        
        if (!self.notAutoLogin && ![_userNameUI.text isEqualToString:@""] && ![_userNameUI.text isEqualToString:@""] && !useCaptcha) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                自动登录
                [self login:nil];
//                [self faceID];
            });
        }
    }
}

- (void)getCaptchaData {
    __weak typeof(self) weakSelf = self;
    [[HttpManager manager] get:[UrlConfig URL:captchaUrl] param:@{
        @"_": [self currentTimeStr]
    } success:^(NSData *data) {
        if ([ResponseUtils success:data]) {
            NSDictionary *resData = [[ResponseUtils getData:@"data"] mj_JSONObject];
            captchaKey = resData[@"captchaKey"];
            NSString *captchaImage = resData[@"captchaImage"];
            if (captchaImage != nil && ![captchaImage isEqualToString:@""]) {
                [weakSelf.captchaIV setImage:[UIImage imageWithData:[[NSData alloc] initWithBase64EncodedString:captchaImage options:0]]];
            } else {
                [MBManager showBriefAlert:@"验证码获取失败！"];
            }
        } else {
            [MBManager showBriefAlert:[ResponseUtils getMsg]];
        }
    } faild:^(NSString *msg) {
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            [weakSelf getCaptchaData];
//        });
    }];
}

#pragma mark - 按钮点击事件
- (IBAction)caBtnClick:(id)sender {
    CaRegistViewController *caregVc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"CaregVc"];
    caregVc.encryptPwd = self.encryptPwd;
    [self presentViewController:caregVc animated:YES completion:nil];
}

- (IBAction)captchaClick:(id)sender {
    [self getCaptchaData];
}

- (IBAction)changeIpClick:(id)sender {
    IpViewController *vc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"ip"];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)rememberAction:(UIButton *)sender {
    sender.selected = !sender.isSelected;
}
- (IBAction)regise:(id)sender {
    MainWebController *webvc =  [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"MainWebController"];
    webvc.url = [NSString stringWithFormat:@"%@", [UrlConfig URL:@"/financeApp/agrolabourerCompanyInfo?isNew=1"]];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:webvc];
    [UIApplication sharedApplication].keyWindow.rootViewController = nav;
}
- (IBAction)login:(id)sender {
    [self loginNowPre];
}

- (void)loginNowPre {
    if (self.networkStatus == AFNetworkReachabilityStatusUnknown || self.networkStatus == AFNetworkReachabilityStatusNotReachable) {
        [MBManager showBriefAlert:@"当前网络不可用，请检查网络！"];
        __weak typeof(self) weakSelf = self;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [weakSelf jumpToSettings];
        });
        return;
    }
    
    //判断用户名密码是否为空
    if ([_userNameUI.text isEqualToString:@""]) {
        [MBManager showBriefAlert:@"用户名不能为空"];
        return;
    }
    if ([_pwdUI.text isEqualToString:@""]) {
        [MBManager showBriefAlert:@"密码不能为空"];
        return;
    }
    
    if (useCaptcha && [_captchaUI.text isEqualToString:@""]) {
        [MBManager showBriefAlert:@"验证码不能为空"];
        return;
    }
    
    self.encryptPwd = NO;
    __weak typeof(self) weakSelf = self;
    [[HttpManager manager] get:[UrlConfig URL:pwdWayUrl] param:@{} success:^(NSData *data) {
        if ([ResponseUtils success:data]) {
            NSString *res = [ResponseUtils getData:@"data"];
            if (res != nil) {
                if ([res isEqualToString:@"aes"] || [res isEqualToString:@"rsa"]) {
                    weakSelf.encryptType = res;
                    weakSelf.encryptPwd = YES;
                    if ([res isEqualToString:@"rsa"]) {
                        [weakSelf getPublicKey];
                        return;
                    }
                }
            }
        }
        [weakSelf loginNow];
    } faild:^(NSString *msg) {
        [weakSelf loginNow];
    }];
}

- (void)getPublicKey {
    __weak typeof(self) weakSelf = self;
    [[HttpManager manager] get:[UrlConfig URL:publicKeyUrl] param:@{} success:^(NSData *data) {
        if ([ResponseUtils success:data]) {
            weakSelf.publicKey = [ResponseUtils getData:@"data"];
            [weakSelf loginNow];
        } else {
            [MBManager showBriefAlert:[ResponseUtils getMsg]];
        }
    } faild:^(NSString *msg) {
        [MBManager showBriefAlert:msg];
    }];
}

-(void)loginNow {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSMutableArray *userList = [NSMutableArray arrayWithArray:[userDefaults objectForKey:@"userList"]];
    //根据记住密码按钮状态存储用户名和密码
    if (_rememberPwdUI.isSelected) {
        [userDefaults setObject:_userNameUI.text forKey:@"user"];
        [userDefaults setObject:_pwdUI.text forKey:@"pwd"];
        [userDefaults setObject:@"1" forKey:@"remember"];
       
    }else {
        [userDefaults setObject:_userNameUI.text forKey:@"user"];
        [userDefaults setObject:@"" forKey:@"pwd"];
        [userDefaults setObject:@"0" forKey:@"remember"];
    }
    NSString *pwd = _pwdUI.text;
    if (self.encryptPwd) {
        if ([self.encryptType isEqualToString:@"aes"]) {
            pwd = [_pwdUI.text aesEncrypt];
        } else if ([self.encryptType isEqualToString:@"rsa"]) {
            pwd = [RSAUtil encryptString:_pwdUI.text publicKey:self.publicKey];
        }
    }
    [userDefaults setObject:_pwdUI.text forKey:@"password"];
    [userDefaults setObject:[self handleEncode:pwd] forKey:@"password2"];
    [userDefaults synchronize];
    
    [MBManager showLoading];
    __weak typeof(self) weakSelf = self;
    
    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithDictionary:@{
        @"user": _userNameUI.text,
        @"pwd": pwd,
        @"platform": @"1011"
    }];
    if (useCaptcha) {
        [param setObject:[_captchaUI.text stringByReplacingOccurrencesOfString:@" " withString:@""] forKey:@"captcha"];
        [param setObject:captchaKey forKey:@"captchaKey"];
    }
    
    [[HttpManager manager] post:[UrlConfig login] param:[param copy] success:^(NSData *data) {
        [MBManager hideAlert];
        if ([ResponseUtils success:data]) {
            [UserInfo initUserWithDic:[ResponseUtils getData:@"data"]];
            
            AppUser *appUser = [AppUser mj_objectWithKeyValues:[ResponseUtils getData:@"data"]];
            [[AppUser sharedInstance] updateWithUser:appUser];
            
            [[XGPushTokenManager defaultTokenManager] upsertAccountsByDict:@{ @(0):[NSString stringWithFormat:@"12%@",[UserInfo getInstance].ID] }];
            
            ZIMAppConfig *appConfig = [[ZIMAppConfig alloc] init];
            appConfig.appID = KeyCenter.appID;
            appConfig.appSign = KeyCenter.appSign;
            [[ZGZIMManager shared] createZIM:appConfig];
            ZIMUserInfo *userInfo = [[ZIMUserInfo alloc] init];
            userInfo.userID = [UserInfo getInstance].ID;
            userInfo.userName = [UserInfo getInstance].name;
            
            [[ZGZIMManager shared] login:userInfo token:@"" callback:^(ZIMError * _Nonnull errorInfo) {
              }
            ];
            
            //记住登陆成功过的账号密码
            BOOL remberedUser = false;
            NSInteger remberedIndex = 0;
            NSMutableDictionary *remberedDic = [NSMutableDictionary dictionary];
            if (_rememberPwdUI.isSelected) {
                for (NSInteger i=0; i<userList.count; i++) {
                    NSMutableDictionary *dic =  [NSMutableDictionary dictionaryWithDictionary:userList[i]];
                    if([dic[@"user"] isEqualToString:_userNameUI.text]){
                        remberedUser = true;
                        remberedIndex = i; 
                        dic[@"pwd"] =_pwdUI.text;
                        remberedDic = dic;
                    }
                }
                if(!remberedUser){
                    [userList addObject:@{@"user":_userNameUI.text,@"pwd":_pwdUI.text}];
                }else{
                    [userList  replaceObjectAtIndex:remberedIndex withObject:remberedDic];
                }
     
                [userDefaults setObject:userList forKey:@"userList"];
            }
            
            [weakSelf checkClearCache];
        } else {
            [MBManager showBriefAlert:[ResponseUtils getMsg]];
            [weakSelf getCaptchaData];
        }
    } faild:^(NSString *msg) {
        [MBManager hideAlert];
        [MBManager showBriefAlert:msg];
        [weakSelf getCaptchaData];
    }];
}

- (void)checkClearCache {
    __weak typeof(self) weakSelf = self;
    [[HttpManager manager] jsonPost:[UrlConfig URL:recordQueryUrl] param:@{ @"entityName": @"YX_YDDQD_VERSION" } success:^(NSData *data) {
        if ([ResponseUtils success:data]) {
            NSArray *dataArray = [ResponseUtils getData:@"rows"];
            if (dataArray.count > 0) {
                NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
                NSString *frontVersion = [[dataArray.firstObject objectForKey:@"fields"] objectForKey:@"VERSION_NO"];
                NSString *localFrontVersion = [userDefaults objectForKey:@"frontVersion"];
                if (localFrontVersion != nil && ![localFrontVersion isEqualToString:frontVersion]) {
                    [weakSelf clearCacheWithFilePath:[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject]];
                }
                [userDefaults setObject:frontVersion forKey:@"frontVersion"];
                [userDefaults synchronize];
            }
        }
        [weakSelf toMainVc];
    } faild:^(NSString *msg) {
        [weakSelf toMainVc];
    }];
}

- (void)toMainVc {
    NSString *userName = [[NSUserDefaults standardUserDefaults] objectForKey:@"user"];
    NSString *password = [[NSUserDefaults standardUserDefaults] objectForKey:@"password2"];
    MainWebController *webvc =  [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"MainWebController"];
    NSString *url = [NSString stringWithFormat:@"%@?user=%@&pwd=%@&mobileType=all,ios",
                     [UrlConfig URL:@"/mobileHome/tabbarHome"],[userName stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]], password];
    webvc.url = url;
    webvc.localUC = useCaptcha;
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:webvc];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [UIApplication sharedApplication].keyWindow.rootViewController = nav;
}

#pragma mark - 处理转码问题
- (NSString *)handleEncode:(NSString *)str {
    NSString *tempStr = [str stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    tempStr = [tempStr stringByReplacingOccurrencesOfString:@"+" withString:@"%2B"];
    return tempStr;
}

#pragma mark - 选择工程
- (void)showProjectPicker {
    if (!_dataSource) {
        return;
    }
    NSMutableArray <NSString *>*dataArr = [NSMutableArray array];
    for (ProtocolModel *model in _dataSource) {
        [dataArr addObject:[NSString stringWithFormat:@"%@(%@)", model.name, model.desc]];
    }
    STPickerSingle *pickerSingle = [[STPickerSingle alloc]init];
    pickerSingle.login = YES;
    [pickerSingle setArrayData:dataArr];
    [pickerSingle setTitle:@"请选择"];
    [pickerSingle setDelegate:self];
    pickerSingle.contentMode = STPickerContentModeCenter;
    [pickerSingle show];
}

#pragma mark - STPickerSingleDelegate
- (void)pickerSingle:(STPickerSingle *)pickerSingle selectedTitle:(NSString *)selectedTitle {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    for (ProtocolModel *item in _dataSource) {
        if ([item.name isEqualToString:[selectedTitle componentsSeparatedByString:@"("].firstObject]) {
            [userDefaults setObject:item.protocol forKey:@"protocol"];
            [userDefaults setObject:item.ip forKey:@"ip"];
            [userDefaults setObject:item.port forKey:@"port"];
            if (item.hasOutline) {
                [userDefaults setObject:@"1" forKey:@"hasOutline"];
            } else {
                [userDefaults setObject:@"0" forKey:@"hasOutline"];
            }
            if (item.hasMeasure) {
                //计量暂时屏蔽
//                [userDefaults setObject:@"1" forKey:@"hasMeasure"];
                [userDefaults setObject:@"0" forKey:@"hasMeasure"];
            } else {
                [userDefaults setObject:@"0" forKey:@"hasMeasure"];
            }
            if (item.hasSealManagement) {
                [userDefaults setObject:@"1" forKey:@"hasSealManagement"];
            } else {
                [userDefaults setObject:@"0" forKey:@"hasSealManagement"];
            }
            [userDefaults setObject:item.name forKey:@"projectName"];
            
            [userDefaults synchronize];
        }
    }
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

//获取当前时间戳
- (NSString *)currentTimeStr{
    NSDate* date = [NSDate dateWithTimeIntervalSinceNow:0];//获取当前时间0秒后的时间
    NSTimeInterval time=[date timeIntervalSince1970]*1000;// *1000 是精确到毫秒，不乘就是精确到秒
    NSString *timeString = [NSString stringWithFormat:@"%.0f", time];
    return timeString;
}

- (void)jumpToSettings {
    NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
    
    if ([[UIApplication sharedApplication] canOpenURL:url]) {
        [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:^(BOOL success) {
            if (success) {
            } else {
            }
        }];
    }
}

-(void)dealloc {
    [[AFNetworkReachabilityManager sharedManager] stopMonitoring];
}

@end
