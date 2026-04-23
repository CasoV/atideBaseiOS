//
//  NewFunctionListController.m
//  PMPlatform_IOS
//
//  Created by 末末班车 on 2022/6/13.
//  Copyright © 2022 com.atide. All rights reserved.
//

#import "NewFunctionListController.h"
#import "ChooseProjectController.h"
#import "FunctionListHeaderView.h"
#import "FunctionClickUtil.h"
#import "FunctionListCell.h"
#define kCellId @"FunctionListCell"

@interface NewFunctionListController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) FunctionListHeaderView *functionListHeaderView;

@end

@implementation NewFunctionListController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view addSubview:self.functionListHeaderView];
    [self.view addSubview:self.tableView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationItem.title = self.model.resourceName;
    self.navigationController.navigationBar.hidden = NO;
    [self setProSectName];
}

#pragma mark - 懒加载
- (FunctionListHeaderView *)functionListHeaderView {
    if (!_functionListHeaderView) {
        _functionListHeaderView = [[NSBundle mainBundle] loadNibNamed:@"FunctionListHeaderView" owner:nil options:nil].firstObject;
        _functionListHeaderView.frame = CGRectMake(0, kStatusBarH + kNavBarH, kScreen_Width, 40);
        [_functionListHeaderView.clickView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(rightItemClicked)]];
    }
    return _functionListHeaderView;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, kStatusBarH + kNavBarH + 40, kScreen_Width, kScreen_Height - kStatusBarH - kNavBarH - 40) style:UITableViewStylePlain];
        _tableView.rowHeight = 70;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = UIColorBackground;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerNib:[UINib nibWithNibName:kCellId bundle:nil] forCellReuseIdentifier:kCellId];
    }
    return _tableView;
}

#pragma mark - UITableViewDelegate, UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FunctionListCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellId forIndexPath:indexPath];
    
    cell.model = self.dataSource[indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    PermissionModel *model = self.dataSource[indexPath.row];
    
    [FunctionClickUtil handleFunctionClick:self functionData:model];
}

#pragma mark - 设置项目/标段名称
- (void)setProSectName {
    if ([[UserAgent DefaultAgent].sectionName isEqualToString:@""]) {
        self.functionListHeaderView.nameLabel.text = [UserAgent DefaultAgent].prjName;
    } else {
        self.functionListHeaderView.nameLabel.text = [UserAgent DefaultAgent].sectionName;
    }
}

#pragma mark - 点击事件
- (void)rightItemClicked {
    ChooseProjectController *vc = [[ChooseProjectController alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

@end
