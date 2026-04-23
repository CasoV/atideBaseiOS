//
//  TLHomeViewModel.m
//  ZegoRoomkitDemo
//
//  Created by KaelDing on 2020/7/15.
//  Copyright © 2020 zego. All rights reserved.
//

#import "TLHomeViewModel.h"
#import "TLManager.h"
#import "TLMeetingUIConfig.h"
#import "TLToken.h"
#import "TLOutRoomService.h"
#import "TLHomeViewModel+Room.h"

@interface TLHomeViewModel ()


@end

@implementation TLHomeViewModel
- (instancetype)init {
    self = [super init];
    if (self) {
        self.accessToken = [TLManager sharedInstance].token;
        [self refreshMeetingSettings];
        self.arrangeData = [self arrangeData];
    }
    return self;
}

#pragma mark - Public

#pragma mark -- Join room
- (void)joinMeetingWithData:(NSDictionary *)data
                    showHUD:(BOOL)isShowhud
                    success:(void(^) (void))susBlock
                    failure:(void(^) (NSError *error))faiBlock{
    self.progressHidden = NO;
    NSDictionary *meeting = data[@"meeting"];
    UIViewController *fromVC = data[@"fromVC"];
    ZegoJoinRoomConfig *config = [ZegoJoinRoomConfig new];
    config.roomID = meeting[@"room_id"];
    config.productID = [meeting[@"pid"] integerValue];
    
    config.userName =  [UserInfo getInstance].name;
    config.userID = TLManager.sharedInstance.userID;
    config.role = ZegoRoomKitRoleHost;
    config.token = [TLToken getToken];
    
    ZegoRoomParameter *roomParam = [ZegoRoomParameter new];
    roomParam.subject = meeting[@"subject"];
    roomParam.beginTimestamp = [meeting[@"begin_timestamp"] doubleValue];
    roomParam.duration = [meeting[@"dutation"] integerValue];
    roomParam.hostNickname = [NSString stringWithFormat:@"%@", meeting[@"host"][@"uid"]];
    [[ZegoRoomKit sharedInstance].inRoomService setRoomParameter:roomParam];
    
    /// 测试头像开关代码 验证后删除
    if (![NSUserDefaults.standardUserDefaults boolForKey:@"teacherHideAvatar"]) {
        ZegoUserParameter *userParameter = [ZegoUserParameter new];
        userParameter.avatarUrl = @"https://gss3.bdstatic.com/84oSdTum2Q5BphGlnYG/timg?wapp&quality=80&size=b150_150&subsize=20480&cut_x=0&cut_w=0&cut_y=0&cut_h=0&sec=1369815402&srctrace&di=9f46b42f94ad866a87f516bccc32bbbc&wh_rate=null&src=http%3A%2F%2Fimgsrc.baidu.com%2Fforum%2Fpic%2Fitem%2Fb1f204d162d9f2d398ed608fa6ec8a136227ccdd.jpg";
        userParameter.customIconUrl = @"https://gss3.bdstatic.com/84oSdTum2Q5BphGlnYG/timg?wapp&quality=80&size=b150_150&subsize=20480&cut_x=0&cut_w=0&cut_y=0&cut_h=0&sec=1369815402&srctrace&di=9f46b42f94ad866a87f516bccc32bbbc&wh_rate=null&src=http%3A%2F%2Fimgsrc.baidu.com%2Fforum%2Fpic%2Fitem%2Fb1f204d162d9f2d398ed608fa6ec8a136227ccdd.jpg";
        [[ZegoRoomKit sharedInstance].inRoomService setUserParameter:userParameter];
    }
   
    [self setUIConfig];
    [self addScreenShare];
    
#if DEBUG
    UIPasteboard *pab = [UIPasteboard generalPasteboard];
    pab.string = meeting[@"room_id"];
#endif
    
    [[ZegoRoomKit sharedInstance].inRoomService joinRoomWithConfig:config fromVC:fromVC completion:^(ZegoRoomKitError errorCode) {
        self.progressHidden = YES;
        if (errorCode == 0) {
            if(susBlock) susBlock();
        } else {
            NSError *error = [[NSError alloc] initWithDomain:@"TLNetworkDomain" code:errorCode userInfo:nil];
            if(faiBlock) faiBlock(error);
        }
    }];
}

- (void)quickJoinMeetingWithData:(NSDictionary *)data
                         showHUD:(BOOL)isShowhud
                         success:(void(^ _Nullable) (void))susBlock
                         failure:(void(^) (NSError *error))faiBlock{
    self.progressHidden = NO;
    UIViewController *fromVC = data[@"fromVC"];
    ZegoJoinRoomConfig *config = [[ZegoJoinRoomConfig alloc] init];
    config.roomID = self.quickJoinRoomID;
#ifdef ZEGO_ACCESS_ENV_FLAG
    config.productID = [ZegoEnviromentManager getProductIDOfRoomType:self.roomType];
    BOOL isL3on = [NSUserDefaults.standardUserDefaults boolForKey:@"isL3on"];
    if (self.roomType ==  5 && isL3on) {
        config.productID = [ZegoEnviromentManager getProductIDOfRoomType:6];
    }
#else
    config.productID = kProductID;
#endif

    config.userName = [UserInfo getInstance].name;
    config.userID = TLManager.sharedInstance.userID;
    config.role = self.role;
    config.token = [TLToken getToken];
    
    /// 测试头像开关代码 验证后删除
    if (![NSUserDefaults.standardUserDefaults boolForKey:@"studentHideAvatar"]) {
        ZegoUserParameter *userParameter = [ZegoUserParameter new];
        userParameter.avatarUrl = @"https://gss3.bdstatic.com/84oSdTum2Q5BphGlnYG/timg?wapp&quality=80&size=b150_150&subsize=20480&cut_x=0&cut_w=0&cut_y=0&cut_h=0&sec=1369815402&srctrace&di=9f46b42f94ad866a87f516bccc32bbbc&wh_rate=null&src=http%3A%2F%2Fimgsrc.baidu.com%2Fforum%2Fpic%2Fitem%2Fb1f204d162d9f2d398ed608fa6ec8a136227ccdd.jpg";
        userParameter.customIconUrl = @"https://gss3.bdstatic.com/84oSdTum2Q5BphGlnYG/timg?wapp&quality=80&size=b150_150&subsize=20480&cut_x=0&cut_w=0&cut_y=0&cut_h=0&sec=1369815402&srctrace&di=9f46b42f94ad866a87f516bccc32bbbc&wh_rate=null&src=http%3A%2F%2Fimgsrc.baidu.com%2Fforum%2Fpic%2Fitem%2Fb1f204d162d9f2d398ed608fa6ec8a136227ccdd.jpg";
        [[ZegoRoomKit sharedInstance].inRoomService setUserParameter:userParameter];
    }
    
    [self setUIConfig];
    [self addScreenShare];
    
#if DEBUG
    UIPasteboard *pab = [UIPasteboard generalPasteboard];
    pab.string = self.quickJoinRoomID;
#endif
    
    [[ZegoRoomKit sharedInstance].inRoomService joinRoomWithConfig:config fromVC:fromVC completion:^(ZegoRoomKitError errorCode) {
        if (errorCode == 0) {
            self.progressHidden = YES;
            if(susBlock) susBlock();
        } else {
            if (errorCode == 36 || errorCode == 37) {
                // token 错误/失效，重新获取
                [TLToken getAccessTokenWithCompletion:^(NSString * _Nullable token) {
                    if (token && token.length) {
                        self.accessToken = token;
                        config.token = [TLToken getToken];
                        
                        // 重新试加入一次，再失败则报错
                        [[ZegoRoomKit sharedInstance].inRoomService joinRoomWithConfig:config fromVC:fromVC completion:^(ZegoRoomKitError errorCode) {
                            self.progressHidden = YES;
                            if (errorCode == 0) {
                                if(susBlock) susBlock();
                            } else {
                                NSError *error = [[NSError alloc] initWithDomain:@"TLNetworkDomain" code:errorCode userInfo:nil];
                                if(faiBlock) faiBlock(error);
                            }
                        }];
                    } else {
                        NSError *error = [[NSError alloc] initWithDomain:@"TLNetworkDomain" code:-100 userInfo:nil];
                        if(faiBlock) faiBlock(error);
                    }
                }];
                return;
            }
            self.progressHidden = YES;
            NSError *error = [[NSError alloc] initWithDomain:@"TLNetworkDomain" code:errorCode userInfo:nil];
            if(faiBlock) faiBlock(error);
        }
    }];
}

#pragma mark -- Manage room
- (void)refreshMeetingSettings {

}

- (void)createMeetingWithData:(NSDictionary *)data
                      showHUD:(BOOL)isShowhud
                      success:(void(^) (NSString *message))susBlock
                      failure:(void(^) (NSError *error))faiBlock{
    self.progressHidden = NO;
    NSDictionary *arrangeData = data;
    [TLOutRoomService createRoomWithDict:[self createRoomDictWithData:data] completion:^(NSInteger errorCode, NSDictionary * _Nullable data) {
        self.progressHidden = YES;
        if (errorCode == 0) {
            NSString *message = arrangeData[@"succeedMsg"];
            if(susBlock) susBlock(message);
        } else {
            NSString *message = arrangeData[@"failMsg"];
            if ([[NSUserDefaults standardUserDefaults] integerForKey:@"ZEGO_ENVIROMENT_FLAG"] == 1) {
                message = [NSString stringWithFormat:@"%@\nerrorCode: %ld", message, (long)errorCode];
            }
            NSError *error = [[NSError alloc] initWithDomain:@"TLNetworkDomain" code:errorCode userInfo:@{@"message" : message}];
            if(faiBlock) faiBlock(error);
        }
    }];
}

- (void)deleteMeeting:(NSDictionary *)classInfo
              showHUD:(BOOL)isShowhud
              success:(void(^) (void))susBlock
              failure:(void(^) (NSError *error))faiBlock{
    self.progressHidden = NO;
    @ZegoWeak(self)
    [TLOutRoomService deleteRoomWithDict:[self deleteRoomDictOfRoomID:classInfo[@"room_id"]] completion:^(NSInteger errorCode, NSDictionary * _Nullable data) {
        @ZegoStrong(self)
        self.progressHidden = YES;
        self.progressHidden = YES;
        if (errorCode == 0) {
            if(susBlock) susBlock();
        } else {
            NSError *error = [[NSError alloc] initWithDomain:@"TLNetworkDomain" code:errorCode userInfo:nil];
            if(faiBlock) faiBlock(error);
        }
    }];
}

- (void)getMeetingList:(BOOL)needScrollToBottom
               showHUD:(BOOL)isShowhud
               success:(void(^) (BOOL needScroll))susBlock
               failure:(void(^) (NSError *error))faiBlock{
    self.progressHidden = NO;
    @ZegoWeak(self)
    [TLOutRoomService listRoomWithDict:[self listRoomDict] completion:^(NSInteger errorCode, NSDictionary * _Nullable data) {
        @ZegoStrong(self)
        self.progressHidden = YES;
        if (errorCode == 0) {
            self.meetings = data[@"room_list"];
            if(susBlock) susBlock(needScrollToBottom);
        } else {
            NSError *error = [[NSError alloc] initWithDomain:@"TLNetworkDomain" code:errorCode userInfo:nil];
            if(faiBlock) faiBlock(error);
        }
    }];
}
- (void)getMeetingNoLoginList:(BOOL)needScrollToBottom
               showHUD:(BOOL)isShowhud
               success:(void(^) (BOOL needScroll))susBlock
               failure:(void(^) (NSError *error))faiBlock{
    NSString *getAccessTokenUrl = @"https://roomkit-api.zego.im/auth/get_access_token";
    NSString *nonce = @"asdasdss";
    NSDate* date = [NSDate dateWithTimeIntervalSinceNow:3600];
    NSTimeInterval second=[date timeIntervalSince1970];
    NSNumber *expire_second = [NSNumber numberWithString:[NSString stringWithFormat:@"%.0f",second]];
    //kSecretKey
    NSString *kSecretKey = @"b603ceb8bc33759759285e776b5178da";
    NSString *hashSrc =  [NSString stringWithFormat:@"%d%@%@%@",kSecretID,kSecretKey,nonce,expire_second];
    NSString *hash =  hashSrc.md5String;
    NSDictionary *param = @{
        @"ver":@1,
        @"hash":hash,
        @"nonce":nonce,
        @"expired":expire_second
    };
    NSString *token = [param mj_JSONString].base64EncodedString;

    NSDictionary *paramPost = @{
        @"secret_id": [NSNumber numberWithInt:kSecretID],
        @"token":token
    };
    //获取AccessToken
    [[HttpManager manager]jsonPost:getAccessTokenUrl param:paramPost success:^(NSData *data) {
        NSDictionary *dic = [data mj_JSONObject];
        if(![dic[@"ret"][@"code"] isEqualToNumber:@0]){
            NSError *error = [[NSError alloc] initWithDomain:@"TLNetworkDomain" code:1 userInfo:nil];
            if(faiBlock) faiBlock(error);
            return;
        }
            NSString *accessToken = dic[@"data"][@"access_token"];
            NSCalendar *calendar = [NSCalendar currentCalendar];
            NSDate *now = [NSDate date];
            NSDateComponents *components = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:now];
            NSDate *startDate = [calendar dateFromComponents:components];
            NSTimeInterval start = [startDate timeIntervalSince1970];
            NSDate *endDate = [calendar dateByAddingUnit:NSCalendarUnitDay value:1 toDate:startDate options:0];
            NSTimeInterval end = [endDate timeIntervalSince1970];
            NSDictionary *paramList = @{
                @"secret_id":[NSNumber numberWithInt:kSecretID],
                @"access_token":accessToken,
                @"pid":[NSNumber numberWithInt:kProductID],
                @"begin_timestamp":[NSNumber numberWithString:[NSString stringWithFormat:@"%.0f",start]],
                @"end_timestamp":[NSNumber numberWithString:[NSString stringWithFormat:@"%.0f",end]],
                @"page_no":@1,
                @"page_size":@99,
            };
            NSString *getProjectRooms = @"https://roomkit-api.zego.im/statistic/v2/room/get_project_rooms";
            [[HttpManager manager]jsonPost:getProjectRooms param:paramList success:^(NSData *datac) {
                NSDictionary *dicc = [datac mj_JSONObject];
                if(![dicc[@"ret"][@"code"] isEqualToNumber:@0]){
                    NSError *error = [[NSError alloc] initWithDomain:@"TLNetworkDomain" code:1 userInfo:nil];
                    if(faiBlock) faiBlock(error);
                    return;
                }
                if(![dicc[@"data"][@"records"] isKindOfClass:[NSNull class]]){
                    NSArray *arr = dicc[@"data"][@"records"];
                    NSMutableArray *modelArr = [NSMutableArray new];
                    for (NSDictionary *model in arr) {
                        NSDictionary *infoModel = [NSMutableDictionary dictionary];
                        NSNumber *pid =  model[@"pid"];
                        NSNumber *status =  model[@"status"];
                        [infoModel setValue: model[@"room_id"] forKey:@"room_id"];
                        [infoModel setValue:status forKey:@"state"];
                        [infoModel setValue:pid forKey:@"productID"];
                        [infoModel setValue:model[@"room_name"] forKey:@"subject"];
                        NSNumber *pre_begin_time = model[@"pre_begin_time"];
                        [infoModel setValue:[NSNumber numberWithInteger:pre_begin_time.integerValue * 10000] forKey:@"begin_timestamp"];
                        [infoModel setValue:model[@"host_name"] forKey:@"host_name"];
                        
                        if([model[@"status"] isEqualToNumber:@1] || [model[@"status"] isEqualToNumber:@2] ){
                            [modelArr addObject:infoModel];
                        }
                    }
                    self.meetings = modelArr;
                }
                if(susBlock) susBlock(NO);
                
            } faild:^(NSString *msg) {
                NSError *error = [[NSError alloc] initWithDomain:@"TLNetworkDomain" code:1 userInfo:nil];
                if(faiBlock) faiBlock(error);
            }];
            
        
    } faild:^(NSString *msg) {
        NSError *error = [[NSError alloc] initWithDomain:@"TLNetworkDomain" code:1 userInfo:nil];
        if(faiBlock) faiBlock(error);
    }];
    

}
- (void)queryMeeting:(NSDictionary *)data
             success:(void(^) (NSDictionary *dict))susBlock
             failure:(void(^) (NSError *error))faiBlock {
    @ZegoWeak(self)
    [TLOutRoomService queryRoomWithDict:[self queryRoomDictWithData:data] completion:^(NSInteger errorCode, NSDictionary * _Nullable data) {
        @ZegoStrong(self)
        if (errorCode == 0) {
            if(susBlock) susBlock(data);
        } else {
            NSError *error = [[NSError alloc] initWithDomain:@"TLNetworkDomain" code:errorCode userInfo:nil];
            if(faiBlock) faiBlock(error);
        }
    }];
}

#pragma mark - Private
- (void)addScreenShare {
    if (kZegoRPAppGroup.length > 0 && kAppExtensionBundleID.length > 0) {
        ZegoScreenShareConfig *screenShare = [ZegoScreenShareConfig new];
        screenShare.appGroupID = kZegoRPAppGroup;
        screenShare.appExtensionBundleID = kAppExtensionBundleID;
        [[ZegoRoomKit sharedInstance].inRoomService addShareScreenModule:screenShare];
    }
}

- (void)setUIConfig {
    [[ZegoRoomKit sharedInstance].inRoomService setUIConfig:[[TLMeetingUIConfig new] joinMeetingUIConfig]];
}

#pragma mark - getter
- (NSArray *)arrangeData {
    return @[
#ifdef ZEGO_ACCESS_ENV_FLAG
        @{@"name":TLLocalizedString(schedule_1v1),
          @"type":@(TLArrangeType1v1),
          @"succeedMsg": TLLocalizedString(schedule_1v1_succeeded),
          @"failMsg": TLLocalizedString(schedule_1v1_failed),
          @"defaultTitle": TLLocalizedString(schedule_1v1_default_title_placeholder)
        },
        @{@"name":TLLocalizedString(schedule_small_class),
          @"type":@(TLArrangeTypeSmallClass),
          @"succeedMsg": TLLocalizedString(schedule_small_class_succeeded),
          @"failMsg": TLLocalizedString(schedule_small_class_failed),
          @"defaultTitle": TLLocalizedString(schedule_small_class_default_title_placeholder)
        },
        @{@"name":TLLocalizedString(schedule_large_class),
          @"type":@(TLArrangeTypeLargeClass),
          @"succeedMsg": TLLocalizedString(schedule_large_class_succeeded),
          @"failMsg": TLLocalizedString(schedule_large_class_failed),
          @"defaultTitle": TLLocalizedString(schedule_large_class_default_title_placeholder)
        }
#else
        @{@"name":@"安排直播",
          @"type":@(TLArrangeTypeLargeClass),
          @"succeedMsg": TLLocalizedString(schedule_large_class_succeeded),
          @"failMsg": TLLocalizedString(schedule_large_class_failed),
          @"defaultTitle": TLLocalizedString(schedule_large_class_default_title_placeholder)
        }
#endif
    ];
}

@end
