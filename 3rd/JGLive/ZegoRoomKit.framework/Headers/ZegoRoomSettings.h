#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/// 美颜模式枚举
///
/// 设置美颜模式的美颜级别
///
typedef NS_ENUM(NSUInteger, ZegoBeautifyMode) {

    /// 无美颜效果
    ZegoBeautifyNone = 0,

    /// 中等美颜效果，全屏美白+磨皮
    ZegoBeautifyMedium = 1

};

/// 本端预览画面视频镜像模式枚举
///
/// 该枚举只影响本地预览视频画面，远端看到的镜像状态不受该枚举影响
///
typedef NS_ENUM(NSUInteger, ZegoPreviewVideoMirrorMode) {

    /// 预览不镜像
    ZegoPreviewVideoMirrorModeNone = 0,

    /// 预览左右交换镜像
    ZegoPreviewVideoMirrorModeLeftRightSwap = 1

};

/// 推流镜像模式枚举
///
/// 该枚举影响远端视频流镜像模式
///
typedef NS_ENUM(NSUInteger, ZegoPublishMirrorMode) {

    /// 推流不镜像
    ZegoPublishMirrorNone = 0,

    /// 推流左右交换镜像
    ZegoPublishMirrorLeftRightSwap = 1

};

/// 房间工具栏隐藏模式枚举
///
/// 改变底部工具栏显示
///
typedef NS_ENUM(NSUInteger, ZegoToolBarHiddenMode) {

    /// 自动隐藏，受用户点击影响
    ZegoToolBarAuto = 0,

    /// 一直隐藏
    ZegoToolBarAlwaysHidden = 1,

    /// 一直显示
    ZegoToolBarAlwaysDisplayed = 2

};

/// 视频填充模式枚举
///
/// 设置视频画面的填充模式
///
typedef NS_ENUM(NSUInteger, ZegoVideoFitMode) {

    /// 等比缩放，画面可能有黑边
    ZegoVideoAspectFit = 0,

    /// 填充，画面可能被裁减
    ZegoVideoFill = 1

};

/// 房间配置类，加入房间前配置。
///
/// 改变房间内处理逻辑
///
@interface ZegoRoomSettings : NSObject

/// 是否开启省流量模式。仅移动端支持。
@property (nonatomic, assign) BOOL isSaveTrafficModeOn;

/// 加入房间摄像头是否开启
@property (nonatomic, assign) BOOL isCameraOnWhenJoiningRoom;

/// 加入房间麦克风是否开启
@property (nonatomic, assign) BOOL isMicrophoneOnWhenJoiningRoom;

/// 是否开启降噪模式
@property (nonatomic, assign) BOOL isReduceBackgroundNoiseModeOn;

/// 本端预览画面视频镜像模式
@property (nonatomic, assign) ZegoPreviewVideoMirrorMode previewVideoMirrorMode;

/// 推流镜像模式
@property (nonatomic, assign) ZegoPublishMirrorMode publishMirrorMode;

/// 视频填充模式
@property (nonatomic, assign) ZegoVideoFitMode videoFitMode;

/// 美颜模式
@property (nonatomic, assign) ZegoBeautifyMode beautifyMode;


@end

NS_ASSUME_NONNULL_END

