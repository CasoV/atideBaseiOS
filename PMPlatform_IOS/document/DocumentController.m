//
//  DocumentController.m
//  PMPlatform_IOS
//
//  Created by 末末班车 on 2017/9/6.
//  Copyright © 2017年 com.atide. All rights reserved.
//

#import "DocumentController.h"
#import "DocumentRcvModel.h"
#import "DocumentModel.h"
#import "DocumentCell.h"
#import "SearchViewController.h"
#import "DetailController.h"

@interface DocumentController ()<UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation DocumentController {
    NSMutableArray *_dataSource;
    
    NSInteger page;
    NSInteger rows;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupTableView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.tableView.mj_header beginRefreshing];
}

#pragma mark - 初始化界面
- (void)setupTableView {
    _dataSource = [NSMutableArray array];
    page = 1;
    rows = 10;
    
    __weak typeof(self) weakself = self;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakself refresh];
    }];
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [weakself loadMore];
    }];
}

#pragma mark - 加载数据
- (void)refresh {
    page = 1;
    [self.tableView.mj_footer resetNoMoreData];
    [self cleanParam];
    [[HttpManager manager] post:self.url param:self.searchParam success:^(NSData *data) {
        [self.tableView.mj_header endRefreshing];
        [self generatorData:data isRefresh:YES];
    } faild:^(NSString *msg) {
        [self.tableView.mj_header endRefreshing];
        [MBManager showBriefAlert:msg];
    }];
}

- (void)refresh:(NSDictionary *)param {
    if (param[@"search"]) {
        SearchParam *params = (SearchParam *)param[@"search"];
        [self normalSearch:params];
        [self.tableView.mj_header beginRefreshing];
    }
}

- (void)loadMore {
    [self cleanParam];
    [[HttpManager manager] post:self.url param:self.searchParam success:^(NSData *data) {
        [self.tableView.mj_footer endRefreshing];
        [self generatorData:data isRefresh:NO];
    } faild:^(NSString *msg) {
        [self.tableView.mj_footer endRefreshing];
        [MBManager showBriefAlert:msg];
    }];
}

- (void)generatorData:(NSData *)data isRefresh:(BOOL)isRefresh {
    if (self.searchType == 7 || self.searchType == 8) {
        [DataCollection mj_setupObjectClassInArray:^NSDictionary *{
            return @{@"rows":@"DocumentModel"};
        }];
        [DocumentModel mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
            return @{@"ID":@"id", @"UNION":@"union", @"COPYORG":@"copyOrg"};
        }];
    }else {
        [DataCollection mj_setupObjectClassInArray:^NSDictionary *{
            return @{@"rows":@"DocumentRcvModel"};
        }];
        [DocumentRcvModel mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
            return @{@"ID":@"id", @"COPYORG":@"copyOrg"};
        }];
    }

    DataCollection *result = [DataCollection mj_objectWithKeyValues:data];
    if (result == nil || result.rows == nil) {
        
    }else {
        page += 1;
    }
    if (isRefresh) {
        [_dataSource removeAllObjects];
    }
    
    if (result.rows) {
        [_dataSource addObjectsFromArray:result.rows];
        if (result.total) {
            SearchViewController *parentVC = (SearchViewController *)self.parentViewController;
            [parentVC resetTotalButton:result.total];
            
            if (_dataSource.count == result.total.integerValue) {
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            }
        }
    }
    
    [self.tableView reloadData];
}

#pragma mark - 初始化请求参数
- (void)cleanParam {
    [self.searchParam setValue:@(page) forKey:@"page"];
    [self.searchParam setValue:@(rows) forKey:@"rows"];
    if (self.searchType == 7 || self.searchType == 8) {
        if (self.searchParam[@"fromDate"]) {
            self.searchParam[@"startTime"] = self.searchParam[@"fromDate"];
            [self.searchParam removeObjectForKey:@"fromDate"];
        }
        if (self.searchParam[@"toDate"]) {
            self.searchParam[@"endTime"] = self.searchParam[@"toDate"];
            [self.searchParam removeObjectForKey:@"toDate"];
        }
    }else {
        if (self.searchType == 5) {
            [self.searchParam setValue:@"2" forKey:@"type"];
        } else {
            [self.searchParam setValue:@"1" forKey:@"type"];
        }
    }
    
    if (self.searchType == 6 || self.searchType == 8) {
        [self.searchParam setValue:@"1" forKey:@"gongshi"];
    }else {
        [self.searchParam setValue:@"0" forKey:@"gongshi"];
    }
}

#pragma mark - UITableViewDelegate, UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.searchType == 6) {
        return 220;
    } else {
        return 250;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DocumentCell *cell = [tableView dequeueReusableCellWithIdentifier:@"documentCell" forIndexPath:indexPath];
    cell.searchType = self.searchType;
    if (self.searchType == 7 || self.searchType == 8) {
        [cell loadDataModel:_dataSource[indexPath.row]];
    }else {
        [cell loadDataRcvModel:_dataSource[indexPath.row]];
    }

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSString *storyboardId;
    NSString *ID;
    NSString *dealId;
    NSString *fileName;
    if (self.searchType == SearchTypeSendManagement || self.searchType == SearchTypeSendPublicity) {
        DocumentModel *model = _dataSource[indexPath.row];
        ID = model.ID;
        dealId = model.ID;
        fileName = model.fileName;
        storyboardId = @"detailSend";
    }else {
        DocumentRcvModel *model = _dataSource[indexPath.row];
        if (!model.dealId || [model.dealId isEqualToString:@""]) {
            dealId = model.ID;
        }else {
            dealId = model.dealId;
        }
        ID = model.ID;
        fileName = model.fileName;
        storyboardId = @"detailRcv";
    }
    
    DetailController *vc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:storyboardId];
    vc.searchType = self.searchType;
    vc.ID = ID;
    vc.dealID = dealId;
    [self.parentViewController.navigationController pushViewController:vc animated:YES];
}

@end
