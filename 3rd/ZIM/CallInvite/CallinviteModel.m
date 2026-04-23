//
//  CallinviteModel.m
//  ZIMExampleDemo
//
//  Created by 武耀琳 on 2023/5/21.
//

#import "CallinviteModel.h"

@implementation CallinviteModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.memberList = [[NSMutableArray alloc] init];
        self.memberListDelegates = [NSHashTable weakObjectsHashTable];
        
    }
    return self;
}

- (void)addMemberListDelegate:(id<CallMemberListDelegate>)delegate{
    [self.memberListDelegates addObject:delegate];
}


-(void)addMemberList:(nonnull NSString *)callMemberID{
    bool isRepetition = false;
   
    for (NSString *memberID in self.memberList) {
        if([memberID isEqual:callMemberID]){
            isRepetition = true;
        }
    }
    if(isRepetition == false){
        [self.memberList addObject:callMemberID];
        [self noticeGroupMemberList];
    }
    
}

-(void)deleteMemberList:(NSString *)callMemberID{
    int index = 0 ;
    for (int i = 0; i<self.memberList.count; i++) {
        if([self.memberList[i] isEqual:callMemberID]){
            index = i;
        }
    }
    [self.memberList removeObjectAtIndex:index];
    [self noticeGroupMemberList];
}


-(void)noticeGroupMemberList{
    dispatch_async(dispatch_get_main_queue(), ^{
        for (id<CallMemberListDelegate> delegate in self.memberListDelegates) {
            if ([delegate respondsToSelector:@selector(callMemberListupdate:)]) {
                [delegate callMemberListupdate:self.memberList];
            }
        }
    });
}
@end
