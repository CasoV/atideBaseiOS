#import <ReplayKit/ReplayKit.h>
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/// 共享屏幕代理类
///
/// 屏幕共享结束事件回调处理
///
@protocol ZegoScreenShareServiceDelegate <NSObject>

/// 结束共享屏幕回调
///
/// @param error 错误码
- (void)onFinishBroadcastWithError:(NSError *)error;

@end


/// 共享屏幕服务类
///
/// iOS使用屏幕共享相关配置
///
@interface ZegoScreenShareService : NSObject

/// iOS屏幕共享管理类代理
@property (nonatomic, weak) id<ZegoScreenShareServiceDelegate> delegate;

/// 结束屏幕共享
///
/// 调用时机：屏幕共享结束的时候
- (void)broadcastFinished;

/// 设置屏幕共享扩展进程所属组
///
/// 调用时机：扩展进程启动时设置
/// 需要保证扩展进程与应用主进程在同一组，才能保证进程间信息可以顺利传递。
///
/// @param appGroup app组
- (void)configWithAppGroup:(NSString *)appGroup;

/// 发送屏幕录制数据到主进程
///
/// 调用时机：开启屏幕共享后，需要发送采集到的屏幕数据到主进程的时候
///
/// @param sampleBuffer  屏幕录制数据
- (void)sendVideoBufferToHostApp:(CMSampleBufferRef)sampleBuffer;

/// 获取共享屏幕单例对象
+ (instancetype)sharedInstance;

/// 开始屏幕共享
///
/// 调用时机：屏幕共享扩展进程启动的时候
- (void)startBroadcast;

@end

NS_ASSUME_NONNULL_END

