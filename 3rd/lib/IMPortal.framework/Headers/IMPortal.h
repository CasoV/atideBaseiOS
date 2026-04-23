//
//  IMPortal.h
//  IMPortal
//
//  Created by rd2 on 2020/3/6.
//  Copyright © 2020 rd2. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "IMError.h"
#import "IMCert.h"
#import "IMUser.h"
#import "IMApp.h"
#import "IMOtp.h"

//! Project version number for IMPortal.
FOUNDATION_EXPORT double IMPortalVersionNumber;

//! Project version string for IMPortal.
FOUNDATION_EXPORT const unsigned char IMPortalVersionString[];

/// 标准端口初始化
/// @param host 服务器地址
/// @param service_port 服务端口号
/// @param manage_port 管理端口号
/// @param serverCerts 服务器证书路径，为空则为http
/// @param otpSeed 与服务器通讯的动态口令种子
/// @param otpSeedLen 动态口令种子长度
/// @param client_id 应用的唯一标识
/// @param client_secret 应用密钥
/// @param oauth_consumer_key 用户认证密钥，一般为clientID
int infosec_initialize_std(char host[128],int service_port , int manage_port,NSArray *serverCerts,unsigned char* otpSeed, int otpSeedLen, char *client_id, char *client_secret, char *oauth_consumer_key);

int infosec_finalize();

@interface IMPortal : NSObject

/**
 获取SDK版本

 @return 版本信息
 */
+ (NSString *)getVersion;


/**
 *  获取唯一标识
 *
 *  @return 设备唯一标识字符串
 */
+ (NSString *)getDeviceIdentifier;

/**
 Base64编码

 @param data 原文数据
 @return 编码后的字符串
 */
+(NSString *)base64EncodingWithPlainData:(NSData *)data;

+(NSString *)hashWithString:(NSString *)string;

/**
 base64解码

 @param base64String 待解码base64字符串
 @return 解码后的字节流数据
 */
+(NSData *)base64DecodingWithBase64String:(NSString *)base64String;


/// SM3摘要
/// @param string 摘要原文
+(NSString *)SM3WithString:(NSString *)string;


/// sm4加解密
/// @param operation 加密/解密(0解密，非0加密)
/// @param src 原文
/// @param srcLen 原文长度
/// @param key 密钥
/// @param kenLen 密钥长度
/// @param iv 初始化向量
/// @param ivLen 初始化向量长度
/// @param mode 0-ECB模式；1-CBC模式
+ (NSString *)sm4WithOP:(NSInteger)operation
                   src:(unsigned char *)src
                srcLen:(int)srcLen
                   key:(unsigned char *)key
                kenLen:(int)kenLen
                    iv:(unsigned char *)iv
                 ivLen:(int)ivLen
                  mode:(int)mode;

@end

