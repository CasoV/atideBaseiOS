//
//  SupervisionPunishmentListController.m
//  ycxm
//
//  Created by 末末班车 on 2020/3/18.
//  Copyright © 2020 末末班车. All rights reserved.
//

#import "SupervisionPunishmentListController.h"
#import "SupervisionPunishmentFlowController.h"
#import "DOPDropDownMenu.h"
#import "ToDoListCell.h"
#import "NoDataView.h"
#import "Panel.h"

#define kMenu_Height 40

@interface SupervisionPunishmentListController ()<UITableViewDelegate, UITableViewDataSource, DOPDropDownMenuDelegate, DOPDropDownMenuDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *addBtn;

@property (nonatomic, strong) NSMutableArray <SupervisionPunishmentModel *>*dataSource;

@property (nonatomic, strong) DOPDropDownMenu *prjMenu;
@property (nonatomic, copy) NSArray <Panel *>*menuArray;

@property (nonatomic, copy) NSString *status;

@end

@implementation SupervisionPunishmentListController {
    NSInteger _page;
    NSInteger _rows;
    
    NoDataView *_noDataView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.isFirst = YES;
    self.view.clipsToBounds = YES;
    [self.view addSubview:self.prjMenu];
    
    
    [self.tableView registerNib:[UINib nibWithNibName:@"ToDoListCell" bundle:nil] forCellReuseIdentifier:@"ToDoListCell"];

    __weak typeof(self) weakSelf = self;
    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf refresh];
    }];
    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [weakSelf loadMore];
    }];
    footer.stateLabel.font = [UIFont systemFontOfSize:12.f];
    footer.stateLabel.textColor = UIColorFromRGB(0x888888);
    self.tableView.mj_footer = footer;

    _noDataView = [NoDataView viewWithTableView:self.tableView];

    [self.prjMenu selectIndexPath:[DOPIndexPath indexPathWithCol:0 row:0] triggerDelegate:YES];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.navigationItem.title = self.resourceTitle ? self.resourceTitle : @"监理违约处罚";
    
    if (self.isFirst) {
        self.isFirst = NO;
    } else {
        [self.tableView.mj_header beginRefreshing];
    }
}

#pragma mark - 懒加载
- (DOPDropDownMenu *)prjMenu{
    if (!_prjMenu) {
        _prjMenu = [[DOPDropDownMenu alloc] initWithOrigin:CGPointMake(0, kStatusBarH + kNavBarH + 0.5) andHeight:kMenu_Height - 0.5];
        _prjMenu.delegate = self;
        _prjMenu.dataSource = self;
        _prjMenu.indicatorColor = UIColorTextStress;
        _prjMenu.textSelectedColor = UIColorTextStress;
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, kMenu_Height - 1, kScreen_Width, 0.5)];
        line.backgroundColor = UIColorBackground;
        [_prjMenu addSubview:line];
    }
    return _prjMenu;
}

- (NSMutableArray<SupervisionPunishmentModel *> *)dataSource {
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

- (NSArray<Panel *> *)menuArray {
    if (!_menuArray) {
        NSMutableArray <Panel *>*tempArray = [NSMutableArray array];
        [tempArray addObject:[[Panel alloc] init:@"" text:@"全部" icon:nil]];
        [tempArray addObject:[[Panel alloc] init:@"1" text:@"草稿" icon:nil]];
        [tempArray addObject:[[Panel alloc] init:@"2" text:@"退回" icon:nil]];
        [tempArray addObject:[[Panel alloc] init:@"3" text:@"流转中" icon:nil]];
        [tempArray addObject:[[Panel alloc] init:@"4" text:@"审批通过" icon:nil]];
        
        _menuArray = [tempArray copy];
    }
    return _menuArray;
}

#pragma mark - 加载数据
- (void)refresh {
    _page = 1;
    [self.tableView.mj_footer resetNoMoreData];
    [self loadData:YES];
}

- (void)loadMore {
    _page += 1;
    [self loadData:NO];
}

- (void)loadData:(BOOL)isRefresh {
    __weak typeof(self) weakSelf = self;
    [[HttpManager manager] get:[UrlConfig URL:qualityRecord] param:[self params] success:^(NSData *data) {
        if ([ResponseUtils success:data]) {
            [DataCollection mj_setupObjectClassInArray:^NSDictionary *{
                return @{@"rows":@"SupervisionPunishmentModel"};
            }];
            DataCollection *dataCollection = [DataCollection mj_objectWithKeyValues:[ResponseUtils getData:@"data"]];
            if (dataCollection) {
                if (isRefresh) {
                    [weakSelf.tableView.mj_header endRefreshing];
                    [weakSelf.dataSource removeAllObjects];
                } else {
                    [weakSelf.tableView.mj_footer endRefreshing];
                }
                
                [weakSelf.dataSource addObjectsFromArray:dataCollection.rows];
                if (weakSelf.dataSource.count >= dataCollection.total) {
                    [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
                }
                
                [weakSelf.tableView reloadData];
            } else {
                if (isRefresh) {
                    [weakSelf.tableView.mj_header endRefreshing];
                } else {
                    [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
                }
                [SVProgressHUD showErrorWithStatus:@"数据错误!"];
            }
            self->_noDataView.hidden = weakSelf.dataSource.count != 0;
        } else {
            if (isRefresh) {
                [weakSelf.tableView.mj_header endRefreshing];
            } else {
                [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
            }
            [SVProgressHUD showErrorWithStatus:@"数据错误!"];
        }
    } faild:^(NSString *msg) {
        if (isRefresh) {
            [weakSelf.tableView.mj_header endRefreshing];
        } else {
            [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
        }
        [SVProgressHUD showErrorWithStatus:msg];
        self->_noDataView.hidden = weakSelf.dataSource.count != 0;
    }];
}

- (NSDictionary *)params {
    return @{
        @"page":@(_page),
        @"rows":@(_rows),
        @"projectId":[UserAgent DefaultAgent].projectId,
        @"sectId": [UserAgent DefaultAgent].sectionId,
        @"userName": @"",
        @"flowStatus":self.status
    };
}

#pragma mark - UITableViewDelegate, UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ToDoListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ToDoListCell" forIndexPath:indexPath];
    cell.label1.text = [NSString stringWithFormat:@"违约人:%@", self.dataSource[indexPath.row].userName];
    cell.label3.text = [NSString stringWithFormat:@"编号:%@", self.dataSource[indexPath.row].code ? self.dataSource[indexPath.row].code : @""];
    cell.label4.text = [NSString stringWithFormat:@"日期:%@", self.dataSource[indexPath.row].registerDate];
    
    UIImage *image = nil;
    switch (self.dataSource[indexPath.row].flowStatus) {
        case 1:
            image = [UIImage imageNamed:@"icon_draft"];
            cell.label2.text = @"草稿";
            break;
        case 2:
            image = [UIImage imageNamed:@"icon_back"];
            cell.label2.text = @"退回";
            break;
        case 3:
            image = [UIImage imageNamed:@"icon_wait"];
            cell.label2.text = @"流转中";
            break;
        case 4:
            image = [UIImage imageNamed:@"icon_pass"];
            cell.label2.text = @"审核通过";
            break;
        default:
            cell.label2.text = @"未知";
            break;
    }
    
    cell.iv.image = image;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    SupervisionPunishmentFlowController *vc = [[SupervisionPunishmentFlowController alloc] init];
    vc.model = self.dataSource[indexPath.row];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark -- dropmenu datasource
- (NSInteger)numberOfColumnsInMenu:(DOPDropDownMenu *)menu {
    return 1;
}

- (NSInteger)menu:(DOPDropDownMenu *)menu numberOfRowsInColumn:(NSInteger)column{
    return self.menuArray.count;
}

- (NSString *)menu:(DOPDropDownMenu *)menu titleForRowAtIndexPath:(DOPIndexPath *)indexPath{
    return self.menuArray[indexPath.row].content;
}

#pragma mark -- dropmenu delegate
- (void)menu:(DOPDropDownMenu *)menu didSelectRowAtIndexPath:(DOPIndexPath *)indexPath{
    self.status = self.menuArray[indexPath.row].ID;
    [self.tableView.mj_header beginRefreshing];
}

#pragma mark - 新增按钮点击
- (IBAction)addBtnClicked:(id)sender {
    SupervisionPunishmentFlowController *vc = [[SupervisionPunishmentFlowController alloc] init];
    vc.newFormFlag = YES;
    [self.navigationController pushViewController:vc animated:YES];
}
@end
