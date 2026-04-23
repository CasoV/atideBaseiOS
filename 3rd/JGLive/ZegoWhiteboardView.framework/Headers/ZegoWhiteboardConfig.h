#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/// 白板 SDK 配置信息
///
@interface ZegoWhiteboardConfig : NSObject

/// SDK 日志保存目录，记录 SDK 运行过程中的日志，便于定位问题。
/// 需要与 ZegoExpressEngine SDK 的日志路径保持一致，否则日志无法上传成功
/// 默认为 "[NSHomeDirectory() stringByAppendingPathComponent:@"Documents/ZegoLogFile"]"
@property (nonatomic, copy) NSString *logPath;

/// SDK 缓存文件目录，保存 SDK 运行过程中的缓存，例如图片信息。
/// 默认值为 “[NSHomeDirectory() stringByAppendingPathComponent:@"Documents/ZegoWhiteboardCache"]”
@property (nonatomic, copy) NSString *cacheFolder;

@end

NS_ASSUME_NONNULL_END

