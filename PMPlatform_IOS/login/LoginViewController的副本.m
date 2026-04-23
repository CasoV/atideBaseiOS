//
//  LoginViewController.m
//  EasyCost
//
//  Created by 末末班车 on 2017/8/21.
//  Copyright © 2017年 atide. All rights reserved.
//

#import "LoginViewController.h"
#import <AipOcrSdk/AipOcrSdk.h>
#import "ProtocolModel.h"
#import "STPickerSingle.h"
#import "MainWebController.h"
#import "JPUSHService.h"
#import "NSString+trim.h"
#import <ZIM/ZIM.h>
#import "ZGZIMManager.h"
#import "KeyCenter.h"
#import <LocalAuthentication/LocalAuthentication.h>

@interface LoginViewController ()<STPickerSingleDelegate>

@property (weak, nonatomic) IBOutlet UIView *usernameView;
@property (weak, nonatomic) IBOutlet UIView *pwdView;
@property (weak, nonatomic) IBOutlet UITextField *userNameUI;
@property (weak, nonatomic) IBOutlet UITextField *pwdUI;
@property (weak, nonatomic) IBOutlet UIButton *rememberPwdUI;


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
    
    [self initUI];
    UIView *statusBar = [[UIView alloc] initWithFrame:[UIApplication sharedApplication].keyWindow.windowScene.statusBarManager.statusBarFrame];
     statusBar.backgroundColor = [UIColor navigationBgColor];;
     [[UIApplication sharedApplication].keyWindow addSubview:statusBar];

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
                    NSLog(@"验证成功");
                    [self login:nil];
                });
                
            } else {
                NSLog(@"%@", error.localizedDescription);
                switch (error.code) {
                    case LAErrorSystemCancel: {
                        NSLog(@"系统取消授权，如其他APP切入");
                        break;
                    }
                    case LAErrorUserCancel: {
                        NSLog(@"用户取消验证Face ID");
                        break;
                    }
                    case LAErrorAuthenticationFailed: {
                        NSLog(@"授权失败");
                        break;
                    }
                    case LAErrorPasscodeNotSet: {
                        NSLog(@"系统未设置密码");
                        break;
                    }
                    case LAErrorBiometryNotAvailable: {
                        NSLog(@"设备Face ID不可用，例如未打开");
                        break;
                    }
                    case LAErrorBiometryNotEnrolled: {
                        NSLog(@"设备Face ID不可用，用户未录入");
                        break;
                    }
                    case LAErrorUserFallback: {
                        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                            NSLog(@"用户选择输入密码，切换主线程处理");
                        }];
                        break;
                    }
                    default: {
                        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                            NSLog(@"其他情况，切换主线程处理");
                        }];
                        break;
                    }
                }
            }
        }];
        
    } else {
        NSLog(@"不支持Face ID或Touch ID");
        switch (error.code) {
            case LAErrorBiometryNotEnrolled: {
                NSLog(@"Face ID未注册");
                break;
            }
            case LAErrorPasscodeNotSet: {
                NSLog(@"未设置密码");
                break;
            }
            default: {
                NSLog(@"Face ID不可用");
                break;
            }
        }
        
        NSLog(@"%@",error.localizedDescription);
    }
    
}
- (void)viewWillDisappear:(BOOL)animated{
    [self setStatusBarBackgroundColor:[UIColor navigationBgColor]];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDarkContent;
    [self setStatusBarBackgroundColor:[UIColor navigationBgColor]];
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
            statusBar.backgroundColor= color;
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

    [userDefaults setObject:@"国道219" forKey:@"projectName"];
    [userDefaults setObject:protocolStr forKey:@"protocol"];
    [userDefaults setObject:serverHost forKey:@"ip"];
    [userDefaults setObject:serverPort forKey:@"port"];

//    NSString *ip = [userDefaults objectForKey:@"ip"];
//    NSString *proName = [userDefaults objectForKey:@"projectName"];
    
//    if (ip == nil || [ip isEqualToString:@""] || proName == nil || [proName isEqualToString:@""]) {
//        [self loadIP];
//    }
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
    //默认添加上次登录时的账号密码
    _userNameUI.text = [userDefaults objectForKey:@"user"];
    _pwdUI.text = [userDefaults objectForKey:@"pwd"];
    NSString *remember = [userDefaults objectForKey:@"remember"];
    if (remember == nil || [remember isEqualToString:@"0"]) {
        _rememberPwdUI.selected = NO;
    } else {
        _rememberPwdUI.selected = YES;
        
        if (!self.notAutoLogin && ![_userNameUI.text isEqualToString:@""] && ![_userNameUI.text isEqualToString:@""]) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                自动登录
//                [self login:nil];
                [self faceID];
            });
        }
    }
}

#pragma 按钮点击事件
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
    [self loginNow];
}
-(void)loginNow{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];

    
//    [userDefaults setObject:@"112.112.9.234" forKey:@"ip"];
//    [userDefaults setObject:@"13380" forKey:@"port"];
//    
////    NSString *ip = [userDefaults objectForKey:@"ip"];
////    if (ip == nil || [ip isEqualToString:@""]) {
////        [self loadIP];
////        return;
////    }
////    
    //判断用户名密码是否为空
    if ([_userNameUI.text isEqualToString:@""]) {
        [MBManager showBriefAlert:@"用户名不能为空"];
        return;
    }
    if ([_pwdUI.text isEqualToString:@""]) {
        [MBManager showBriefAlert:@"密码不能为空"];
        return;
    }
    
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
    [userDefaults setObject:_pwdUI.text forKey:@"password"];
    [userDefaults setObject:[self handleEncode:[_pwdUI.text aesEncrypt]] forKey:@"password2"];
    [userDefaults synchronize];
    
    [MBManager showLoading];
//    NSString *pwd = [_pwdUI.text aesEncrypt];
    [[HttpManager manager] post:[UrlConfig login] param:@{@"userId":@"", @"user":_userNameUI.text, @"pwd":_pwdUI.text } success:^(NSData *data) {
        [MBManager hideAlert];
        if ([ResponseUtils success:data]) {
            [UserInfo initUserWithDic:[ResponseUtils getData:@"data"]];
            
//            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//            UIViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"mainTabBar"];
//            [UIApplication sharedApplication].keyWindow.rootViewController = vc;
            
            //登陆的时候加上别名--推送绑定设备和用户
            [JPUSHService setAlias:[UserInfo getInstance].ID completion :^( NSInteger iResCode, NSString *iAlias, NSInteger seq) {
                NSLog ( @"%@" ,iAlias);
                if (iResCode == 0 ) {
                    NSLog ( @"添加别名成功" );
                }
            } seq : 1 ];
            
            ZIMAppConfig *appConfig = [[ZIMAppConfig alloc] init];
            appConfig.appID = KeyCenter.appID;
            appConfig.appSign = KeyCenter.appSign;
            [[ZGZIMManager shared] createZIM:appConfig];
            ZIMUserInfo *userInfo = [[ZIMUserInfo alloc] init];
            userInfo.userID = [UserInfo getInstance].ID;
            userInfo.userName = [UserInfo getInstance].name;
            
            [[ZGZIMManager shared] login:userInfo token:@"" callback:^(ZIMError * _Nonnull errorInfo) {
                NSLog(@"%@",errorInfo);
              }
            ];
            
            
            NSString *userName = [[NSUserDefaults standardUserDefaults] objectForKey:@"user"];
            NSString *password = [[NSUserDefaults standardUserDefaults] objectForKey:@"password"];
            MainWebController *webvc =  [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"MainWebController"];
//            [UrlConfig URL:@"/mobileHome/tabbarHome"],
            webvc.url = [NSString stringWithFormat:@"%@?user=%@&pwd=%@&mobileType=all,ios",
                         [UrlConfig URL:@"/mobileHome/tabbarHome"],[userName stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]], [self handleEncode:password]];
//            webvc.url = @"https://m.500.com/info/article/detail-231721.shtml";
//            ChooseCharacterViewController *webvc =  [[UIStoryboard storyboardWithName:@"Live" bundle:nil]instantiateViewControllerWithIdentifier:@"ChooseCharacterViewController"];
            
            UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:webvc];
            
            [UIApplication sharedApplication].keyWindow.rootViewController = nav;
            
        } else {
            [MBManager showBriefAlert:[ResponseUtils getMsg]];
        }
    } faild:^(NSString *msg) {
        [MBManager hideAlert];
        [MBManager showBriefAlert:msg];
    }];
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
- (IBAction)changeIP:(id)sender {
    self.userNameUI.text = @"";
    self.pwdUI.text = @"";
    
    [self loadIP];
}

@end
