#import <UIKit/UIKit.h>
#import "ZegoWhiteboardDefine.h"
#import "ZegoWhiteboardViewModel.h"
#import "ZegoWhiteboardView.h"
#import "ZegoWhiteboardConfig.h"

@class ZegoWhiteboardContentView;

NS_ASSUME_NONNULL_BEGIN

/// 白板交互错误回调
///
/// @param errorCode 错误码
typedef void(^ZegoWhiteboardBlock)(ZegoWhiteboardViewError errorCode);

/// 创建白板回调
///
/// errorCode 为0则创建成功，同时在回调中可以获取到白板视图
///
/// @param errorCode 错误码
/// @param whiteboardView 白板视图
typedef void(^ZegoCreateWhiteboardBlock)(ZegoWhiteboardViewError errorCode, ZegoWhiteboardView *whiteboardView);

/// 销毁白板回调
///
/// errorCode 为0则销毁成功
///
/// @param errorCode 错误码
/// @param whiteboardID 销毁的白板 ID
typedef void(^ZegoDestroyWhiteboardBlock)(ZegoWhiteboardViewError errorCode, ZegoWhiteboardID whiteboardID);

/// 获取白板列表回调
///
/// errorCode 为0则获取白板列表成功
///
/// @param errorCode 错误码
/// @param whiteboardViewList 白板
typedef void(^ZegoGetWhiteboardListBlock)(ZegoWhiteboardViewError errorCode, NSArray *whiteboardViewList);

/// 远端进行白板操作产生的回调通知
///
@protocol ZegoWhiteboardManagerDelegate <NSObject>

/// 新增白板的通知
///
/// 用户可在收到此通知时将 ZegoWhiteboardView 展现到视图中。
///
/// 通知时机：同一房间内其他用户成功创建白板(调用 [createWhiteboardView])后，本端会收到此通知。
///
/// @param whiteboardView 新增的 ZegoWhiteboardView
- (void)onWhiteboardAdd:(ZegoWhiteboardView *)whiteboardView;

/// 白板被删除的通知
///
/// 用户应在收到此通知时将 whiteboardID 对应的 ZegoWhiteboardView 从视图中移除。
///
/// 通知时机：同一房间内其他成员成功销毁白板（调用 [destroyWhiteboardID]）后，本端会收到此通知。
///
/// @param whiteboardID 移除白板对应的白板 ID
- (void)onWhiteboardRemoved:(ZegoWhiteboardID)whiteboardID;

/// 收到远端动画执行回调
///
/// 远端的（例如动态 ppt）文件进行动画播放时发出的通知。本端需要调用 ZegoDocsView 的 -playAnimation：方法以实现本端（动态 ppt）动画的同步播放
///
/// @param animationInfo 动画执行相关的 h5 信息，本端动画播放需要传递该参数给 ZegoDocsView SDK 以让内嵌 webview 同步播放动画
- (void)onPlayAnimation:(NSString *)animationInfo;

/// 错误回调
///
/// 白板发生内部错误产生的回调通知，可根据对应的错误码知道具体的错误类型，然后进行对应的业务
///
/// @param error 可在 ZegoWhiteboardDefine.h 查看对应错误码
/// @param whiteboardView 发生错误的白板对象
- (void)onError:(ZegoWhiteboardViewError)error whiteboardView:(ZegoWhiteboardView *)whiteboardView;

/// 白板操作权限变更回调
///
/// 该权限用于控制对白板的操作，包括缩放，滚动
///
/// @param authInfo 包含 scale、scroll 2个key  value为 0 和 1 （0代表对应权限关闭 1代表对应权限打开）
- (void)onWhiteboardAuthChanged:(NSDictionary *)authInfo;

/// 图元操作权限变更回调
///
/// 图元操作权限包括创建、删除、移动、更新、清空所有图元
///
/// @param authInfo 包含 create、delete、move、update、clear 5个key  value为 0 和 1 （0代表对应权限关闭 1代表对应权限打开）
- (void)onWhiteboardGraphicAuthChanged:(NSDictionary *)authInfo;

@end

/// 白板 SDK 的管理类
///
/// 创建、移除、获取白板等操作
///
@interface ZegoWhiteboardManager : NSObject

/// 当前操作白板视图的工具（教具）
/// 包含画笔、文字、直线、激光笔等工具，设置该属性可改变工具类型
@property (nonatomic, assign, readwrite) ZegoWhiteboardTool toolType;

/// 画笔颜色
@property (nonatomic, strong, readwrite) UIColor *brushColor;

/// 画笔粗细
@property (nonatomic, assign, readwrite) NSUInteger brushSize;

/// 文本字体大小
@property (nonatomic, assign, readwrite) NSUInteger fontSize;

/// 是否设置粗体字
@property (nonatomic, assign, readwrite) BOOL isFontBold;

/// 是否设置斜体字
@property (nonatomic, assign, readwrite) BOOL isFontItalic;

/// 是否将缩放同步给房间内其他成员
@property (nonatomic, assign, readwrite) BOOL enableSyncScale;

/// 是否响应房间内其他成员的缩放
@property (nonatomic, assign, readwrite) BOOL enableResponseScale;


/// 白板代理，发生错误、白板新增、白板移除时收到回调
@property (nonatomic, weak) id<ZegoWhiteboardManagerDelegate> delegate;

/// 用户可自定义文本教具的默认文本，默认值为 @“文本”
@property (nonatomic, copy) NSString *customText;

/// 清除整个缓存目录
///
/// 在需要清理缓存时调用此方法，可清除已加载的文件缓存
- (void)clearCacheFolder;

/// 创建 ZegoWhiteboardView
///
/// 用户可调用此接口创建白板，创建成功后将获取到的白板添加到视图中即可。
///
/// 调用时机：初始化 ZegoWhiteboardView SDK，且调用 ZegoExpressEngine SDK 的 [loginRoom] 登录房间之后。
///
/// 创建成功后，其他用户会在 [onWhiteboardAdd] 回调中收到相应通知。
///
/// @param whiteboardModel 创建 ZegoWhiteboardView 的配置项，SDK 根据该配置创建出相应的 ZegoWhiteboardView
/// @param completeBlock 创建 ZegoWhiteboardView 的结果回调
///                      如果创建成功，返回 errorCode  为 0 和  ZegoWhiteboardView
///                      如果创建失败，返回 errorCode  为非 0 。详见常见错误码
- (void)createWhiteboardView:(ZegoWhiteboardViewModel *)whiteboardModel completeBlock:(ZegoCreateWhiteboardBlock)completeBlock;

/// 获取 SDK 版本号
///
/// 调用时机：初始化后, 需要获取 SDK 版本号的时候
///
/// @return 返回当前 SDK 版本号
- (NSString *)getVersion;

/// 销毁指定 ZegoWhiteboardView
///
/// 用户可以调用此接口销毁自己或其他用户创建的 ZegoWhiteboardView，销毁成功后可移除对应的视图。
///
/// 调用时机：初始化 ZegoWhiteboardView SDK，且调用 ZegoExpressEngine SDK 的 [loginRoom] 登录房间之后。
///
/// 如果 ZEGO 服务器上不存在 whiteboardID 对应的 ZegoWhiteboardView ，则不会收到任何回调。
///
/// 销毁成功后，其他用户会在 [onWhiteboardRemoved] 回调中收到相应通知。
///
/// @param whiteboardID 需销毁白板 ID
/// @param completeBlock 销毁白板结果回调
///                      销毁成功返回 errorCode 为 0 和 被销毁的 whiteboardID
///                      销毁失败返回 errorCode 为非 0 和 被销毁的 whiteboardID
- (void)destroyWhiteboardID:(ZegoWhiteboardID)whiteboardID completeBlock:(ZegoDestroyWhiteboardBlock)completeBlock;

/// 获取 ZegoWhiteboardView 列表
///
/// 用户登录房间时，可通过此接口获取房间内已创建的 ZegoWhiteboardView 列表，用户可以将相应的 ZegoWhiteboardView 添加到视图中，或者保存起来之后使用。
///
/// 调用时机：初始化 ZegoWhiteboardView SDK，调用 [loginRoom] 登录房间之后。
///
/// @param completeBlock 拉取 ZegoWhiteboardView 列表的结果回调
///                      如果拉取成功，返回 errorCode 为 0 和 ZegoWhiteboardView 数组
///                      如果拉取失败，返回 errorCode 为非 0 
- (void)getWhiteboardListWithCompleteBlock:(ZegoGetWhiteboardListBlock)completeBlock;

/// 退房前清理资源
///
/// 调用时机：初始化后, 进入房间之后，SDK 对于房间内资源的清理，需要在退出房间前主动调用
- (void)clear;

/// 初始化 ZegoWhiteboardView SDK
///
/// 调用时机：在使用 SDK 的其他接口之前需首先调用此接口，并且在回调成功之后才能进行其他功能的使用。
///
/// 必须在调用 ZegoExpressEngine SDK 的 [loginRoom] 接口之前调用，否则会收到 112000002 错误。
///
/// @param completeBlock 初始化白板结果回调，errorCode 返回 0 则初始化成功
- (void)initWithCompleteBlock:(ZegoWhiteboardBlock)completeBlock;

/// 反初始化 SDK
///
/// 调用时机：初始化之后
- (void)uninit;

/// 设置白板配置信息
///
/// 调用时机：请在初始化 init() 方法之前调用
///
/// @param config 配置信息
- (void)setConfig:(ZegoWhiteboardConfig *)config;

/// 设置自定义新字体
///
/// 调用时机：创建白板之后
///
/// Note: 只支持特定的字体, 并且需要在工程中内置我们提供的字体文件，请联系技术支持获取字体文件与对应的字体名
///
/// @param regularFontName 常规字体的字体名称，请联系技术支持获取
/// @param boldFontName 粗体字体的字体名称，请联系技术支持获取
- (void)setCustomFontWithName:(NSString *)regularFontName boldFontName:(NSString *)boldFontName;

/// 管理类单例
///
/// @return 管理类单例
+ (ZegoWhiteboardManager *)sharedInstance;

@end

NS_ASSUME_NONNULL_END

