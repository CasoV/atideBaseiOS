//
//  AppDelegate.m
//  PMPlatform_IOS
//
//  Created by vxg on 2017/09/04.
//  Copyright © 2017年 com.atide. All rights reserved.
//

#import "AppDelegate.h"
#import <IQKeyboardManager/IQKeyboardManager.h>
#import "ProtocolModel.h"
#import <AMapFoundationKit/AMapFoundationKit.h>
#import "XGPush.h"
// 引入JPush功能所需头文件
//#import "JPUSHService.h"
// iOS10注册APNs所需头文件
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#endif
#import <ZPNs/ZPNs.h>
#import "ZGZIMManager.h"
#import "KeyCenter.h"
#import <UserNotifications/UserNotifications.h>
#import "NSDictionary+MyLog.h"
#import <ZIM/ZIM.h>
#import "PushKit/PushKit.h"
#import <ZPNs/ZPNs.h>
#import "CallDataManager.h"
#import "LoginViewController.h"
#import "IpViewController.h"
#import "MainWebController.h"
#import <Intents/Intents.h>
#import "GULAppEnvironmentUtil.h"
#import "XGPush.h"
#import "XGPushPrivate.h"
#import <UserNotifications/UserNotifications.h>

#if TARGET_OS_IOS || TARGET_OS_TV || TARGET_OS_WATCH
static NSString *const kEntitlementsAPSEnvironmentKey = @"Entitlements.aps-environment";
#else
static NSString *const kEntitlementsAPSEnvironmentKey =
    @"Entitlements.com.apple.developer.aps-environment";
#endif
static NSString *const kAPSEnvironmentDevelopmentValue = @"development";


@interface AppDelegate ()<UNUserNotificationCenterDelegate,ZPNsNotificationCenterDelegate,PKPushRegistryDelegate,XGPushDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    // init Push
    // notice: 2.1.5版本的SDK新增的注册方法，改成可上报IDFA，如果没有使用IDFA直接传nil
    // 如需继续使用pushConfig.plist文件声明appKey等配置内容，请依旧使用[JPUSHService setupWithOption:launchOptions]方式初始化。
//    [JPUSHService setupWithOption:launchOptions appKey:@"490d6104488a33c8d8dbaf53"
//                          channel:@"App Store"
//                 apsForProduction:1
//            advertisingIdentifier:nil];
    
    // IOS8 新系统需要使用新的代码
    [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge) categories:nil]];
    
    [[UIApplication sharedApplication] registerForRemoteNotifications];
    
    // 创建讯飞语言识别
//    [IFlySpeechUtility createUtility:@"appid=57d67d4e"];
    
    [IQKeyboardManager sharedManager].enable = YES;
    self.blockRotation = NO;
    
    //文@"704702bce345052c6ea661673a1d0c53";  张@"4635f875e1e5379f9825c54aa233288f"
    //    ATD@"4412a16c24fcdadc76e17b9d5fbd9d83"  新：@"4412a16c24fcdadc76e17b9d5fbd9d83";
    [AMapServices sharedServices].apiKey =  @"704702bce345052c6ea661673a1d0c53";
   
    
    //设置导航栏
//    [UINavigationBar appearance].backgroundColor = [UIColor whiteColor];
    [UINavigationBar appearance].tintColor = [UIColor blackColor];
    [UINavigationBar appearance].titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor blackColor]};

    if (@available(iOS 11.0, *)) {

    } else {
        [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -60) forBarMetrics:UIBarMetricsDefault];
    }
    
    
   
    
    [self redirectNSLogToDocumentFolder];
    [[ZGZIMManager shared] addZIMEventDelegate:(id)[CallDataManager shared]];
    [self loadKeyCenter];
    //AppDelegate注册通知
    if (@available(iOS 10.0, *)) {
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        center.delegate = (id)[ZPNs shared];
        [[ZPNs shared] setZPNsNotificationCenterDelegate:self];
        [center requestAuthorizationWithOptions:(UNAuthorizationOptionBadge|UNAuthorizationOptionSound|UNAuthorizationOptionAlert) completionHandler:^(BOOL granted, NSError * _Nullable error) {
            if(granted){
                dispatch_async(dispatch_get_main_queue(), ^{
                    [ZPNs version];
                    ZPNsConfig *config = [[ZPNsConfig alloc] init];
                    config.appType = 0;
                    [[ZPNs shared] setPushConfig:config];
                    [[ZPNs shared] setZPNsNotificationCenterDelegate:(id)self];
                    [[ZPNs shared] registerAPNs];
                });
            }
        }];
        
        ZPNsConfig *zpnsConfig = [[ZPNsConfig alloc] init];
        zpnsConfig.appType = 0;
        [[ZPNs shared] setPushConfig:zpnsConfig];
        [AppDelegate voipRegistration];
        
        [[XGPush defaultManager] startXGWithAccessID:1600040984 accessKey:@"ITXJ1QHQ96U6" delegate:self];
        [self xgStart];
        
#if TARGET_OS_SIMULATOR && TARGET_OS_IOS
          // If APNS token is available on iOS Simulator, we must use the sandbox profile
          // https://developer.apple.com/documentation/xcode-release-notes/xcode-14-release-notes
          BOOL isSandboxApp = YES;
          GGLog(@"is sandbox app is true");
#else
          BOOL isSandboxApp = [self FIRMessagingIsSandboxApp];
        
    }
#endif    
    
    return YES;
}

/// 启动TPNS
- (void)xgStart {
    /// 控制台打印TPNS日志，开发调试建议开启
    [[XGPush defaultManager] setEnableDebug:YES];
    
    /// 自定义通知栏消息行为，有自定义消息行为需要使用
    //    [self setNotificationConfigure];

    /// 非广州集群，请开启对应集群配置（广州集群无需使用），此函数需要在startXGWithAccessID函数之前调用
    //    [self configHost];
#ifdef TPNS_VoIP
    /// 注册VoIP服务，需要先于startXGWithAccessID:accessKey:delegate:主线程执行
    [TPNSVoIPManager voipRegistration];
#endif
#ifdef TPNS_AUTHOR_CUSTOM /// 需要定义通知授权弹框时机时使用,如无此类需求请直接参考else分支代码
    /// 读取"通知权限弹框"是否展示过的标识
    if ([TPNSCommonMethod hasTPNSAuthorAlertShown]) {
        /// 如果通知权限弹框已展示过，则启动时调用注册
        /// 启动TPNS服务
        [[XGPush defaultManager] startXGWithAccessID:1600040984 accessKey:@"ITXJ1QHQ96U6" delegate:self];
        /// 角标数目清零,通知中心清空，不清空可设置成-1
        [XGPush defaultManager].xgApplicationBadgeNumber = 0;
    } else {
        /// 若未通知权限弹框展示过, 则请在需要展示的时机（如用户隐私协议弹出后展示通知授权弹框）调用注册代码
    }
#else
    /// 启动TPNS服务，需要主线程执行
    [[XGPush defaultManager] startXGWithAccessID:1600040984 accessKey:@"ITXJ1QHQ96U6" delegate:self];
    /// 角标数目清零,通知中心清空，不清空可设置成-1
    [XGPush defaultManager].xgApplicationBadgeNumber = 0;
#endif
}

/********XGPush代理，提供注册机反注册结果回调，消息接收机消息点击回调，清除角标回调********/

#pragma mark *** TPNS业务回调（注册，接收/点击消息，同步角标） ***

/// 注册推送服务成功回调
/// @param deviceToken APNs 生成的Device Token
/// @param xgToken TPNS 生成的 Token，推送消息时需要使用此值。TPNS 维护此值与APNs 的 Device Token的映射关系
/// @param error 错误信息，若error为nil则注册推送服务成功
- (void)xgPushDidRegisteredDeviceToken:(nullable NSString *)deviceToken xgToken:(nullable NSString *)xgToken error:(nullable NSError *)error {
    NSString *errorStr = !error ? NSLocalizedString(@"success", nil) : NSLocalizedString(@"failed", nil);
    NSString *message = [NSString stringWithFormat:@"%@%@", NSLocalizedString(@"register_app", nil), errorStr];

    //在注册完成后上报角标数目
    if (!error) {
        //重置TPNS服务端角标基数
//        [[XGPush defaultManager] setBadge:0];
    }

}

/// 统一接收消息的回调
/// @param notification 消息对象(有2种类型NSDictionary和UNNotification具体解析参考示例代码)
/// @note 此回调为前台收到通知消息及所有状态下收到静默消息的回调（消息点击需使用统一点击回调）
/// 区分消息类型说明：xg字段里的msgtype为1则代表通知消息,msgtype为2则代表静默消息,msgtype为9则代表本地通知
- (void)xgPushDidReceiveRemoteNotification:(nonnull id)notification withCompletionHandler:(nullable void (^)(NSUInteger))completionHandler {
    NSDictionary *notificationDic = nil;
    if ([notification isKindOfClass:[UNNotification class]]) {
        notificationDic = ((UNNotification *)notification).request.content.userInfo;
        completionHandler(UNNotificationPresentationOptionBadge | UNNotificationPresentationOptionSound | UNNotificationPresentationOptionAlert);
    } else if ([notification isKindOfClass:[NSDictionary class]]) {
        notificationDic = notification;
        completionHandler(UIBackgroundFetchResultNewData);
    }
}

/// 统一点击回调
/// @param response 如果iOS 10+/macOS 10.14+则为UNNotificationResponse，低于目标版本则为NSDictionary
/// 区分消息类型说明：xg字段里的msgtype为1则代表通知消息,msgtype为9则代表本地通知
- (void)xgPushDidReceiveNotificationResponse:(nonnull id)response withCompletionHandler:(nonnull void (^)(void))completionHandler {
    if ([response isKindOfClass:[UNNotificationResponse class]]) {
        /// iOS10+消息体获取
        NSDictionary *notificationDic = ((UNNotificationResponse *)response).notification.request.content.userInfo;
        NSString *customStr = [notificationDic objectForKey:@"custom"];
        if (customStr != nil) {
            NSDictionary *customDic = [customStr mj_JSONObject];
            NSString *doUrl = [customDic objectForKey:@"doUrl"];
            if (doUrl != nil) {
                UIViewController *rootVc = [UIApplication sharedApplication].keyWindow.rootViewController;
                if (rootVc != nil && [rootVc isKindOfClass:[UINavigationController class]]) {
                    UINavigationController *rootNav = (UINavigationController *)rootVc;
                    UIViewController *navPre = rootNav.visibleViewController;
                    if ([navPre isKindOfClass:[MainWebController class]]) {
                        MainWebController *navPreF = (MainWebController *)navPre;
                        [navPreF handleTodoWithUrl:doUrl];
                    } else {
                        self.doUrl = doUrl;
                    }
                }
            }
        }
    } else if ([response isKindOfClass:[NSDictionary class]]) {
        /// 低于iOS10消息体获取
    }
    completionHandler();
}

/// 角标设置成功回调
/// @param isSuccess 设置角标是否成功
/// @param error 错误标识，若设置不成功会返回
- (void)xgPushDidSetBadge:(BOOL)isSuccess error:(nullable NSError *)error {
}

/// 通知授权弹框的回调
/// @param isEnable 用户是否授权
- (void)xgPushDidRequestNotificationPermission:(bool)isEnable error:(nullable NSError *)error {
}

/// TPNS网络连接成功
- (void)xgPushNetworkConnected {
}



#pragma mark *** 自定义通知栏消息行为 ***

/// 自定义通知栏消息行为（无自定义需求无需使用）
- (void)setNotificationConfigure {
    XGNotificationAction *action1 = [XGNotificationAction actionWithIdentifier:@"xgaction001"
                                                                         title:@"xgAction1"
                                                                       options:XGNotificationActionOptionNone];
    XGNotificationAction *action2 = [XGNotificationAction actionWithIdentifier:@"xgaction002"
                                                                         title:@"xgAction2"
                                                                       options:XGNotificationActionOptionDestructive];
    if (action1 && action2) {
        XGNotificationCategory *category = [XGNotificationCategory categoryWithIdentifier:@"xgCategory"
                                                                                  actions:@[ action1, action2 ]
                                                                        intentIdentifiers:@[]
                                                                                  options:XGNotificationCategoryOptionNone];

        XGNotificationConfigure *configure = [XGNotificationConfigure
            configureNotificationWithCategories:[NSSet setWithObject:category]
                                          types:XGUserNotificationTypeAlert | XGUserNotificationTypeBadge | XGUserNotificationTypeSound];
        if (configure) {
            [[XGPush defaultManager] setNotificationConfigure:configure];
        }
    }
}

#pragma mark *** 非广州集群启动TPNS前需配置域名 ***

/// 非广州集群，请开启对应集群配置（广州集群无需使用）
- (void)configHost {
    //    /// 香港集群
    //    NSString *currentDomainName = TPNS_DOMAIN_HK;
    //    /// 新加坡集群
    //    NSString *currentDomainName = TPNS_DOMAIN_SGP;
    //    /// 上海集群
    //    NSString *currentDomainName = TPNS_DOMAIN_SH;
    //    [[XGPush defaultManager] configureClusterDomainName:currentDomainName];
    //    //过滤配置的DomainName与AccessID不匹配问题
    //    if (![TPNSCommonMethod isMatchingDomainName:currentDomainName withAccessID:TPNS_ACCESS_ID]) {
    //    }
}

#pragma mark *** VoIP相关UIApplicationDelegate ***

/// 收到的VoIP通话，会出现在系统通话记录里，点击通话记录，会执行回调
- (BOOL)application:(UIApplication *)application
    continueUserActivity:(nonnull NSUserActivity *)userActivity
      restorationHandler:(nonnull void (^)(NSArray<id<UIUserActivityRestoring>> *_Nullable))restorationHandler {

    return false;
}

/// iOS10以前的VoIP本地通知回调，前台接收，前台点击，后台点击
- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification {
    if (application.applicationState != UIApplicationStateActive) {
    } else {
    }
}

/// 销毁资源
- (void)dealloc {
    /// 取消订阅通知
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

+(void)voipRegistration{
    dispatch_queue_t mainQueue = dispatch_get_main_queue();
    PKPushRegistry *voipRegistry = [[PKPushRegistry alloc] initWithQueue:mainQueue];
//    [voipRegistry setDelegate:[CallKitManager getInstance]];
    NSMutableSet *desiredPushTypes = [[NSMutableSet alloc] init];
//    [desiredPushTypes addObject:PKPushTypeVoIP];
    voipRegistry.desiredPushTypes = desiredPushTypes;
}


- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options {
    
//    NSString *urlStr = [url absoluteString];
//    if ([urlStr hasPrefix:@"pmoa://"]) {
//        NSMutableDictionary *parm = [[NSMutableDictionary alloc]init];
//        NSURLComponents *urlComponents = [[NSURLComponents alloc] initWithString:url.absoluteString];
//          [urlComponents.queryItems enumerateObjectsUsingBlock:^(NSURLQueryItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//              [parm setObject:obj.value forKey:obj.name];
//          }];
//        //选择项目并登陆
//        [self loadPrjByParam:parm];
//    }
    return YES;
}
//选择项目
-(void)loadPrjByParam:(NSDictionary *)param{
    NSString *prjName = [param[@"type"] isEqualToString:@"jxjz"]?@"京新京藏联络线":@"";
    [[HttpManager manager] get:protocolStrIp param:nil success:^(NSData *data) {
        NSArray *prjArr = [ProtocolModel mj_objectArrayWithKeyValuesArray:data];
        if(!prjArr)return;
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        
        for (ProtocolModel *item in prjArr) {
            if ([item.name isEqualToString:prjName]) {
                [userDefaults setObject:item.protocol forKey:@"protocol"];
                [userDefaults setObject:item.ip forKey:@"ip"];
                [userDefaults setObject:item.port forKey:@"port"];
                if (item.hasOutline) {
                    [userDefaults setObject:@"1" forKey:@"hasOutline"];
                } else {
                    [userDefaults setObject:@"0" forKey:@"hasOutline"];
                }
                if (item.hasMeasure) {
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
                [self loginByParam:param];
                break;
            }
        }
       
        
    } faild:^(NSString *msg) {
        
    }];
}
//登陆
-(void)loginByParam:(NSDictionary *)param{
    [MBManager showLoading];
    [[HttpManager manager] post:[UrlConfig login] param:@{@"userId":@"", @"user":param[@"user"], @"pwd":param[@"password"]} success:^(NSData *data) {
        [MBManager hideAlert];
        if ([ResponseUtils success:data]) {
            [UserInfo initUserWithDic:[ResponseUtils getData:@"data"]];
            
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            UIViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"mainTabBar"];
            [UIApplication sharedApplication].keyWindow.rootViewController = vc;
            
        } else {
            [MBManager showBriefAlert:[ResponseUtils getMsg]];
        }
    } faild:^(NSString *msg) {
        [MBManager hideAlert];
        [MBManager showBriefAlert:msg];
    }];
}
//- (UIInterfaceOrientationMask)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window {
//    if (self.blockRotation) {
//        return UIInterfaceOrientationMaskLandscape;
//    }else {
//        return UIInterfaceOrientationMaskPortrait;
//    }
//}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
//    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    
    /// Required - 注册 DeviceToken
//    [JPUSHService registerDeviceToken:deviceToken];
    
#if TARGET_OS_SIMULATOR && TARGET_OS_IOS
          // If APNS token is available on iOS Simulator, we must use the sandbox profile
          // https://developer.apple.com/documentation/xcode-release-notes/xcode-14-release-notes
          BOOL isSandboxApp = YES;
          GGLog(@"is sandbox app is true");
    [[ZPNs shared] setDeviceToken:deviceToken isProduct:false];
#else
          BOOL isSandboxApp = [self FIRMessagingIsSandboxApp];
    /// Required - 注册 DeviceToken
    //isProduct 根据是否是生产环境来填写    [[ZPNs shared] setDeviceToken:deviceToken isProduct:false];
#endif
    NSString *token = [self getHexStringForData:deviceToken];
    
#if TARGET_OS_SIMULATOR && TARGET_OS_IOS
          // If APNS token is available on iOS Simulator, we must use the sandbox profile
          // https://developer.apple.com/documentation/xcode-release-notes/xcode-14-release-notes
          BOOL isSandboxApp = YES;
          GGLog(@"is sandbox app is true");
    [[ZPNs shared] setDeviceToken:deviceToken isProduct:!isSandboxApp];
#else
          
    [[ZPNs shared] setDeviceToken:deviceToken isProduct:false];
#endif
//    NSString *token = [self getHexStringForData:deviceToken];
}
- (NSString *)getHexStringForData:(NSData *)data
{
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 13) {
        
        if (![data isKindOfClass:[NSData class]]) {
            return @"";
        }
        NSUInteger len = [data length];
        char *chars = (char *)[data bytes];
        NSMutableString *hexString = [[NSMutableString alloc]init];
        for (NSUInteger i=0; i<len; i++) {
            [hexString appendString:[NSString stringWithFormat:@"%0.2hhx" , chars[i]]];
        }
        return hexString;
    } else {
         NSString *myToken = [[data description] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
        myToken = [myToken stringByReplacingOccurrencesOfString:@" " withString:@""];
        return myToken;
    }
}
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    //Optional
}

//#pragma mark- JPUSHRegisterDelegate
//- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
//
//    // Required, iOS 7 Support
//    [JPUSHService handleRemoteNotification:userInfo];
//    completionHandler(UIBackgroundFetchResultNewData);
//}

- (void)redirectNSLogToDocumentFolder {
    // 如果已经连接Xcode调试则不输出到文件
//    if(isatty(STDOUT_FILENO)) {
//        return;
//    }
    
    UIDevice *device = [UIDevice currentDevice];
    if([[device model] hasSuffix:@"Simulator"]){ //在模拟器不保存到文件中
        return;
    }
    
    // 获取Document目录下的Log文件夹，若没有则新建
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *logDirectory = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"Log"];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL fileExists = [fileManager fileExistsAtPath:logDirectory];
    if (!fileExists) {
        [fileManager createDirectoryAtPath:logDirectory  withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"]];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"]; //每次启动后都保存一个新的日志文件中
    NSString *dateStr = [formatter stringFromDate:[NSDate date]];
    NSString *logFilePath = [logDirectory stringByAppendingFormat:@"/%@.txt",dateStr];
    
    // freopen 重定向输出输出流，将log输入到文件
    freopen([logFilePath cStringUsingEncoding:NSASCIIStringEncoding], "a+", stdout);
    freopen([logFilePath cStringUsingEncoding:NSASCIIStringEncoding], "a+", stderr);
}
-(void)loadKeyCenter{

    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    if([userDefault objectForKey:@"appID"]!= nil){
        [KeyCenter setAppID:[[userDefault objectForKey:@"appID"] unsignedIntValue] ];
    }
    
    if([userDefault objectForKey:@"appSign"]!= nil){
        [KeyCenter setAppSign:[userDefault objectForKey:@"appSign"] ];
    }
    if([userDefault objectForKey:@"isUseToken"] != nil){
        [KeyCenter setIsUseToken:[[userDefault objectForKey:@"isUseToken"] boolValue]];
    }

    
}

-(BOOL) FIRMessagingIsSandboxApp {
  static BOOL isSandboxApp = YES;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    isSandboxApp = ![self FIRMessagingIsProductionApp];
  });
  return isSandboxApp;
}


 -(BOOL) FIRMessagingIsProductionApp {
  const BOOL defaultAppTypeProd = YES;

  NSError *error = nil;
  if ([GULAppEnvironmentUtil isSimulator]) {
//    FIRMessagingLoggerError(kFIRMessagingMessageCodeInstanceID014,
//                            @"Running InstanceID on a simulator doesn't have APNS. "
//                            @"Use prod profile by default.");
    return defaultAppTypeProd;
  }

  if ([GULAppEnvironmentUtil isFromAppStore]) {
    // Apps distributed via AppStore or TestFlight use the Production APNS certificates.
    return defaultAppTypeProd;
  }
#if TARGET_OS_OSX || TARGET_OS_MACCATALYST
  NSString *path = [[[[NSBundle mainBundle] resourcePath] stringByDeletingLastPathComponent]
      stringByAppendingPathComponent:@"embedded.provisionprofile"];
#elif TARGET_OS_IOS || TARGET_OS_TV || TARGET_OS_WATCH
  NSString *path = [[[NSBundle mainBundle] bundlePath]
      stringByAppendingPathComponent:@"embedded.mobileprovision"];
#endif

  if ([GULAppEnvironmentUtil isAppStoreReceiptSandbox] && !path.length) {
    // Distributed via TestFlight
    return defaultAppTypeProd;
  }

  NSMutableData *profileData = [NSMutableData dataWithContentsOfFile:path options:0 error:&error];

  if (!profileData.length || error) {
//    NSString *errorString =
//        [NSString stringWithFormat:@"Error while reading embedded mobileprovision %@", error];
   // FIRMessagingLoggerError(kFIRMessagingMessageCodeInstanceID014, @"%@", errorString);
    return defaultAppTypeProd;
  }

  // The "embedded.mobileprovision" sometimes contains characters with value 0, which signals the
  // end of a c-string and halts the ASCII parser, or with value > 127, which violates strict 7-bit
  // ASCII. Replace any 0s or invalid characters in the input.
  uint8_t *profileBytes = (uint8_t *)profileData.bytes;
  for (int i = 0; i < profileData.length; i++) {
    uint8_t currentByte = profileBytes[i];
    if (!currentByte || currentByte > 127) {
      profileBytes[i] = '.';
    }
  }

  NSString *embeddedProfile = [[NSString alloc] initWithBytesNoCopy:profileBytes
                                                             length:profileData.length
                                                           encoding:NSASCIIStringEncoding
                                                       freeWhenDone:NO];

  if (error || !embeddedProfile.length) {
//    NSString *errorString =
//        [NSString stringWithFormat:@"Error while reading embedded mobileprovision %@", error];
//    FIRMessagingLoggerError(kFIRMessagingMessageCodeInstanceID014, @"%@", errorString);
    return defaultAppTypeProd;
  }

  NSScanner *scanner = [NSScanner scannerWithString:embeddedProfile];
  NSString *plistContents;
  if ([scanner scanUpToString:@"<plist" intoString:nil]) {
    if ([scanner scanUpToString:@"</plist>" intoString:&plistContents]) {
      plistContents = [plistContents stringByAppendingString:@"</plist>"];
    }
  }

  if (!plistContents.length) {
    return defaultAppTypeProd;
  }

  NSData *data = [plistContents dataUsingEncoding:NSUTF8StringEncoding];
  if (!data.length) {
//    FIRMessagingLoggerError(kFIRMessagingMessageCodeInstanceID014,
//                            @"Couldn't read plist fetched from embedded mobileprovision");
    return defaultAppTypeProd;
  }

  NSError *plistMapError;
  id plistData = [NSPropertyListSerialization propertyListWithData:data
                                                           options:NSPropertyListImmutable
                                                            format:nil
                                                             error:&plistMapError];
  if (plistMapError || ![plistData isKindOfClass:[NSDictionary class]]) {
    //NSString *errorString =
        [NSString stringWithFormat:@"Error while converting assumed plist to dict %@",
                                   plistMapError.localizedDescription];
    //FIRMessagingLoggerError(kFIRMessagingMessageCodeInstanceID014, @"%@", errorString);
    return defaultAppTypeProd;
  }
  NSDictionary *plistMap = (NSDictionary *)plistData;

  if ([plistMap valueForKeyPath:@"ProvisionedDevices"]) {
//    FIRMessagingLoggerDebug(kFIRMessagingMessageCodeInstanceID012,
//                            @"Provisioning profile has specifically provisioned devices, "
//                            @"most likely a Dev profile.");
  }

  NSString *apsEnvironment = [plistMap valueForKeyPath:kEntitlementsAPSEnvironmentKey];
  //NSString *debugString __unused =
      [NSString stringWithFormat:@"APNS Environment in profile: %@", apsEnvironment];
//  FIRMessagingLoggerDebug(kFIRMessagingMessageCodeInstanceID013, @"%@", debugString);

  // No aps-environment in the profile.
  if (!apsEnvironment.length) {
//    FIRMessagingLoggerError(kFIRMessagingMessageCodeInstanceID014,
//                            @"No aps-environment set. If testing on a device APNS is not "
//                            @"correctly configured. Please recheck your provisioning "
//                            @"profiles. If testing on a simulator this is fine since APNS "
//                            @"doesn't work on the simulator.");
    return defaultAppTypeProd;
  }

  if ([apsEnvironment isEqualToString:kAPSEnvironmentDevelopmentValue]) {
    return NO;
  }

  return defaultAppTypeProd;
}

- (void)pushRegistry:(PKPushRegistry *)registry didUpdatePushCredentials: (PKPushCredentials *)credentials forType:(NSString *)type {
  // Register VoIP push token (a property of PKPushCredentials) with server //应用启动获取token，并上传服务器
}



- (void)userNotificationCenter:(UNUserNotificationCenter *)center
       willPresentNotification:(UNNotification *)notification
         withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler
    API_AVAILABLE(macos(10.14), ios(10.0)) {
    
    
}



@end


