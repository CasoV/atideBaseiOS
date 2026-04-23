//
//  TLSettingViewController.m
//  ZegoRoomkitDemo
//
//  Created by Kael Ding on 2020/7/17.
//  Copyright © 2020 zego. All rights reserved.
//

#import "TLSettingViewController.h"
#import "TLSettingViewModel.h"
#import "TLSettingCell.h"
#import "TLManager.h"
#import "TLMeetingSettingViewController.h"
#import "TLUISettingViewController.h"
#import "TLTestSettingViewController.h"
#import <LEEAlert/LEEAlert.h>
#import "UIAlertController+Leaks.h"
#import "TLFeedbackViewController.h"
#import "NSString+Utility.h"
#import "TLPopupSettingView.h"
#import "MBProgressHUD+TL.h"

@interface TLSettingViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) TLSettingViewModel *viewModel;

@end

static NSString *reuseIdentifier = @"TLSettingCellReuseIdentifier";

@implementation TLSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setupActions];
    [self configUI];
    [self configNavigationBar];
}

- (void)configUI {
    [self.tableView registerClass:[TLSettingCell class] forCellReuseIdentifier:reuseIdentifier];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.equalTo(self.view).offset(TOP_BAR_HEIGHT);
    }];
}

- (void)configNavigationBar {
    self.navigationItem.title = TLLocalizedString(setting);
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nav_back"] style:UIBarButtonItemStylePlain target:self action:@selector(leftItemClick:)];
    self.navigationItem.leftBarButtonItems = @[leftItem];
}

- (void)setupActions {
    @ZegoWeak(self)
    
    //会议设置
    self.viewModel.meetingSettingBlock = ^{
        @ZegoStrong(self)
        TLMeetingSettingViewController *vc = [TLMeetingSettingViewController new];
        [self.navigationController pushViewController:vc animated:YES];
    };
    
    //自定义UI
    self.viewModel.uiSettingBlock = ^{
        @ZegoStrong(self)
        TLUISettingViewController *vc = [TLUISettingViewController new];
        [self.navigationController pushViewController:vc animated:YES];
    };
    
    //测试设置
    self.viewModel.testSettingBlock = ^{
        @ZegoStrong(self)
        TLTestSettingViewController *vc = [TLTestSettingViewController new];
        [self.navigationController pushViewController:vc animated:YES];
    };
    
    //上传日志
    self.viewModel.uploadLogBlock = ^{
        @ZegoStrong(self)
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [ZegoRoomKit uploadLog:[NSString logFileName]
                    completion:^(ZegoRoomKitError error) {
            [MBProgressHUD hideHUDForView:self.view animated:NO];
            if (error == 0) {
                [MBProgressHUD showSuccess:TLLocalizedString(setting_upload_log_succeeded) withFinishBlock:nil];
            } else {
                NSString *message = [NSString stringWithFormat:TLLocalizedString(setting_upload_log_failed), (long)error];
                [MBProgressHUD showSuccess:message withFinishBlock:nil];
            }
        }];
    };
    
    // 意见反馈
    self.viewModel.feedbackBlock = ^{
        @ZegoStrong(self)
        TLFeedbackViewController *fb = [TLFeedbackViewController new];
        fb.webTitle = TLLocalizedString(setting_feedback);
        NSString *domain = @"https://demo-operation.zego.im";
        NSString *path= @"feedback/roomkit/index.html";
        NSString *fileName = [NSString logFileName];
        NSDictionary *params = @{
            @"platform": @"4",
            @"system_version": [NSString systemVersion],
            @"app_version": [NSString appVersion],
            @"sdk_version": [ZegoRoomKit version],
            @"device_id": [ZegoRoomKit deviceID],
            @"log_filename":fileName,
            @"client":[NSString getDeviceName],
        };
        NSString *paramsStr = [NSString paramStrFromDict:params];
        NSString *url = [NSString stringWithFormat:@"%@/%@?%@", domain, path, paramsStr];
        NSLog(@"feedback url: %@", url);
        fb.urlString = url;
        fb.logFileName = fileName;
        [self.navigationController pushViewController:fb animated:YES];
    };
    
    // 清除缓存
    self.viewModel.clearCacheBlock = ^{
        @ZegoStrong(self)
        [self clearCache];
        [MBProgressHUD showSuccess:TLLocalizedString(setting_clear_cache_finished) withFinishBlock:nil];
    };
    
    //退出登录
    self.viewModel.loginoutBlock = ^ {
        @ZegoStrong(self)
        [[TLManager sharedInstance] logout];
        [self.navigationController popViewControllerAnimated:YES];
    };
    
    // 接入环境
    self.viewModel.accessEnvBlock = ^{
        @ZegoStrong(self)
        TLPopupSettingView *setting = [TLPopupSettingView addPopupSettingViewWithTitle:TLLocalizedString(quick_join_access_env)
                                                                               options:[self selectAccessEnvOptions]
                                                                                onView:self.navigationController.view];
        setting.actionBlock = ^(NSInteger index) {
#ifdef ZEGO_ACCESS_ENV_FLAG
            [ZegoEnviromentManager setAccessEnv:index];
#endif
        };
    };
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.viewModel.dataSource.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.viewModel.dataSource[section] count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    TLSettingCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    
    TLSettingCellConfig *config = self.viewModel.dataSource[indexPath.section][indexPath.row];
    cell.config = config;
    
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 57;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *header = [UIView new];
    header.backgroundColor = [UIColor colorWithHexString:@"f5f5f5"];
    return header;
}
#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if(self.viewModel.dataSource[indexPath.section][indexPath.row].actionBlock){
        self.viewModel.dataSource[indexPath.section][indexPath.row].actionBlock();
    }
}

#pragma mark - Private

- (void)clearCache {
    NSString *filePath = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES).firstObject stringByAppendingPathComponent:@"ZGDownloadCache"];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSLog(@"clear cache, path: %@", filePath);
        [self removeFileWithPath:filePath];
    });
}

- (void)removeFileWithPath:(NSString *)directoryPath {
    //获取文件管理者
    NSFileManager *mgr = [NSFileManager defaultManager];
    BOOL isDirectoey;
    BOOL isExist = [mgr fileExistsAtPath:directoryPath isDirectory:&isDirectoey];
    //获取cache文件夹下所有文件，不包括子路径的子路径
    NSArray *subPaths = [mgr contentsOfDirectoryAtPath:directoryPath error:nil];
    for (NSString *subPath in subPaths) {
        //拼接完整路径
        NSString *filePath = [directoryPath stringByAppendingPathComponent:subPath];
        //删除路径
        [mgr removeItemAtPath:filePath error:nil];
    }
}

#pragma mark - action
- (void)leftItemClick:(UIBarButtonItem *)item {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - getter
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.estimatedRowHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.tableFooterView = [UIView new];
        _tableView.backgroundColor = [UIColor colorWithHexString:@"f5f5f5"];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.contentInset = UIEdgeInsetsMake(0, 0, 8, 0);
    }
    return _tableView;
}
- (TLSettingViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [TLSettingViewModel new];
    }
    return _viewModel;
}

- (NSArray *)selectAccessEnvOptions {
    return @[
        @{@"title": TLLocalizedString(quick_join_access_env_mainland),
#ifdef ZEGO_ACCESS_ENV_FLAG
          @"isSelected": @([ZegoEnviromentManager getAccessEnv] == 1),
#endif
          @"tag": @1,
        },
        @{@"title": TLLocalizedString(quick_join_access_env_overseas),
#ifdef ZEGO_ACCESS_ENV_FLAG
          @"isSelected": @([ZegoEnviromentManager getAccessEnv] == 2),
#endif
          @"tag": @2,
        }
    ];
}

@end
