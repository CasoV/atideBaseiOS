#ifndef ZEGODOCSVIEWCONSTANTS_H 
#define ZEGODOCSVIEWCONSTANTS_H

typedef unsigned int ZegoSeq;

static NSString * _Nonnull REQUEST_SEQ = @"request_seq";        // 操作序列号
static NSString * _Nonnull UPLOAD_PERCENT = @"upload_percent";  // 上传进度
static NSString * _Nonnull UPLOAD_FILEID = @"upload_fileid";    // 格式转换后的文件ID
static NSString * _Nonnull CACHE_PERCENT = @"cache_percent";    // 下载进度

NS_ASSUME_NONNULL_BEGIN

/// ZegoDocsView 错误码
///
typedef NS_ENUM(NSUInteger, ZegoDocsViewError) {

    /// 执行成功
    ZegoDocsViewSuccess = 0,

    /// 内部错误
    ZegoDocsViewErrorInternal = 2000001,

    /// 参数错误
    ZegoDocsViewErrorParamInvalid = 2000002,

    /// 网络超时
    ZegoDocsViewErrorNetworkTimeout = 2000003,

    /// 文件不存在
    ZegoDocsViewErrorFileNotExist = 2010001,

    /// 上传失败
    ZegoDocsViewErrorUploadFailed = 2010002,

    /// 不支持渲染模式
    ZegoDocsViewErrorUnsupportRenderType = 2010003,

    /// 文件被加密
    ZegoDocsViewErrorFileEncrypt = 2020001,

    /// 文件内容过大
    ZegoDocsViewErrorFileSizeLimit = 2020002,

    /// 文件页数过多
    ZegoDocsViewErrorFileSheetLimit = 2020003,

    /// 格式转换失败
    ZegoDocsViewErrorConvertFail = 2020004,

    /// 格式转换被取消
    ZegoDocsViewErrorConvertCancel = 2020005,
    
    /// 源文件中存在不支持转码的元素
    ZegoDocsViewErrorConvertElementNotSupported = 2020008,
    
    /// 文件后缀名不匹配，不符合 ZEGO 定义的文件规范
    ZegoDocsViewErrorConvertFileTypeInvalid = 2020009,

    /// 认证参数错误
    ZegoDocsViewErrorAuthParamInvalid = 2030001,

    /// 路径权限不足
    ZegoDocsViewErrorFilePathNotAccess = 2030002,

    /// 初始化失败
    ZegoDocsViewErrorInitFailed = 2030003,

    /// 无法获取当前view宽高
    ZegoDocsViewErrorSizeInvalid = 2030004,

    /// 本地空间不足
    ZegoDocsViewErrorFreeSpaceLimit = 2030005,

    /// 不支持文件上传功能
    ZegoDocsViewErrorUploadNotSupported = 2030006,

    /// 正在上传相同文件
    ZegoDocsViewErrorUploadDuplicated = 2030007,

    /// 空域名
    ZegoDocsViewErrorEmptyDomain = 2030008,
        
    /// 文件内容为空
    ZegoDocsViewErrorFileContentEmpty = 2020006,

    /// 文件为只读模式。
    /// 1. 动态 PPT 文件被设置为只读模式，会导致转码失败。
    /// 2. 动态 PPT 文件中包含转码服务器不支持的字体，会导致转码失败。
    ZegoDocsViewErrorFileReadOnly = 2020007,

    /// 找不到对应的转码后文件
    ZegoDocsViewErrorServerFileNotExist = 2030010,
    
    /// 初始化时设置的日志目录无法创建或写入
    ZegoDocsViewErrorLogFolderNotAccess = 2030011 ,
    
    /// 初始化时设置的缓存目录无法创建或写入
    ZegoDocsViewErrorCacheFolderNotAccess = 2030012,
    
    /// 初始化时设置的数据目录无法创建或写入
    ZegoDocsViewErrorDataFolderNotAccess =  2030013,
    
    /// 不支持预加载该文件，请联系ZEGO技术支持
    ZegoDocsViewErrorCacheNotSupported = 2030014,
    
    /// 预加载失败
    ZegoDocsViewErrorCacheFailed = 2030015,
    
    /// 无效的 ZIP 文件，不是合法的 ZIP 文件或文件损坏了
    ZegoDocsViewErrorZipFileInvalid = 2030016,
    
    /// 无效的 H5 文件，不符合 ZEGO 定义的 H5 文件规范
    ZegoDocsViewErrorH5FileInvalid = 2030017,
    

};

/// 文件类型
///
typedef NS_ENUM(NSUInteger, ZegoDocsViewFileType) {

    /// 未知
    ZegoDocsViewFileTypeUnknown = 0,

    /// 静态演示文件（pptx、ppt）
    ZegoDocsViewFileTypePPT = 1,

    /// 文字文件（doc，docx）
    ZegoDocsViewFileTypeDOC = 2,

    /// 表格文件（xls，xlsx）
    ZegoDocsViewFileTypeELS = 4,

    /// PDF 文件
    ZegoDocsViewFileTypePDF = 8,

    /// 图片（jpg、jpeg、png、bmp)
    ZegoDocsViewFileTypeIMG = 16,

    /// TXT 文本文件
    ZegoDocsViewFileTypeTXT = 32,

    /// 动态演示文件（pptx、ppt）
    ZegoDocsViewFileTypeDynamicPPTH5 = 512,
    
    /// 自定义H5课件类型
    ZegoDocsViewFileTypeCustomH5 = 4096

};

/// 渲染模式类型
///
typedef NS_ENUM(NSUInteger, ZegoDocsViewRenderType) {

    /// Vector 向量模式，适用于文件共享 SDK PC 端、移动端做的文档智能转换，能够更换地支持文档浏览以及更清晰的缩放。
    ZegoDocsViewRenderTypeVector = 1,

    /// IMG 图片模式，适用于文件共享SDK Web端、小程序使用的文档转换，按文件样式每一页都生成图片样式。
    ZegoDocsViewRenderTypeIMG = 2,

    /// VectorAndIMG 向量和图片模式， 适用于当存在Web端、小程序、移动端、PC端，多端的并存情况，在web端、小程序将使用IMG图片模式， 而PC端、移动端将使用Vector向量模式。
    ZegoDocsViewRenderTypeVectorAndIMG = 3,

    /// DynamicPPTH5 动态ppt模式， 适用于文件共享SDK PC端、移动端、Web端、小程序使用的PPT文件转码格式， 会将PPT文件转成动态ppt的H5文件。
    ZegoDocsViewRenderTypeDynamicPPTH5 = 6,
    
    /// 自定义课件类型
    ZegoDocsViewRenderTypeCustomH5 = 7

};

/// 文件下载阶段
///
typedef NS_ENUM(NSUInteger, ZegoDocsViewCacheState) {

    /// 缓存中
    ZegoDocsViewCacheStateCaching = 1,

    /// 缓存结束
    ZegoDocsViewCacheStateCached = 2

};

/// 文件上传阶段
///
typedef NS_ENUM(NSUInteger, ZegoDocsViewUploadState) {

    /// 上传
    ZegoDocsViewUploadStateUpload = 1,

    /// 格式转换
    ZegoDocsViewUploadStateConvert = 2

};

NS_ASSUME_NONNULL_END

#endif /* ZegoDocsViewConstants.h */

