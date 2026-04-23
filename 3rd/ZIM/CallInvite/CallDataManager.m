//
//  CallDataManager.m
//  ZIMExampleDemo
//
//  Created by 武耀琳 on 2023/6/2.
//

#import "CallDataManager.h"
#import "ZGZIMManager.h"
static CallDataManager *_sharedManager = nil;

@interface CallDataManager()<ZIMEventDelegate>

@property NSMutableDictionary<NSString *,NSMutableArray<ZIMCallUserInfo *> *>  *callUsersMap;

@end

@implementation CallDataManager

+(CallDataManager *)shared{
    if (!_sharedManager) {
        @synchronized (self) {
            if (!_sharedManager) {
                _sharedManager = [[self alloc] init];
                _sharedManager.callUsersMap = [[NSMutableDictionary alloc] init];
            }
        }
    }
    return _sharedManager;
}


-(NSArray<ZIMCallUserInfo *> *)takeCurrentCallList:(NSString *)callID{
    NSArray<ZIMCallUserInfo *> * targetArr = [_callUsersMap objectForKey:callID];
    return targetArr;
}

-(void)zim:(ZIM *)zim callInvitationReceived:(ZIMCallInvitationReceivedInfo *)info callID:(NSString *)callID{
    [_callUsersMap setObject:[[NSMutableArray alloc] initWithArray:info.callUserList] forKey:callID];
}

-(void)zim:(ZIM *)zim callUserStateChanged:(ZIMCallUserStateChangeInfo *)info callID:(nonnull NSString *)callID{
    NSMutableArray *targetArr = [_callUsersMap objectForKey:callID];
    if(targetArr == nil){
        targetArr = [targetArr initWithArray:info.callUserList];
    }else{
        for (ZIMCallUserInfo *aUserInfo in info.callUserList) {
            long long index = -1;
            for(ZIMCallUserInfo *bUserInfo in targetArr){
                if([bUserInfo.userID isEqual: aUserInfo.userID]){
                    index = [targetArr indexOfObject:bUserInfo];
                    break;
                }
            }
            if(index == -1){
                [targetArr addObject:aUserInfo];
            }else{
                [targetArr replaceObjectAtIndex:index withObject:aUserInfo];
            }
        }
    }
}

@end
