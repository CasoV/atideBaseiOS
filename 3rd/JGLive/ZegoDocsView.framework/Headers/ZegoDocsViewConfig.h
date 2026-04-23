#ifndef ZEGODOCSVIEWCONFIG_H
#define ZEGODOCSVIEWCONFIG_H 

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/// 配置类，用于初始化 ZegoDocsView SDK。
///
@interface ZegoDocsViewConfig : NSObject

/// 必填
/// ZEGO 为开发者签发的应用 ID，请从 ZEGO 管理控制台 申请，取指范围为 0 - 4294967295。
@property (nonatomic, assign) unsigned int appID;

/// 每个 AppID 对应的应用签名，请从 ZEGO 管理控制台申请。
/// 如果申请到的签名是字符串（例如 "a3b4c5d6e7" 这种格式），请直接将该字符串设置为 appSign，SDK 会自动解析；
/// 如果申请到的签名是字节数组（例如 0xa3, 0xb4, 0xc5, 0xd6, 0xe7 这种格式），请将 appSign 直接转为字符串 "0xa3, 0xb4, 0xc5, 0xd6, 0xe7" 并设置为 appSign，SDK 会自动解析。
@property (nonatomic, copy) NSString *appSign;

/// SDK 数据保存目录。
/// Note: 建议设置为 [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents/ZegoDocs"] stringByAppendingString:@""]
@property (nonatomic, copy) NSString *dataFolder;

/// SDK 日志保存目录，记录 SDK 运行过程中的日志，便于定位问题。
/// 需要与 ZegoWhiteboardView SDK 的日志路径保持一致，否则日志无法上传
/// 选填
/// note: 默认设置为 "[NSHomeDirectory() stringByAppendingPathComponent:@"Documents/ZegoLogFile"]"
@property (nonatomic, copy) NSString *logFolder;

/// SDK 缓存保存目录，调用 [loadFile] 加载过的文件，会缓存在此目录下并加密。用户可通过调用 [clearCacheFolder] 接口清除缓存。
/// 建议设置为[NSHomeDirectory() stringByAppendingPathComponent:@"Documents/ZegoDocs"]
@property (nonatomic, copy) NSString *cacheFolder;

/// 是否在测试环境执行，该值默认为 false(正式环境)。
/// 不同环境下的文件不能互通。
/// 请先在测试环境调试，联系 ZEGO 技术支持在正式环境上线。
@property (nonatomic, assign) BOOL isTestEnv;

/// 内部字段禁止使用，否则初始化会发生异常
@property (nonatomic, copy) NSString *token;

@end

NS_ASSUME_NONNULL_END

#endif

