//
//  TLTestSettingViewController.m
//  ZegoRoomkitDemo
//
//  Created by Kael Ding on 2020/7/20.
//  Copyright © 2020 zego. All rights reserved.
//

#import "TLTestSettingViewController.h"
#import "TLTestSettingViewModel.h"
#import "TLSettingCell.h"
#import <LEEAlert.h>
#import "TLToken.h"

@interface TLTestSettingViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) TLTestSettingViewModel *viewModel;

@end

static NSString *reuseIdentifier = @"TLSettingCellReuseIdentifier";

@implementation TLTestSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setupActions];
    [self configUI];
    [self configNavigationBar];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    if (self.viewModel.isEnvironmentChanged) {
        [LEEAlert alert].config.LeeTitle(@"提示").LeeContent(@"重启后生效。立即重启").LeeAction(@"确定", ^{
            //切换环境 清除token
            [TLToken saveToken:nil];
            [[NSUserDefaults standardUserDefaults] setInteger:self.viewModel.enviromentFlag forKey:@"ZEGO_ENVIROMENT_FLAG"];
            //程序即将退出 需要同步
            [[NSUserDefaults standardUserDefaults] synchronize];
            exit(0);
        }).LeeShow();
    }
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
    self.navigationItem.title = @"测试设置";
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nav_back"] style:UIBarButtonItemStylePlain target:self action:@selector(leftItemClick:)];
    self.navigationItem.leftBarButtonItems = @[leftItem];
}

- (void)setupActions {
    @weakify(self);
    //切换测试环境
    // 正式环境
    self.viewModel.config1.actionBlock = ^{
        @strongify(self);
        for (TLSettingCellConfig *config in self.viewModel.dataSource) {
            config.isSelected = NO;
        }
        self.viewModel.config1.isSelected = YES;
        self.viewModel.enviromentFlag = 0;
    };
    // 测试环境
    self.viewModel.config2.actionBlock = ^{
        @strongify(self);
        for (TLSettingCellConfig *config in self.viewModel.dataSource) {
            config.isSelected = NO;
        }
        self.viewModel.config2.isSelected = YES;
        self.viewModel.enviromentFlag = 1;
    };
    // alpha环境
    self.viewModel.config3.actionBlock = ^{
        @strongify(self);
        for (TLSettingCellConfig *config in self.viewModel.dataSource) {
            config.isSelected = NO;
        }
        self.viewModel.config3.isSelected = YES;
        self.viewModel.enviromentFlag = 2;
    };
}

#pragma mark - UITableViewDataSource & UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.viewModel.dataSource.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    TLSettingCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    TLSettingCellConfig *config = self.viewModel.dataSource[indexPath.row];
    cell.config = config;
    
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 57;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if(self.viewModel.dataSource[indexPath.row].actionBlock){
        self.viewModel.dataSource[indexPath.row].actionBlock();
    }
    [tableView reloadData];
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
- (TLTestSettingViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [TLTestSettingViewModel new];
    }
    return _viewModel;
}
@end
