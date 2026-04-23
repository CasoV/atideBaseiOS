//
//  IMOtp.h
//  InfosecToken
//
//  Created by infosec2013 on 16/6/6.
//  Copyright © 2016年 IF. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IMOtp : NSObject

@property(nonatomic,readonly,strong)NSString *SN;
@property(nonatomic,readonly,strong)NSString *seedFactor;

///初始化，单独初始化otp对象时调用，尽量不要使用init进行初始化
///
///@param username 用户名
///@return otp对象
- (instancetype)initWithUsername:(NSString *)username;


/// 产生口令
/// @param length 口令长度 6 / 8
/// @return 6 / 8 位动态口令字符串
- (NSString *)generateOtpWithLength:(int) length;


/// 绑定令牌
/// @param completionBlock 执行完成后的回调，resultCode 返回码，msg服务端返回的错误信息
- (void)bindNetPassCompletionBlock:(void(^)(int resultCode, NSString *msg))completionBlock;


/// 解绑令牌
/// @param completionBlock 执行完成后的回调，resultCode 返回码，msg服务端返回的错误信息
- (void)untienetpassCompletionBlock:(void(^)(int resultCode, NSString *msg))completionBlock;



/// 检查用户是否绑定令牌
/// @param completionBlock 执行完成后的回调，resultCode 返回码，msg服务端返回的错误信息
- (void)checkNetPassStateCompletionBlock:(void(^)(int resultCode, NSString *msg))completionBlock;
@end
