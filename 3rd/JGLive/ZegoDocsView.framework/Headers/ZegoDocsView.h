#import <UIKit/UIKit.h>
#import "ZegoDocsViewConstants.h"
#import "ZegoDocsViewManager.h"
#import "ZegoDocsViewConfig.h"
#import "ZegoDocsViewPage.h"

NS_ASSUME_NONNULL_BEGIN

/// loadFile 方法的回调。
///
/// @param errorCode 回调错误码，0 表示执行成功，更多解释请查看 ZegoDocsViewError
typedef void(^ZegoDocsViewLoadFileBlock)(ZegoDocsViewError errorCode);

/// 视图内位置跳转事件回调。
///
/// @param isScrollSuccess 跳转是否成功，接口方法传入的页码或者偏移百分比超出范围时，该参数为 false。
typedef void(^ZegoDocsViewScrollCompleteBlock)(BOOL isScrollSuccess);

@protocol ZegoDocsViewDelegate <NSObject>

/// @param isScrollFinish 是否停止滚动
- (void)onScroll:(BOOL)isScrollFinish;

/// 用户步骤变化通知
- (void)onStepChange;

/// 文档展示异常错误通知，例如网络超时错误
///
/// @param errorCode 错误码
- (void)onError:(ZegoDocsViewError)errorCode;

/// 用户用手指点击播放动态 PPT 文件内的动画时产生的回调，仅对动态PPT有效
///
/// 通知时机：当用户通过主动点击的方式播放了动态PPT文件内的动画
///
/// 只有文件是带有动画效果的动态 PPT (ZegoDocsViewRenderTypeDynamicPPTH5) 时，此通知才有效
///
/// 如果用户通过调用接口的方式播放动画时，不会触发此通知
///
/// 如果开发者需要同步 A 端和 B 端的文件动画播放，可以这样实现:
/// 当 A 端用手指点击触发了动态 PPT 文件内的动画播放，会收到此通知，此时 A 端将 [animationInfo] 通过 Express SDK 或者其他通信渠道传送给 B 端；
/// B 端用户接收到该 [animationInfo] 时，调用 [playAnimation] 接口，将 [animationInfo] 传入，这样 B 端的文件动画就会和 A 端实现同步。
///
/// @param animationInfo 播放动画信息（带有元素 ID ）
- (void)onPlayAnimation:(NSString *)animationInfo;

/// 用户主动点击动态 PPT 文件时触发的步数改变通知
///
/// 通知时机：当用户通过主动点击的方式改变了动态PPT类型的文件的步数(step) 时。
///
/// 只有文件是带有步骤的动态 PPT (ZegoDocsViewRenderTypeDynamicPPTH5) 时，此通知才有效。
///
/// 如果用户通过调用 [nextStep]、[previousStep]、[flipPage] 等接口改变了动态PPT类型的文件的步数时，会通过 [onStepChange] 收到。
- (void)onStepChangeForClick;

@end

/// ZegoDocsView
///
@interface ZegoDocsView : UIView

/// 获取当前view对应的fileID，与loadFile传入的fileID一致
@property (nonatomic, copy, readonly) NSString *fileID;

/// 获取当前加载文档的类型，支持的文档类型列表详见 ZegoDocsViewConstants
@property (nonatomic, assign, readonly) ZegoDocsViewFileType fileType;

/// 获取当前屏幕中间位置所在页码，页码从1开始
@property (nonatomic, assign, readonly) NSInteger currentPage;

/// 获取当前文件的名称
@property (nonatomic, copy, readonly) NSString *fileName;

/// 获取当前动态PPT当前页的动画步骤，动画步骤从1开始
@property (nonatomic, assign, readonly) NSInteger currentStep;

/// 获取总页数
@property (nonatomic, assign, readonly) NSInteger pageCount;

/// 获取当前纵向偏移百分比，参数取值范围 0.00 ~ 1.00
@property (nonatomic, assign, readonly) CGFloat verticalPercent;

/// 获取当前文件显示的宽高
@property (nonatomic, assign, readonly) CGSize visibleSize;

/// 获取文档内容的宽高，根据当前设置的显示宽度得出的总高度
@property (nonatomic, assign, readonly) CGSize contentSize;

/// 获取Excel文件的sheet列表
@property (nonatomic, copy, readonly) NSArray <NSString *> *sheetNameList;

/// 关联白板的ID
@property (nonatomic, assign, readwrite) long associatedWhiteboardID;

/// view宽高预估值
@property (nonatomic, assign, readwrite) CGSize estimatedSize;

/// 代理
@property (nonatomic, weak, readwrite) id <ZegoDocsViewDelegate> delegate;

/// 跳转到文件的指定页面(page)
///
/// 前提条件: 调用 [loadFile] 成功加载文件之后。
///
/// 重要提示: 高频率调用该方法时，该方法会等待上个方法执行完成后再执行下一个（串行执行）。
///
/// @param page 跳转目标页，页码从1开始，取值范围：1 ~ 文件最大页数，超出此范围会导致跳转失败。
/// @param completionBlock 跳转完成回调，可以传空。
- (void)flipPage:(NSInteger)page completionBlock:(nullable ZegoDocsViewScrollCompleteBlock)completionBlock;

/// 跳转到文件的指定页面(page)和指定步骤(step)
///
/// 前提条件: 调用 [loadFile] 成功加载文件之后
///
/// 只有当文件是带有步骤的动态 PPT (ZegoDocsViewRenderTypeDynamicPPTH5) 时，此方法才有效。
///
/// 跳转成功时，不仅会在 completionBlock 收到回调，也会在 ZegoDocsViewDelegate 的 [onStepChange] 中收到通知
///
/// 重要提示: 高频率调用该方法时，该方法会等待上个方法执行完成后再执行下一个（串行执行）。
///
/// @param page 跳转目标页，页码从1开始，取值范围：1 ~ 文件最大页数，超出此范围会导致跳转失败。
/// @param step 跳转目标页的动画步骤数，步骤从1开始，取值范围：1 ~ 目标文件页内最大步数，超出此范围会导致跳转失败。
/// @param completionBlock 翻页完成回调，可以传空。
- (void)flipPage:(NSInteger)page step:(NSInteger)step completionBlock:(nullable ZegoDocsViewScrollCompleteBlock)completionBlock;

/// 获取文件当前页的信息
///
/// @return 文件当前页的信息
- (ZegoDocsViewPage *)getCurrentPageInfo;

/// 获取当前文件缩略图列表，仅支持 PDF ，PPT，动态 PPT 文件格式
/// 调用时机：loadFile 成功之后
///
/// @return 文件缩略图URL列表(NSArray<NSString *> *)
- (NSArray *)getThumbnailUrlList;

/// 加载并展示文件
///
/// 前提条件: 需要保证此时 ZegoDocsView 的宽高大于 0, 请在加载文件前提前设置 size。
/// 在成功加载文件后，ZegoDocsView 的相关属性会根据文件的具体内容自动更新 ，如 contentSize 等。
/// 用户只有在成功加载文件之后，才能调用对文件内容进行功能操作的接口，如 [flipPage]、[scrollTo]、[playAnimation] 等。
/// 成功加载文件后，当用户不需要展示文件时，可调用 [unloadFile] 将文件从视图中卸载。
///
/// @param fileID 目标文件的唯一 ID，在转换格式后得到该 ID，业务服务器需要建立文件 ID 与业务的联系，比如与一堂课联系，与某个人联系，与某个角色联系。
/// @param authKey 业务服务与 ZegoDocs 服务约定算法生成的文件共享鉴权 key。
///                如果用户未开启鉴权功能，authKey 可传 ""。如果开启了鉴权功能，当鉴权失败时，loadFile 也会失败。
/// @param completionBlock 加载文件成功或者失败的回调。
- (void)loadFileWithFileID:(NSString *)fileID authKey:(NSString *)authKey completionBlock:(ZegoDocsViewLoadFileBlock)completionBlock;

/// 跳转到 动态 PPT 的下一步
///
/// 前提条件: 调用 [loadFile] 成功加载文件之后
///
/// 只有当文件是带有步骤的动态 PPT (ZegoDocsViewRenderTypeDynamicPPTH5) 时，此方法才有效
///
/// 如果当前步骤已经是当前页的最后一步，此时调用此接口时，文件会跳转到下一页。
///
/// 跳转成功时，不仅会在 completionBlock 收到回调，也会在 ZegoDocsViewDelegate 的 [onStepChange] 中收到通知。
///
/// 重要提示: 高频率调用该方法时，该方法会等待上个方法执行完成后再执行下一个（串行执行）
///
/// @param completionBlock  跳转完成回调，可以传空
- (void)nextStepWithCompletionBlock:(nullable ZegoDocsViewScrollCompleteBlock)completionBlock;

/// 根据 [animationInfo] 具体信息播放文件中的相应动画，仅对带有动画效果的动态 PPT 有效。
///
/// 如果开发者需要同步 A 端和 B 端的文件动画播放，可以这样实现:
/// 当 A 端用手指点击触发了动态 PPT 文件内的动画播放，会收到 [onPlayAnimation] 通知，此时 A 端将收到的 [animationInfo] 通过 Express SDK 或者其他通信渠道传送给 B 端；
/// B 端用户接收到该 [animationInfo] 时，调用此接口，将 [animationInfo] 传入，这样 B 端的文件动画就会和 A 端实现同步。
///
/// 只有文件是带有动画效果的动态 PPT (ZegoDocsViewRenderTypeDynamicPPTH5) 时，此通知才有效。
///
/// @param animationInfo 动画的具体信息。如果文件里没有传入 [animationInfo] 对应的动画，那么此次调用没有效果。
- (void)playAnimation:(NSString *)animationInfo;

/// 获取 PPT 指定页码的备注
///
/// 调用时机：loadFile 成功之后
///
/// @param page 指定页码，页码从1开始
///
/// @return 该页备注，若没有备注，则返回 ""
- (NSString *)pptNotesOfPage:(NSInteger)page;

/// 跳转到 动态 PPT 的上一步
///
/// 前提条件: 调用 [loadFile] 成功加载文件之后
///
/// 只有当文件是带有步骤的动态 PPT (ZegoDocsViewRenderTypeDynamicPPTH5) 时，此方法才有效。
///
/// 如果当前步骤已经是当前页的第一步，此时调用此接口时，文件会跳转到上一页；如果当前是第一页的第一步，则此接口无效。
///
/// 跳转成功时，不仅会在 completionBlock 收到回调，也会在 ZegoDocsViewDelegate 的 [onStepChange] 中收到通知。
///
/// 重要提示: 高频率调用该方法时，该方法会等待上个方法执行完成后再执行下一个（串行执行）
///
/// @param completionBlock 跳转完成回调，可以传空
- (void)previousStepWithCompletionBlock:(nullable ZegoDocsViewScrollCompleteBlock)completionBlock;

/// 重新加载文件，例如横竖屏切换时调用
///
/// 调用时机：loadFile 成功之后
/// 重要提示：修改 DocsView 的 宽度或高度 之后请调用一下本方法
///
/// @param completionBlock 加载文件成功或者失败的回调
- (void)reloadFileWithCompletionBlock:(nullable ZegoDocsViewLoadFileBlock)completionBlock;

/// 同步区域，包括缩放、偏移、滑动范围等。应用场景：如与白板操作同步
///
/// 调用时机：loadFile 成功之后
/// 重要提示：如果需要与白板进行缩放联动，当白板缩放时应主动调用此接口使 DocView 同步缩放，具体实现请参考Demo（联系技术支持）
///
/// @param scaleFactor 缩放比例
/// @param scaleOffsetX 缩放偏移量X
/// @param scaleOffsetY 缩放偏移量Y
- (void)scaleDocsViewWithScaleFactor:(CGFloat)scaleFactor scaleOffsetX:(CGFloat)scaleOffsetX scaleOffsetY:(CGFloat)scaleOffsetY;

/// 将文件跳转到指定偏移位置(纵向偏移)
///
/// 前提条件: 调用 [loadFile] 成功加载文件之后。
///
/// @param verticalPercent 纵向偏移百分比，参数取值范围 0.00 ~ 1.00，例如要跳转到一半的位置，则传入参数为 0.50。
/// @param completionBlock 跳转完成回调，可以传空
- (void)scrollTo:(CGFloat)verticalPercent completionBlock:(nullable ZegoDocsViewScrollCompleteBlock)completionBlock;

/// 是否允许手动滑动
///
/// @param enable true：可以手动滑动；false ：不能手动滑动
- (void)setManualScrollEnable:(BOOL)enable;

/// 设置 ZegoDocsView 的操作权限
///
/// 该接口需要与 ZegoWhiteboardView SDK 的 [onWhiteboardAuthChange:] 回调方法配合使用。当收到 [onWhiteboardAuthChange:] 回调方法时，需要调用该方法使 ZegoDocsView 的权限与ZegoWhiteboardView 保持一致。
///
/// @param authInfo 权限设置信息。将 ZegoWhiteboardView SDK 的 [onWhiteboardAuthChange:] 参数的字典传入即可
- (void)setOperationAuth:(NSDictionary *)authInfo;

/// 设置是否支持缩放
///
/// 如放大后，调用该方法设置为 false 。此时处于放大状态，无法继续放大和缩小。再次设置 true ，可以继续放大和缩小
///
/// @param enable 支持缩放
- (void)setScaleEnable:(BOOL)enable;

/// 停止本端动态 PPT 文件某一页的音视频播放
///
/// 该接口的使用场景一般用于切换文件时，停止掉上个动态 PPT 文件的音视频播放
///
/// @param pageNumber 当为 0 时，表示停止当前页的音视频，否则，停止指定页的音视频。
- (void)stopPlay:(NSInteger)pageNumber;

/// 将 Excel 文件切换到指定sheet
///
/// 前提条件: 调用 [loadFile] 成功加载文件之后。
///
/// 只有当文件是 Excel类型的文件时时，此方法才有效。
///
/// @param sheetIndex sheet下标，从0开始
- (void)switchSheet:(int)sheetIndex;

/// 将文件从视图中卸载
///
/// 前提条件: 调用 [loadFile] 接口成功加载文件之后。
/// 当前 DocsView 已经调用过 [loadFile] 加载了文件，如果想要加载另外一个文件，建议先调用此接口卸载文件。
/// 如果开发者没有调用此接口释放文件句柄，那么调用 [clearCacheFolder] 清楚缓存时，无法清除对应文件的缓存。
- (void)unloadFile;

@end

NS_ASSUME_NONNULL_END

