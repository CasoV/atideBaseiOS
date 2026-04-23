//
//  IMUser.h
//  IMSecurity
//
//  Created by infosec2013 on 16/6/14.
//  Copyright © 2016年 IF. All rights reserved.
//

#import <Foundation/Foundation.h>
@class IMCert;
@class IMOtp;

//用户登录类型
#define  Certificate   @"certificate"
#define  DyncToken     @"dynctoken"
#define  FaceId        @"faceid"
#define  PassAccount   @"passaccount"

typedef  NS_ENUM(NSInteger,UserType)
{
    UserTypeFaceid = 0,
    UserTypeStatic,
    UserTypeCert,
    UserTypeToken
};
typedef  NS_ENUM(NSInteger,OtpType)
{
    UserTypeIos = 1,
    UserTypeAndroid
};

typedef  NS_ENUM(NSInteger,FaceIdOperation)
{
    FaceIdIsBind = 0,
    FaceIdUpdate,
    FaceIdBind,
    FaceIdCompare,
    FaceIdLogin,
    FaceIdUntied
};

typedef  NS_ENUM(NSInteger,SignMode)
{
    SignModeRaw = 0,
    SignModeAttached,
    SignModeDetached
};

typedef NS_ENUM(NSInteger,CertAlgType){
    CertAlgTypeSM2WithSM3,
    CertAlgTypeRSAWithMD5,
    CertAlgTypeRSAWithSHA1,
    CertAlgTypeRSAWithSHA256,
    CertAlgTypeRSAWithSHA512,
    CertAlgTypeUnknown,
};

typedef NS_ENUM(NSInteger,CertItemType){
    CertItemTypeDN = 0, //证书DN
    CertItemTypeSN,     //证书SN
    CertItemTypeIsser,  //证书颁发者
    CertItemTypeKeyUsage = 4, //证书密钥用途
    CertItemTypeKeyLength,//证书密钥长度
    CertItemTypeNotBefore,//证书生效日期
    CertItemTypeNotAfter,//证书失效日期
    CertItemTypeAlg,    //证书签名算法
    CertItemTypeVersion //证书版本
};

@interface IMUser : NSObject
@property(nonatomic,strong)NSString *username;
@property(nonatomic,strong)NSString *realname;
@property(nonatomic,strong)NSString *companyid;
@property(nonatomic,strong)NSString *mobile;
@property(nonatomic,strong)NSString *certstatus;
@property(nonatomic,strong)NSString *tokenstatus;

@property(nonatomic,strong)NSString *refresh_token;
@property(nonatomic,strong)NSString *expires_date;
@property(nonatomic,strong)NSString *open_id;
@property(nonatomic,strong)NSString *access_token;
@property(nonatomic,assign)BOOL isBindFaceid;
@property(nonatomic,assign)BOOL isBindNetpass;
@property(nonatomic,assign)BOOL isCert;
@property(nonatomic,assign)BOOL isOTP;

@property(nonatomic,readonly,strong)IMOtp *otp;
@property(nonatomic,readonly,strong)IMCert *cert;
@property(nonatomic,readonly,assign)UserType userType;

/**
 以用户名初始化的用户对象

 @param username 用户名
 @return 本地存在此用户，返回用户对象，本地不存在用户，返回nil，用户未注册时应使用init进行初始化
 */
+ (instancetype)userWithUserName:(NSString *)username;

//存储当前user
- (void)store;

//删除当前用户
- (BOOL)deleteUser;

//删除所有用户
+ (BOOL)deleteAllUsers;



/**
 *  用户注册
 *
 *  @param username      用户名
 *  @param signCode      签约码
 *  @param completeBlock 完成后回调block
 */
+ (void)signUpWithUserName:(NSString *)username
                  signCode:(NSString *)signCode
          andCompleteBlock:(void(^)(int resultCode, IMUser *user))completeBlock;

/**
 *  锁定用户
 *
 *  @param completeBlock 完成后回调block
 */
- (void)lockUserWithCompleteBlock:(void(^)(int resultCode))completeBlock;

/**
 *  解锁用户
 *
 *  @param lockTrade     解锁码
 *  @param completeBlock 解锁完成后回调block
 */
- (void)unlockUserWithLockTrade:(NSString *)lockTrade andCompleteBlock:(void(^)(int resultCode))completeBlock;



/// 获取随机数
/// @param completionBlock 完成后的回调，当resultCode为0时，msg值为随机数；其他为错误信息
- (void)appRandomCompletionBlock:(void (^)(int resultCode, NSString *msg))completionBlock;


/// 用户登录
/// @param credential 用户凭证 PIN码，静态密码，动态密码，或者人脸数据
/// @param loginType  登录类型 见头文件13行
/// @param completionBlock 执行完后的回调   resultCode返回码
- (void)userLoginWithCredential:(NSString *)credential
                      loginType:(NSString *)loginType
                completionBlock:(void(^)(int errcode, NSString *msg))completionBlock;


/// 刷新access_token
/// @param completionBlock 执行完后的回调   resultCode返回码
- (void)refreshTokenCompletionBlock:(void(^)(int resultCode,NSString *token))completionBlock;



/// 移动平台扫码登录
/// @param random 二维码随机数
/// @param time 二维码时间戳
/// @param pin PIN码
/// @param block 执行完后的回调   dict服务器返回的响应
- (void)scaveningLoginWithRandom:(NSString *)random
                            time:(NSString *)time
                             pin:(NSString *)pin
                 completionBlock:(void(^)(NSDictionary *dict))block;



/// 判断移动平台扫码登录是否成功
/// @param random 二维码随机数
/// @param block 执行完后的回调   dict服务器返回的响应
- (void)isLoginWithRandom:(NSString *)random
          completionBlock:(void(^)(NSDictionary *dict))block;


/// 人脸识别处理
/// @param faceid 人脸数据
/// @param operation 操作 0-检查人脸是否绑定；1-更新人脸数据；2-绑定人脸；3-人脸数据比较；4-人脸登录；5-解绑人脸
/// @param completionBlock 执行完后的回调   resultCode返回码
- (void)dealFaceDataWithFaceid:(NSString *)faceid
                     operation:(FaceIdOperation)operation
               completionBlock:(void(^)(int resultCode, NSString *msg))completionBlock;



/// 扫码功能
/// @param function netauth/signin/productversion
/// @param URL URL
/// @param method GET/POST
/// @param completionBlock 执行完后的回调   resultCode返回码
- (void)scanQRCodeWithFunction:(NSString *)function
                           URL:(NSString *)URL
                        method:(NSString *)method
               completionBlock:(void(^)(int resultCode, NSString *msg))completionBlock;



/**
 返回用户证书别名

 @return 用户别名
 */
- (NSString *)certAlias;

/**
 当前用户证书算法类型，如果是证书类型用户

 @return 证书算法类型，非证书类型返回CertAlgTypeUnknown
 */
- (CertAlgType)UserCertAlgType;

/**
 当前证书密钥长度，如果是证书类型用户

 @return 证书密钥长度，非证书用户返回0
 */
- (int)UsertCertKeyLen;


/// 获取Authorization Code
/// @param username 用户名
/// @param pin 证书PIN码
/// @param credential 身份凭证
/// @param loginType 登录类型
/// @param completionBlock 更新完成block
- (void)authorizeWithUsername:(NSString *)username
                          pin:(NSString *)pin
                   credential:(NSString *)credential
                    loginType:(NSString *)loginType
              completionBlock:(void(^)(int resultCode,NSString *AuthorizationCode, NSString *msg))completionBlock;



/// 获取Access Token
/// @param authorize_code authorize_code
/// @param completionBlock 执行完后的回调   resultCode返回码
- (void)accessTokenWithAuthorize_code:(NSString *)authorize_code
                      completionBlock:(void(^)(int resultCode,NSString *token))completionBlock;


/// 获取openid
/// @param completionBlock 执行完后的回调   resultCode返回码
- (void)openidWithToken:(NSString *)token completionBlock:(void(^)(int resultCode,NSString *openid))completionBlock;


@end
