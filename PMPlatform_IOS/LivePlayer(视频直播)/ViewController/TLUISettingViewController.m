//
//  TLUISettingViewController.m
//  ZegoRoomkitDemo
//
//  Created by Kael Ding on 2020/7/20.
//  Copyright © 2020 zego. All rights reserved.
//

#import "TLUISettingViewController.h"
#import "TLUISettingViewModel.h"
#import "TLSettingCell.h"

@interface TLUISettingViewController ()<UITableViewDataSource, UITableViewDelegate, TLMeetingSettingCellDelegate>

@property (nonatomic, strong) TLUISettingViewModel *viewModel;
@property (nonatomic, strong) UITableView *tableView;

@end

static NSString *reuseIdentifier = @"TLSettingCellReuseIdentifier";

@implementation TLUISettingViewController

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
    self.navigationItem.title = TLLocalizedString(setting_custom_ui);
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nav_back"] style:UIBarButtonItemStylePlain target:self action:@selector(leftItemClick:)];
    self.navigationItem.leftBarButtonItems = @[leftItem];
}

- (void)setupActions {
    
    @ZegoWeak(self)
    //是否隐藏底部工具栏
    self.viewModel.bottomBarBlock = ^(BOOL status) {
        @ZegoStrong(self)
        self.viewModel.uiConfig.isBottomBarHidden = status;
    };
    //隐藏聊天按钮
    self.viewModel.chatBlock = ^(BOOL status) {
        @ZegoStrong(self)
        self.viewModel.uiConfig.isChatHidden = status;
    };
    //隐藏成员
    self.viewModel.attendeesBlock = ^(BOOL status) {
        @ZegoStrong(self)
        self.viewModel.uiConfig.isAttendeesHidden = status;
    };
    //隐藏分享按钮
    self.viewModel.shareBlock = ^(BOOL status) {
        @ZegoStrong(self)
        self.viewModel.uiConfig.isShareHidden = status;
    };
    //隐藏摄像头按钮
    self.viewModel.cameraBlock = ^(BOOL status) {
        @ZegoStrong(self)
        self.viewModel.uiConfig.isCameraHidden = status;
    };
    //隐藏麦克风按钮
    self.viewModel.micBlock = ^(BOOL status) {
        @ZegoStrong(self)
        self.viewModel.uiConfig.isMicrophoneHidden = status;
    };
    //隐藏更多按钮
    self.viewModel.moreBlock = ^(BOOL status) {
        @ZegoStrong(self)
        self.viewModel.uiConfig.isMoreHidden = status;
    };
    //隐藏人数
    self.viewModel.memberCountBlock = ^(BOOL status) {
        @ZegoStrong(self)
        self.viewModel.uiConfig.isMemberCountHidden = status;
    };
}

#pragma mark - UITableViewDataSource & UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.viewModel.dataSource.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    TLSettingCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    cell.delegate = self;
    TLSettingCellConfig *config = self.viewModel.dataSource[indexPath.row];
    cell.config = config;
    
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 57;
}

#pragma mark - TLMeetingSettingCellDelegate
- (void)switchButtonClickWithConfig:(TLSettingCellConfig *)config isSwitchOn:(BOOL)isSwitchOn {
    config.isSwitchOn = isSwitchOn;
    if(config.switchBlock){
        config.switchBlock(isSwitchOn);
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
        _tableView.contentInset = UIEdgeInsetsMake(8, 0, 8, 0);
    }
    return _tableView;
}
- (TLUISettingViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [TLUISettingViewModel new];
    }
    return _viewModel;
}

@end
