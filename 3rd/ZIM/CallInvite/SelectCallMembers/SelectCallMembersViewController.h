//
//  SelectRoomCallMembersViewController.h
//  ZIMExampleDemo
//
//  Created by 武耀琳 on 2022/11/7.
//

#import <UIKit/UIKit.h>
#import <ZIM/ZIM.h>
NS_ASSUME_NONNULL_BEGIN

@interface SelectCallMembersViewController : UIViewController

-(void)selectTheUserID:(nonnull NSString *)selectedUserID;

-(void)unSelectTheUserID:(nonnull NSString *)unSelectedUserID;

-(void)addList:(NSArray<ZIMUserInfo *> *)userList;


@end

NS_ASSUME_NONNULL_END
