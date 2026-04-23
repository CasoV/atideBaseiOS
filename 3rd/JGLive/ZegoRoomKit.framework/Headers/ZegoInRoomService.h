#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "ZegoRoomKitError.h"
#import "ZegoRoomInfo.h"
#import "ZegoRoomSettings.h"

NS_ASSUME_NONNULL_BEGIN

/// 加入房间结果回调
///
/// 调用时机：加入房间接口调用，执行完毕时调用
///
/// @param error 加入房间错误码
typedef void (^ZegoJoinRoomBlock)(ZegoRoomKitError error);

/// 离开房间结果回调
///
/// 调用时机：调用离开房间接口或离开房间事件触发，执行完毕时回调
///
/// @param error 离开房间事件错误码
typedef void (^ZegoLeaveRoomBlock)(ZegoRoomKitError error);

/// 离开房间事件类型
///
typedef NS_ENUM(NSUInteger, ZegoLeaveRoomType) {

    /// 离开房间
    ZegoLeaveRoomTypeLeave = 0,

    /// 结束房间
    ZegoLeaveRoomTypeEnd = 1

};

/// 房间内事件
///
typedef NS_ENUM(NSUInteger, ZegoRoomEvent) {

    /// 当前成员离开房间
    ZegoRoomEventMemberLeft = 0,

    /// 临时断线，SDK 通知该事件后会自动重连
    ZegoRoomEventMemberTemporaryDisconnected = 1,

    /// 永久断线，SDK 自动重连失败后会通知该事件
    ZegoRoomEventMemberPermanentDisconnected = 2,

    /// 重连成功，SDK 自动重连成功后会通知该事件
    ZegoRoomEventMemberReconnected = 3,

    /// 当前成员被踢出房间
    ZegoRoomEventMemberKickedOut = 4,

    /// 房间已结束
    ZegoRoomEventEnded = 5,
    
    /// 房间最小化
    ZegoRoomEventMinimize = 6

};

/// 房间多语言枚举类
///
typedef NS_ENUM(NSUInteger, ZegoRoomUILanguage) {

    /// 简体中文
    ZegoRoomUILanguageZHHans = 0,

    /// 繁体中文
    ZegoRoomUILanguageZHHant = 1,

    /// 英文
    ZegoRoomUILanguageEN = 2,

    /// 日语
    ZegoRoomUILanguageJA = 3,

    /// 韩语
    ZegoRoomUILanguageKO = 4

};

///点击事件
///
typedef NS_ENUM(NSUInteger, ZegoButtonEventType) {
    
    /// 邀请
    ZegoButtonEventTypeInvite = 1,
};

/// 房间成员角色
///
typedef NS_ENUM(NSUInteger, ZegoRoomKitRole) {
    /// 主持人
    ZegoRoomKitRoleHost          = 1,
    /// 普通观众
    ZegoRoomKitRoleAttendee      = 2,
    /// 助理主持人
    ZegoRoomKitRoleAssistantHost = 4,
};


/// 加入房间默认样式配置。针对当前加入的房间生效，加入房间后修改无效。
///
@interface ZegoJoinRoomUIConfig : NSObject

/// 底部工具栏隐藏模式
@property (nonatomic, assign) ZegoToolBarHiddenMode isBottomBarHidden;

/// 是否隐藏聊天按钮
@property (nonatomic, assign) BOOL isChatHidden;

/// 是否隐藏成员按钮
@property (nonatomic, assign) BOOL isAttendeesHidden;

/// 是否隐藏共享按钮
@property (nonatomic, assign) BOOL isShareHidden;

/// 是否隐藏摄像头按钮
@property (nonatomic, assign) BOOL isCameraHidden;

/// 是否隐藏麦克风按钮
@property (nonatomic, assign) BOOL isMicrophoneHidden;

/// 是否隐藏更多按钮
@property (nonatomic, assign) BOOL isMoreHidden;

/// 是否隐藏上传文件/图片按钮
@property (nonatomic, assign) BOOL isUploadFileHidden;

/// 设置房间内 UI 语言
@property (nonatomic, assign) ZegoRoomUILanguage language;

/// 房间自定义标题
@property (nonatomic, copy) NSString *customizedTitle;

/// 房间自定义水印
@property (nonatomic, copy) NSString *watermark;

/// 是否隐最小化按钮
@property (nonatomic, assign) BOOL isMinimizeHidden;

/// 是否显示邀请按钮
@property (nonatomic, assign) BOOL isInviteShow;

/// 是否隐藏房间成员人数
@property (nonatomic, assign) BOOL isMemberCountHidden;

/// 讨论消息中是否隐藏进房消息
@property (nonatomic, assign) BOOL isMemberJoinRoomMessageHidden;

/// 讨论消息中是否隐藏退房消息
@property (nonatomic, assign) BOOL isMemberLeaveRoomMessageHidden;

/// 是否隐藏企业云盘
@property (nonatomic, assign) BOOL isCompanyFilesHidden;

/// 是否固定展示进退房消息
@property (nonatomic, assign) BOOL isFixedInOutMessage;

@end

/// 加入房间配置对象
///
@interface ZegoJoinRoomConfig : NSObject

/// 房间号
@property (nonatomic, copy) NSString *roomID;

/// 项目 ID
@property (nonatomic, assign) NSInteger productID;

/// token
@property (nonatomic, copy) NSString *token;

/// 用户名
@property (nonatomic, copy) NSString *userName;

/// 用户 ID
@property (nonatomic, assign) NSInteger userID;

/// 加入房间时的角色
@property (nonatomic, assign) ZegoRoomKitRole role;

@end


/// 离开房间命令类
///
@interface ZegoLeaveRoomCommand : NSObject

/// 离开房间类型
@property (nonatomic, assign) ZegoLeaveRoomType type;

@end


@interface ZegoScreenShareConfig : NSObject

/// app应用组，iOS屏幕共享时使用，用于扩展进程与主进程通信
@property (nonatomic, copy) NSString *appGroupID;

/// 扩展进程Bundle，iOS屏幕共享时使用，用于主进程调起扩展进程
@property (nonatomic, copy) NSString *appExtensionBundleID;

@end


@interface ZegoRoomParameter : NSObject

/// 房间主题
@property (nonatomic, copy) NSString *subject;

/// 主持人昵称
@property (nonatomic, copy) NSString *hostNickname;

/// 房间开始时间戳
@property (nonatomic, assign) NSTimeInterval beginTimestamp;

/// 持续时长
@property (nonatomic, assign) NSInteger duration;

/// 流加解密秘钥
@property (nonatomic, copy) NSString *streamEncryptKey;

@end


@interface ZegoUserParameter : NSObject

/// 头像url
@property (nonatomic, copy) NSString *avatarUrl;

/// 图标url
@property (nonatomic, copy) NSString *customIconUrl;

@end



/// 房间内事件通知
///
@protocol ZegoInRoomServiceDelegate <NSObject>

/// 房间内事件通知
///
/// 调用时机：房间内重要事件变更时调用
///
/// @param event 房间内事件
/// @param roomID 房间 ID
- (void)onInRoomEventNotify:(ZegoRoomEvent)event roomID:(NSString *)roomID;

/// 成员进入房间通知
///
/// 调用时机：房间内成员加入时调用
///
/// @param roomID 房间 ID
/// @param memberID 成员 ID
- (void)onMemberJoinRoom:(NSString *)roomID memberID:(long)memberID;

/// 成员离开房间通知
///
/// 调用时机：房间内成员离开房间时调用
///
/// @param roomID 房间 ID
/// @param memberID 成员 ID
- (void)onMemberLeaveRoom:(NSString *)roomID memberID:(long)memberID;

/// 房间内按钮点击回调
///
/// 调用时机：调用加入房间后，房间内按钮点击时
///
///@param type 点击事件类型
- (void)onButtonEventWithType:(ZegoButtonEventType)type;

/// 房间内自定义消息通知
///
/// 调用时机：房间内收到自定义消息时调用
///
/// @param customMessage 自定义消息内容
- (void)receiveCustomMessage:(NSDictionary *)customMessage;

/// 主持人视频视频流分辨率变化回调
///
/// 调用时机：主持人视频流分辨率变化时
///
/// @param size 分辨率大小
- (void)onHostVideoSizeChanged:(CGSize)size;

@end


/// 房间内控制类
///
/// 加入房间，房间内UI设置，房间内摄像头、麦克风加入房间默认状态设置
///
@interface ZegoInRoomService : NSObject

/// 房间内事件代理
@property (nonatomic, weak) id<ZegoInRoomServiceDelegate> delegate;

/// 加入房间
///
/// 调用时机：初始化后，需要加入房间的时候
///
/// @param config 加入房间参数配置
/// @param fromVC 加入房间之前的VC
/// @param completion 加入房间结果回调
- (void)joinRoomWithConfig:(nonnull ZegoJoinRoomConfig *)config fromVC:(UIViewController *)fromVC completion:(ZegoJoinRoomBlock)completion;

/// 离开或结束房间
///
/// 调用时机：加入房间后，需要离开或结束房间的时候
///
/// @param command 离开或结束房间
/// @param completion 离开或结束房间结果回调
- (void)leaveRoomWithCommand:(nonnull ZegoLeaveRoomCommand *)command completion:(ZegoLeaveRoomBlock)completion;

/// 获取当前房间信息
///
/// 调用时机：加入房间后，需要获取当前房间信息的时候
///
/// @return 返回当前房间信息
- (ZegoRoomDetailInfo *)getCurrentRoomInfo;

/// 获取当前视频画面
///
/// 调用时机：加入房间后，需要获取当前视频画面的时候
///
/// @return 返回当前视频画面View
- (UIView *)getCurrentVideoView;

/// 最大化房间界面
///
/// 调用时机：最小化房间后，需要重新展示房间页面的时候
///
/// @param fromVC 显示房间之前的VC
- (void)displayRoomViewFromVC:(UIViewController *)fromVC;

/// 获取房间内容器
///
/// 调用时机：加入房间后，需要获取房间容器时
///
/// @return 房间容器
- (UIViewController *)getCurrentRoomVC;

/// 新增共享屏幕模块
///
/// 调用时机：加入房间前，需要使用共享屏幕功能的时候
///
- (void)addShareScreenModule:(ZegoScreenShareConfig *)config;

/// 设置房间UI配置项
///
/// 调用时机：加入房间前，需要自定义房间UI的时候
///
- (void)setUIConfig:(ZegoJoinRoomUIConfig *)uiConfig;

/// 设置房间数据
///
/// 调用时机：加入房间前，需要自定义房间数据的时候
///
- (void)setRoomParameter:(ZegoRoomParameter *)roomParameter;

/// 设置房间数据
///
/// 调用时机：加入房间前，需要自定义房间数据的时候
///
- (void)setUserParameter:(ZegoUserParameter *)userParameter;

@end

NS_ASSUME_NONNULL_END

