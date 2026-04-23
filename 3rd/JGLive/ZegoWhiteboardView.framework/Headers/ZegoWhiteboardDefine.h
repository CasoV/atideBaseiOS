//
//  ZegoWhiteboardDefine.h
//  ZegoWhiteboardView
//
//  Created by zego on 2020/4/13.
//  Copyright © 2020 zego. All rights reserved.
//



#ifndef ZegoWhiteboardDefine_h
#define ZegoWhiteboardDefine_h

#define ZEGO_WHITEBOARD_VIEW_VERSION @"ZegoWhiteboardView_v1.21.2.98_210629_111421_ios"
#define ZEGO_WHITEBOARD_MATCH_VERSION @"1.21.2"

/** 白板id类型，唯一标识一块白板 */
typedef unsigned long long ZegoWhiteboardID;

NS_ASSUME_NONNULL_BEGIN

/// 白板操作工具（教具）
///
typedef NS_ENUM(NSUInteger, ZegoWhiteboardTool) {

    /// 涂鸦
    ZegoWhiteboardViewToolPen = 1,

    /// 文本框
    ZegoWhiteboardViewToolText = 2,

    /// 直线
    ZegoWhiteboardViewToolLine = 4,

    /// 空心矩形
    ZegoWhiteboardViewToolRect = 8,

    /// 空心椭圆
    ZegoWhiteboardViewToolEllipse = 16,

    /// 选择工具
    ZegoWhiteboardViewToolSelector = 32,

    /// 橡皮擦
    ZegoWhiteboardViewToolEraser = 64,

    /// 激光笔
    ZegoWhiteboardViewToolLaser = 128,

    /// 动态ppt点击工具
    ZegoWhiteboardViewToolClick = 256,

    /// 自定义图形工具
    ZegoWhiteboardViewToolCustomImage = 512,

    /// 不知名类型
    ZegoWhiteboardViewToolNone = 0

};

/// 白板错误码枚举
///
typedef NS_ENUM(NSUInteger, ZegoWhiteboardViewError) {

    /// 成功
    ZegoWhiteboardViewSuccess = 0,

    /// 内部错误
    ZegoWhiteboardViewErrorInternal = 3000001,

    /// 参数错误
    ZegoWhiteboardViewErrorParamInvalid = 3000002,

    /// 网络超时
    ZegoWhiteboardViewErrorNetworkTimeout = 3000003,

    /// 网络断开
    ZegoWhiteboardViewErrorNetworkDisconnect = 3000004,

    /// 网络回包错误
    ZegoWhiteboardViewErrorInvalidRsp = 3000005,

    /// 请求过于频繁
    ZegoWhiteboardViewErrorRequestTooMany = 3000006,

    /// 未登录房间
    ZegoWhiteboardViewErrorNoLoginRoom = 3010001,

    /// 用户不存在
    ZegoWhiteboardViewErrorUserNotExist = 3010002,

    /// 白板view不存在
    ZegoWhiteboardViewErrorViewNotExist = 3020001,

    /// 创建白板view失败
    ZegoWhiteboardViewErrorViewCreateFail = 3020002,

    /// 修改白板view失败
    ZegoWhiteboardViewErrorViewModifyFail = 3020003,

    /// 白板view名称过长
    ZegoWhiteboardViewErrorViewNameLimit = 3020004,

    /// 白板view的parent不存在
    ZegoWhiteboardViewErrorViewParentNotExist = 3020005,

    /// 超过白板最大数量限制
    ZegoWhiteboardViewErrorViewNumLimit = 3020006,
    
    /// 动画信息过长
    ZegoWhiteboardViewErrorAnimationInfoLimit = 3020007,

    /// 图元不存在
    ZegoWhiteboardViewErrorGraphicNotExist = 3030001,

    /// 创建图元错误
    ZegoWhiteboardViewErrorGraphicCreateFail = 3030002,

    /// 修改图元错误
    ZegoWhiteboardViewErrorGraphicModifyFail = 3030003,

    /// 未开启绘制
    ZegoWhiteboardViewErrorGraphicUnableDraw = 3030004,

    /// 单个图元数据大小超过限制
    ZegoWhiteboardViewErrorGraphicDataLimit = 3030005,

    /// 超过图元最大数量限制
    ZegoWhiteboardViewErrorGraphicNumLimit = 3030006,

    /// 文本文案超过最大值
    ZegoWhiteboardViewErrorGraphicTextLimit = 3030007,

    /// 初始化失败
    ZegoWhiteboardViewErrorInitFail = 3040001,

    /// 拉取白板view列表失败
    ZegoWhiteboardViewErrorGetListFail = 3040002,

    /// 创建白板view失败
    ZegoWhiteboardViewErrorCreateFail = 3040003,

    /// 销毁白板view失败
    ZegoWhiteboardViewErrorDestroyFail = 3040004,

    /// attach白板view失败
    ZegoWhiteboardViewErrorAttachFail = 3040005,

    /// 清空白板view失败
    ZegoWhiteboardViewErrorClearFail = 3040006,

    /// 滚动白板view失败
    ZegoWhiteboardViewErrorScrollFail = 3040007,

    /// 撤销操作失败
    ZegoWhiteboardViewErrorUndoFail = 3040008,

    /// 重做操作失败
    ZegoWhiteboardViewErrorRedoFail = 3040009,
    
    /// 初始化时设置的日志目录无法创建或写入
    ZegoWhiteboardViewErrorLogPathNotAccess = 3040010,
    
    /// 初始化时设置的缓存目录无法创建或写入
    ZegoWhiteboardViewErrorCacheFolderNotAccess = 3040011,

    /// 初始化失败，白板和liveroom版本不匹配
    ZegoWhiteboardViewErrorVersionMismatch = 3000007,

    /// 图片图元大小超限制
    ZegoWhiteboardViewErrorGraphicImageSizeLimit = 3030008,

    /// 不支持的图片类型
    ZegoWhiteboardViewErrorGraphicImageTypeNotSupport = 3030009,

    /// 非法图片 URL
    ZegoWhiteboardViewErrorGraphicIllegalAddress = 3030010,
    
    /// @deprecated
    /// 请使用 ZegoWhiteboardViewErrorGraphicIllegalAddress
    ZegoWhiteboardViewErrorGraphicIllegalUrl DEPRECATED_ATTRIBUTE = ZegoWhiteboardViewErrorGraphicIllegalAddress,

    /// 无白板缩放权限
    ZegoWhiteboardViewErrorNoAuthScale = 3050001,

    /// 无白板滚动权限
    ZegoWhiteboardViewErrorNoAuthScroll = 3050002,

    /// 无图元创建权限
    ZegoWhiteboardViewErrorNoAuthCreateGraphic = 3050003,

    /// 无图元编辑权限
    ZegoWhiteboardViewErrorNoAuthUpdateGraphic = 3050004,

    /// 无图元移动权限
    ZegoWhiteboardViewErrorNoAuthMoveGraphic = 3050005,

    /// 无图元删除权限
    ZegoWhiteboardViewErrorNoAuthDeleteGraphic = 3050006,

    /// 无图元清空权限
    ZegoWhiteboardViewErrorNoAuthClearGraphic = 3050007,
    
};

/// ZegoWhiteboardView 添加图片类型
///
typedef NS_ENUM(NSUInteger, ZegoWhiteboardViewImageType) {

    /// 普通图片图元类型
    ZegoWhiteboardViewImageTypeGraphic = 0,

    /// 自定义图片图元类型
    ZegoWhiteboardViewImageTypeCustom = 1

};

/// 白板操作模式
///
typedef NS_OPTIONS(NSUInteger, ZegoWhiteboardOperationMode) {

    /// 不可操作模式，如果与其他模式混合，则依然是不可操作模式
    ZegoWhiteboardOperationModeNone = 1 << 0,

    /// 滚动模式，此模式下可以进行滚动翻页，并同步到其他端，此时将无法响应手动绘制操作,不可以与ZegoWhiteboardOperationModeDraw 混合使用
    ZegoWhiteboardOperationModeScroll = 1 << 1,

    /// 绘制模式，此模式下将会响应图元绘制操作，并同步图元到其他端，无法滚动，不可以与ZegoWhiteboardOperationModeScroll 混合使用
    ZegoWhiteboardOperationModeDraw = 1 << 2,

    /// 放缩模式，此模式下可以对白板内容进行放大。
    ZegoWhiteboardOperationModeZoom = 1 << 3,

};

/// 白板背景图片填充模式
///
typedef NS_ENUM(NSUInteger, ZegoWhiteboardViewImageFitMode) {

    /// 靠左对齐按宽或按高等比放大或缩小
    ZegoWhiteboardViewImageFitModeLeft = 0,

    /// 靠右对齐按宽或按高等比放大或缩小
    ZegoWhiteboardViewImageFitModeRight = 1,

    /// 底部对齐按宽或按高等比放大或缩小
    ZegoWhiteboardViewImageFitModeBottom = 2,

    /// 顶部对齐按宽或按高等比放大或缩小
    ZegoWhiteboardViewImageFitModeTop = 3,

    /// 居中对齐按宽或按高等比放大或缩小
    ZegoWhiteboardViewImageFitModeCenter = 4

};

NS_ASSUME_NONNULL_END

#endif /* ZegoWhiteboardDefine_h */

