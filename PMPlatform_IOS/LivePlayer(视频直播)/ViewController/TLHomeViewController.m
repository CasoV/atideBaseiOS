//
//  TLHomeViewController.m
//  ZegoRoomkitDemo
//
//  Created by KaelDing on 2020/7/15.
//  Copyright © 2020 zego. All rights reserved.
//

#import "TLHomeViewController.h"
#import "TLHomeHeaderView.h"
#import "TLSelectEnvView.h"
#import "TLLoginView.h"
#import "TLQuickJoinView.h"
#import "TLTestLoginView.h"
#import "TLMainPageView.h"
#import "TLArrangePopView.h"
#import "TLHomeViewModel.h"
#import <MBProgressHUD.h>
#import "TLManager.h"
#import "TLToken.h"
#import "TLSettingViewController.h"
#import "TLMeetingUIConfig.h"
#import <objc/message.h>
#import "UIAlertController+Leaks.h"
#import "TLPopupSettingView.h"
#import "TLSelectEnvView.h"
#import "TLNotLoginTopView.h"
#import "MBProgressHUD+TL.h"
#import "AddLiveRoomViewController.h"
#import "TLMeetingSettingViewModel.h"
#import "TLUISettingViewModel.h"

@interface TLHomeViewController () <TLNotLoginTopViewDelegate, UIScrollViewDelegate, ZegoInRoomServiceDelegate>

@property (nonatomic, strong) TLNotLoginTopView *topView;
@property (nonatomic, strong) TLTestLoginView *testLoginView;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) TLQuickJoinView *quickJoinView;
@property (nonatomic, strong) TLSelectEnvView *selectEnvView;
@property (nonatomic, strong) TLMainPageView *mainView;
@property (nonatomic, strong) TLArrangePopView *arrangeView;
@property (nonatomic, strong) UIView *minimizeView;

@property (nonatomic, strong) TLHomeViewModel *viewModel;


@property (nonatomic, strong) TLMeetingSettingViewModel *setingViewModel;
@property (nonatomic, strong) TLUISettingViewModel *uiViewModel;

@end

@implementation TLHomeViewController

#pragma mark - life cycle

- (instancetype)init {
    self = [super init];
    if (self) {
#ifdef ZEGO_ACCESS_ENV_FLAG
        [ZegoEnviromentManager setAccessEnv:1];
#endif
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = TLLocalizedString(main_page);
    
    [self bindViewModel];
    [self configUI];
    [self addGesture];
    [self getToken];
    
    if(self.isCreate){
        [self startLogin:NO];
        self.setingViewModel.meetingSetting.isMicrophoneOnWhenJoiningRoom = YES;
        self.setingViewModel.meetingSetting.isCameraOnWhenJoiningRoom = YES;
        self.uiViewModel.uiConfig.isCameraHidden = NO;
        self.uiViewModel.uiConfig.isMicrophoneHidden = NO;
    }else{
        [self logout];
        self.viewModel.role = 2;//观众
        self.setingViewModel.meetingSetting.isMicrophoneOnWhenJoiningRoom = NO;
        self.setingViewModel.meetingSetting.isCameraOnWhenJoiningRoom = NO;
        self.uiViewModel.uiConfig.isCameraHidden = YES;
        self.uiViewModel.uiConfig.isMicrophoneHidden = YES;
    }
    ZegoRoomKit.sharedInstance.inRoomService.delegate = self;
    
    
    

    
}
- (TLMeetingSettingViewModel *)setingViewModel {
    if (!_setingViewModel) {
        _setingViewModel = [TLMeetingSettingViewModel new];
    }
    return _setingViewModel;
}

- (TLUISettingViewModel *)uiViewModel {
    if (!_uiViewModel) {
        _uiViewModel = [TLUISettingViewModel new];
    }
    return _uiViewModel;
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self refreshUI];
    [self reAdjustScrollViewContentOffset];
#ifdef ZEGO_ACCESS_ENV_FLAG
    [self.selectEnvView selectEnv:[ZegoEnviromentManager getAccessEnv]];
#endif
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self getMeetingList];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)dealloc {
    //移除观察者
    [self.quickJoinView removeObserver:self forKeyPath:@"quickJoinRoomID" context:nil];
    [self.quickJoinView removeObserver:self forKeyPath:@"quickJoinName" context:nil];
    [self.testLoginView removeObserver:self forKeyPath:@"testLoginId" context:nil];
    [self.testLoginView removeObserver:self forKeyPath:@"testLoginName" context:nil];
    [self.viewModel removeObserver:self forKeyPath:@"meetings" context:nil];
    [self.viewModel removeObserver:self forKeyPath:@"arrangeData" context:nil];
    [self.viewModel removeObserver:self forKeyPath:@"progressHidden" context:nil];
    [self.viewModel removeObserver:self forKeyPath:@"roomType" context:nil];
    [self.viewModel removeObserver:self forKeyPath:@"role" context:nil];
}

#pragma mark - add KVO
- (void)addObservers{
    // 绑定viewModel的相关数据
    [self.viewModel addObserver:self forKeyPath:@"progressHidden" options:NSKeyValueObservingOptionNew context:nil];
    [self.viewModel addObserver:self forKeyPath:@"meetings" options:NSKeyValueObservingOptionNew context:nil];
    [self.viewModel addObserver:self forKeyPath:@"arrangeData" options:NSKeyValueObservingOptionNew context:nil];
    [self.viewModel addObserver:self forKeyPath:@"roomType" options:NSKeyValueObservingOptionNew context:nil];
    [self.viewModel addObserver:self forKeyPath:@"role" options:NSKeyValueObservingOptionNew context:nil];
    [self.quickJoinView addObserver:self forKeyPath:@"quickJoinRoomID" options:NSKeyValueObservingOptionNew context:nil];
    [self.quickJoinView addObserver:self forKeyPath:@"quickJoinName" options:NSKeyValueObservingOptionNew context:nil];
    [self.testLoginView addObserver:self forKeyPath:@"testLoginId" options:NSKeyValueObservingOptionNew context:nil];
    [self.testLoginView addObserver:self forKeyPath:@"testLoginName" options:NSKeyValueObservingOptionNew context:nil];
}
//回调方法
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if([keyPath isEqualToString:@"progressHidden"] && object == self.viewModel){
        if([[change valueForKey:@"new"] boolValue])
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        else
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        return;
    }
        
    if (!keyPath || keyPath.length==0) return;
    
    NSString *dealString = [keyPath stringByReplacingCharactersInRange:NSMakeRange(0,1) withString:[[keyPath substringToIndex:1] capitalizedString]];
    NSString *methodName = [NSString stringWithFormat:@"set%@:",dealString];
    SEL setSEL = NSSelectorFromString(methodName);
    
    if (object == self.quickJoinView || object == self.testLoginView) {
        if(![self.viewModel respondsToSelector:setSEL]) return;
        ((void(*)(id, SEL, id))objc_msgSend)(self.viewModel, setSEL, [change valueForKey:@"new"]);
    } else if (object == self.viewModel) {
        if([self.mainView respondsToSelector:setSEL] && [keyPath isEqualToString:@"meetings"])
            ((void(*)(id, SEL, id))objc_msgSend)(self.mainView, setSEL, [change valueForKey:@"new"]);
        else if ([self.arrangeView respondsToSelector:setSEL] && [keyPath isEqualToString:@"arrangeData"]){
            ((void(*)(id, SEL, id))objc_msgSend)(self.arrangeView, setSEL, [change valueForKey:@"new"]);
        }
    }
    
    NSArray *tmp = @[@"quickJoinRoomID", @"quickJoinName", @"roomType", @"role"];
    if ([tmp containsObject:keyPath]) {
        BOOL haveRoomType = YES;
#ifdef ZEGO_ACCESS_ENV_FLAG
        haveRoomType = self.viewModel.roomType;
#endif
        BOOL isJoinButtonEnabled = self.quickJoinView.quickJoinName.length > 0 && self.quickJoinView.quickJoinRoomID.length > 0 && haveRoomType > 0 && self.viewModel.role > 0;
        [self.quickJoinView updateJoinButtonToEnable:isJoinButtonEnabled];
    }
}

- (void)configUI {
//    [self.view addSubview:self.topView];
    [self.view addSubview:self.scrollView];
    [self.view addSubview:self.mainView];
    [self.view addSubview:self.arrangeView];
    [self.scrollView addSubview:self.quickJoinView];
    [self.scrollView addSubview:self.testLoginView];
    
//    [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.right.equalTo(self.view);
//        make.top.equalTo(self.view).offset(TOP_BAR_HEIGHT+18);
//        make.height.mas_equalTo(29);
//    }];
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.equalTo(self.view.mas_top).mas_offset(kStatusBarH + kNavBarH + 39);
    }];
    [self.testLoginView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self.scrollView);
        make.left.equalTo(self.quickJoinView.mas_right);
        make.height.equalTo(self.scrollView);
        make.width.mas_equalTo(SCREEN_WIDTH);
        make.right.equalTo(self.scrollView);
    }];
    [self.quickJoinView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.equalTo(self.scrollView);
        make.height.equalTo(self.scrollView);
        make.width.mas_equalTo(SCREEN_WIDTH);
    }];
    
    [self.mainView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
#ifdef ZEGO_ACCESS_ENV_FLAG
    [self.view insertSubview:self.selectEnvView belowSubview:self.mainView];
    [self.selectEnvView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).mas_offset(30);
        make.right.equalTo(self.view).mas_offset(-30);
        make.bottom.equalTo(self.view.mas_bottom).mas_offset(-30);
        make.height.mas_equalTo(66);
    }];
    
    // 适配小屏幕手机，底部切换环境隐藏
    [self.view layoutIfNeeded];
    CGFloat topMargin = [self.quickJoinView convertRect:self.quickJoinView.frame toView:self.view].origin.y;
    CGFloat bottom = topMargin + self.quickJoinView.bottomPoint;
    if (bottom > SCREEN_HEIGHT - self.selectEnvView.height - 30) {
        self.selectEnvView.hidden = YES;
    }
#endif
    
    [self refreshUI];
}

- (void)refreshUI {
    BOOL isLogin = [[TLManager sharedInstance] isLogin];
    self.mainView.hidden = false;
    self.quickJoinView.hidden = true;
    self.scrollView.hidden = true;
    self.topView.hidden = true;
    
    UIBarButtonItem *settingItem = [[UIBarButtonItem alloc] initWithTitle:TLLocalizedString(setting) style:UIBarButtonItemStylePlain target:self action:@selector(settingItemAction:)];
    if (isLogin) {
        self.navigationItem.title = TLLocalizedString(main_page);
        UIBarButtonItem *scheduleItem = [[UIBarButtonItem alloc] initWithTitle:TLLocalizedString(main_schedule) style:UIBarButtonItemStylePlain target:self action:@selector(scheduleItemAction:)];
//        self.navigationItem.leftBarButtonItem = settingItem;
        self.navigationItem.rightBarButtonItem = scheduleItem;
        self.navigationItem.rightBarButtonItem.tintColor = UIColorHex(#2953ff);
    } else {
        self.navigationItem.title = @"加入直播间";
        self.navigationItem.leftBarButtonItem = nil;
        self.navigationItem.rightBarButtonItem = nil;
        self.navigationItem.rightBarButtonItem.tintColor = UIColorHex(#000000);
        
        self.viewModel.meetings = @[];
        
        //刷新meetingSetting
        [self.viewModel refreshMeetingSettings];
    }
}

- (void)addGesture {
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onGestureTap:)];
    tap.numberOfTapsRequired = 1;
    [self.quickJoinView addGestureRecognizer:tap];
}

- (void)bindViewModel {
    [self addObservers];
    NSArray *data = self.viewModel.arrangeData;
    self.viewModel.arrangeData = data;
    
    @ZegoWeak(self)
    //快速加入
    self.quickJoinView.quickJoinBlock = ^{
        @ZegoStrong(self)
        if (!self.viewModel.quickJoinName.length || !self.viewModel.quickJoinRoomID.length) {
            [MBProgressHUD showError:TLLocalizedString(quick_join_failed_id_nickname_empty) withFinishBlock:nil];
            return;
        }
        [self.view endEditing:YES];
        TLManager.sharedInstance.userName = self.viewModel.quickJoinName;
        [self quickJoinMeeting];
    };
    
    //测试登录
    self.testLoginView.testLoginBlock = ^{
        @ZegoStrong(self)
        if (self.viewModel.testLoginId.length == 0) {
            [MBProgressHUD showError:TLLocalizedString(quick_join_failed_id_nickname_empty) withFinishBlock:nil];
            return;
        }
        [self.view endEditing:YES];
        [self startTestLoginWithUserID:self.viewModel.testLoginId];
    };
    
    //自动登录
    self.quickJoinView.createBlock = ^{
        @ZegoStrong(self)
        [self startLogin:NO];
    };
    
    //安排会议
    self.arrangeView.arrangeblock = ^(NSDictionary * _Nonnull selectedData){
        @ZegoStrong(self)
#ifdef ZEGO_ENVIROMENT_FLAG
        [self showCreateMeetingAlertWithData:selectedData];
#else
        NSMutableDictionary *tmp = [selectedData mutableCopy];
        [tmp setObject:@(2) forKey:@"maxOnStageCount"];
        [self createMeeting:tmp];
#endif
    };
    
    //删除会议
    self.mainView.closeMeetingBlock = ^(NSDictionary * _Nullable x) {
        @ZegoStrong(self)
        [self deleteMeeting:x];
    };
    
    //加入会议
    self.mainView.joinMeetingBlock = ^(NSDictionary * _Nullable x) {
        @ZegoStrong(self)
        if(![[TLManager sharedInstance] isLogin]){
            TLManager.sharedInstance.userName = [UserInfo getInstance].name;
            self.viewModel.quickJoinRoomID = x[@"room_id"];
            self.viewModel.roomType = 3;
            [self quickJoinMeeting];
            return;
        }
        TLManager.sharedInstance.userName = self.viewModel.quickJoinName;
        [self joinMeeting:x];
    };

    //下拉刷新
    self.mainView.refreshMeetingsBlock = ^{
        @ZegoStrong(self)
        [self getMeetingList];
    };
    
    // 选择房间类型
    self.quickJoinView.selectTypeBlock = ^{
        @ZegoStrong(self)
        TLPopupSettingView *setting = [TLPopupSettingView addPopupSettingViewWithTitle:TLLocalizedString(quick_join_select_room_type_title)
                                                                               options:[self selectTypeOptions]
                                                                                onView:self.navigationController.view];
        setting.actionBlock = ^(NSInteger index) {
            self.viewModel.roomType = index;
            [self.quickJoinView setRoomTypeTitle:[self typeTitleOfIndex:index]];
        };
    };
    
    // 选择角色
    self.quickJoinView.selectRoleBlock = ^{
        @ZegoStrong(self)
        TLPopupSettingView *setting = [TLPopupSettingView addPopupSettingViewWithTitle:TLLocalizedString(quick_join_select_role_title)
                                                                               options:[self selectRoleOptions]
                                                                                onView:self.navigationController.view];
        setting.actionBlock = ^(NSInteger index) {
            self.viewModel.role = index;
            [self.quickJoinView setRoleTitle:[self roleTitleOfIndex:index]];
        };
    };
    
#ifdef ZEGO_ACCESS_ENV_FLAG
    // 选择接入环境
    self.selectEnvView.selectEnvBlock = ^(NSInteger env) {
        @ZegoStrong(self)
        self.viewModel.env = env;
        [ZegoEnviromentManager setAccessEnv:env];
    };
#endif
}

#pragma mark - Private
- (void)startLogin:(BOOL)isTestLogin {
    [TLManager sharedInstance].isLogin = YES;
    TLManager.sharedInstance.userID = 0;
    TLManager.sharedInstance.userName = nil;
    [self refreshUI];
    [self getMeetingList];
}

- (void)startTestLoginWithUserID:(NSString *)userID {
    [TLManager sharedInstance].isLogin = YES;
    self.viewModel.userID = [userID integerValue];
    [self refreshUI];
    [self getMeetingList];
}

- (void)reLogin {
    if (![TLManager sharedInstance].isLogin) return;
    
    //重新获取token
    if (self.viewModel.accessToken.length == 0) {
        [self getToken];
        return;
    }
    
    [self.viewModel reLogin:^{
        [self getMeetingList];  ;
    } failure:^(ZegoRoomKitError error) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self reLogin];
        });
    }];
}

- (void)showCreateMeetingAlertWithData:(NSDictionary *)data {
    NSInteger type = [data[@"type"] integerValue];
    NSMutableDictionary *tmp = [data mutableCopy];
    @ZegoWeak(self)
    if (type == ZegoRoomTypeLargeRoom) {
        [UIAlertController showAlertWithTitle:@"设置【大班课】最大上台数"
                                      message:@"设置范围 [1,4], 不设置/设置错误/其他房间类型均默认为 2"
                                 cancelAction:^(UIAlertAction *action, NSString *content) {
        }
                                confirmAction:^(UIAlertAction *action, NSString *content)
                                  {
            @ZegoStrong(self)
            NSInteger count = [content integerValue];
            if (content.length == 0 || [content integerValue] < 1 || [content integerValue] > 4) {
                count = 2;
            }
            [tmp setObject:@(count) forKey:@"maxOnStageCount"];
            [self createMeeting:tmp];
        }
                                 onController:self
                                  placeHolder:@"不设置默认为 2"
        ];
    } else {
        [tmp setObject:@2 forKey:@"maxOnStageCount"];
        [self createMeeting:tmp];
    }
}

- (void)createMeeting:(NSDictionary *)data {
    [self.viewModel createMeetingWithData:data showHUD:YES success:^(NSString * _Nonnull message) {
        [self getMeetingListWithNeedScrollToBottom:YES];
        [MBProgressHUD showSuccess:message withFinishBlock:nil];
    } failure:^(NSError * _Nonnull error) {
        if (error.code == 4000007) {
            [self showLoginExpiredAlert];
            return;
        }
        NSString *message = error.userInfo[@"message"];
        [MBProgressHUD showSuccess:message withFinishBlock:nil];
    }];
}

- (void)deleteMeeting:(NSDictionary *)meeting {
    [self.viewModel deleteMeeting:meeting showHUD:YES success:^{
        [self getMeetingList];
        [MBProgressHUD showSuccess:TLLocalizedString(room_delete_succeeded) withFinishBlock:nil];
    } failure:^(NSError * _Nonnull error) {
        if (error.code == 4000007) {
            [self showLoginExpiredAlert];
            return;
        }
        NSString *message = TLLocalizedString(room_delete_failed);
        [MBProgressHUD showSuccess:message withFinishBlock:nil];
    }];
}

- (void)joinMeeting:(NSDictionary *)meeting {
    NSDictionary *input = @{@"meeting" : meeting, @"fromVC" : self};
    [self.viewModel joinMeetingWithData:input showHUD:YES success:nil failure:^(NSError * _Nonnull error) {
        NSString *message = TLLocalizedString(room_join_failed);
        if (error.code == 4000007) {
            [self showLoginExpiredAlert];
            return;
        } else if (error.code == 20053) {
            // 助教已满
            message = TLLocalizedString(enter_1v1_room_fail_assitant_exist);
        } else if (error.code == 20070) {
            // 普通成员已满
            message = TLLocalizedString(enter_1v1_room_fail_attendee_exist);
        }
        [MBProgressHUD showSuccess:message withFinishBlock:nil];
    }];
}

- (void)quickJoinMeeting {
    NSDictionary *input = @{@"roomID": self.viewModel.quickJoinRoomID,
                            @"roomType": @(self.viewModel.roomType)};
    [self.viewModel queryMeeting:input success:^(NSDictionary * _Nonnull dict) {
        NSLog(@"query meeting succeeded: %@", dict);
        ZegoRoomParameter *roomParam = [ZegoRoomParameter new];
        roomParam.subject = dict[@"subject"];
        roomParam.beginTimestamp = [dict[@"begin_timestamp"] doubleValue];
        roomParam.duration = [dict[@"duration"] integerValue];
        roomParam.hostNickname = [NSString stringWithFormat:@"%@", dict[@"host"][@"uid"]];

        [[ZegoRoomKit sharedInstance].inRoomService setRoomParameter:roomParam];
        
        [self quickJoin];
    } failure:^(NSError * _Nonnull error) {
        NSLog(@"query meeting failed: %@", error);
        [self quickJoin];
    }];
}

- (void)quickJoin {
    NSDictionary *input = @{@"fromVC" : self};
    [self.viewModel quickJoinMeetingWithData:input showHUD:YES success:nil failure:^(NSError * _Nonnull error) {
        NSString *message = TLLocalizedString(room_join_failed);
        if (error.code == ZegoRoomKitErrorNameError) {
            message = TLLocalizedString(quick_join_failed_nickname_exceed_limit);
        } else if (error.code == ZegoRoomKitErrorTokenError){
            // TODO:
        } else if (error.code == 20070) {
            // 普通成员已满
            message = TLLocalizedString(enter_1v1_room_fail_attendee_exist);
        }
        [MBProgressHUD showSuccess:message withFinishBlock:nil];
    }];
}

- (void)getMeetingList {
    [self getMeetingListWithNeedScrollToBottom:NO];
}

- (void)getMeetingListWithNeedScrollToBottom:(BOOL)needScrollToBottom {
    //未登录
    if (![[TLManager sharedInstance] isLogin]){
        [self.viewModel getMeetingNoLoginList:needScrollToBottom showHUD:NO success:^(BOOL needScroll) {
            [self.mainView endRefresh];
            [LEEAlert closeWithCompletionBlock:^{}];
        } failure:^(NSError * _Nonnull error) {
            [self.mainView endRefresh];
            [MBProgressHUD showSuccess:@"请求失败！" withFinishBlock:nil];
        }];
        return;
    }
    
    [self.viewModel getMeetingList:needScrollToBottom showHUD:NO success:^(BOOL needScroll) {
        [self.mainView endRefresh];
        [LEEAlert closeWithCompletionBlock:^{}];
        if (needScroll) {
            [self.mainView scrollToBottom];
        }
    } failure:^(NSError * _Nonnull error) {
        [self.mainView endRefresh];
        if (error.code == 4000007) {
            [self showLoginExpiredAlert];
            return;
        }
        NSString *message = TLLocalizedString(room_list_failed);
        [MBProgressHUD showSuccess:message withFinishBlock:nil];
    }];
}

- (void)getToken {
    @ZegoWeak(self)
    [TLToken getAccessTokenWithCompletion:^(NSString * _Nullable token) {
        @ZegoStrong(self)
        self.viewModel.accessToken = token;
        [TLToken saveToken:token];
    }];
}

- (void)showLoginExpiredAlert {
    [LEEAlert alert].config.LeeTitle(TLLocalizedString(login_status_expire)).LeeContent(TLLocalizedString(login_status_expire_relogin)).LeeAction(TLLocalizedString(confirm), ^{
        [self logout];
    }).LeeShow();
}

- (void)logout {
    [[TLManager sharedInstance] logout];
    [self refreshUI];
//    NSString *message = TLLocalizedString(login_failed_retry);
//    [MBProgressHUD showSuccess:message withFinishBlock:nil];
//    [LEEAlert alert].config.LeeContent(message).LeeClickBackgroundClose(YES).LeeShow();
}

- (NSString *)typeTitleOfIndex:(NSInteger)index {
    return [self titleOfIndex:index fromSource:[self selectTypeOptions]];
}

- (NSString *)roleTitleOfIndex:(NSInteger)index {
    return [self titleOfIndex:index fromSource:[self selectRoleOptions]];
}

- (NSString *)titleOfIndex:(NSInteger)index fromSource:(NSArray *)array {
    for (NSDictionary *dict in array) {
        if ([dict[@"tag"] integerValue] == index) {
            return dict[@"title"];
        }
    }
    return @"";
}

- (void)reAdjustScrollViewContentOffset {
    if ([TLManager sharedInstance].isLogin) return;
    CGFloat offsetX = self.scrollView.contentOffset.x;
    NSUInteger tag = offsetX / SCREEN_WIDTH;
    CGFloat x = tag * SCREEN_WIDTH;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.scrollView setContentOffset:CGPointMake(x, 0) animated:YES];
    });
}

#pragma mark - action
- (void)settingItemAction:(UIBarButtonItem *)item {
    self.arrangeView.hidden = YES;
    TLSettingViewController *settingVC = [TLSettingViewController new];
    
    @ZegoWeak(self)
    settingVC.quickJoinRoomBlock = ^(NSString *roomID) {
        @ZegoStrong(self)
        ZegoRoomDetailInfo *info = [ZegoRoomDetailInfo new];
        info.roomID = roomID;
        [self joinMeeting:info];
    };
    [self.navigationController pushViewController:settingVC animated:YES];
}
- (void)scheduleItemAction:(UIBarButtonItem *)item {
//    self.arrangeView.hidden = !self.arrangeView.hidden;
    AddLiveRoomViewController *vc = [[UIStoryboard storyboardWithName:@"Live" bundle:nil]instantiateViewControllerWithIdentifier:@"AddLiveRoomViewController"];
    vc.viewModel = self.viewModel;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)onGestureTap:(UITapGestureRecognizer *)tap {
    [self.quickJoinView resignFirstResponder];
}
    
#pragma mark - TLNotLoginTopViewDelegate
- (void)notLoginTopViewDidClickWithActionButton:(UIButton *)sender {
    CGFloat x = sender.tag * SCREEN_WIDTH;
    [self.scrollView setContentOffset:CGPointMake(x, 0) animated:YES];
    [self.view endEditing:YES];
}
    
#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    //计算位置
    CGFloat offsetX = scrollView.contentOffset.x;
    NSUInteger tag = offsetX / SCREEN_WIDTH;
    [self.topView selectTopViewActionButtonWithType:tag];
}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self.view endEditing:YES];
}

#pragma mark - ZegoInRoomServiceDelegate
- (void)onInRoomEventNotify:(ZegoRoomEvent)event roomID:(NSString *)roomID{
    switch (event) {
        case ZegoRoomEventMinimize:
            [self showMinimizeView:YES];
            break;
        case ZegoRoomEventEnded:
            [self showMinimizeView:NO];
            break;
        case ZegoRoomEventMemberLeft:
            [self showMinimizeView:NO];
            break;
        default:
            break;
    }
}

- (void)showMinimizeView:(BOOL)isShow{
    [self.mainView showMinimizeTip:isShow];
    
    if(isShow){
        ZegoRoomKit.sharedInstance.inRoomService.getCurrentVideoView.bottom = ZegoKeyWindow.bottom - 16;
        ZegoRoomKit.sharedInstance.inRoomService.getCurrentVideoView.left = ZegoKeyWindow.left + 16;
        [ZegoKeyWindow addSubview:ZegoRoomKit.sharedInstance.inRoomService.getCurrentVideoView];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(displayRoomViewFromVC)];
        [ZegoRoomKit.sharedInstance.inRoomService.getCurrentVideoView addGestureRecognizer:tap];
    }
}

- (void)displayRoomViewFromVC{
    [ZegoRoomKit.sharedInstance.inRoomService displayRoomViewFromVC:self];
}

- (void)onButtonEventWithType:(ZegoButtonEventType)type {
    if (type == ZegoButtonEventTypeInvite) {
        NSLog(@"invite...");
    }
}

#pragma mark - getter
- (TLNotLoginTopView *)topView {
    if (!_topView) {
        _topView = [TLNotLoginTopView new];
        _topView.delegate = self;
    }
    return _topView;
}

- (TLTestLoginView *)testLoginView {
    if (!_testLoginView) {
        _testLoginView = [TLTestLoginView new];
    }
    return _testLoginView;
}
    
- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [UIScrollView new];
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.pagingEnabled = YES;
        _scrollView.delegate = self;
#ifndef HAVE_TEST_LOGIN
        _scrollView.scrollEnabled = NO;
#endif
    }
    return _scrollView;
}

- (TLArrangePopView *)arrangeView {
    if (!_arrangeView) {
        _arrangeView = [[TLArrangePopView alloc] initWithFrame:self.view.bounds
                                                 showViewFrame:CGRectMake(kScreenWidth - (20 + 220) * 0.5,
                                                                          39 + kTLTopStatusBarHeight,
                                                                          110,
#ifdef ZEGO_ACCESS_ENV_FLAG
                                                                          131
#else
                                                                          131 - 80
#endif
                                                                          )
                                                   clickHidden:YES];
        _arrangeView.hidden = YES;
    }
    return _arrangeView;
}
- (TLQuickJoinView *)quickJoinView {
    if (!_quickJoinView) {
        _quickJoinView = [TLQuickJoinView new];
    }
    return _quickJoinView;
}

- (TLMainPageView *)mainView {
    if (!_mainView) {
        _mainView = [TLMainPageView new];
        @ZegoWeak(self);
        _mainView.joinRoomBlock = ^{
            @ZegoStrong(self);
            [ZegoRoomKit.sharedInstance.inRoomService displayRoomViewFromVC:self];
        };
        [_mainView showMinimizeTip:NO];
    }
    return _mainView;
}

- (TLSelectEnvView *)selectEnvView {
    if (!_selectEnvView) {
        _selectEnvView = [[TLSelectEnvView alloc] initWithSelectedEnv:self.viewModel.env];
    }
    return _selectEnvView;
}

- (TLHomeViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [TLHomeViewModel new];
    }
    return _viewModel;
}

- (NSArray *)selectTypeOptions {
    return @[
        @{@"title": TLLocalizedString(quick_join_select_room_type_1v1),
          @"isSelected": @(self.viewModel.roomType == 3),
          @"tag": @3,
        },
        @{@"title": TLLocalizedString(quick_join_select_room_type_small),
          @"isSelected": @(self.viewModel.roomType == 4),
          @"tag": @1,
        },
        @{@"title": TLLocalizedString(quick_join_select_room_type_large),
          @"isSelected": @(self.viewModel.roomType == 5),
          @"tag": @5,
        }
    ];
}

- (NSArray *)selectRoleOptions {
    return @[
        @{@"title": TLLocalizedString(quick_join_select_role_attendee),
          @"isSelected": @(self.viewModel.role == 2),
          @"tag": @2,
        },
        @{@"title": TLLocalizedString(quick_join_select_role_assistant),
          @"isSelected": @(self.viewModel.role == 4),
          @"tag": @4,
        },
        @{@"title": TLLocalizedString(quick_join_select_role_host),
          @"isSelected": @(self.viewModel.role == 1),
          @"tag": @1,
        },
    ];
}
@end
