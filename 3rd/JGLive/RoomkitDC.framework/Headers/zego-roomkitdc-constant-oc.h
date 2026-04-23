#pragma once

typedef unsigned int ZegoSeq;

#pragma mark - enum model

typedef enum ZegoRoomkitNetType
{
	kZegoNetTypeNone = 0,
	kZegoNetTypeLine = 1,
	kZegoNetTypeWifi = 2,
	kZegoNetType2G = 3,
	kZegoNetType3G = 4,
	kZegoNetType4G = 5,
	kZegoNetTypeUnknown = 32
} ZegoRoomkitNetType;

typedef enum ZegoUpdateSource
{
	kZegoUpdateSourceAuto = 1,
	kZegoUpdateSourceManual = 2
} ZegoUpdateSource;

typedef enum ZegoUpdateType
{
	kZegoUpdateTypeIncrement = 1,
	kZegoUpdateTypeTotal = 2
} ZegoUpdateType;

typedef enum ZegoRoomHistoryType
{
    kZegoRoomHistoryTypeInner = 1,
    kZegoRoomHistoryTypeGlobal = 2,

    kZegoRoomHistoryTypeAll = kZegoRoomHistoryTypeInner | kZegoRoomHistoryTypeGlobal
} ZegoRoomHistoryType;

// 搜索类型
typedef enum ZegoSearchStyle
{
    kZegoSearchStyleName        = 0x01,         //根据用户名搜索
    kZegoSearchStylePhone       = (0x01 << 1),  //根据手机号搜索
    kZegoSearchStyleEmail       = (0x01 << 2),  //根据邮箱搜索
    kZegoSearchStyleLetterAll   = (0x01 << 3),  //根据拼音全拼搜索
    kZegoSearchStyleLetterShort = (0x01 << 4),  //根据拼音缩写搜索

    kZegoSearchStyleAll =  (kZegoSearchStyleName  | kZegoSearchStylePhone |
                            kZegoSearchStyleEmail | kZegoSearchStyleLetterAll |
                            kZegoSearchStyleLetterShort) //全搜索
} ZegoSearchStyle;

// 成员在编辑会议时的选择状态
typedef enum ZegoUserSelectedStatus
{
    kZegoUserSelectedStatusYes = 1,             //被选中
    kZegoUserSelectedStatusNo = 2,              //未被选中
} ZegoUserSelectedStatus;

// 文档转换状态
typedef enum ZegoDocumentStatus
{
    kZegoDocumentStatusQueue = 1,               //排队中
    kZegoDocumentStatusConvert = 2,             //转换中
    kZegoDocumentStatusSuccess = 3,             //转换成功
    kZegoDocumentStatusFail = 4,                //转换失败
    kZegoDocumentStatusCancel = 5,              //取消转换
    kZegoDocumentStatusNoConvert = 6,           //不转换
} ZegoDocumentStatus;

// 用户绑定企业状态
typedef enum ZegoUserBindStatus
{
    kZegoUserBindStatusUnknown = 0,             //未知
    kZegoUserBindStatusNo = 1,                  //未绑定
    kZegoUserBindStatusRequest = 2,             //请求绑定中
    kZegoUserBindStatusYes = 4,                 //已绑定
    kZegoUserBindStatusReject = 8,              //绑定请求被拒绝
} ZegoUserBindStatus;

// 用户版本
typedef enum ZegoUserVersion
{
    kZegoUserVersionUnknown = 0,               //未知
    kZegoUserVersionBase = 1,                  //个人版
    kZegoUserVersionProfession = 2,            //专业版
    kZegoUserVersionEnterpriseTrial = 4,       //企业版试用版
    kZegoUserVersionLiveTrial = 5,             //直播试用
    kZegoUserVersionLive = 6,                  //直播正式
    kZegoUserVersionEnterprise = 8,            //企业版
} ZegoUserVersion;



// 用户服务模式
typedef enum ZegoUserServiceMode
{
    kZegoUserServiceModeUnknown = 0,            //未知
    kZegoUserServiceModePorts = 1,              //并发数模式
    kZegoUserServiceModeRoom = 2,               //云会议室模式
    kZegoUserServiceModeFree = 3,               //免费模式
} ZegoUserServiceMode;


// 用户绑定企业状态发生变更的类型
typedef enum ZegoUserBindType
{
    kZegoUserBindChangeTypeClient = 1,          //客户端
    kZegoUserBindChangeTypeServer = 2,          //服务端
} ZegoUserBindType;

// 用户反馈分类
typedef enum ZegoUserFeedbackCategory
{
    kZegoUserFeedbackCategoryeAll = 0,          //全部
    kZegoUserFeedbackCategoryAdvice = 1,        //功能建议
    kZegoUserFeedbackCategoryExperience = 2,    //产品体验
    kZegoUserFeedbackCategoryBug = 3,           //程序故障
    kZegoUserFeedbackCategoryOther = 4          //其他
} ZegoUserFeedbackCategory;

//云盘类型
typedef enum ZegoSharedFileType {
    kZegoSharedFileTypePersonal  = 1,           //个人云盘
    kZegoSharedFileTypeCompany   = 2,           //企业云盘
    kZegoSharedFileTypeTemporary = 3,          //临时云盘
    kZegoSharedFileTypeClass     = 4            //课堂云盘
}ZegoSharedFileType;

//云盘文件列表排序字段
typedef NS_ENUM(NSUInteger, ZegoSharedFileSortType) {
    kZegoSharedFileSortTypeTimestamp = 0,       //按创建时间排序
    kZegoSharedFileSortTypeFileName,            //按文件名称排序
    kZegoSharedFileSortTypeFileSize,            //按文件大小排序
};

//云盘文件列表排序顺序
typedef NS_ENUM(NSUInteger, ZegoSharedFileSortOrderType) {
    kZegoSharedFileSortOrderTypeAscend = 0,    //升序
    kZegoSharedFileSortOrderTypeDescend,       //降序
};

// 会议状态
typedef NS_ENUM(NSInteger, ZegoConferenceStatus) {
    ZegoConferenceStatusNotStarted = 1,        //未开始
    ZegoConferenceStatusStarted = 2,           //进行中
    ZegoConferenceStatusEnd = 4,               //结束
    ZegoConferenceStatusCancel = 8,            //取消
    ZegoConferenceStatusTimeOut = 100,         //主持人时长不够，房间已清空
};

// 客户端类型
typedef enum ZegoClientType
{
    kZegoClientTypeClientTalkline = 0,            //Talkline
    kZegoClientTypeClientSdk = 1,                 //Talkline sdk
}ZegoClientType;
