//
//  IMApp.h
//  IMSecurity
//
//  Created by infosec2013 on 2017/3/27.
//  Copyright © 2017年 IF. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IMUser.h"

#define iOS_type @"1"
#define Android_type @"2"

@interface IMApp : NSObject
@property(nonatomic,copy)NSString *appCode;
@property(nonatomic,copy)NSString *appDesc;
@property(nonatomic,copy)NSString *appDetail;
@property(nonatomic,copy)NSString *appName;
@property(nonatomic,copy)NSString *appType;
@property(nonatomic,copy)NSString *appPack;
@property(nonatomic,copy)NSString *isShow;
@property(nonatomic,copy)NSString *isApp;
@property(nonatomic,copy)NSString *appUrl;
@property(nonatomic,copy)NSString *appVersion;
@property(nonatomic,copy)NSString *iconUrl;
@property(nonatomic,copy)NSString *fileSize;
@property(nonatomic,copy)NSString *id;
@property(nonatomic,copy)NSString *modifyTime;
@property(nonatomic,copy)NSString *uploadTime;
@property(nonatomic,copy)NSString *picUrl;

/**
 获取系统App版本号
 @param username 用户名
 @param version 当前版本
 @param completeBlock 完成后执行block
        resultCode:返回码 0:成功 其他:失败
 */
+ (void)getSysAppVersionWithUsername:(NSString *)username
                             version:(NSString *)version
                       completeBlock:(void(^)(int resultCode,NSString *url))completeBlock;

/**
 获取消息待办的开关配置
 @param completeBlock 完成后执行block
 resultCode:返回码 0:成功 其他:失败
 */
+ (void)getModuleConfigWithCompleteBlock:(void(^)(int resultCode,id ismessageon, id istodotaskon))completeBlock;



/**
 获取登录方式列表

 @param completionBlock 完成后的回调
 */
+ (void)getLoginTypeListCompletionBlock:(void(^)(int resultCode,NSArray *loginTypeArray))completionBlock;




/**
 用户登出
 @param username  用户名
 @param completionBlock 完成后的回调
 */
+ (void)userLogoutWithUsername:(NSString *)username
               CompletionBlock:(void(^)(int retCode))completionBlock;

/**
 获取轮播图片

 @param completionBlock 完成后的回调
 */
+ (void)getbannerCompletionBlock:(void(^)(int resultCode,NSArray *imageSrc))completionBlock;

/**
 获取当前登录用户有权限访问的系统
 @param isShow 是否显示
 @param username  用户名
 @param block 完成后的回调
 */
+ (void)getAppsInfoWithIsShow:(BOOL) isShow
                     username:(NSString *)username
              completionBlock:(void(^)(int retCode, NSString *errMsg, NSArray *appList))block;



/**
 绑定业务系统账号
 @param appId appId
 @param accountName 业务系统账号
 @param password 业务系统密码
 @param param 扩展参数
 @param username  用户名
 @param block 完成后的回调
 */
+ (void)registerResAccWithAppId:(NSString *)appId
                    accountName:(NSString *)accountName
                       password:(NSString *)password
                          param:(NSString *)param
                       username:(NSString *)username
                completionBlock:(void(^)(int resultCode,NSDictionary *dict))block;



/**
 修改绑定的业务系统密码
 @param appId appId
 @param accountName 业务系统账号
 @param password 业务系统密码
 @param param 扩展参数
 @param username  用户名
 @param block 完成后的回调
 */
+ (void)modifyresaccWithAppId:(NSString *)appId
                  accountName:(NSString *)accountName
                     password:(NSString *)password
                        param:(NSString *)param
                     username:(NSString *)username
              completionBlock:(void(^)(int ret, NSDictionary *dict))block;



/**
 得到用户的应用系统账号信息
 @param appId appId
 @param username  用户名
 @param block 完成后的回调
 */
+(void)getResAccByAppId:(NSString *)appId
               username:(NSString *)username
        completionBlock:(void(^)(int ret,NSDictionary *dict))block;



/// 解除业务系统账号的绑定
/// @param appId appId
/// @param accountName  业务系统账号
/// @param username  用户名
/// @param block 完成后的回调
+ (void)removeresaccWithAppId:(NSString *)appId
                  accountName:(NSString *)accountName
                     username:(NSString *)username
              completionBlock:(void(^)(int ret, NSDictionary *dict))block;


///// 设置业务系统是否在门户页上显示
///// @param appId 业务系统id
///// @param isShow  是否显示  true或者false
///// @param username  用户名
///// @param block 完成后的回调
//+ (void)setResourceIsShowWithAppId:(NSString *)appId
//                            isShow:(BOOL) isShow
//                          username:(NSString *)username
//                   completionBlock:(void(^)(int ret, NSDictionary *dict))block;

@end
