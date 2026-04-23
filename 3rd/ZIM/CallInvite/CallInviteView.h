//
//  CallInviteView.h
//  ZIMExampleDemo
//
//  Created by 武耀琳 on 2022/10/27.
//

#import <UIKit/UIKit.h>
#import <ZIM/ZIM.h>
NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, CallInviteViewKind) {

    Caller = 0,

    Receiver = 1
};

@interface CallInviteView : UIView
@property (weak, nonatomic) IBOutlet UILabel *callUserID;

+(void)show:(CallInviteViewKind)kind
     userID:(NSString *)userID
     callID:(NSString *)callID
     mode:(ZIMCallInvitationMode)mode extendedData:(NSString *)extendedData;

+(void)CallerCancel:(NSString *)callID;

+(void)timeout:(NSString *)callID;

+(void)receiverAccept:(NSString *)callID;

+(void)receiverRefused:(NSString *)callID;

+(void)hide;

@end

NS_ASSUME_NONNULL_END
