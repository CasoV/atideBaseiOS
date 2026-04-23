#import <UIKit/UIKit.h>
#import "ZegoWhiteboardDefine.h"

NS_ASSUME_NONNULL_BEGIN

/// 与白板关联的文件信息
///
/// 描述文件的数据结构
///
/// Note: 如果白板与文件转码配合使用，就必须设置此 Model 到 ZegoWhiteboardViewModel 中，从而实现同步文件信息
///
/// Note: 文件的页数、步数等信息依然是通过 ZegoWhiteboardViewModel 中的 horizontalScrollPercent、pptStep 来同步
///
@interface ZegoFileInfoModel : NSObject

/// 文件ID，此 ID 唯一
/// 重要提示: 文件转码成功后获取的 ID
@property (nonatomic, strong) NSString *fileID;

/// 文件名称
@property (nonatomic, strong) NSString *fileName;

/// 文件类型，参考 ZegoDocsView SDK 定义的文件类型
@property (nonatomic, assign) NSUInteger fileType;

/// 授权码
@property (nonatomic, strong) NSString *authKey;

@end

/// 白板信息
///
/// 描述白板的数据结构，用来初始化 ZegoWhiteboardView 以及同步相关信息到远端
/// Note:  pptStep 仅用在和文件转码 SDK 配合使用时同步 PPT 的动画步骤信息
/// 举例: 如果我们需要创建一个 16:9 的白板，并且宽度可以有 5 页，那么相关参数设置为：
/// ZegoWhiteboardViewModel model
/// model.aspectWidth = 16.0 * 5
/// model.aspectHeight = 9.0
/// model.pageCount = 5
/// model.name = "白板名字"
///
@interface ZegoWhiteboardViewModel : NSObject

/// 白板所在的房间 ID
@property (nonatomic, copy) NSString *roomID;

/// 白板的唯一标识符
@property (nonatomic, assign) ZegoWhiteboardID whiteboardID;

/// 白板名，限制长度为 128 字节，支持中英文
@property (nonatomic, copy) NSString *name;

/// 白板内容宽度系数，非绝对值，在不同端的不同尺寸 View 上保持宽高比一致
/// 重要提示: 此字段与 aspectHeight 配合使用，两者的比例决定内容宽高比
@property (nonatomic, assign) CGFloat aspectWidth;

/// 白板内容高，在不同端的不同尺寸 View 上保持宽高比一致
@property (nonatomic, assign) CGFloat aspectHeight;

//@property (nonatomic, assign) CGFloat aspectWidth_viewPortStub;
//@property (nonatomic, assign) CGFloat aspectHeight_viewPortStub;

/// 横向滚动百分比，取值范围 0~1.0，0 代表偏移量为零的位置，1 代表偏移到最大值
@property (nonatomic, assign) CGFloat horizontalScrollPercent;

/// 纵向滚动百分比，取值范围 0~1.0，0 代表偏移量为零的位置，1 代表偏移到最大值
/// 重要提示: 当与文件转码 SDK 配合使用时，可用此参数来同步文件页数、文件偏移量的信息
@property (nonatomic, assign) CGFloat verticalScrollPercent;

/// 动态 PPT 的动画步骤，以 1 为起始
/// 重要提示: 当与文件转码 SDK 配合使用时，可用此参数来同步动态 PPT 类型的文件动画步骤数
@property (nonatomic, assign) NSUInteger pptStep;

/// 白板总页数，SDK 不做任何处理，由调用方处理
@property (nonatomic, assign) NSUInteger pageCount;

/// 与白板关联的转码后的文件信息，通常白板是透明的，覆盖在文件内容之上，变成标注层
/// 详情可参考 ZegoFileInfoModel 描述
@property (nonatomic, strong) ZegoFileInfoModel *fileInfo;

/// 白板创建时间
/// Unix 时间戳(毫秒)
@property (nonatomic, assign) NSUInteger createTime;

/// PPT 动画信息，可用来同步动态 PPT 文件的动画播放信息
/// 重要提示: 当此属性有值时，ZegoDocsView 可以调用 playAnimation 接口，传入 h5_extra ，达到同步动画的效果
@property (nonatomic, copy) NSString *h5_extra;

//缩放因子
@property (nonatomic, assign) CGFloat scaleFactor;

//缩放横向偏移
@property (nonatomic, assign) CGFloat horizontalScalePercent;

//缩放纵向偏移
@property (nonatomic, assign) CGFloat verticalScalePercent;


@end

NS_ASSUME_NONNULL_END

