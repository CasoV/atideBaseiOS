//
//  TLMeetingSettingViewController.m
//  ZegoRoomkitDemo
//
//  Created by Kael Ding on 2020/7/20.
//  Copyright © 2020 zego. All rights reserved.
//

#import "TLMeetingSettingViewController.h"
#import "TLMeetingSettingViewModel.h"
#import "TLSettingCell.h"

@interface TLMeetingSettingViewController ()<UITableViewDataSource, UITableViewDelegate, TLMeetingSettingCellDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) TLMeetingSettingViewModel *viewModel;
@end

static NSString *reuseIdentifier = @"TLSettingCellReuseIdentifier";

@implementation TLMeetingSettingViewController

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
    self.navigationItem.title = TLLocalizedString(setting_room);
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nav_back"] style:UIBarButtonItemStylePlain target:self action:@selector(leftItemClick:)];
    self.navigationItem.leftBarButtonItems = @[leftItem];
}

- (void)setupActions {
    @ZegoWeak(self)
    //麦克风设置
    self.viewModel.micBlock = ^(BOOL status) {
        @ZegoStrong(self)
        self.viewModel.meetingSetting.isMicrophoneOnWhenJoiningRoom = !status;
    };
    //摄像头设置
    self.viewModel.cameraBlock = ^(BOOL status) {
        @ZegoStrong(self)
        self.viewModel.meetingSetting.isCameraOnWhenJoiningRoom = !status;
    };
    //美颜
    self.viewModel.beautifyBlock = ^(BOOL status) {
        @ZegoStrong(self)
        self.viewModel.meetingSetting.beautifyMode = status;
    };
    //视频镜像
    self.viewModel.videoMirrorBlock = ^(BOOL status) {
        @ZegoStrong(self)
        self.viewModel.meetingSetting.previewVideoMirrorMode = status;
    };
    //视频填充
    self.viewModel.videoFitBlock = ^(BOOL status) {
        @ZegoStrong(self)
        self.viewModel.meetingSetting.videoFitMode = status;
    };
    //省流模式开关
    self.viewModel.saveTrafficBlock = ^(BOOL status) {
        @ZegoStrong(self)
        self.viewModel.meetingSetting.isSaveTrafficModeOn = status;
    };
    //拉流开启L3
    self.viewModel.L3Block = ^(BOOL status) {
        [NSUserDefaults.standardUserDefaults setBool:status forKey:@"isL3on"];
    };
    
    //进退房消息配置
    self.viewModel.joinMessageBlock = ^(BOOL status) {
        [NSUserDefaults.standardUserDefaults setBool:status forKey:@"joinMsg"];
    };
    self.viewModel.leaveMessageBlock = ^(BOOL status) {
        [NSUserDefaults.standardUserDefaults setBool:status forKey:@"leaveMsg"];
    };
    
    self.viewModel.fixedInOutMsgBlock = ^(BOOL status) {
        [NSUserDefaults.standardUserDefaults setBool:status forKey:@"fixedInOutMsg"];
    };
    
    self.viewModel.teacherAvatarBlock = ^(BOOL status) {
        [NSUserDefaults.standardUserDefaults setBool:status forKey:@"teacherHideAvatar"];
    };
    self.viewModel.studentAvatarBlock = ^(BOOL status) {
        [NSUserDefaults.standardUserDefaults setBool:status forKey:@"studentHideAvatar"];
    };
}

#pragma mark - UITableViewDataSource & UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.viewModel.dataSource.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.viewModel.dataSource[section].count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TLSettingCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    cell.delegate = self;
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
        _tableView.contentInset = UIEdgeInsetsMake(0, 0, 8, 0);
    }
    return _tableView;
}
- (TLMeetingSettingViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [TLMeetingSettingViewModel new];
    }
    return _viewModel;
}

@end
