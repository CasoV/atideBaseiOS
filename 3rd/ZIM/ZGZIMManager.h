//
//  ZGRoomZIMManager.h
//  ZIMExampleLegacy
//
//  Created by Patrick Fu on 2021/7/5.
//  Copyright © 2021 Zego. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ZIM/ZIM.h>      
#import <ZIM/ZIMDefines.h>

NS_ASSUME_NONNULL_BEGIN
@class ZIMGroupOperatedInfo;
@protocol ZIMEventDelegate;
@protocol callBackLogDelegate;
@interface ZGZIMManager : NSObject

@property UITabBarController *myTabbar;

@property NSString *myUserID;

@property ZIMUserFullInfo *userFullInfo;

@property unsigned int myAppID;

@property NSString *mySecret;

@property NSString *targetCallID;

+ (ZGZIMManager *)shared;

// MARK: - Delegates

-(void)addZIMEventDelegate:(id<ZIMEventDelegate>)delegate;

-(void)removeZIMEventDelegate:(id<ZIMEventDelegate>)delegate;

// MARK: - Main
- (void)setLogConfig:(NSString*)logPath
             logSize:(int)logSize;


- (void)createZIM:(ZIMAppConfig *)config;

- (void)destroyZIM;

- (void)login:(ZIMUserInfo *)userInfo
        token:(NSString *)token
     callback:(ZIMLoggedInCallback)callback;

- (void)logout;

- (void)setEventHandler;

- (void)renewToken:(NSString *)token callback:(ZIMTokenRenewedCallback)callback;

- (void)uploadLog:(ZIMLogUploadedCallback)callback;

- (void)queryUsersInfo:(NSArray<NSString *> *)userIDs
                config:(ZIMUsersInfoQueryConfig *)config
              callback:(ZIMUsersInfoQueriedCallback)callback;

- (void)updateUserName:(NSString *)userName callback:(ZIMUserNameUpdatedCallback)callback;

- (void)updateUserExtendedData:(NSString *)userExtendedData
                      callback:(ZIMUserExtendedDataUpdatedCallback)callback;

- (void)updateUserAvatarUrl:(NSString *)userAvatarUrl
                   callback:(ZIMUserAvatarUrlUpdatedCallback)callback;
// MARK: - Message

- (void)sendMessage:(ZIMMessage *)message
    toConversationID:(NSString *)toConversationID
    conversationType:(ZIMConversationType)conversationType
              config:(ZIMMessageSendConfig *)config
        notification:(nullable ZIMMessageSendNotification *)notification
           callback:(ZIMMessageSentCallback)callback;

- (void)sendPeerMessage:(ZIMMessage *)message
               toUserID:(NSString *)toUserID
                 config:(ZIMMessageSendConfig *)config
               callback:(ZIMMessageSentCallback)callback;

- (void)sendGroupMesage:(ZIMMessage *)message
              toGroupID:(NSString *)toGroupID
                 config:(ZIMMessageSendConfig *)config
               callback:(ZIMMessageSentCallback)callback;

- (void)sendRoomMessage:(ZIMMessage *)message
               toRoomID:(NSString *)toRoomID
                 config:(ZIMMessageSendConfig *)config
               callback:(ZIMMessageSentCallback)callback;

- (void)queryHistoryMessage:(NSString *)conversationID
           conversationType:(ZIMConversationType)conversationType
                     config:(ZIMMessageQueryConfig *)config
                   callback:(ZIMMessageQueriedCallback)callback;

- (void)deleteMessageByConversationID:(NSString *)conversationID
                     conversationType:(ZIMConversationType)conversationType
                               config:(ZIMMessageDeleteConfig *)config
                             callback:(ZIMMessageDeletedCallback)callback;
- (void)deleteMessages:(NSArray<ZIMMessage *> *)messageList
        conversationID:(NSString *)conversationID
      conversationType:(ZIMConversationType)conversationType
                config:(ZIMMessageDeleteConfig *)config
              callback:(ZIMMessageDeletedCallback)callback;

- (void)sendMediaMessage:(ZIMMediaMessage *)message
        toConversationID:(NSString *)toConversationID
        conversationType:(ZIMConversationType)conversationType
                  config:(ZIMMessageSendConfig *)config
                progress:(ZIMMediaUploadingProgress)progress
                callback:(ZIMMessageSentCallback)callback;

- (void)downloadMediaFileWithMessage:(ZIMMediaMessage *)message
                            fileType:(ZIMMediaFileType)fileType
                            progress:(ZIMMediaDownloadingProgress)progress
                            callback:(ZIMMediaDownloadedCallback)callback;

- (void)sendMessageReceiptsRead:(NSArray<ZIMMessage *> *)messageList
                 conversationID:(NSString *)conversationID
               conversationType:(ZIMConversationType)conversationType
                       callback:(ZIMMessageReceiptsReadSentCallback)callback;

- (void)queryMessageReceiptsInfoByMessageList:(NSArray<ZIMMessage *> *)messageList
                               conversationID:(NSString *)conversationID
                             conversationType:(ZIMConversationType)conversationType
                                     callback:(ZIMMessageReceiptsInfoQueriedCallback)callback;
//MARK: - Conversation
- (void)queryConversationListWithConfig:(ZIMConversationQueryConfig *)config
                               callback:(ZIMConversationListQueriedCallback)callback;

- (void)deleteConversation:(NSString *)conversationID
                      type:(ZIMConversationType)type
                    config:(ZIMConversationDeleteConfig *)config
                  callback:(ZIMConversationDeletedCallback)callback;

- (void)clearConversationUnreadMessageCount:(NSString *)conversationID
                                       type:(ZIMConversationType)type
                                   callback:
                                       (ZIMConversationUnreadMessageCountClearedCallback)callback;

- (void)revokeMessage:(ZIMMessage *)message
               config:(ZIMMessageRevokeConfig *)config
             callback:(ZIMMessageRevokedCallback)callback;

- (void)sendConversationMessageReceiptRead:(NSString *)conversationID
                          conversationType:(ZIMConversationType)conversationType
                                  callback:(ZIMConversationMessageReceiptReadSentCallback)callback;
// MARK: - Room

- (void)createRoom:(ZIMRoomInfo *)roomInfo callback:(ZIMRoomCreatedCallback)callback;

- (void)createRoom:(ZIMRoomInfo *)roomInfo config:(ZIMRoomAdvancedConfig *)config callback:(ZIMRoomCreatedCallback)callback;

- (void)joinRoom:(NSString *)roomID callback:(ZIMRoomJoinedCallback)callback;

- (void)leaveRoom:(NSString *)roomID callback:(ZIMRoomLeftCallback)callback;
- (void)queryRoomMemberListByRoomID:(NSString *)roomID
                             config:(ZIMRoomMemberQueryConfig *)config
                           callback:(ZIMRoomMemberQueriedCallback)callback;

- (void)queryRoomOnlineMemberCount:(NSString *)roomID
                          callback:(ZIMRoomOnlineMemberCountQueriedCallback)callback;

- (void)setRoomAttributes:(NSDictionary<NSString *, NSString *> *)roomAttributes
                   roomID:(NSString *)roomID
                   config:(ZIMRoomAttributesSetConfig *)config
                 callback:(ZIMRoomAttributesOperatedCallback)callback;

- (void)deleteRoomAttributesByKeys:(NSArray<NSString *> *)keys
                            roomID:(NSString *)roomID
                            config:(ZIMRoomAttributesDeleteConfig *)config
                          callback:(ZIMRoomAttributesOperatedCallback)callback;

- (void)beginRoomAttributesBatchOperationWithRoomID:(NSString *)roomID
                                             config:(ZIMRoomAttributesBatchOperationConfig *)config;

- (void)endRoomAttributesBatchOperationWithRoomID:(NSString *)roomID
                                         callback:(ZIMRoomAttributesBatchOperatedCallback)callback;

- (void)queryRoomAllAttributesByRoomID:(NSString *)roomID
                              callback:(ZIMRoomAttributesQueriedCallback)callback;

//MARK: -呼叫邀请
- (void)callInviteWithInvitees:(NSArray<NSString *> *)invitees
                        config:(ZIMCallInviteConfig *)config
                      callback:(ZIMCallInvitationSentCallback)callback;

- (void)callCancelWithInvitees:(NSArray<NSString *> *)invitees
                        callID:(unsigned long long)callID
                        config:(ZIMCallCancelConfig *)config
                      callback:(ZIMCallCancelSentCallback)callback;

- (void)callAcceptWithCallID:(unsigned long long)callID
                      config:(ZIMCallAcceptConfig *)config
                    callback:(ZIMCallAcceptanceSentCallback)callback;

- (void)callRejectWithCallID:(unsigned long long)callID
                      config:(ZIMCallRejectConfig *)config
                    callback:(ZIMCallRejectionSentCallback)callback;
//MARK: - Group
- (void)createGroup:(ZIMGroupInfo *)groupInfo
           userIDs:(NSArray<NSString *> *)userIDs
           callback:(ZIMGroupCreatedCallback)callback;

- (void)createGroup:(ZIMGroupInfo *)groupInfo
           userIDs:(NSArray<NSString *> *)userIDs
             config:(ZIMGroupAdvancedConfig *)config
           callback:(ZIMGroupCreatedCallback)callback;

- (void)dismissGroup:(NSString *)groupID
            callback:(ZIMGroupDismissedCallback)callback;

- (void)joinGroup:(NSString *)groupID
         callback:(ZIMGroupJoinedCallback)callback;

- (void)leaveGroup:(NSString *)groupID
          callback:(ZIMGroupLeftCallback)callback;

- (void)inviteUsersIntoGroup:(NSArray<NSString *> *)userIDList
                     groupID:(NSString *)groupID
                    callback:(ZIMGroupUsersInvitedCallback)callback;

- (void)kickGroupMembers:(NSArray<NSString *> *)userIDs
                 groupID:(NSString *)groupID
                callback:(ZIMGroupMemberKickedCallback)callback;

- (void)transferGroupOwner:(NSString *)userID
                   groupID:(NSString *)groupID
                  callback:(ZIMGroupOwnerTransferredCallback)callback;

- (void)updateGroupName:(NSString *)userName
                groupID:(NSString *)groupID
               callback:(ZIMGroupNameUpdatedCallback)callback;

- (void)updateGroupNotice:(NSString *)userNotice
                  groupID:(NSString *)groupID
                 callback:(ZIMGroupNoticeUpdatedCallback)callback;

- (void)queryGroupInfo:(NSString *)groupID
                  callback:(ZIMGroupInfoQueriedCallback)callback;

- (void)setGroupAttributes:(NSDictionary<NSString *, NSString *> *)groupAttributes
                   groupID:(NSString *)groupID
                  callback:(ZIMGroupAttributesOperatedCallback)callback;

- (void)deleteGroupAttributes:(NSArray<NSString *> *)groupAttributesKeys
                      groupID:(NSString *)groupID
                     callback:(ZIMGroupAttributesOperatedCallback)callback;

- (void)queryGroupAttributes:(NSArray<NSString *> *)groupAttributesKeys
                     groupID:(NSString *)groupID
                    callback:(ZIMGroupAttributesQueriedCallback)callback;

- (void)queryGroupAllAttributes:(NSString *)groupID
                       callback:(ZIMGroupAttributesQueriedCallback)callback;

- (void)setGroupMemberRole:(int)role
                    userID:(NSString *)userID
                   groupID:(NSString *)groupID
                  callback:(ZIMGroupMemberRoleUpdatedCallback)callback;

- (void)setGroupMemberNickname:(NSString *)nickname
                        userID:(NSString *)userID
                       groupID:(NSString *)groupID
                      callback:(ZIMGroupMemberNicknameUpdatedCallback)callback;

- (void)queryGroupMemberInfo:(NSString *)userID
                         groupID:(NSString *)groupID
                        callback:(ZIMGroupMemberInfoQueriedCallback)callback;

- (void)queryGroupList:(ZIMGroupListQueriedCallback)callback;

- (void)queryGroupMemberListByGroupID:(NSString *)groupID
                               config:(ZIMGroupMemberQueryConfig *)config
                             callback:(ZIMGroupMemberListQueriedCallback)callback;

- (void)queryGroupMemberCountByGroupID:(NSString *)groupID
                              callback:(ZIMGroupMemberCountQueriedCallback)callback;

- (void)queryGroupMemberInfoByUserID:(NSString *)userID
                             groupID:(NSString *)groupID
                            callback:(ZIMGroupMemberInfoQueriedCallback)callback;

- (void)updateGroupAvatarUrl:(NSString *)groupAvatarUrl
                     groupID:(NSString *)groupID
                    callback:(ZIMGroupAvatarUrlUpdatedCallback)callback;

//MARK: -呼叫邀请
- (void)callInviteWithInvitees:(NSArray<NSString *> *)invitees
                        config:(ZIMCallInviteConfig *)config
                      callback:(ZIMCallInvitationSentCallback)callback;

-(void)callingInviteWithInvitees:(NSArray<NSString *> *)invitees
                          callID:(NSString *)callID
                          config:(ZIMCallingInviteConfig *)config
                        callback:(ZIMCallingInvitationSentCallback)callback;

- (void)callQuit:(NSString *)callID
          config:(ZIMCallQuitConfig *)config
        callback:(ZIMCallQuitSentCallback)callback;

- (void)callEnd:(NSString *)callID
         config:(ZIMCallEndConfig *)config
       callback:(ZIMCallEndSentCallback)callback;

- (void)queryCallInvitationListWithConfig:(ZIMCallInvitationQueryConfig *)config callback:(ZIMCallInvitationListQueriedCallback)callback;
@end


@protocol ZIMEventDelegate <NSObject>
@optional
- (void)connectionStateChanged:(ZIMConnectionState)state
                     event:(ZIMConnectionEvent)event
              extendedData:(NSDictionary *)extendedData;

- (void)errorInfo:(ZIMError *)errorInfo;

- (void)tokenWillExpire:(unsigned int)second;

- (void)conversationChanged:(NSArray<ZIMConversationChangeInfo *> *)conversationChangeInfoList;

- (void)conversationTotalUnreadMessageCountUpdated:(unsigned int)totalUnreadMessageCount;

- (void)zim:(ZIM *)zim conversationMessageReceiptChanged:(NSArray<ZIMMessageReceiptInfo *> *)infos;

- (void)receivePeerMessage:(NSArray<ZIMMessage *> *)messageList
            fromUserID:(NSString *)fromUserID;

- (void)receiveRoomMessage:(NSArray<ZIMMessage *> *)messageList
            fromRoomID:(NSString *)fromRoomID;

- (void)receiveGroupMessage:(NSArray<ZIMMessage *> *)messageList
            fromGroupID:(NSString *)fromGroupID;

- (void)messageRevokeReceived:(NSArray<ZIMRevokeMessage *> *)messageList;

- (void)zim:(ZIM *)zim messageReceiptChanged:(NSArray<ZIMMessageReceiptInfo *> *)infos;

- (void)zim:(ZIM *)zim messageDeleted:(ZIMMessageDeletedInfo *)deletedInfo;

- (void)zim:(ZIM *)zim broadcastMessageReceived:(ZIMMessage *)message;

- (void)roomMemberJoined:(NSArray<ZIMUserInfo *> *)memberList
              roomID:(NSString *)roomID;

- (void)roomMemberLeft:(NSArray<ZIMUserInfo *> *)memberList
            roomID:(NSString *)roomID;

- (void)roomStateChanged:(ZIMRoomState)state
               event:(ZIMRoomEvent)event
        extendedData:(NSDictionary *)extendedData
              roomID:(NSString *)roomID;

- (void)roomAttributesUpdated:(ZIMRoomAttributesUpdateInfo *)updateInfo
                   roomID:(NSString *)roomID;


- (void)roomAttributesBatchUpdated:(NSArray<ZIMRoomAttributesUpdateInfo *> *)updateInfo
                        roomID:(NSString *)roomID;

//- (void)zim:(ZIM *)zim
//    roomMemberAttributesUpdated:(NSArray<ZIMRoomMemberAttributesUpdateInfo *> *)infos
//                   operatedInfo:(ZIMRoomOperatedInfo *)operatedInfo
//                         roomID:(NSString *)roomID;

- (void)groupStateChanged:(ZIMGroupState)state
                event:(ZIMGroupEvent)event
         operatedInfo:(ZIMGroupOperatedInfo *)operatedInfo
            groupInfo:(ZIMGroupFullInfo *)groupInfo;

- (void)groupNameUpdated:(NSString *)groupName
        operatedInfo:(ZIMGroupOperatedInfo *)operatedInfo
             groupID:(NSString *)groupID;

- (void)groupNoticeUpdated:(NSString *)groupNotice
          operatedInfo:(ZIMGroupOperatedInfo *)operatedInfo
               groupID:(NSString *)groupID;

- (void)zim:(ZIM *)zim
    groupAvatarUrlUpdated:(NSString *)groupAvatarUrl
             operatedInfo:(ZIMGroupOperatedInfo *)operatedInfo
    groupID:(NSString *)groupID;

- (void)groupAttributesUpdated:(NSArray<ZIMGroupAttributesUpdateInfo *> *)updateInfo
              operatedInfo:(ZIMGroupOperatedInfo *)operatedInfo
                   groupID:(NSString *)groupID;

- (void)groupMemberStateChanged:(ZIMGroupMemberState)state
                      event:(ZIMGroupMemberEvent)event
                   userList:(NSArray<ZIMGroupMemberInfo *> *)userList
               operatedInfo:(ZIMGroupOperatedInfo *)operatedInfo
                    groupID:(NSString *)groupID;

- (void)groupMemberInfoUpdated:(NSArray<ZIMGroupMemberInfo *> *)userInfo
              operatedInfo:(ZIMGroupOperatedInfo *)operatedInfo
                   groupID:(NSString *)groupID;

- (void)zim:(ZIM *)zim
    callInvitationReceived:(ZIMCallInvitationReceivedInfo *)info
                    callID:(NSString *)callID;

- (void)zim:(ZIM *)zim
    callInvitationCancelled:(ZIMCallInvitationCancelledInfo *)info
                     callID:(NSString *)callID;

- (void)zim:(ZIM *)zim
    callInvitationAccepted:(ZIMCallInvitationAcceptedInfo *)info
                    callID:(NSString *)callID;

- (void)zim:(ZIM *)zim
    callInvitationRejected:(ZIMCallInvitationRejectedInfo *)info
                    callID:(NSString *)callID;

- (void)zim:(ZIM *)zim
    callInvitationEnded:(ZIMCallInvitationEndedInfo *)info
                 callID:(NSString *)callID;

- (void)zim:(ZIM *)zim callInvitationTimeout:(NSString *)callID;

- (void)zim:(ZIM *)zim
    callInviteesAnsweredTimeout:(NSArray<NSString *> *)invitees
                         callID:(NSString *)callID;

- (void)zim:(ZIM *)zim callUserStateChanged:(ZIMCallUserStateChangeInfo *)info callID:(nonnull NSString *)callID;

- (void)zim:(ZIM *)zim userInfoUpdated:(ZIMUserFullInfo *)info;

- (void)zim:(ZIM *)zim
    messageSentStatusChanged:
(NSArray<ZIMMessageSentStatusChangeInfo *> *)messageSentStatusChangeInfoList;
@end
NS_ASSUME_NONNULL_END
