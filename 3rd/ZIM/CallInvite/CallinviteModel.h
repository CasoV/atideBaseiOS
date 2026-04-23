//
//  CallinviteModel.h
//  ZIMExampleDemo
//
//  Created by 武耀琳 on 2023/5/21.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol CallMemberListDelegate <NSObject>

-(void)callMemberListupdate:(NSArray *)groupMmemberList;

@end


@interface CallinviteModel : NSObject

@property NSMutableArray *memberList;

@property (nonatomic, strong) NSHashTable<id<CallMemberListDelegate>> *memberListDelegates;
 
- (void)addMemberListDelegate:(id<CallMemberListDelegate>)delegate;


-(void)addMemberList:(nonnull NSString *)memberID;

-(void)deleteMemberList:(nonnull NSString *)memberID;


@end

NS_ASSUME_NONNULL_END
