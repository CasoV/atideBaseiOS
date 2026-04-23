//
//  CallInviteView.m
//  ZIMExampleDemo
//
//  Created by 武耀琳 on 2022/10/27.
//

#import "CallInviteView.h"
#import "ZGZIMManager.h"
#import "CallInviteDetailsViewController.h"
#import "UIViewControllerCJHelper.h"
#import "CallDataManager.h"
#import "MainWebController.h"
#ifndef SCREEN_WIDTH
#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#endif

static CallInviteView *inviteView = nil;
static NSString *callerInvitingString = @"呼叫中...";
static NSString *receiverInvitingString = @"邀请你发起直播";
static NSString *timeOutString = @"已超时";
static NSString *canceledString = @"已取消";
static NSString *acceptString = @"已接受";
static NSString *refusedString = @"已拒绝";

@interface CallInviteView()
@property (weak, nonatomic) IBOutlet UILabel *userIDLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UIButton *acceptButton;
@property (weak, nonatomic) IBOutlet UIButton *rejuctButton;
@property CallInviteViewKind kind;
@property NSString *callID;
@property ZIMCallInvitationMode mode;
@property NSString *extendedData;
@end


@implementation CallInviteView

//- (instancetype)initWithCoder:(NSCoder *)aDecoder {
////    self = [super initWithCoder:aDecoder];
////    CallInviteView *view = [[[UINib nibWithNibName:@"CallInviteView" bundle:[NSBundle mainBundle]]
////                     instantiateWithOwner:self options:nil] lastObject];
////    [self addSubview:view];
////    return self;
//}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
       NSString *className = NSStringFromClass([self class]);
       self = [[[NSBundle mainBundle] loadNibNamed:className owner:self options:nil] lastObject];
    }
    return self;
}


+(void)show:(CallInviteViewKind)kind
     userID:(NSString *)userID
     callID:(NSString *)callID
       mode:(ZIMCallInvitationMode)mode extendedData:(NSString *)extendedData{
    if(inviteView == nil){
        inviteView = [[[UINib nibWithNibName:@"CallInviteView" bundle:[NSBundle mainBundle]]
                       instantiateWithOwner:nil options:nil] lastObject];
        [inviteView setFrame:CGRectMake(5, -4000, [UIScreen mainScreen].bounds.size.width -10, 100)];

        inviteView.layer.zPosition = MAXFLOAT;
        inviteView.layer.cornerRadius = 8;
        inviteView.layer.masksToBounds = YES;
        inviteView.kind = kind;
        inviteView.callID = callID;
        inviteView.mode = mode;
        inviteView.extendedData = extendedData;
        [inviteView.userIDLabel setText:userID];
        switch (kind) {
            case Caller:
                inviteView.acceptButton.hidden = true;
                [inviteView.contentLabel setText:callerInvitingString];
                break;
            case Receiver:
                inviteView.acceptButton.hidden = false;
                [inviteView.contentLabel setText:receiverInvitingString];
            default:
                break;
        }
    }
    [[UIApplication sharedApplication].keyWindow.rootViewController.view addSubview:inviteView];
    [UIView animateWithDuration:0.3 animations:^{
    //self.alpha = 1.0;
    if (@available(iOS 11.0, *)) {
        [inviteView setFrame:CGRectMake(5,[UIApplication sharedApplication].keyWindow.safeAreaInsets.top, [UIScreen mainScreen].bounds.size.width -10, 100)];
        
    } else {
        [inviteView setFrame:CGRectMake(5,10, [UIScreen mainScreen].bounds.size.width -10, 100)];
    }

    } completion:nil];
}


+(void)CallerCancel:(NSString *)callID{
    if([callID isEqual:inviteView.callID] == false){
        return;
    }
    [inviteView.contentLabel setText:canceledString];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [CallInviteView hide];
    });
    
}

+(void)timeout:(NSString *)callID{
    if([callID isEqual:inviteView.callID] == false){
        return;
    }
    [inviteView.contentLabel setText:timeOutString];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [CallInviteView hide];
    });
}

+(void)receiverAccept:(NSString *)callID{
    if([callID isEqual:inviteView.callID] == false){
        return;
    }
    [inviteView.contentLabel setText:acceptString];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [CallInviteView hide];
    });
}

+(void)receiverRefused:(NSString *)callID{
    if([callID isEqual:inviteView.callID] == false){
        return;
    }
    [inviteView.contentLabel setText:refusedString];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [CallInviteView hide];
    });
}


+(void)hide{
    [[UIApplication sharedApplication].keyWindow willRemoveSubview:inviteView];
        [UIView animateWithDuration:0.3 animations:^{
           //  self.alpha = 1.0;
        [inviteView setFrame:CGRectMake(5,-4000, [UIScreen mainScreen].bounds.size.width -10, 100)];

        } completion:nil];
    inviteView = nil;
}


- (IBAction)acceptCallInviteButtonClicked:(UIButton *)sender {
    if(inviteView.kind == Receiver){
       
        NSDictionary *param = [inviteView.extendedData mj_JSONObject];

        NSMutableDictionary *createDic = [NSMutableDictionary dictionaryWithDictionary:@{
            @"classifyCode":param[@"classifyCode"],
            @"taskId":param[@"taskId"],
            @"title":[NSString stringWithFormat:@"%@直播间",[UserInfo getInstance].name],
            @"projectId":param[@"projectId"],
            @"sectionId":param[@"sectionId"],
            @"remark":![[UserAgent DefaultAgent].sectionName isEqualToString:@""]
            ?[UserAgent DefaultAgent].sectionName:[UserAgent DefaultAgent].prjName
        }];
        //创建直播间，保存到服务器
        [[HttpManager manager]jsonPost:[UrlConfig URL:liveAdd] param:createDic success:^(NSData *data) {
            //进入直播间
            ZIMCallAcceptConfig *config = [[ZIMCallAcceptConfig alloc] init];
            NSDictionary *resData = [data mj_JSONObject];
            if([[resData[@"succeed"] stringValue] isEqualToString:@"1"]){
                config.extendedData =  [resData[@"data"] mj_JSONString];
                [[ZGZIMManager shared]callAcceptWithCallID:inviteView.callID config:config callback:^(NSString * _Nonnull callID, ZIMError * _Nonnull errorInfo) {
                if(errorInfo.code == 0){
                    if(self.mode == ZIMCallInvitationModeGeneral){
                        [CallInviteView receiverAccept:inviteView.callID];
                        MainWebController *vc = (MainWebController *)[UIViewControllerCJHelper findCurrentShowingViewController];
                        //观众身份加入直播间
                        [vc gzJoinLivingRoom:resData[@"data"]];
                    }
                   
                }
                }];
            }

        } faild:^(NSString *msg) {
            
        }];
        
            

    }
    
    
}

- (IBAction)rejectCallInviteButtonClicked:(UIButton *)sender {
    if(inviteView.kind == Caller){
        ZIMCallCancelConfig *cancelConfig = [[ZIMCallCancelConfig alloc] init];
        [[ZGZIMManager shared] callCancelWithInvitees:@[inviteView.userIDLabel.text] callID:inviteView.callID config:cancelConfig callback:^(NSString * _Nonnull callID, NSArray<NSString *> * _Nonnull errorInvitees, ZIMError * _Nonnull errorInfo) {
            if(errorInfo.code == 0){
                [CallInviteView CallerCancel:inviteView.callID];
            }
        }];
    }else{
        ZIMCallRejectConfig *config = [[ZIMCallRejectConfig alloc] init];
        [[ZGZIMManager shared] callRejectWithCallID:inviteView.callID config:config callback:^(NSString * _Nonnull callID, ZIMError * _Nonnull errorInfo) {
            if(errorInfo.code == 0){
                [CallInviteView receiverRefused:inviteView.callID];
            }
        }];
    }
    
}

- (UIViewController*)GetViewController:(UIView*)uView
{
    for (UIView* next = [uView superview]; next; next = next.superview) {
        UIResponder* nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController*)nextResponder;
        }
    }
    return nil;
}



@end
