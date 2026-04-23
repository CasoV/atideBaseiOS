//
//  TLHomeViewModel.h
//  ZegoRoomkitDemo
//
//  Created by KaelDing on 2020/7/15.
//  Copyright © 2020 zego. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, TLArrangeType) {
    TLArrangeType1v1 = 3,
    TLArrangeTypeSmallClass = 1,
    TLArrangeTypeLargeClass = 5
};

@interface TLHomeViewModel : NSObject

#pragma mark - in info
@property (nonatomic, copy) NSString *quickJoinRoomID;
@property (nonatomic, copy) NSString *quickJoinName;
@property (nonatomic, assign) NSInteger userID;
@property (nonatomic, assign) BOOL progressHidden;

@property (nonatomic, copy) NSString *testLoginName;
@property (nonatomic, copy) NSString *testLoginId;

@property (nonatomic, assign) NSInteger roomType;
@property (nonatomic, assign) NSInteger role;
@property (nonatomic, assign) NSInteger env;

#pragma mark - out info
@property (nonatomic, strong) NSArray<ZegoRoomDetailInfo *> *meetings;
@property (nonatomic, copy) NSString *accessToken;
@property (nonatomic, copy) NSArray *arrangeData;

#pragma mark - public方法
/// 登录请求
- (void)login:(BOOL)isTestLogin
      showHUD:(BOOL)isShowhud
      success:(void(^) (void))susBlock
      failure:(void(^) (NSError *error))faiBlock;
      
/// 重新登录请求
- (void)reLogin:(void(^) (void))susBlock
        failure:(void(^) (ZegoRoomKitError error))faiBlock;

/// 创建会议请求
- (void)createMeetingWithData:(NSDictionary *)data
                      showHUD:(BOOL)isShowhud
                      success:(void(^) (NSString *message))susBlock
                      failure:(void(^) (NSError *error))faiBlock;
/// 删除会议请求
- (void)deleteMeeting:(ZegoRoomDetailInfo *)classInfo
              showHUD:(BOOL)isShowhud
              success:(void(^) (void))susBlock
              failure:(void(^) (NSError *error))faiBlock;
/// 加入会议请求
- (void)joinMeetingWithData:(NSDictionary *)data
                    showHUD:(BOOL)isShowhud
                    success:(void(^ _Nullable) (void))susBlock
                    failure:(void(^) (NSError *error))faiBlock;
/// 快速加入会议请求
- (void)quickJoinMeetingWithData:(NSDictionary *)data
                         showHUD:(BOOL)isShowhud
                         success:(void(^ _Nullable) (void))susBlock
                         failure:(void(^) (NSError *error))faiBlock;
/// 获取会议列表请求
- (void)getMeetingList:(BOOL)needScrollToBottom
               showHUD:(BOOL)isShowhud
               success:(void(^) (BOOL needScroll))susBlock
               failure:(void(^) (NSError *error))faiBlock;

//查询项目内的直播房间列表
- (void)getMeetingNoLoginList:(BOOL)needScrollToBottom
               showHUD:(BOOL)isShowhud
               success:(void(^) (BOOL needScroll))susBlock
                      failure:(void(^) (NSError *error))faiBlock;

/// 查询会议详情
- (void)queryMeeting:(NSDictionary *)data
             success:(void(^) (NSDictionary *dict))susBlock
             failure:(void(^) (NSError *error))faiBlock;

#pragma mark - Public

/// 获取随机的UserID
- (NSInteger)randomUserId;

- (void)refreshMeetingSettings;

@end

NS_ASSUME_NONNULL_END
