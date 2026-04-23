#import <Foundation/Foundation.h>
#import "ZegoWhiteboardDefine.h"
#import "ZegoWhiteboardViewModel.h"

@class ZegoWhiteboardView;

NS_ASSUME_NONNULL_BEGIN

typedef void(^ZegoWhiteboardScrollBlock)(ZegoWhiteboardViewError errorCode, float horizontalPercent, float verticalPercent, unsigned int pptStep);

/// ZegoWhiteboardView 白板同步回调协议
///
@protocol ZegoWhiteboardViewDelegate <NSObject>

/// 实现该方法以响应白板的缩放
///
/// 白板缩放后，会调用该回调方法通知业务层，根据参数可对白板的缩放实现响应。例如使文件进行同步缩放。
///
/// @param scaleFactor 缩放系数
/// @param scaleOffsetX 缩放时产生的横向偏移
/// @param scaleOffsetY 缩放时产生的纵向偏移
/// @param whiteboardView 正在进行缩放的白板对象
- (void)onScaleChangedWithScaleFactor:(CGFloat)scaleFactor scaleOffsetX:(CGFloat)scaleOffsetX scaleOffsetY:(CGFloat)scaleOffsetY whiteboardView:(ZegoWhiteboardView *)whiteboardView;

/// 实现该方法以响应白板的滚动
///
/// 白板滚动后，会调用该回调方法通知外界，根据参数可对白板的滚动实现响应。例如使文件进行同步滚动。
///
/// @param horizontalPercent 白板横向滚动的百分比
/// @param verticalPercent 白板纵向滚动的百分比
/// @param whiteboardView 正在发生滚动的白板对象
- (void)onScrollWithHorizontalPercent:(CGFloat)horizontalPercent verticalPercent:(CGFloat)verticalPercent whiteboardView:(ZegoWhiteboardView *)whiteboardView;

@end

/// 白板 View
///
@interface ZegoWhiteboardView : UIView

/// 放缩比例因子
@property (nonatomic, assign, readonly) CGFloat scaleFactor;

/// 放缩后，对视图显示内容进行滚动产生的水平偏移量
@property (nonatomic, assign, readonly) CGFloat scaleOffsetX;

/// 放缩后，对视图显示内容进行滚动产生的垂直偏移量
@property (nonatomic, assign, readonly) CGFloat scaleOffsetY;

/// 视图当前显示区域的起点
@property (nonatomic, assign, readonly) CGPoint contentOffset;

/// 视图的实际可展示范围
@property (nonatomic, assign) CGSize contentSize;

/// 白板 View 对应的 viewModel
@property (nonatomic, strong, readonly) ZegoWhiteboardViewModel *whiteboardModel;

/// ZegoWhiteboardView 回调
@property (nonatomic, weak) id<ZegoWhiteboardViewDelegate> whiteboardViewDelegate;

/// 在白板中添加图片
///
/// Note:
/// 1、支持图片类型：png/jpg/jpeg；
/// 2、当type为ZegoWhiteboardViewImageGraphic时，支持本地图片和网络图片，图片大小限制10M；
/// 3、当type为ZegoWhiteboardViewImageCustom时，只支持网络图片，图片大小限制500KB；
///
/// @param type 图片类型，目前支持普通图片和自定义图形
/// @param positionX 图片插入位置的起始点，相对所在viewport的左上角的横向偏移，如10，此处的viewport是指可写区域。自定义图形直接传 0 即可。
/// @param positionY 图片插入位置的起始点，相对所在viewport的左上角的纵向偏移，如10，此处的viewport是指可写区域。自定义图形直接传 0 即可。
/// @param address 图片地址，支持本地图片地址和网络图片地址，本地图片会先上传到cdn存储。目前自定义图形只支持网络图片地址。（网络图片仅支持 https）例："xxxxxxxxxx.png"，"https://xxxxxxxx.com/xxx.png"。
/// @param complete 添加图片结果回调，错误码参考 ZegoWhiteboardViewError
- (void)addImage:(ZegoWhiteboardViewImageType)type positionX:(int)positionX positionY:(int)positionY address:(NSString *)address complete:(void(^)(int errorcode))complete;

/// 给白板 View 添加文本
///
/// @param complete 操作结果回调
- (void)addTextEditWithComplete:(void(^)(ZegoWhiteboardViewError errorcode))complete;

/// 向白板添加自定义文本
///
/// 在白板view中添加文本，会创建一个新的文本图元（不会弹出键盘输入框，会自适应缩放系数）
///
/// @param text 待添加文本图元的字符串内容
/// @param positionX 相对所在viewport的左上角的横向偏移，如10，此处的viewport是指可写区域
/// @param positionY 相对所在viewport的左上角的纵向偏移，如10，此处的viewport是指可写区域
/// @param complete 操作结果回调
- (void)addText:(NSString *)text positionX:(int)positionX positionY:(int)positionY complete:(void(^)(ZegoWhiteboardViewError errorcode))complete;

/// 清除白板上的所有图元
///
/// @param complete 操作结果回调
- (void)clearWithComplete:(void(^)(ZegoWhiteboardViewError errorcode))complete;

/// 移除白板背景图片
///
/// @param complete 清除背景完成回调
- (void)clearBackgroundImageWithComplete:(void(^)(ZegoWhiteboardViewError errorcode))complete;

/// 清空指定坐标范围内的所有图元
///
/// 调用时机：一般用于清除当前页
/// Note: 如果是要清除当前页，在纯白板模式，调用者自行算出当前白板页的坐标范围；在文件白板场景下，可通过ZegoDocsView SDK的接口获取当前页的坐标范围
///
/// @param rect 待清空的白板指定范围
/// @param complete 操作结果回调
- (void)clear:(CGRect)rect complete:(void(^)(ZegoWhiteboardViewError errorcode))complete;

/// 删除已选图元
///
/// 调用时机: 该接口用于提供给用户进行自定义删除已选图元。比如，在选择tooltype类型下选择了多个图元后，想要在切到橡皮擦tooltype时，能删除已选图元，就可以使用本接口实现
///
/// @param complete 操作结果回调
- (void)deleteSelectedGraphicsWithComplete:(void(^)(ZegoWhiteboardViewError errorcode))complete;

/// 初始化白板
///
/// @param whiteboardModel 白板信息
///
/// @return 初始化后的白板对象
- (instancetype)initWithWhiteboardModel:(ZegoWhiteboardViewModel *)whiteboardModel;

/// 同步动态PPT播放动画的信息到其他端
///
/// 调用时机: 当自己端点击了动态PPT的动画，执行完成之后调用此方法同步给房间内的其他成员
/// Note: 仅支持动态PPT类型的文件
///
/// @param animationInfo 动态PPT动画播放的信息
- (void)playAnimation:(NSString *)animationInfo;

/// 恢复上一步撤销的操作
- (void)redo;

/// 移除激光笔
- (void)removeLaser;

/// 将白板滚动到指定偏移位置，用百分比描述
///
/// 支持垂直以及水平方向的滚动。如果 ZegoWhiteboardView 内容超出一页，用户可以通过此接口滚动到白板的不同区域。
///
/// 调用时机：创建 或 获取 ZegoWhiteboardView 之后。
///
/// 滚动操作会通过 [ZegoExpressEngine] SDK 或者 [ZegoLiveRoom] SDK 同步到远端，ZegoWhiteboardView 会自动处理滚动区域的同步，开发者无需做额外接口的调用。
/// 假设用户 A 调用此接口滚动到 horizontalPercent = 0.1，verticalPercent = 0.2 的位置，则在同一房间的 B 的相应 ZegoWhiteboardView 会自动滚动到相同位置，这个过程无需开发者做额外接口的调用。
///
/// @param horizontalPercent 横向滚动百分比，取值范围0~1.0，0代表偏移量为零的位置，1代表偏移到最大值。
/// @param verticalPercent 纵向滚动百分比，取值范围0~1.0，0代表偏移量为零的位置，1代表偏移到最大值。
/// @param completionBlock 滚动操作完成后的回调，用户可在回调中做相应业务处理。
- (void)scrollToHorizontalPercent:(CGFloat)horizontalPercent verticalPercent:(CGFloat)verticalPercent completionBlock:(ZegoWhiteboardScrollBlock)completionBlock;

/// 将白板滚动到指定偏移位置，用百分比描述
///
/// 支持垂直以及水平方向的滚动，使用上与 UIScrollView 类似
/// 重要提示: 滚动操作会通过 ZegoExpressEngine 或者 ZegoLiveRoom 同步到远端，可在回调完成后做自定义操作
///
/// @param horizontalPercent 横向滚动百分比，取值范围0~1.0，0代表偏移量为零的位置，1代表偏移到最大值
/// @param verticalPercent 纵向滚动百分比，取值范围0~1.0，0代表偏移量为零的位置，1代表偏移到最大值
/// @param pptStep 动态PPT步数
///                重要提示: 当白板需要与文件转码 SDK 配合使用时，通过设置此参数来同步动态类型的PPT的动画步骤数
/// @param completionBlock 滚动回调
- (void)scrollToHorizontalPercent:(CGFloat)horizontalPercent verticalPercent:(CGFloat)verticalPercent pptStep:(NSInteger)pptStep completionBlock:(ZegoWhiteboardScrollBlock)completionBlock;

/// 向白板设置背景图
///
/// @param imagePath 背景图片 URL 路径, 本地路径或者网络路径均可（网络图片仅支持 https）例："xxxxxxxxxx.png"，"https://xxxxxxxx.com/xxx.png"。
/// @param mode 背景图片填充模式
/// @param complete 背景图片设置完成回调
- (void)setBackgroundImageWithPath:(NSString *)imagePath mode:(ZegoWhiteboardViewImageFitMode)mode complete:(void(^)(int errorcode))complete;

/// 设置当前白板的操作模式，详情查看ZegoWhiteboardOperationMode
///
/// 调用时机：创建 或 获取 ZegoWhiteboardView 之后。
///
/// 此接口不能与 [enableUserOperation] 和 [canDraw] 同时使用(enableUserOperation 和 canDraw 接口已废弃)。
///
/// 用户可使用“按位或”的方式同时设置多种模式，比如设置为 ZegoWhiteboardOperationModeZoom | ZegoWhiteboardOperationModeDraw 时，可同时支持 放缩模式 和 绘制模式。
///
/// @param operationMode 详情查看ZegoWhiteboardOperationMode
- (void)setWhiteboardOperationMode:(ZegoWhiteboardOperationMode)operationMode;

/// 撤销上一步绘制
- (void)undo;

/// @deprecated use -[ZegoWhiteboardView addTextEditWithComplete:] instead
///
/// 给白板 View 添加文本
- (void)addTextEdit DEPRECATED_ATTRIBUTE;

/// @deprecated use -[ZegoWhiteboardView addText:positionX:positionY:complete:] instead
///
/// 向白板添加自定义文本
///
/// 在白板view中添加文本，会创建一个新的文本图元（不会弹出键盘输入框，会自适应缩放系数）
///
/// @param text 待添加文本图元的字符串内容
/// @param positionX 相对所在viewport的左上角的横向偏移，如10，此处的viewport是指可写区域
/// @param positionY 相对所在viewport的左上角的纵向偏移，如10，此处的viewport是指可写区域
- (void)addText:(NSString *)text positionX:(int)positionX positionY:(CGFloat)positionY DEPRECATED_ATTRIBUTE;

/// @deprecated use -[ZegoWhiteboardView clearWithComplete:] instead
///
/// 清除白板上的所有图元
- (void)clear DEPRECATED_ATTRIBUTE;

/// @deprecated use -[ZegoWhiteboardView clear:complete:] instead
///
/// 清空指定坐标范围内的所有图元
///
/// 调用时机：一般用于清除当前页
/// Note: 如果是要清除当前页，在纯白板模式，调用者自行算出当前白板页的坐标范围；在文件白板场景下，可通过ZegoDocsView SDK的接口获取当前页的坐标范围
///
/// @param rect 待清空的白板指定范围
- (void)clear:(CGRect)rect DEPRECATED_ATTRIBUTE;

/// @deprecated use -[ZegoWhiteboardView deleteSelectedGraphicsWithComplete:] instead
///
/// 删除已选图元
///
/// 调用时机: 该接口用于提供给用户进行自定义删除已选图元。比如，在选择tooltype类型下选择了多个图元后，想要在切到橡皮擦tooltype时，能删除已选图元，就可以使用本接口实现
- (void)deleteSelectedGraphics DEPRECATED_ATTRIBUTE;

@end

NS_ASSUME_NONNULL_END

//! Project version number for ZegoWhiteboardView.
FOUNDATION_EXPORT double ZegoWhiteboardViewVersionNumber;

//! Project version string for ZegoWhiteboardView.
FOUNDATION_EXPORT const unsigned char ZegoWhiteboardViewVersionString[];

// In this header, you should import all the public headers of your framework using statements like #import <ZegoWhiteboardView/PublicHeader.h>

#import <ZegoWhiteboardView/ZegoWhiteboardManager.h>
#import <ZegoWhiteboardView/ZegoWhiteboardDefine.h>
#import <ZegoWhiteboardView/ZegoWhiteboardView.h>
#import <ZegoWhiteboardView/ZegoWhiteboardViewModel.h>

