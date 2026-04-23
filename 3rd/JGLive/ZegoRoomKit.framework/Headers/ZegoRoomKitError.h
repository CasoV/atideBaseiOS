NS_ASSUME_NONNULL_BEGIN

/// 错误码
///
typedef NS_ENUM(NSUInteger, ZegoRoomKitError) {

    /// 成功
    ZegoRoomKitSuccess = 0,

    /// 内部错误
    ZegoRoomKitErrorInternal = 4000001,

    /// 参数错误
    ZegoRoomKitErrorParamInvalid = 4000002,

    /// 网络错误
    ZegoRoomKitErrorNetworkError = 4000003,

    /// 网络超时
    ZegoRoomKitErrorNetworkTimeout = 4000004,

    /// 请求过于频繁
    ZegoRoomKitErrorRequestTooFrequent = 4000006,

    /// 无操作权限
    ZegoRoomKitErrorPermissionDenied = 4000007,

    /// 房间不存在
    ZegoRoomKitErrorNotExist = 4010001,

    /// 房间未开始
    ZegoRoomKitErrorNotStart = 4010002,

    /// 房间已删除
    ZegoRoomKitErrorDeleted = 4010003,

    /// 房间已结束
    ZegoRoomKitErrorEnded = 4010004,

    /// 无法修改房间，房间正在使用中
    ZegoRoomKitErrorInProgress = 4010005,

    /// 加入房间需要密码
    ZegoRoomKitErrorJoinNeedPassword = 4020001,

    /// 加入房间密码错误
    ZegoRoomKitErrorJoinWrongPassword = 4020002,

    /// 房间已锁定
    ZegoRoomKitErrorLocked = 4020003,

    /// 加入房间失败
    ZegoRoomKitErrorJoinRoomError = 4020004,
    
    /// 流加密密钥格式错误
    ZegoRoomKitErrorStreamEncryptKeyError = 4020005,
    
    /// 加入房间用户名错误, 用户名不超过40个字符
    ZegoRoomKitErrorNameError = 4020007,
    
    /// Token验证失败
    ZegoRoomKitErrorTokenError = 4000008,
    
    /// 房间成员已满
    ZegoRoomKitErrorMemberFull = 4020008,
    
    /// 房间助教已满
    ZegoRoomKitErrorAsssitantFull = 4020009,

};

NS_ASSUME_NONNULL_END

