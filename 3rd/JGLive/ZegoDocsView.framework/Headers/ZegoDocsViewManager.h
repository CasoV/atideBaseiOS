#ifndef ZEGODOCSVIEWMANAGER_H
#define ZEGODOCSVIEWMANAGER_H

#import <Foundation/Foundation.h>
#import "ZegoDocsViewConfig.h"
#import "ZegoDocsViewConstants.h"

NS_ASSUME_NONNULL_BEGIN

/// ZegoDocsViewManager init 方法的完成回调。
///
/// @param errorCode 回调错误码，0表示执行成功。
typedef void(^ZegoDocsViewInitBlock)(ZegoDocsViewError errorCode);

/// uploadFile 方法的回调。
///
/// @param state 文件上传分为上传 ZegoDocsViewUploadStateUpload 和格式转换 ZegoDocsViewUploadStateConvert 两个阶段。
/// @param errorCode 当前阶段的回调错误码，0表示执行成功。
/// @param infoDictionary 不同阶段 [block] 回调中的 infoDictionary 不一致：
///                       上传阶段：如果正常上传，会产生多次回调，每次都包含文件上传进度。例如上传进度为 50%时，则 infoDictionary 内容为 {"upload_percent":0.50,"request_seq":xxx}；上传进度为 100%，则 infoDictionary 内容为 {"upload_percent":1.00,"request_seq":xxx}。
///                       其中 request_seq 对应的值是一个整数，是接口调用时由服务端返回的标识，用于区分正在上传的不同文件。该参数只有用户同时上传多个文件时才会用到。
///
///                       格式转换阶段：如果转换成功，只产生一次回调，包含转换后的文件 ID。例如当前转换完成，则 infoDictionary 内容为 {"upload_fileid":"ekxxxxxxxxv","request_seq":xxx}。
///                       upload_fileid 对应的值即为文件 fileID。
typedef void(^ZegoDocsViewUploadBlock)(ZegoDocsViewUploadState state, ZegoDocsViewError errorCode, NSDictionary *infoDictionary);

/// cancelUploadFile 方法的完成回调。
///
/// @param errorCode 回调错误码，0表示执行完成。
typedef void(^ZegoDocsViewCancelUploadComplementBlock)(ZegoDocsViewError errorCode);

/// cacheFile 方法的回调。
///
/// @param state 文件缓存分为缓存 ZegoDocsViewCacheStateCaching 和缓存完成 ZegoDocsViewCacheStateCached 两个阶段。
/// @param errorCode 当前阶段的回调错误码，0表示执行成功。
/// @param infoDictionary 当前阶段回调所包含的信息。
///                       缓存中阶段会有多次回调，若正常缓存，则每次回调包含文件缓存进度。例如缓存50%，则参数内容为 {"cache_percent":0.50,"request_seq":xxx}，缓存100%，则参数内容为 {"cache_percent":1.00,"request_seq":xxx}。
///                       缓存完成阶段只有一次回调，如正常完成，同时也会返回方法调用时的序列号seq，格式为{"request_seq":xxx}}。
typedef void(^ZegoDocsViewCacheBlock)(ZegoDocsViewCacheState state, ZegoDocsViewError errorCode, NSDictionary *infoDictionary);

/// cancelCacheFile 方法的完成回调。
///
/// @param errorCode 回调错误码，0表示执行完成。
typedef void(^ZegoDocsViewCancelCacheComplementBlock)(ZegoDocsViewError errorCode);

/// queryFileCached 方法的完成回调。
///
/// @param errorCode 回调错误码，0表示执行成功。
/// @param fileCached 缓存是否存在的结果。
typedef void(^ZegoDocsViewQueryCachedCompletionBlock)(ZegoDocsViewError errorCode, BOOL fileCached);

@class ZegoDocsViewCustomH5Config;

/// DocsView SDK 管理类。
///
@interface ZegoDocsViewManager : NSObject

/// 初始化 ZegoDocsView SDK
///
/// 请在初始化回调成功后再进行 load、upload 等操作
///
/// @param config ZegoDocsView SDK 配置对象，具体参数请查询 ZegoDocsViewConfig.h
/// @param completionBlock 初始化结果回调
- (void)initWithConfig:(ZegoDocsViewConfig *)config completionBlock:(ZegoDocsViewInitBlock)completionBlock;

/// 设置用户自定义扩展内容
///
/// 可提供键值对形式的客户自定义参数设置, 具体支持的 Key Value 请咨询技术支持
/// 调用时机： initWithConfig 方法之前调用
///
/// @param value 自定义的文档域名等扩展内容, eg @"xxxx.com"
/// @param key key 自定义的文档域名等扩展内容对应的 key. eg @"domain"
///
/// @return 是否设置成功
- (BOOL)setCustomizedConfig:(NSString *)value key:(NSString *)key;

/// 根据Key值获取指定的扩展内容
///
/// 键值对形式的客户自定义参数, 具体支持的 Key Value 请咨询技术支持
/// 调用时机: initWithConfig 成功之后
///
/// @param key 扩展内容对应的key值
///
/// @return key值对应的扩展内容
- (NSString *)getCustomizedConfigWithKey:(NSString *)key;

/// 返回ZegoDocsViewManager的单例对象
///
/// @return 单例对象
+ (instancetype)sharedInstance;

/// 反初始化
///
/// 调用时机：initWithConfig 成功之后
/// Note： 非线程安全，使用时需与 init 配对使用
- (void)uninit;

/// 计算缓存目录大小
///
/// 调用时机:：initWithConfig 成功之后
///
/// @return 缓存目录大小，返回值单位为字节
- (long)calculateCacheSize;

/// 清除整个缓存目录
///
/// 在需要清理缓存时调用此方法，可清除已加载的文件缓存
/// 调用时机：initWithConfig 成功之后
- (void)clearCacheFolder;

/// 获取 SDK 版本信息
///
/// @return 版本信息
- (NSString *)getVersion;

/// 上传文件到 ZegoDocs 服务
///
/// 上传过程中，SDK 会根据传入的 [renderType] 对文件进行格式转换，格式转换后文件的渲染模式取决于传入的 [renderType]，可在结果回调中获取上传的进度信息。
///
/// @param filePath 需要上传的文件绝对路径，支持 ppt、pdf、xls、jpg、jpeg、png、bmp、txt 等类型的文件，具体参考 https://doc-zh.zego.im/zh/6551.html。
/// @param renderType 上传文件转码后的渲染模式类型，建议设置为 ZegoDocsViewRenderTypeVector，详见 ZegoDocsViewConstants。
/// @param completionBlock 上传的进度和结果的回调。上传文件的过程中，会在 [completionBlock] 内收到多次回调，具体请查看 ZegoDocsViewUploadBlock 的介绍
///
/// @return 返回上传文件的请求seq
- (ZegoSeq)uploadFile:(NSString *)filePath renderType:(ZegoDocsViewRenderType)renderType completionBlock:(ZegoDocsViewUploadBlock)completionBlock;

/// 在上传文件的过程中取消上传动作
///
/// @param seq 调用uploadFile时返回的上传seq。
/// @param completionBlock 取消上传文件结果回调。
- (void)cancelUploadFileWithSeq:(ZegoSeq)seq completionBlock:(ZegoDocsViewCancelUploadComplementBlock)completionBlock;

/// 将文件缓存到本地
///
/// @param fileID 需要缓存的文件 ID
/// @param completionBlock 下载文件进度和结果回调
///
/// @return 下载文件操作对应的序列号
- (ZegoSeq)cacheFileWithFileId:(NSString *)fileID completionBlock:(ZegoDocsViewCacheBlock)completionBlock;

/// 在缓存文件的过程中取消缓存动作
///
/// 通过调用该方法，可以在文件正在缓存时取消缓存操作。
///
/// @param seq 缓存操作的序列号。
/// @param completionBlock 取消缓存操作结果回调。
- (void)cancelCacheFileWithSeq:(ZegoSeq)seq completionBlock:(ZegoDocsViewCancelCacheComplementBlock)completionBlock;

/// 查询文件缓存是否存在
///
/// @param fileID 待查询的文件ID。
/// @param completionBlock 查询结果回调。
- (void)queryFileCachedWithFileId:(NSString *)fileID completionBlock:(ZegoDocsViewQueryCachedCompletionBlock)completionBlock;


/// 上传自定义H5课件
/// @param filePath 文件路径
/// @param config 自定义H5 课件相关数据
/// @param completionBlock 结果回调
- (ZegoSeq)uploadH5File:(NSString *)filePath
                 config:(ZegoDocsViewCustomH5Config *)config
        completionBlock:(ZegoDocsViewUploadBlock)completionBlock;

@end


NS_ASSUME_NONNULL_END

#endif

