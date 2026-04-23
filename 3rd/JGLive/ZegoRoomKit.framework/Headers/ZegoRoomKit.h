#import <Foundation/Foundation.h>

#import <UIKit/UIKit.h>
#import "ZegoRoomKitError.h"
#import "ZegoInRoomService.h"
#import "ZegoRoomSettings.h"
#import "ZegoRoomInfo.h"
#import "ZegoScreenShareService.h"

NS_ASSUME_NONNULL_BEGIN

/// SDK 初始化回调
///
/// @param error 初始化错误码
typedef void (^ZegoRoomKitInitBlock)(ZegoRoomKitError error);

/// SDK 上传日志结果回调
///
/// @param error 上传日志错误码
typedef void (^ZegoUploadLogResultBlock)(ZegoRoomKitError error);

/// SDK 初始化配置类
///
/// 设置初始化SDK需要配置的参数
///
@interface ZegoInitConfig : NSObject

/// 由Zego后台分配的
@property (nonatomic, assign) NSInteger secretID;

@end

/// 获取SDK管理单例对象
///
/// 用户登录、房间增删改查、房间内设置、加入房间等功能模块入口
///
@interface ZegoRoomKit : NSObject

/// 获取设备ID
///
/// 调用时机：初始化后, 需要获取设备ID的时候
///
/// @return 设备ID
+ (NSString *)deviceID;

/// 获取房间内控制对象
///
/// 调用时机：初始化后, 需要加入房间，设置房间属性的时候
///
/// @return 房间内控制对象
- (ZegoInRoomService *)inRoomService;

/// SDK 初始化方法
///
/// 调用时机：使用 SDK 前第一个需要调用的接口
///
/// @param config config 初始化配置
/// @param completion completion 初始化结果回调
- (void)initWithConfig:(nonnull ZegoInitConfig *)config completion:(ZegoRoomKitInitBlock)completion;

/// 获取房间内设置对象
///
/// 调用时机：初始化后, 需要配置房间内行为的时候
///
/// @return 房间内设置对象
- (ZegoRoomSettings *)roomSettings;

/// 获取ZegoRoomKit的单例对象
///
/// @return ZegoRoomKit单例对象
+ (instancetype)sharedInstance;

/// SDK 反初始化
///
/// 调用时机：初始化之后
- (void)uninit;

/// 上传日志到 Zego SDK 后台
///
/// 调用时机：初始化之后，需要上传日志的时候
///
/// @param completion 上传结果回调
+ (void)uploadLog:(NSString *)fileName completion:(ZegoUploadLogResultBlock)completion;

/// 获取 SDK 版本信息
///
/// 调用时机：初始化后, 需要获取 SDK 版本号的时候
///
/// @return SDK版本号
+ (NSString *)version;

/// 支持版本：1.15.0
/// 详情描述：设置sdk的私有参数, 具体的参数请咨询 ZEGO 技术支持
/// 调用时机:   在调用 `initWithConfig` 之前调用生效
/// @param advancedConfig 字典数据
+ (void)setAdvancedConfig:(NSDictionary<NSString *, NSString *> *)advancedConfig;

@end

NS_ASSUME_NONNULL_END

