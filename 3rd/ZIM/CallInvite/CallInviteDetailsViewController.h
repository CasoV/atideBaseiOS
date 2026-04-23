//
//  CallInviteDetailsViewController.h
//  ZIMExampleDemo
//
//  Created by 武耀琳 on 2023/5/21.
//

#import <UIKit/UIKit.h>
#import <ZIM/ZIM.h>
NS_ASSUME_NONNULL_BEGIN

@interface CallInviteDetailsViewController : UIViewController

@property NSString *callID;

@property NSString *caller;

-(void)addCallMembers:(NSArray<ZIMCallUserInfo *> *)callUserList;

@end

NS_ASSUME_NONNULL_END
