#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/// 房间类型枚举
///
typedef NS_ENUM(NSUInteger, ZegoRoomType) {

    /// 普通房间
    ZegoRoomTypeNormal = 1,

    /// 1v1房间
    ZegoRoomType1V1 = 3,
    
    /// 大房间
    ZegoRoomTypeLargeRoom = 5,

};


/// 房间当前状态枚举
///
typedef NS_ENUM(NSUInteger, ZegoRoomState) {

    /// 房间状态未知
    ZegoRoomStateUnknown = 0,

    /// 房间未开始
    ZegoRoomStateNotStarted = 1,

    /// 房间进行中
    ZegoRoomStateInProgress = 2,

    /// 房间状态已结束
    ZegoRoomStateEnded = 3,

    /// 房间状态已取消
    ZegoRoomStateCanceled = 4

};


/// 房间成员对象
///
@interface ZegoRoomMember : NSObject

/// 成员 ID
@property (nonatomic, assign) long memberID;

/// 成员名称
@property (nonatomic, copy) NSString *memberName;

@end


/// 房间详细信息类
///
@interface ZegoRoomDetailInfo : NSObject

/// 房间类型
@property (nonatomic, assign) ZegoRoomType type;

/// 房间主题
@property (nonatomic, strong) NSString *subject;

/// 主持人
@property (nonatomic, strong) ZegoRoomMember *host;

/// 房间成员列表
@property (nonatomic, strong) NSArray<ZegoRoomMember *> *attendees;

/// 助理主持人列表
@property (nonatomic, strong) NSArray<ZegoRoomMember *> *assistants;

/// 房间最大加入人数
@property (nonatomic, assign) NSInteger maxAttendeeCount;

/// 产品ID，由Zego后台分配。
@property (nonatomic, assign) NSInteger productID;

/// 房间状态
@property (nonatomic, assign) ZegoRoomState state;

/// 房间唯一标识，删除/查询房间密码/查询房间详情等时用。安排房间成功后返回
@property (nonatomic, copy) NSString *roomID;

@end

NS_ASSUME_NONNULL_END

