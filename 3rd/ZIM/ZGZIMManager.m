//
//  ZGRoomZIMManager.m
//  ZIMExampleLegacy
//
//  Created by Patrick Fu on 2021/7/5.
//  Copyright © 2021 Zego. All rights reserved.
//

#import "ZGZIMManager.h"
#import <ZIM/ZIMEventHandler.h>
#import "AppDelegate.h"
#import "LoginViewController.h"
#import "CallInviteView.h"
#import "KeyCenter.h"
#import "ZIMPluginConverter.h"
#import "UserBean.h"
#import <AudioToolbox/AudioToolbox.h>
static ZGZIMManager *_sharedManager = nil;

@interface ZGZIMManager () <ZIMEventHandler>


@property UITextField *tokenTextField;

@property (nonatomic, strong) NSLock *lock;

@property (nonatomic, strong) NSHashTable<id<ZIMEventDelegate>> *zimEventDelegates;
//全局变量
//SystemSoundID sound;
@end

@implementation ZGZIMManager


//开始播放的时候调用
-(void)startButton_cClickedAction{
    
    //震动的提示文件名放到资源目录下
//    NSString *path = [[NSBundle mainBundle] pathForResource:@"ring" ofType:@"wav"];
//    AudioServicesCreateSystemSoundID((__bridge CFURLRef)[NSURL fileURLWithPath:path], &sound);
    //分别注册铃声和震动完后的回调
    AudioServicesAddSystemSoundCompletion(kSystemSoundID_Vibrate, NULL, NULL, vibrationCompleteCallback, NULL);
//    AudioServicesAddSystemSoundCompletion(sound, NULL, NULL, soundCompleteCallback, NULL);
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);//开始震动
//    AudioServicesPlaySystemSound(sound);//开始播放铃声
}

//手动停止播放的时候调用
- (void)stopButton_cClickedAction {
    stopRingAndVibration();
}

//停止响铃和震动，移除回调并处理掉铃声和震动
void stopRingAndVibration() {
    
    AudioServicesRemoveSystemSoundCompletion(kSystemSoundID_Vibrate);
//    AudioServicesRemoveSystemSoundCompletion(sound);
    AudioServicesDisposeSystemSoundID(kSystemSoundID_Vibrate);
//    AudioServicesDisposeSystemSoundID(sound);
}
 
//震动完成回调，因为震动一下便会调用一次，这里延迟800ms再继续震动，和微信差不多，时间长短可自己控制。参数sound即为注册回调时传的第一个参数
void vibrationCompleteCallback(SystemSoundID sound,void * clientData) {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(800 * NSEC_PER_MSEC)), dispatch_get_global_queue(0, 0), ^{
        AudioServicesPlaySystemSound(sound);
    });
}

//铃声播放完成回调，这种方法播放的音频限制在30秒内，播放完直接响铃和震动
void soundCompleteCallback(SystemSoundID sound,void * clientData) {
    
    stopRingAndVibration();
}

+ (ZGZIMManager *)shared {
    if (!_sharedManager) {
        @synchronized (self) {
            if (!_sharedManager) {
                _sharedManager = [[self alloc] init];
                _sharedManager.lock = [[NSLock alloc] init];
                _sharedManager.zimEventDelegates = [NSHashTable weakObjectsHashTable];
            }
        }
    }
    return _sharedManager;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
    }
    return self;
}


-(void)addZIMEventDelegate:(id<ZIMEventDelegate>)delegate{
    [self.zimEventDelegates addObject:delegate];
}

-(void)removeZIMEventDelegate:(id<ZIMEventDelegate>)delegate{
    [self.zimEventDelegates removeObject:delegate];
}


//MARK: - MAIN
- (void)setLogConfig:(NSString*)logPath
             logSize:(int)logSize{
    ZIMLogConfig *zimLogConfig = [[ZIMLogConfig alloc]init];
    zimLogConfig.logPath = logPath;
    zimLogConfig.logSize = logSize;
    [ZIM setLogConfig:zimLogConfig];
}

- (void)createZIM:(ZIMAppConfig *)config{
    if([ZIM getInstance] != nil){
        [[ZIM getInstance] destroy];
    }
    [ZIM createWithAppConfig:config];
    [self setEventHandler];
}

- (void)setEventHandler{
    [[ZIM getInstance] setEventHandler:self];
}

- (void)destroyZIM {
    
    [[ZIM getInstance] destroy];
}


- (void)login:(ZIMUserInfo *)userInfo
        token:(NSString *)token
     callback:(ZIMLoggedInCallback)callback{
    [[ZIM getInstance] loginWithUserInfo:userInfo token:token callback:^(ZIMError * _Nonnull errorInfo) {
       
        callback(errorInfo);
    }];
  self.myUserID = userInfo.userID;
}


- (void)logout {
    [[ZIM getInstance] logout];
    
}

- (void)renewToken:(NSString *)token
          callback:(ZIMTokenRenewedCallback)callback{
    [[ZIM getInstance] renewToken:token callback:^(NSString * _Nonnull token, ZIMError * _Nonnull errorInfo) {
        
        callback(token,errorInfo);
    }];
    
}

- (void)uploadLog:(ZIMLogUploadedCallback)callback{
    [[ZIM getInstance] uploadLog:^(ZIMError * _Nonnull errorInfo) {
       callback(errorInfo);
    }];
    
}

- (void)queryUsersInfo:(NSArray<NSString *> *)userIDs
                config:(ZIMUsersInfoQueryConfig *)config
              callback:(ZIMUsersInfoQueriedCallback)callback{
    [[ZIM getInstance] queryUsersInfo:userIDs config:config callback:^(NSArray<ZIMUserFullInfo *> * _Nonnull userList, NSArray<ZIMErrorUserInfo *> * _Nonnull errorUserList, ZIMError * _Nonnull errorInfo) {
        
        callback(userList,errorUserList,errorInfo);
    }];
    
}

- (void)updateUserName:(NSString *)userName callback:(ZIMUserNameUpdatedCallback)callback{
    [[ZIM getInstance] updateUserName:userName callback:^(NSString * _Nonnull userName, ZIMError * _Nonnull errorInfo) {
       
        callback(userName,errorInfo);
    }];
   
}

- (void)updateUserExtendedData:(NSString *)userExtendedData
                      callback:(ZIMUserExtendedDataUpdatedCallback)callback{
    [[ZIM getInstance] updateUserExtendedData:userExtendedData callback:^(NSString * _Nonnull extendedData, ZIMError * _Nonnull errorInfo) {
      
        callback(extendedData,errorInfo);
    }];
   
}

- (void)updateUserAvatarUrl:(NSString *)userAvatarUrl
                   callback:(ZIMUserAvatarUrlUpdatedCallback)callback{
    [[ZIM getInstance] updateUserAvatarUrl:userAvatarUrl callback:^(NSString * _Nonnull userAvatarUrl, ZIMError * _Nonnull errorInfo) {
       
        callback(userAvatarUrl,errorInfo);
    }];
    
}
//MARK: - MESSAGE
- (void)sendPeerMessage:(ZIMMessage *)message
               toUserID:(NSString *)toUserID
                 config:(ZIMMessageSendConfig *)config
               callback:(ZIMMessageSentCallback)callback{
    
    [self sendMessage:message toConversationID:toUserID conversationType:ZIMConversationTypePeer config:config notification:nil callback:callback];
}

- (void)sendMessage:(ZIMMessage *)message
    toConversationID:(NSString *)toConversationID
    conversationType:(ZIMConversationType)conversationType
              config:(ZIMMessageSendConfig *)config
        notification:(nullable ZIMMessageSendNotification *)notification
           callback:(ZIMMessageSentCallback)callback{
    message.extendedData = @"510-extenedData";
    [[ZIM getInstance] sendMessage:message toConversationID:toConversationID conversationType:conversationType config:config notification:nil callback:^(ZIMMessage * _Nonnull message, ZIMError * _Nonnull errorInfo) {
       
        callback(message,errorInfo);
    }];

}


- (void)sendGroupMesage:(ZIMMessage *)message
              toGroupID:(NSString *)toGroupID
                 config:(ZIMMessageSendConfig *)config
               callback:(ZIMMessageSentCallback)callback{
    [self sendMessage:message toConversationID:toGroupID conversationType:ZIMConversationTypeGroup config:config notification:nil callback:callback];
}

- (void)sendRoomMessage:(ZIMMessage *)message
               toRoomID:(NSString *)toRoomID
                 config:(ZIMMessageSendConfig *)config
               callback:(ZIMMessageSentCallback)callback{
    [self sendMessage:message toConversationID:toRoomID conversationType:ZIMConversationTypeRoom config:config notification:nil callback:callback];
}

- (void)queryHistoryMessage:(NSString *)conversationID
           conversationType:(ZIMConversationType)conversationType
                     config:(ZIMMessageQueryConfig *)config
                   callback:(ZIMMessageQueriedCallback)callback{
    
    [[ZIM getInstance] queryHistoryMessageByConversationID:conversationID conversationType:conversationType config:config callback:^(NSString * _Nonnull conversationID, ZIMConversationType conversationType, NSArray<ZIMMessage *> * _Nonnull messageList, ZIMError * _Nonnull errorInfo) {
        
        for(ZIMMessage *message in messageList){
            
        }
        callback(conversationID,conversationType,messageList,errorInfo);
    }];
    
}

- (void)deleteMessageByConversationID:(NSString *)conversationID
                     conversationType:(ZIMConversationType)conversationType
                               config:(ZIMMessageDeleteConfig *)config
                             callback:(ZIMMessageDeletedCallback)callback{
    [[ZIM getInstance] deleteAllMessageByConversationID:conversationID conversationType:conversationType config:config callback:^(NSString * _Nonnull conversationID, ZIMConversationType conversationType, ZIMError * _Nonnull errorInfo) {
       
        callback(conversationID,conversationType,errorInfo);
    }];
   
}

- (void)deleteMessages:(NSArray<ZIMMessage *> *)messageList
        conversationID:(NSString *)conversationID
      conversationType:(ZIMConversationType)conversationType
                config:(ZIMMessageDeleteConfig *)config
              callback:(ZIMMessageDeletedCallback)callback{
    [[ZIM getInstance] deleteMessages:messageList conversationID:conversationID conversationType:conversationType config:config callback:^(NSString * _Nonnull conversationID, ZIMConversationType conversationType, ZIMError * _Nonnull errorInfo) {
       
        callback(conversationID,conversationType,errorInfo);
    }];
}


- (void)sendMediaMessage:(ZIMMediaMessage *)message
        toConversationID:(NSString *)toConversationID
        conversationType:(ZIMConversationType)conversationType
                  config:(ZIMMessageSendConfig *)config
                progress:(ZIMMediaUploadingProgress)progress
                callback:(ZIMMessageSentCallback)callback{
    message.extendedData = @"510-extenedData";
    ZIMMediaMessageSendNotification *notification = [[ZIMMediaMessageSendNotification alloc] init];
    notification.onMediaUploadingProgress = ^(ZIMMediaMessage * _Nonnull message, unsigned long long currentFileSize, unsigned long long totalFileSize) {
       
        progress(message,currentFileSize,totalFileSize);
    };
    [[ZIM getInstance] sendMediaMessage:message toConversationID:toConversationID conversationType:conversationType config:config notification:notification callback:^(ZIMMessage * _Nonnull message, ZIMError * _Nonnull errorInfo) {
        callback(message,errorInfo);
        if(message.type == ZIMMessageTypeImage){
            ZIMImageMessage *imageMsg = (ZIMImageMessage *)message;
          
        }else if (message.type == ZIMMessageTypeVideo){
            ZIMVideoMessage *videoMsg = (ZIMVideoMessage *)message;
           
        }
        else{
            
        }
    }];
   
}

- (void)downloadMediaFileWithMessage:(ZIMMediaMessage *)message
                            fileType:(ZIMMediaFileType)fileType
                            progress:(ZIMMediaDownloadingProgress)progress
                            callback:(ZIMMediaDownloadedCallback)callback{
    [[ZIM getInstance] downloadMediaFileWithMessage:message fileType:fileType progress:^(ZIMMediaMessage * _Nonnull message, unsigned long long currentFileSize, unsigned long long totalFileSize) {
        progress(message,currentFileSize,totalFileSize);
        
    } callback:^(ZIMMediaMessage * _Nonnull message, ZIMError * _Nonnull errorInfo) {
        callback(message,errorInfo);
        if(message.type == ZIMMessageTypeImage){
            ZIMImageMessage *imageMsg = (ZIMImageMessage *)message;
            
        }else if (message.type == ZIMMessageTypeVideo){
            ZIMVideoMessage *videoMsg = (ZIMVideoMessage *)message;
           
        }
        else{
          
        }
    }];
   
}

- (void)revokeMessage:(ZIMMessage *)message
               config:(ZIMMessageRevokeConfig *)config
             callback:(ZIMMessageRevokedCallback)callback{
    [[ZIM getInstance] revokeMessage:message config:config callback:^(ZIMMessage * _Nonnull message, ZIMError * _Nonnull errorInfo) {
        callback(message,errorInfo);
     }];
   
}

- (void)sendMessageReceiptsRead:(NSArray<ZIMMessage *> *)messageList
                 conversationID:(NSString *)conversationID
               conversationType:(ZIMConversationType)conversationType
                       callback:(ZIMMessageReceiptsReadSentCallback)callback{
    [[ZIM getInstance] sendMessageReceiptsRead:messageList conversationID:conversationID conversationType:conversationType callback:^(NSString * _Nonnull conversationID, ZIMConversationType conversationType, NSArray<NSNumber *> * _Nonnull errorMessageIDs, ZIMError * _Nonnull errorInfo) {
       callback(conversationID,conversationType,errorMessageIDs,errorInfo);
    }];
    
}

- (void)queryMessageReceiptsInfoByMessageList:(NSArray<ZIMMessage *> *)messageList
                               conversationID:(NSString *)conversationID
                             conversationType:(ZIMConversationType)conversationType
                                     callback:(ZIMMessageReceiptsInfoQueriedCallback)callback{
    [[ZIM getInstance] queryMessageReceiptsInfoByMessageList:messageList conversationID:conversationID conversationType:conversationType callback:^(NSArray<ZIMMessageReceiptInfo *> * _Nonnull infos, NSArray<NSString *> * _Nonnull errorMessageIDs, ZIMError * _Nonnull errorInfo) {
         for (ZIMMessageReceiptInfo *info in infos) {
           
        }
        callback(infos,errorMessageIDs,errorInfo);
    }];
    
}
//MARK: - Conversation
- (void)queryConversationListWithConfig:(ZIMConversationQueryConfig *)config
                               callback:(ZIMConversationListQueriedCallback)callback{
    [[ZIM getInstance] queryConversationListWithConfig:config callback:^(NSArray<ZIMConversation *> * _Nonnull conversationList, ZIMError * _Nonnull errorInfo) {
        callback(conversationList,errorInfo);
        
    }];
   
}

- (void)deleteConversation:(NSString *)conversationID
                      type:(ZIMConversationType)type
                    config:(ZIMConversationDeleteConfig *)config
                  callback:(ZIMConversationDeletedCallback)callback{
    [[ZIM getInstance] deleteConversation:conversationID conversationType:type config:config callback:^(NSString * _Nonnull conversationID, ZIMConversationType conversationType, ZIMError * _Nonnull errorInfo) {
        callback(conversationID,conversationType,errorInfo);
        
    }];
    
}

- (void)clearConversationUnreadMessageCount:(NSString *)conversationID
                                       type:(ZIMConversationType)type
                                   callback:
(ZIMConversationUnreadMessageCountClearedCallback)callback{
    [[ZIM getInstance] clearConversationUnreadMessageCount:conversationID conversationType:type callback:^(NSString * _Nonnull conversationID, ZIMConversationType conversationType, ZIMError * _Nonnull errorInfo) {
       
        callback(conversationID,conversationType,errorInfo);
    }];
    
}

- (void)sendConversationMessageReceiptRead:(NSString *)conversationID
                          conversationType:(ZIMConversationType)conversationType
                                  callback:(ZIMConversationMessageReceiptReadSentCallback)callback{
    [[ZIM getInstance] sendConversationMessageReceiptRead:conversationID conversationType:conversationType callback:^(NSString * _Nonnull conversationID, ZIMConversationType conversationType, ZIMError * _Nonnull errorInfo) {
        
    }];
   
}
//MARK: - ROOM
- (void)createRoom:(ZIMRoomInfo *)roomInfo callback:(ZIMRoomCreatedCallback)callback {
    
    [[ZIM getInstance] createRoom:roomInfo callback:^(ZIMRoomFullInfo * _Nonnull roomInfo, ZIMError * _Nonnull errorInfo) {
        
        callback(roomInfo,errorInfo);
    }];
   
}

- (void)createRoom:(ZIMRoomInfo *)roomInfo config:(ZIMRoomAdvancedConfig *)config callback:(ZIMRoomCreatedCallback)callback {
    [[ZIM getInstance] createRoom:roomInfo config:config callback:^(ZIMRoomFullInfo * _Nonnull roomInfo, ZIMError * _Nonnull errorInfo) {
        callback(roomInfo,errorInfo);
       
    }];
    
}

- (void)joinRoom:(NSString *)roomID callback:(ZIMRoomJoinedCallback)callback {
    
    [[ZIM getInstance] joinRoom:roomID callback:^(ZIMRoomFullInfo * _Nonnull roomInfo, ZIMError * _Nonnull errorInfo) {
        callback(roomInfo,errorInfo);
       
    }];
    
}

- (void)leaveRoom:(NSString *)roomID callback:(ZIMRoomLeftCallback)callback {
    [[ZIM getInstance] leaveRoom:roomID callback:^(NSString * _Nonnull roomID, ZIMError * _Nonnull errorInfo) {
      
    }];
   
}

- (void)queryRoomMemberListByRoomID:(NSString *)roomID
                             config:(ZIMRoomMemberQueryConfig *)config
                           callback:(ZIMRoomMemberQueriedCallback)callback{
    [[ZIM getInstance] queryRoomMemberListByRoomID:roomID config:config callback:^(NSString * _Nonnull roomID, NSArray<ZIMUserInfo *> * _Nonnull memberList, NSString * _Nonnull nextFlag, ZIMError * _Nonnull errorInfo) {
        
    }];
}

- (void)queryRoomOnlineMemberCount:(NSString *)roomID
                          callback:(ZIMRoomOnlineMemberCountQueriedCallback)callback {
    [[ZIM getInstance] queryRoomOnlineMemberCountByRoomID:roomID callback:^(NSString * _Nonnull roomID, unsigned int count, ZIMError * _Nonnull errorInfo) {
       
        callback(roomID,count,errorInfo);
    }];
    
}

- (void)setRoomAttributes:(NSDictionary<NSString *, NSString *> *)roomAttributes
                   roomID:(NSString *)roomID
                   config:(ZIMRoomAttributesSetConfig *)config
                 callback:(ZIMRoomAttributesOperatedCallback)callback {
    [[ZIM getInstance] setRoomAttributes:roomAttributes roomID:roomID config:config callback:^(NSString * _Nonnull roomID, NSArray<NSString *> * _Nonnull errorKeys, ZIMError * _Nonnull errorInfo) {
        callback(roomID,errorKeys,errorInfo);
        
    }];
    
}

- (void)deleteRoomAttributesByKeys:(NSArray<NSString *> *)keys
                            roomID:(NSString *)roomID
                            config:(ZIMRoomAttributesDeleteConfig *)config
                          callback:(ZIMRoomAttributesOperatedCallback)callback {
    [[ZIM getInstance] deleteRoomAttributesByKeys:keys roomID:roomID config:config callback:^(NSString * _Nonnull roomID, NSArray<NSString *> * _Nonnull errorKeys, ZIMError * _Nonnull errorInfo) {
       
    }];
   
}

- (void)beginRoomAttributesBatchOperationWithRoomID:(NSString *)roomID
                                             config:(ZIMRoomAttributesBatchOperationConfig *)config {
    [[ZIM getInstance] beginRoomAttributesBatchOperationWithRoomID:roomID config:config];
    
}

- (void)endRoomAttributesBatchOperationWithRoomID:(NSString *)roomID
                                         callback:(ZIMRoomAttributesBatchOperatedCallback)callback {
    [[ZIM getInstance] endRoomAttributesBatchOperationWithRoomID:roomID callback:^(NSString * _Nonnull roomID, ZIMError * _Nonnull errorInfo) {
        callback(roomID,errorInfo);
        
    }];
    
}

- (void)queryRoomAllAttributesByRoomID:(NSString *)roomID
                              callback:(ZIMRoomAttributesQueriedCallback)callback {
    [[ZIM getInstance] queryRoomAllAttributesByRoomID:roomID callback:^(NSString * _Nonnull roomID, NSDictionary<NSString *,NSString *> * _Nonnull roomAttributes, ZIMError * _Nonnull errorInfo) {
        callback(roomID,roomAttributes,errorInfo);
        
    }];
   
}
//MARK: - Group
- (void)createGroup:(ZIMGroupInfo *)groupInfo
           userIDs:(NSArray<NSString *> *)userIDs
           callback:(ZIMGroupCreatedCallback)callback{
    [[ZIM getInstance] createGroup:groupInfo userIDs:userIDs callback:^(ZIMGroupFullInfo * _Nonnull groupInfo, NSArray<ZIMGroupMemberInfo *> * _Nonnull userList, NSArray<ZIMErrorUserInfo *> * _Nonnull errorUserList, ZIMError * _Nonnull errorInfo) {
        callback(groupInfo,userList,errorUserList,errorInfo);
       
    }];
   
}

- (void)createGroup:(ZIMGroupInfo *)groupInfo
           userIDs:(NSArray<NSString *> *)userIDs
             config:(ZIMGroupAdvancedConfig *)config
           callback:(ZIMGroupCreatedCallback)callback{
    [[ZIM getInstance] createGroup:groupInfo userIDs:userIDs config:config callback:^(ZIMGroupFullInfo * _Nonnull groupInfo, NSArray<ZIMGroupMemberInfo *> * _Nonnull userList, NSArray<ZIMErrorUserInfo *> * _Nonnull errorUserList, ZIMError * _Nonnull errorInfo) {
        callback(groupInfo,userList,errorUserList,errorInfo);
       
    }];
  
}

- (void)dismissGroup:(NSString *)groupID
            callback:(ZIMGroupDismissedCallback)callback{
    [[ZIM getInstance] dismissGroup:groupID callback:^(NSString * _Nonnull groupID, ZIMError * _Nonnull errorInfo) {
        callback(groupID,errorInfo);
        
    }];
}
- (void)joinGroup:(NSString *)groupID
         callback:(ZIMGroupJoinedCallback)callback{
    [[ZIM getInstance] joinGroup:groupID callback:^(ZIMGroupFullInfo * _Nonnull groupInfo, ZIMError * _Nonnull errorInfo) {
        callback(groupInfo,errorInfo);
      
    }];
   
}

- (void)leaveGroup:(NSString *)groupID
          callback:(ZIMGroupLeftCallback)callback{
    [[ZIM getInstance] leaveGroup:groupID callback:^(NSString * _Nonnull groupID, ZIMError * _Nonnull errorInfo) {
        callback(groupID,errorInfo);
        
    }];
  
}

- (void)inviteUsersIntoGroup:(NSArray<NSString *> *)userIDList
                     groupID:(NSString *)groupID
                    callback:(ZIMGroupUsersInvitedCallback)callback{
    [[ZIM getInstance] inviteUsersIntoGroup:userIDList groupID:groupID callback:^(NSString * _Nonnull groupID, NSArray<ZIMGroupMemberInfo *> * _Nonnull userList, NSArray<ZIMErrorUserInfo *> * _Nonnull errorUserList, ZIMError * _Nonnull errorInfo) {
        callback(groupID,userList,errorUserList,errorInfo);
       
    }];
    
}


- (void)kickGroupMembers:(NSArray<NSString *> *)userIDs
                 groupID:(NSString *)groupID
                callback:(ZIMGroupMemberKickedCallback)callback{
    [[ZIM getInstance] kickGroupMembers:userIDs groupID:groupID callback:^(NSString * _Nonnull groupID, NSArray<NSString *> * _Nonnull kickedUserIDList, NSArray<ZIMErrorUserInfo *> * _Nonnull errorUserList, ZIMError * _Nonnull errorInfo) {
        callback(groupID,kickedUserIDList,errorUserList,errorInfo);
       
    }];
    
}


- (void)transferGroupOwner:(NSString *)userID
                   groupID:(NSString *)groupID
                  callback:(ZIMGroupOwnerTransferredCallback)callback{
    [[ZIM getInstance] transferGroupOwnerToUserID:userID groupID:groupID callback:^(NSString * _Nonnull groupID, NSString * _Nonnull toUserID, ZIMError * _Nonnull errorInfo) {
        callback(groupID,toUserID,errorInfo);
       
    }];
    
}

- (void)updateGroupName:(NSString *)userName
                groupID:(NSString *)groupID
               callback:(ZIMGroupNameUpdatedCallback)callback{
    
    [[ZIM getInstance] updateGroupName:userName groupID:groupID callback:^(NSString * _Nonnull groupID, NSString * _Nonnull groupName, ZIMError * _Nonnull errorInfo) {
       
        callback(groupID,groupName,errorInfo);
    }];
    
}

- (void)updateGroupNotice:(NSString *)userNotice
                  groupID:(NSString *)groupID
                 callback:(ZIMGroupNoticeUpdatedCallback)callback{
    [[ZIM getInstance] updateGroupNotice:userNotice groupID:groupID callback:^(NSString * _Nonnull groupID, NSString * _Nonnull groupNotice, ZIMError * _Nonnull errorInfo) {
        callback(groupID,groupNotice,errorInfo);
        
    }];
    
}

- (void)queryGroupInfo:(NSString *)groupID
              callback:(ZIMGroupInfoQueriedCallback)callback{
    [[ZIM getInstance] queryGroupInfoByGroupID:groupID callback:^(ZIMGroupFullInfo * _Nonnull groupInfo, ZIMError * _Nonnull errorInfo) {
        callback(groupInfo,errorInfo);
       
    }];
   
}

- (void)setGroupAttributes:(NSDictionary<NSString *, NSString *> *)groupAttributes
                   groupID:(NSString *)groupID
                  callback:(ZIMGroupAttributesOperatedCallback)callback{
    [[ZIM getInstance] setGroupAttributes:groupAttributes groupID:groupID callback:^(NSString * _Nonnull groupID, NSArray<NSString *> * _Nonnull errorKeys, ZIMError * _Nonnull errorInfo) {
        callback(groupID,errorKeys,errorInfo);
        
    }];
   
}

- (void)deleteGroupAttributes:(NSArray<NSString *> *)groupAttributesKeys
                      groupID:(NSString *)groupID
                     callback:(ZIMGroupAttributesOperatedCallback)callback{
    [[ZIM getInstance] deleteGroupAttributesByKeys:groupAttributesKeys groupID:groupID callback:^(NSString * _Nonnull groupID, NSArray<NSString *> * _Nonnull errorKeys, ZIMError * _Nonnull errorInfo) {
        callback(groupID,errorKeys,errorInfo);
        
    }];
    
}

- (void)queryGroupAttributes:(NSArray<NSString *> *)groupAttributesKeys
                     groupID:(NSString *)groupID
                    callback:(ZIMGroupAttributesQueriedCallback)callback{
    [[ZIM getInstance] queryGroupAttributesByKeys:groupAttributesKeys groupID:groupID callback:^(NSString * _Nonnull groupID, NSDictionary<NSString *,NSString *> * _Nonnull groupAttributes, ZIMError * _Nonnull errorInfo) {
        callback(groupID,groupAttributes,errorInfo);
        
    }];
    
}

- (void)queryGroupAllAttributes:(NSString *)groupID
                       callback:(ZIMGroupAttributesQueriedCallback)callback{
    [[ZIM getInstance] queryGroupAllAttributesByGroupID:groupID callback:^(NSString * _Nonnull groupID, NSDictionary<NSString *,NSString *> * _Nonnull groupAttributes, ZIMError * _Nonnull errorInfo) {
        callback(groupID,groupAttributes,errorInfo);
        
    }];
    
}

- (void)setGroupMemberRole:(int)role
                    userID:(NSString *)userID
                   groupID:(NSString *)groupID
                  callback:(ZIMGroupMemberRoleUpdatedCallback)callback{
    [[ZIM getInstance] setGroupMemberRole:role forUserID:userID groupID:groupID callback:^(NSString * _Nonnull groupID, NSString * _Nonnull forUserID, ZIMGroupMemberRole role, ZIMError * _Nonnull errorInfo) {
        callback(groupID,forUserID,role,errorInfo);
        
    }];
    
}


- (void)setGroupMemberNickname:(NSString *)nickname
                        userID:(NSString *)userID
                       groupID:(NSString *)groupID
                      callback:(ZIMGroupMemberNicknameUpdatedCallback)callback{
    [[ZIM getInstance] setGroupMemberNickname:nickname forUserID:userID groupID:groupID callback:^(NSString * _Nonnull groupID, NSString * _Nonnull forUserID, NSString * _Nonnull nickname, ZIMError * _Nonnull errorInfo) {
        callback(groupID,forUserID,nickname,errorInfo);
        
    }];
    
}

- (void)queryGroupMemberInfo:(NSString *)userID
                         groupID:(NSString *)groupID
                    callback:(ZIMGroupMemberInfoQueriedCallback)callback{
    [[ZIM getInstance] queryGroupMemberInfoByUserID:userID groupID:groupID callback:^(NSString * _Nonnull groupID, ZIMGroupMemberInfo * _Nonnull userInfo, ZIMError * _Nonnull errorInfo) {
        callback(groupID,userInfo,errorInfo);
        
    }];
    
}

- (void)queryGroupList:(ZIMGroupListQueriedCallback)callback{

    [[ZIM getInstance] queryGroupList:^(NSArray<ZIMGroup *> * _Nonnull groupList, ZIMError * _Nonnull errorInfo) {
        callback(groupList,errorInfo);
        
    }];
    
}

- (void)queryGroupMemberListByGroupID:(NSString *)groupID
                               config:(ZIMGroupMemberQueryConfig *)config
                             callback:(ZIMGroupMemberListQueriedCallback)callback{
    [[ZIM getInstance] queryGroupMemberListByGroupID:groupID config:config callback:^(NSString * _Nonnull groupID, NSArray<ZIMGroupMemberInfo *> * _Nonnull userList, unsigned int nextFlag, ZIMError * _Nonnull errorInfo) {
        callback(groupID,userList,nextFlag,errorInfo);
        
    }];
    
}


- (void)queryGroupMemberCountByGroupID:(NSString *)groupID
                               callback:(ZIMGroupMemberCountQueriedCallback)callback{
    [[ZIM getInstance] queryGroupMemberCountByGroupID:groupID callback:^(NSString * _Nonnull groupID, unsigned int count, ZIMError * _Nonnull errorInfo) {
        
    }];
    
}

- (void)queryGroupMemberInfoByUserID:(NSString *)userID
                             groupID:(NSString *)groupID
                            callback:(ZIMGroupMemberInfoQueriedCallback)callback{
    [[ZIM getInstance] queryGroupMemberInfoByUserID:userID groupID:groupID callback:^(NSString * _Nonnull groupID, ZIMGroupMemberInfo * _Nonnull userInfo, ZIMError * _Nonnull errorInfo) {
        callback(groupID,userInfo,errorInfo);
        
    }];
    
}

- (void)updateGroupAvatarUrl:(NSString *)groupAvatarUrl
                     groupID:(NSString *)groupID
                    callback:(ZIMGroupAvatarUrlUpdatedCallback)callback{
    [[ZIM getInstance] updateGroupAvatarUrl:groupAvatarUrl groupID:groupID callback:^(NSString * _Nonnull groupID, NSString * _Nonnull groupAvatarUrl, ZIMError * _Nonnull errorInfo) {
        callback(groupID,groupAvatarUrl,errorInfo);
       
    }];
   
}
// MARK: - 呼叫邀请
- (void)callInviteWithInvitees:(NSArray<NSString *> *)invitees
                        config:(ZIMCallInviteConfig *)config
                      callback:(ZIMCallInvitationSentCallback)callback{
    ZIMPushConfig *pushConfig = [[ZIMPushConfig alloc] init];
    pushConfig.title =@"管理员";
    pushConfig.content = @"邀请你发起直播";
    pushConfig.resourcesID = KeyCenter.resourceID;
    pushConfig.payload = @"payload";
    
    
    config.pushConfig = pushConfig;
    [[ZIM getInstance] callInviteWithInvitees:invitees config:config callback:^(NSString * _Nonnull callID, ZIMCallInvitationSentInfo * _Nonnull info, ZIMError * _Nonnull errorInfo) {
        callback(callID,info,errorInfo);
        
    }];
   
}

-(void)callingInviteWithInvitees:(NSArray<NSString *> *)invitees
                          callID:(NSString *)callID
                          config:(ZIMCallingInviteConfig *)config
                        callback:(ZIMCallingInvitationSentCallback)callback{
    ZIMPushConfig *pushConfig = [[ZIMPushConfig alloc] init];
    pushConfig.title =@"title";
    pushConfig.content = @"calling";
    pushConfig.payload = @"payload";
    pushConfig.resourcesID = KeyCenter.resourceID;
    config.pushConfig = pushConfig;
    [[ZIM getInstance] callingInviteWithInvitees:invitees callID:callID config:config callback:^(NSString * _Nonnull callID, ZIMCallingInvitationSentInfo * _Nonnull info, ZIMError * _Nonnull errorInfo) {
        callback(callID,info,errorInfo);
        
    }];
   
    
}

- (void)callCancelWithInvitees:(NSArray<NSString *> *)invitees
                        callID:(NSString *)callID
                        config:(ZIMCallCancelConfig *)config
                      callback:(ZIMCallCancelSentCallback)callback{
    config.extendedData = @"cancelPayload";
    ZIMPushConfig *pushConfig = [[ZIMPushConfig alloc] init];
    pushConfig.title =@"title";
    pushConfig.content = @"cancel";
    pushConfig.payload = @"payload";
    pushConfig.resourcesID = KeyCenter.resourceID;
    config.pushConfig = pushConfig;
    [[ZIM getInstance] callCancelWithInvitees:invitees callID:callID config:config callback:^(NSString * _Nonnull callID, NSArray<NSString *> * _Nonnull errorInvitees, ZIMError * _Nonnull errorInfo) {
        callback(callID,errorInvitees,errorInfo);
       
    }];
    
}


- (void)callAcceptWithCallID:(NSString *)callID
                      config:(ZIMCallAcceptConfig *)config
                    callback:(ZIMCallAcceptanceSentCallback)callback{
    
    //停止震动
    [self stopButton_cClickedAction];
    [[ZIM getInstance] callAcceptWithCallID:callID config:config callback:^(NSString * _Nonnull callID, ZIMError * _Nonnull errorInfo) {
        callback(callID,errorInfo);
       
    }];
    
}


- (void)callRejectWithCallID:(NSString *)callID
                      config:(ZIMCallRejectConfig *)config
                    callback:(ZIMCallRejectionSentCallback)callback{
    config.extendedData = @"rejectPayload";
    //停止震动
    [self stopButton_cClickedAction];
    [[ZIM getInstance] callRejectWithCallID:callID config:config callback:^(NSString * _Nonnull callID, ZIMError * _Nonnull errorInfo) {
        callback(callID,errorInfo);
       
    }];
    
}

- (void)callQuit:(NSString *)callID
          config:(ZIMCallQuitConfig *)config
        callback:(ZIMCallQuitSentCallback)callback{
    config.extendedData = @"quitPayload";
    ZIMPushConfig *pushConfig = [[ZIMPushConfig alloc] init];
    pushConfig.title =@"title";
    pushConfig.content = @"cancel";
    pushConfig.payload = @"payload";
    pushConfig.resourcesID = KeyCenter.resourceID;
    config.pushConfig = pushConfig;
    [[ZIM getInstance] callQuit:callID config:config callback:^(NSString * _Nonnull callID, ZIMCallQuitSentInfo * _Nonnull info, ZIMError * _Nonnull errorInfo) {
        callback(callID,info,errorInfo);
        
    }];
    
}

- (void)callEnd:(NSString *)callID
         config:(ZIMCallEndConfig *)config
       callback:(ZIMCallEndSentCallback)callback{
    ZIMPushConfig *pushConfig = [[ZIMPushConfig alloc] init];
    pushConfig.title =@"title";
    pushConfig.content = @"cancel";
    pushConfig.payload = @"payload";
    pushConfig.resourcesID = KeyCenter.resourceID;
    config.pushConfig = pushConfig;
    [[ZIM getInstance] callEnd:callID config:config callback:^(NSString * _Nonnull callID, ZIMCallEndedSentInfo * _Nonnull info, ZIMError * _Nonnull errorInfo) {
        
        callback(callID,info,errorInfo);
    }];

}

- (void)queryCallInvitationListWithConfig:(ZIMCallInvitationQueryConfig *)config callback:(ZIMCallInvitationListQueriedCallback)callback{
    
    [[ZIM getInstance] queryCallInvitationListWithConfig:config callback:^(NSArray<ZIMCallInfo *> * _Nonnull callList, long long nextFlag, ZIMError * _Nonnull errorInfo) {
        for (ZIMCallInfo *callInfo in callList) {
            
            for (ZIMCallUserInfo *callUserInfo in callInfo.callUserList) {
                
            }
        }
        callback(callList,nextFlag,errorInfo);
    }];
}
// MARK: - ZIMEventHandler

- (void)zim:(ZIM *)zim errorInfo:(ZIMError *)errorInfo{
    
}

- (void)zim:(ZIM *)zim connectionStateChanged:(ZIMConnectionState)state event:(ZIMConnectionEvent)event extendedData:(NSDictionary *)extendedData {

   
    
//    if(state == 0 && event == 4){
//        [ZGHUDHelper showMessage:[NSString stringWithFormat:NSLocalizedString(@"Logged out because you logged in from another device.",nil)]];
//        NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
//        [userDefault setObject:@"" forKey:@"alreadyUserID"];
//        [userDefault setObject:@"" forKey:@"alreadyUserName"];
//        
//        [ConversationListDataSource releaseMySelf];
//        LoginViewController *vc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"LoginViewController"];
//        NSMutableArray *controllers = [NSMutableArray arrayWithArray: [UIViewControllerCJHelper findCurrentShowingViewController].navigationController.viewControllers];
//        controllers[0] = vc;
//        [ZGHUDHelper showNetworkLoading];
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            [ZGHUDHelper hideNetworkLoading];
//            [[UIViewControllerCJHelper findCurrentShowingViewController].navigationController setViewControllers:controllers];
//        });
//        [[ZGZIMManager shared] destroyZIM];
//        
//
//    }
    // Dispatch event callback
    dispatch_async(dispatch_get_main_queue(), ^{
        for (id<ZIMEventDelegate> delegate in self.zimEventDelegates) {
            if ([delegate respondsToSelector:@selector(connectionStateChanged:event:extendedData:)]) {
                [delegate connectionStateChanged:state event:event extendedData:extendedData];
            }
        }
    });
}

- (void)zim:(ZIM *)zim tokenWillExpire:(unsigned int)second {
    
    UIAlertController *alertView = [UIAlertController alertControllerWithTitle:@"tips" message:@"please input token" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if(self.tokenTextField == nil||[self.tokenTextField.text isEqual:@""] ||self.tokenTextField.text == nil){
//            [ZGHUDHelper showMessage:@"The token cannot be null"];
        }else{
            [[ZIM getInstance] renewToken:self.tokenTextField.text callback:^(NSString * _Nonnull token, ZIMError * _Nonnull errorInfo) {
                if(errorInfo.code != 0){
//                    [ZGHUDHelper showMessage:[NSString stringWithFormat:@"failed,code:%lu,message:%@",errorInfo.code,errorInfo.message]];
                }
            }];
        }
    }];
        [alertView addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        self.tokenTextField = textField;
    }];
    [alertView addAction:action];
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alertView animated:YES completion:nil];
    
    
    // Dispatch event callback
    dispatch_async(dispatch_get_main_queue(), ^{
        for (id<ZIMEventDelegate> delegate in self.zimEventDelegates) {
            if ([delegate respondsToSelector:@selector(tokenWillExpire:)]) {
                [delegate tokenWillExpire:second];
            }
        }
    });
    
    
    
}



- (void)zim:(ZIM *)zim receivePeerMessage:(NSArray<ZIMMessage *> *)messageList fromUserID:(NSString *)fromUserID {
   
    // Dispatch message callback
    dispatch_async(dispatch_get_main_queue(), ^{
        for (id<ZIMEventDelegate> delegate in self.zimEventDelegates) {
            if ([delegate respondsToSelector:@selector(receivePeerMessage:fromUserID:)]) {
                [delegate receivePeerMessage:messageList fromUserID:fromUserID];
            }
        }
    });
}

- (void)zim:(ZIM *)zim receiveRoomMessage:(NSArray<ZIMMessage *> *)messageList fromRoomID:(NSString *)fromRoomID {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        for (id<ZIMEventDelegate> delegate in self.zimEventDelegates) {
            if ([delegate respondsToSelector:@selector(receiveRoomMessage:fromRoomID:)]) {
                [delegate receiveRoomMessage:messageList fromRoomID:fromRoomID];
            }
        }
    });
}

- (void)zim:(ZIM *)zim
    receiveGroupMessage:(NSArray<ZIMMessage *> *)messageList
fromGroupID:(NSString *)fromGroupID{
   
    dispatch_async(dispatch_get_main_queue(), ^{
        for (id<ZIMEventDelegate> delegate in self.zimEventDelegates) {
            if ([delegate respondsToSelector:@selector(receiveGroupMessage:fromGroupID:)]) {
                [delegate receiveGroupMessage:messageList fromGroupID:fromGroupID];
            }
        }
    });
}

- (void)zim:(ZIM *)zim broadcastMessageReceived:(ZIMMessage *)message{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        for (id<ZIMEventDelegate> delegate in self.zimEventDelegates) {
            if ([delegate respondsToSelector:@selector(zim:broadcastMessageReceived:)]) {
                [delegate zim:zim broadcastMessageReceived:message];
            }
        }
    });

}

- (void)zim:(ZIM *)zim messageRevokeReceived:(NSArray<ZIMRevokeMessage *> *)messageList{
  
    dispatch_async(dispatch_get_main_queue(), ^{
        for (id<ZIMEventDelegate> delegate in self.zimEventDelegates) {
            if ([delegate respondsToSelector:@selector(messageRevokeReceived:)]) {
                [delegate messageRevokeReceived:messageList];
            }
        }
    });
}

- (void)zim:(ZIM *)zim messageReceiptChanged:(NSArray<ZIMMessageReceiptInfo *> *)infos{
    NSMutableArray *infosModel = [[NSMutableArray alloc] init];
    for (ZIMMessageReceiptInfo *info in infos) {
        [infosModel safeAddObject:[ZIMPluginConverter mZIMMessageReceiptInfo:info]];
    }
   
    dispatch_async(dispatch_get_main_queue(), ^{
        for (id<ZIMEventDelegate> delegate in self.zimEventDelegates) {
            if([delegate respondsToSelector:@selector(zim:messageReceiptChanged:)]){
                [delegate zim:zim messageReceiptChanged:infos];
            }
        }
    });
    
}

- (void)zim:(ZIM *)zim
    messageSentStatusChanged:
(NSArray<ZIMMessageSentStatusChangeInfo *> *)messageSentStatusChangeInfoList{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        for (id<ZIMEventDelegate> delegate in self.zimEventDelegates) {
            if([delegate respondsToSelector:@selector(zim:messageSentStatusChanged:)]){
                [delegate zim:zim messageSentStatusChanged:messageSentStatusChangeInfoList];
            }
        }
    });
    
}

- (void)zim:(ZIM *)zim messageDeleted:(ZIMMessageDeletedInfo *)deletedInfo{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        for (id<ZIMEventDelegate> delegate in self.zimEventDelegates) {
            if([delegate respondsToSelector:@selector(zim:messageDeleted:)]){

                [delegate zim:zim messageDeleted:deletedInfo];
            }
        }
    });
}

- (void)zim:(ZIM *)zim conversationMessageReceiptChanged:(NSArray<ZIMMessageReceiptInfo *> *)infos{
    NSMutableArray *infosModel = [[NSMutableArray alloc] init];
    for (ZIMMessageReceiptInfo *info in infos) {
        [infosModel safeAddObject:[ZIMPluginConverter mZIMMessageReceiptInfo:info]];
    }
    
   
    
    dispatch_async(dispatch_get_main_queue(), ^{
        for (id<ZIMEventDelegate> delegate in self.zimEventDelegates) {
            if([delegate respondsToSelector:@selector(zim:conversationMessageReceiptChanged:)]){
                [delegate zim:zim conversationMessageReceiptChanged:infos];
            }
        }
    });
}

- (void)zim:(ZIM *)zim
conversationChanged:(NSArray<ZIMConversationChangeInfo *> *)conversationChangeInfoList{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        for (id<ZIMEventDelegate> delegate in self.zimEventDelegates) {
            if([delegate respondsToSelector:@selector(conversationChanged:)]){
            [delegate conversationChanged:conversationChangeInfoList];
            }
        }
    });
    
    
}

- (void)zim:(ZIM *)zim
conversationTotalUnreadMessageCountUpdated:(unsigned int)totalUnreadMessageCount{
   
    dispatch_async(dispatch_get_main_queue(), ^{
        for (id<ZIMEventDelegate> delegate in self.zimEventDelegates) {
            if ([delegate respondsToSelector:@selector(conversationTotalUnreadMessageCountUpdated:)]) {
                [delegate conversationTotalUnreadMessageCountUpdated:totalUnreadMessageCount];
            }
        }
    });
}

- (void)zim:(ZIM *)zim roomMemberJoined:(NSArray<ZIMUserInfo *> *)memberList roomID:(NSString *)roomID {
   
    dispatch_async(dispatch_get_main_queue(), ^{
        for (id<ZIMEventDelegate> delegate in self.zimEventDelegates) {
            if ([delegate respondsToSelector:@selector(roomMemberJoined:roomID:)]) {
                [delegate roomMemberJoined:memberList roomID:roomID];
            }
        }
    });
}

- (void)zim:(ZIM *)zim roomMemberLeft:(NSArray<ZIMUserInfo *> *)memberList roomID:(NSString *)roomID {
   
    // Dispatch message callback
    dispatch_async(dispatch_get_main_queue(), ^{
        for (id<ZIMEventDelegate> delegate in self.zimEventDelegates) {
            if ([delegate respondsToSelector:@selector(roomMemberLeft:roomID:)]) {
                [delegate roomMemberLeft:memberList roomID:roomID];
            }
        }
    });
}

- (void)zim:(ZIM *)zim
    roomStateChanged:(ZIMRoomState)state
               event:(ZIMRoomEvent)event
        extendedData:(NSDictionary *)extendedData
     roomID:(NSString *)roomID{
    // Dispatch message callback
    
    dispatch_async(dispatch_get_main_queue(), ^{
        for (id<ZIMEventDelegate> delegate in self.zimEventDelegates) {
            if ([delegate respondsToSelector:@selector(roomStateChanged:event:extendedData:roomID:)]) {
                [delegate roomStateChanged:state event:event extendedData:extendedData roomID:roomID];
            }
            
        }
    });
}

- (void)zim:(ZIM *)zim
    roomAttributesUpdated:(ZIMRoomAttributesUpdateInfo *)updateInfo
     roomID:(NSString *)roomID{
   
    dispatch_async(dispatch_get_main_queue(), ^{
        for (id<ZIMEventDelegate> delegate in self.zimEventDelegates) {
            if ([delegate respondsToSelector:@selector(zim:roomAttributesUpdated:roomID:)]) {
            [delegate roomAttributesUpdated:updateInfo roomID:roomID];
            }
        }
    });
}



- (void)zim:(ZIM *)zim
    roomAttributesBatchUpdated:(NSArray<ZIMRoomAttributesUpdateInfo *> *)updateInfo
     roomID:(NSString *)roomID {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        for (id<ZIMEventDelegate> delegate in self.zimEventDelegates) {
            if([delegate respondsToSelector:@selector(roomAttributesBatchUpdated:roomID:)]){
                [delegate roomAttributesBatchUpdated:updateInfo roomID:roomID];
            };
        }
    });
}

//- (void)zim:(ZIM *)zim
//    roomMemberAttributesUpdated:(NSArray<ZIMRoomMemberAttributesUpdateInfo *> *)infos
//                   operatedInfo:(ZIMRoomOperatedInfo *)operatedInfo
//     roomID:(NSString *)roomID{
//    NSMutableArray *infosModel = [[NSMutableArray alloc] init];
//    for (ZIMRoomMemberAttributesUpdateInfo *info in infos) {
//        [infosModel safeAddObject:[ZIMPluginConverter mZIMRoomMemberAttributesUpdateInfo:info]];
//    }
//
//    GGLog(@"[GGLog][Event][roomMemberAttributesUpdated],infos:%@,operatedInfo:%@",infosModel,[ZIMPluginConverter mZIMRoomOperatedInfo:operatedInfo]);
//    dispatch_async(dispatch_get_main_queue(), ^{
//        for (id<ZIMEventDelegate> delegate in self.zimEventDelegates) {
//            if([delegate respondsToSelector:@selector(zim:roomMemberAttributesUpdated:operatedInfo:roomID:)]){
//                [delegate zim:zim roomMemberAttributesUpdated:infos operatedInfo:operatedInfo roomID:roomID];
//            }
//        }
//    });
//}



- (void)zim:(ZIM *)zim
    groupStateChanged:(ZIMGroupState)state
                event:(ZIMGroupEvent)event
         operatedInfo:(ZIMGroupOperatedInfo *)operatedInfo
  groupInfo:(ZIMGroupFullInfo *)groupInfo{
  
    dispatch_async(dispatch_get_main_queue(), ^{
        for (id<ZIMEventDelegate> delegate in self.zimEventDelegates) {
            if ([delegate respondsToSelector:@selector(groupStateChanged:event:operatedInfo:groupInfo:)]) {
                [delegate groupStateChanged:state event:event operatedInfo:operatedInfo groupInfo:groupInfo];
            }
        }
    });
}

- (void)zim:(ZIM *)zim
    groupNameUpdated:(NSString *)groupName
        operatedInfo:(ZIMGroupOperatedInfo *)operatedInfo
    groupID:(NSString *)groupID{
    // Dispatch message callback
   
    dispatch_async(dispatch_get_main_queue(), ^{
        for (id<ZIMEventDelegate> delegate in self.zimEventDelegates) {
            if ([delegate respondsToSelector:@selector(groupNameUpdated:operatedInfo:groupID:)]) {
                [delegate groupNameUpdated:groupName operatedInfo:operatedInfo groupID:groupID];
            }
        }
    });
}

- (void)zim:(ZIM *)zim
    groupNoticeUpdated:(NSString *)groupNotice
          operatedInfo:(ZIMGroupOperatedInfo *)operatedInfo
    groupID:(NSString *)groupID{
    // Dispatch message callback
   
    dispatch_async(dispatch_get_main_queue(), ^{
        for (id<ZIMEventDelegate> delegate in self.zimEventDelegates) {
            if ([delegate respondsToSelector:@selector(groupNoticeUpdated:operatedInfo:groupID:)]) {
                [delegate groupNoticeUpdated:groupNotice operatedInfo:operatedInfo groupID:groupID];
            }
            
        }
    });
}

- (void)zim:(ZIM *)zim
    groupAvatarUrlUpdated:(NSString *)groupAvatarUrl
             operatedInfo:(ZIMGroupOperatedInfo *)operatedInfo
    groupID:(NSString *)groupID{

    dispatch_async(dispatch_get_main_queue(), ^{
        for (id<ZIMEventDelegate> delegate in self.zimEventDelegates) {
            if ([delegate respondsToSelector:@selector(zim:groupAvatarUrlUpdated:operatedInfo:groupID:)]) {
                [delegate zim:zim groupAvatarUrlUpdated:groupAvatarUrl operatedInfo:operatedInfo groupID:groupID];
            }
            
        }
    });
}


- (void)zim:(ZIM *)zim
    groupAttributesUpdated:(NSArray<ZIMGroupAttributesUpdateInfo *> *)updateInfo
              operatedInfo:(ZIMGroupOperatedInfo *)operatedInfo
    groupID:(NSString *)groupID{
 
    dispatch_async(dispatch_get_main_queue(), ^{
        for (id<ZIMEventDelegate> delegate in self.zimEventDelegates) {
            if ([delegate respondsToSelector:@selector(groupAttributesUpdated:operatedInfo:groupID:)]) {
                [delegate groupAttributesUpdated:updateInfo operatedInfo:operatedInfo groupID:groupID];
            }
           
        }
    });
}

- (void)zim:(ZIM *)zim
    groupMemberStateChanged:(ZIMGroupMemberState)state
                      event:(ZIMGroupMemberEvent)event
                   userList:(NSArray<ZIMGroupMemberInfo *> *)userList
               operatedInfo:(ZIMGroupOperatedInfo *)operatedInfo
    groupID:(NSString *)groupID{

    dispatch_async(dispatch_get_main_queue(), ^{
        for (id<ZIMEventDelegate> delegate in self.zimEventDelegates) {
            if ([delegate respondsToSelector:@selector(groupMemberStateChanged:event:userList:operatedInfo:groupID:)]) {
                [delegate groupMemberStateChanged:state event:event userList:userList operatedInfo:operatedInfo groupID:groupID];
            }
            
        }
    });
}

- (void)zim:(ZIM *)zim
    groupMemberInfoUpdated:(NSArray<ZIMGroupMemberInfo *> *)userInfo
              operatedInfo:(ZIMGroupOperatedInfo *)operatedInfo
    groupID:(NSString *)groupID{
   
    dispatch_async(dispatch_get_main_queue(), ^{
        for (id<ZIMEventDelegate> delegate in self.zimEventDelegates) {
            if ([delegate respondsToSelector:@selector(groupMemberInfoUpdated:operatedInfo:groupID:)]) {
                [delegate groupMemberInfoUpdated:userInfo operatedInfo:operatedInfo groupID:groupID];
            }
        }
    });
}


- (void)zim:(ZIM *)zim
    callInvitationReceived:(ZIMCallInvitationReceivedInfo *)info
     callID:(NSString *)callID{
    [[HttpManager manager] post:[UrlConfig URL:getUserByCode] param:@{@"userId":info.inviter} success:^(NSData *data) {
        if ([ResponseUtils success:data]) {
            UserBean * userBean = [UserBean mj_objectWithKeyValues:[ResponseUtils getData:@"data"]];
            [CallInviteView show:Receiver userID:userBean.name callID:callID mode:info.mode extendedData:info.extendedData];
            self.targetCallID = callID;
            //开始震动
            [self startButton_cClickedAction];
            dispatch_async(dispatch_get_main_queue(), ^{
                for (id<ZIMEventDelegate> delegate in self.zimEventDelegates) {
                    if ([delegate respondsToSelector:@selector(zim:callInvitationReceived:callID:)]) {
                        [delegate zim:zim callInvitationReceived:info callID:callID];
                    }
                }
            });
        }else{
            [SVProgressHUD showErrorWithStatus:@"获取人员信息失败！"];
        }
    } faild:^(NSString *msg) {
        
    }];

}

- (void)zim:(ZIM *)zim
    callInvitationCancelled:(ZIMCallInvitationCancelledInfo *)info
     callID:(NSString *)callID{
    [CallInviteView CallerCancel:callID];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        for (id<ZIMEventDelegate> delegate in self.zimEventDelegates) {
            if ([delegate respondsToSelector:@selector(zim:callInvitationCancelled:callID:)]) {
                [delegate zim:zim callInvitationCancelled:info callID:callID];
            }
        }
    });
}

- (void)zim:(ZIM *)zim
    callInvitationAccepted:(ZIMCallInvitationAcceptedInfo *)info
     callID:(NSString *)callID{
    [CallInviteView receiverAccept:callID];
   
    dispatch_async(dispatch_get_main_queue(), ^{
        for (id<ZIMEventDelegate> delegate in self.zimEventDelegates) {
            if ([delegate respondsToSelector:@selector(zim:callInvitationAccepted:callID:)]) {
                [delegate zim:zim callInvitationAccepted:info callID:callID];
            }
        }
    });
}

- (void)zim:(ZIM *)zim
    callInvitationRejected:(ZIMCallInvitationRejectedInfo *)info
     callID:(NSString *)callID{
    [CallInviteView receiverRefused:callID];
   
    dispatch_async(dispatch_get_main_queue(), ^{
        for (id<ZIMEventDelegate> delegate in self.zimEventDelegates) {
            if ([delegate respondsToSelector:@selector(zim:callInvitationRejected:callID:)]) {
                [delegate zim:zim callInvitationRejected:info callID:callID];
            }
        }
    });
}

- (void)zim:(ZIM *)zim callInvitationTimeout:(NSString *)callID{
    [CallInviteView timeout:callID];
   
    dispatch_async(dispatch_get_main_queue(), ^{
        for (id<ZIMEventDelegate> delegate in self.zimEventDelegates) {
            if ([delegate respondsToSelector:@selector(zim:callInvitationTimeout:)]) {
                [delegate zim:zim callInvitationTimeout:callID];
            }
        }
    });
}


- (void)zim:(ZIM *)zim
    callInviteesAnsweredTimeout:(NSArray<NSString *> *)invitees
     callID:(NSString *)callID{
    [CallInviteView timeout:callID];
   
    dispatch_async(dispatch_get_main_queue(), ^{
        for (id<ZIMEventDelegate> delegate in self.zimEventDelegates) {
            if ([delegate respondsToSelector:@selector(zim:callInviteesAnsweredTimeout:callID:)]) {
                [delegate zim:zim callInviteesAnsweredTimeout:invitees callID:callID];
            }
        }
    });
}


- (void)zim:(ZIM *)zim callUserStateChanged:(ZIMCallUserStateChangeInfo *)info callID:(nonnull NSString *)callID{
   
    dispatch_async(dispatch_get_main_queue(), ^{
        for (id<ZIMEventDelegate> delegate in self.zimEventDelegates) {
            if ([delegate respondsToSelector:@selector(zim:callUserStateChanged:callID:)]) {
                [delegate zim:zim callUserStateChanged:info callID:callID];
            }
        }
    });
}

- (void)zim:(ZIM *)zim callInvitationEnded:(ZIMCallInvitationEndedInfo *)info callID:(NSString *)callID{
   
    dispatch_async(dispatch_get_main_queue(), ^{
        for (id<ZIMEventDelegate> delegate in self.zimEventDelegates) {
            if ([delegate respondsToSelector:@selector(zim:callInvitationEnded:callID:)]) {
                [delegate zim:zim callInvitationEnded:info callID:callID];
            }
        }
    });
}

- (void)zim:(ZIM *)zim userInfoUpdated:(ZIMUserFullInfo *)info{
  
    dispatch_async(dispatch_get_main_queue(), ^{
        for (id<ZIMEventDelegate> delegate in self.zimEventDelegates) {
            if ([delegate respondsToSelector:@selector(zim:userInfoUpdated:)]) {
                [delegate zim:zim userInfoUpdated:info];
            }
        }
    });
}
@end
