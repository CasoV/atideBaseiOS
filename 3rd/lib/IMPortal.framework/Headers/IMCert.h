//
//  IMCert.h
//  IMSecurity
//
//  Created by infosec2013 on 16/5/24.
//  Copyright © 2016年 Infosec. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "IMUser.h"


@interface IMCert : NSObject
@property(nonatomic,readonly)NSString *username;
@property(nonatomic,readonly)NSString *alias;

/**
 初始化证书对象

 @param username 用户名
 @return 用户名为空，返回nil；用户名不为空，返回一个证书对象，但不能保证证书一定存在。
 */
- (instancetype)initWithUsername:(NSString *)username;

#pragma mark 证书管理和签名
/**
 *  申请证书
 *
 *  @param username         用户名
 *  @param PIN              证书PIN码
 *  @param registerCode     注册码
 *  @param completeBlock 申请完成执行block
 */
- (void)applyCertWithUsername:(NSString *)username
                          PIN:(NSString *)PIN
                 registerCode:(NSString *)registerCode
                completeBlock:(void(^)(int resultCode))completeBlock;


/**
 *  证书更新
 *
 *  @param username         用户名
 *  @param PIN              证书PIN码
 *  @param completeBlock 更新完成block
 */
- (void)updateCertWithUsername:(NSString *)username
                           PIN:(NSString *)PIN
              andCompleteBlock:(void(^)(int resultCode))completeBlock;

/**
 获取证书状态
 @param completeBlock 完成后执行代码块
 */
- (void)getCertStateWithCompleteBlock:(void(^)(int resultCode,int certstatus))completeBlock;


/**
 签名
 @param PIN 证书PIN码
 @param plain 原文
 @param encoding 编码格式
 @param mode 签名组包模式      raw : 0 attached: 1 detached: 2
 */
- (void)signWithPIN:(NSString *)PIN
              Plain:(NSString *)plain
           encoding:(NSStringEncoding)encoding
               mode:(int)mode
     andCompleteBlock:(void(^)(int resultCode,NSString *signResult))completeBlock;


/**
 获取证书信息

 @param item 证书项名称:
    证书DN: "CERT_DN"
    证书SN:" "CERT_SN"
    证书颁发者：""CERT_ISSUER"
    证书状态:""CERT_STATUS"
    证书key用途："CERT_Key_USAGE"
    证书key长度: "CERT_KEY_LENGTH"
    证书生效日期:" "CERT_NOTBEFORE"
    证书失效日期：""CERT_NOTAFTER"
    证书签名算法：""CERT_ALG"
    证书版本:" "CERT_VERSION"
 @return 证书信息项内容，获取失败返回""
 */
- (NSString *)getCertInfoWithItem:(CertItemType)item;

/**
 *  修改PIN码
 *
 *  @param oldPIN 证书原始PIN
 *  @param newPIN 证书新PIN
 *
 */
- (void)changePINWithOldPIN:(NSString *)oldPIN
                  andNewPIN:(NSString *)newPIN
           andCompleteBlock:(void(^)(int resultCode,int remaintimes))completeBlock;



/**
 验证PIN码
 
 @param PIN 用户证书PIN码
 @param completeBlock 完成后执行block resultCode: 返回码 0 成功 其他 失败   remaintimes: 剩余尝试次数
 */
- (void)verifyPIN:(NSString *)PIN andCompleteBlock:(void(^)(int bResult,int remaintimes))completeBlock;


/**
 *  重置本地证书数据
 *
 *  @return 用于因密码丢失造成的本地加密数据损坏的情况，不可轻易使用。
 */
- (BOOL)resetLocationCerts;


/**
 *  获取剩余尝试次数
 *
 *  @return 次数
 */
- (int)getVerifyTimes;

/**
 是否含有某个用户的证书

 @param username 用户名
 @return 存在：YES 不存在：NO
 */
+ (BOOL)hasCertWithUsername:(NSString *)username;


/**
 *  删除当前证书
 *  @return 成功:YES 失败:NO
 */
- (BOOL)deleteCert;


/**
 摘要签名
 
 @param algType 算法类型
 @param PIN 证书PIN码
 @param data 摘要内容
 @param mode 签名模式
 @return 签名返回base64编码字符串
 */
- (NSString *)signWithoutIDWithAlg:(CertAlgType)algType
                               PIN:(NSString *)PIN
                              data:(NSData *)data
                              mode:(int)mode;

/**
 导出证书，不含私钥

 @return 证书内容
 */
- (NSString *)exportCert;



/// 获取证书别名
/// @param username 用户名
+ (NSString *)certAliasWithUsername:(NSString *)username;


- (NSString *)getLastSignError;

@end
