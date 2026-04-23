//
//  CaRegistViewController.m
//  ycxm
//
//  Created by 高小伟 on 2020/4/17.
//  Copyright © 2020 末末班车. All rights reserved.
//

#import "CaRegistViewController.h"
#import <WebKit/WebKit.h>
#import <SDWebImage/SDImageCache.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import "MainWebController.h"
#import "SVProgressHUD.h"
#import "CaLoginUtil.h"
#import "NSString+trim.h"
#import "ZGZIMManager.h"
#import "KeyCenter.h"
#import <ZIM/ZIM.h>
#import "XGPush.h"

@interface CaRegistViewController ()

@property (weak, nonatomic) IBOutlet UITextField *nameTf;
@property (weak, nonatomic) IBOutlet UITextField *pwdTf;
@property (weak, nonatomic) IBOutlet UITextField *RegTf;
@property (weak, nonatomic) IBOutlet UITextField *pinTf;

@property (nonatomic, copy) NSString *username;
@property (nonatomic, copy) NSString *password;
@property (nonatomic, copy) NSString *loginPassword;
@end

@implementation CaRegistViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:SVProgressHUDDidTouchDownInsideNotification object:nil];
}
- (IBAction)login:(id)sender {
    [SVProgressHUD showWithStatus:@"加载中..."];
    [self registerUserDevice];
}
#pragma mark 证书用户激活
- (void)registerUserDevice{
    if (![self checkUsernameAndPassword]) {
        [SVProgressHUD showErrorWithStatus:@"用户名或者密码注册码不能为空！"];
        return;
    }
    if (_pinTf.text.length == 0) {
        [SVProgressHUD showErrorWithStatus:@"请输入PIN码"];
        return;
    }
    [[NSUserDefaults standardUserDefaults] setObject:_username forKey:USER_DEFAULT_USER_NAME];
    IMUser *user = [IMUser userWithUserName:_username];
    if (user) {
        [user.cert verifyPIN:_password andCompleteBlock:^(int resultCode, int remaintimes) {
            if (resultCode == IM_ER_SUCCESS) {
                //登录
                [[CaLoginUtil alloc] loginByPin:self->_pinTf.text openId:^(NSString * _Nonnull openId) {
                    if (openId) {
                        [self loginWithUserName:self->_username Password:self->_loginPassword];
                    }
                }];
            } else {
                if (remaintimes > 0) {
                    [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"PIN码错误，剩余尝试次数%d次", remaintimes]];
                } else {
                    [SVProgressHUD showErrorWithStatus:@"PIN码达到最大错误次数，已被锁定"];
                }
            }
        }];
    } else {
        UserType type;
        NSString *keyword = [_password substringToIndex:1];
        if ([keyword isEqualToString:@"o"]) {
            type = UserTypeToken;
        } else if([keyword isEqualToString:@"c"]){
            type = UserTypeCert;
        } else {
            [SVProgressHUD showErrorWithStatus:@"无效的注册码"];
            return;
        }

        [IMUser signUpWithUserName:_username signCode:_password andCompleteBlock:^(int resultCode, IMUser *user) {
            if (resultCode == IM_ER_SUCCESS) {
                //申请证书
                [self downloadCert];
            }else{
                [SVProgressHUD dismiss];
            }
        }];
    }
}
#pragma mark 激活后下载证书
- (void)downloadCert{
    IMUser *user = [IMUser userWithUserName:_username];
    // 下载证书
    [user.cert applyCertWithUsername:_username PIN:_pinTf.text registerCode:_password  completeBlock:^(int resultCode) {
        if (resultCode == IM_ER_SUCCESS) {
            //登录
            [[CaLoginUtil alloc]loginByPin:self.pinTf.text openId:^(NSString * _Nonnull openId) {
                if (openId) {
                    [self loginWithUserName:self->_username Password:self->_loginPassword];
                }
            }];
        } else {
            NSString *strMsg = [IMError getMsgWithErr:resultCode];
            [SVProgressHUD showErrorWithStatus:strMsg];
        }
    }];
}

-(BOOL)checkUsernameAndPassword {
    BOOL result;
    _username = [_nameTf.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    _password = [_RegTf.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    _loginPassword = [_pwdTf.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if (_username.length == 0 || _password.length == 0 || _loginPassword.length == 0) {
        result = NO;
    }else{
        result = YES;
    }
    
    return result;
}

- (void)loginWithUserName:(NSString *)userName Password:(NSString *)password{
    [SVProgressHUD showWithStatus:@"正在验证身份..."];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSMutableArray *userList = [NSMutableArray arrayWithArray:[userDefaults objectForKey:@"userList"]];
    [userDefaults setObject:userName forKey:@"user"];
    [userDefaults setObject:password forKey:@"pwd"];
    [userDefaults setObject:@"1" forKey:@"remember"];
    NSString *pwd = password;
    if (self.encryptPwd) {
        pwd = [password aesEncrypt];
    }
    [userDefaults setObject:password forKey:@"password"];
    [userDefaults setObject:[self handleEncode:pwd] forKey:@"password2"];
    [userDefaults synchronize];

    __weak typeof(self) weakSelf = self;
    NSDictionary *params = @{ @"user": userName, @"pwd": pwd, @"platform": @"1011" };
    [[HttpManager manager] post:[UrlConfig login] param:params success:^(NSData *data) {
        if ([ResponseUtils success:data]) {
            [SVProgressHUD dismiss];
            [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeNone];

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
            for (NSInteger i = 0; i < userList.count; i++) {
                NSMutableDictionary *dic =  [NSMutableDictionary dictionaryWithDictionary:userList[i]];
                if([dic[@"user"] isEqualToString:userName]){
                    remberedUser = true;
                    remberedIndex = i;
                    dic[@"pwd"] = password;
                    remberedDic = dic;
                }
            }
            if (!remberedUser) {
                [userList addObject:@{ @"user": userName, @"pwd": password }];
            } else {
                [userList replaceObjectAtIndex:remberedIndex withObject:remberedDic];
            }

            [userDefaults setObject:userList forKey:@"userList"];

            [weakSelf checkClearCache];
        } else {
            [SVProgressHUD showInfoWithStatus:[ResponseUtils getMsg]];
            [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeNone];
        }
    } faild:^(NSString *msg) {
        [SVProgressHUD showInfoWithStatus:@"失败!"];
        [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeNone];
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

@end
