#import <Foundation/Foundation.h>

typedef unsigned int ZegoSeq;

typedef void(^ZegoGatewayBaseInitSDKBlock)(int errorCode, NSString *result);

#pragma mark - base notification delegate

@protocol ZegoGatewayBaseDelegate <NSObject>

/**
 状态触发通知

 @param notify  指定notify，参考协议中notify定义
 @param result 结果，json格式

 @note !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
       一个全局响应的通知
       !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
 */
- (void)onNotify:(NSString*)notify andResult:(NSString*)result;

/**
 请求回调

 @param seq 请求序列号，zego_gateway_execute执行时返回
 @param api  指定api，参考协议中api定义
 @param result 结果，json格式
*/
- (void)onResponse:(ZegoSeq)seq api:(NSString *)api result:(NSString *)result;

@end


#pragma mark - base interface

@interface ZegoGatewayBase : NSObject

+ (instancetype)sharedInstance;

- (void)setDelegate:(id<ZegoGatewayBaseDelegate>)delegate;

/**
获取sdk版本号

 @return sdk版本号
*/
- (NSString *)getSdkVersion;

/**
获取柔性配置值

 @param key 柔性配置键值
 @return 柔性配置键值对应值
*/
- (NSString *)getPreferenceConfig:(NSString *)key;

/**
 初始化SDK，SDK功能在初始化之后才可使用，内部会完成对appdc和express的初始化

 @param config 初始化配置参数
 @return 请求序列号
 @note  在执行execute命令前调用
*/
- (ZegoSeq)initSDKWithAppName:(NSString *)config
              completionBlock:(ZegoGatewayBaseInitSDKBlock)completionBlock;

/**
 反初始化SDK

 @return 请求序列号
*/
- (ZegoSeq)uninitSDK;

/**
 初始化SDK，SDK功能在初始化之后才可使用，以下参数都是必填项，否则初始化失败

 @param api 请求api名称，形如：conference/attend
 @param params 参数，json格式
 @return 请求序列号
 */
- (ZegoSeq)request:(NSString *)api params:(NSString *)params;



/**
 获取业务后台时间戳

 @return 请求序列号
 */
- (long long)get_server_timestamp;


@end
