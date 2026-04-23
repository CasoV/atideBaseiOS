//
//  ProcessListController.m
//  PMPlatform_IOS
//
//  Created by 末末班车 on 2017/9/6.
//  Copyright © 2017年 com.atide. All rights reserved.
//

#import "ProcessListController.h"
#import "ProcessListModel.h"
#import "ProcessListCell.h"
#import "SearchViewController.h"
#import "DetailController.h"
#import "BaseWebViewController.h"

@interface ProcessListController ()<UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation ProcessListController {
    NSMutableArray <ProcessListModel *>*_dataSource;
    
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
    if(![self.url isEqualToString:[UrlConfig URL:getTodoMsgList]]){
        [[HttpManager manager] post:self.url param:self.searchParam success:^(NSData *data) {
            [self.tableView.mj_header endRefreshing];
            [self generatorData:data isRefresh:YES];
        } faild:^(NSString *msg) {
            [self.tableView.mj_header endRefreshing];
            [MBManager showBriefAlert:msg];
        }];
        return;
    }
    [[HttpManager manager] get:self.url param:self.searchParam success:^(NSData *data) {
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
    if(![self.url isEqualToString:[UrlConfig URL:getTodoMsgList]]){
        [[HttpManager manager] post:self.url param:self.searchParam success:^(NSData *data) {
            [self.tableView.mj_footer endRefreshing];
            [self generatorData:data isRefresh:NO];
        } faild:^(NSString *msg) {
            [self.tableView.mj_footer endRefreshing];
            [MBManager showBriefAlert:msg];
        }];
        return;
    }
    
    [[HttpManager manager] get:self.url param:self.searchParam success:^(NSData *data) {
        [self.tableView.mj_footer endRefreshing];
        [self generatorData:data isRefresh:NO];
    } faild:^(NSString *msg) {
        [self.tableView.mj_footer endRefreshing];
        [MBManager showBriefAlert:msg];
    }];
    return;
    
}

- (void)generatorData:(NSData *)data isRefresh:(BOOL)isRefresh {
    [DataCollection mj_setupObjectClassInArray:^NSDictionary *{
        return @{@"rows":@"ProcessListModel"};
    }];
    [ProcessListModel mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
        return @{@"ID":@"id"};
    }];
    
    DataCollection *result;
    if(![self.url isEqualToString:[UrlConfig URL:getTodoMsgList]]){
        result = [DataCollection mj_objectWithKeyValues:data];
    }else{
        NSDictionary *dic = [data mj_JSONObject];
        result = [DataCollection mj_objectWithKeyValues:dic[@"data"]];
        
        for (ProcessListModel *model in result.rows) {
            if (model.content) {
                model.title = model.content;
            }
            model.bizTypeName = model.noticeTypeName;
            model.bizType = model.noticeType;
            model.createTime = model.sendTime;
            model.bizPk = model.bizId;
            model.isNoty = YES;
        }
    }
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
    
    if (self.searchParam[@"fromDate"]) {
        self.searchParam[@"startTime"] = self.searchParam[@"fromDate"];
        [self.searchParam removeObjectForKey:@"fromDate"];
    }
    if (self.searchParam[@"toDate"]) {
        self.searchParam[@"endTime"] = self.searchParam[@"toDate"];
        [self.searchParam removeObjectForKey:@"toDate"];
    }
}


#pragma mark - UITableViewDelegate, UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ProcessListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"processListCell" forIndexPath:indexPath];
    [cell loadDataModel:_dataSource[indexPath.row]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSString *storyboardId;
    NSString *ID;
    NSString *dealId;
    ProcessListModel *model = _dataSource[indexPath.row];
    if ([model.bizType isEqualToString:@"doc_send"]) {
        ID = model.bizPk;
        dealId = model.bizPk;
        storyboardId = @"detailSend";
    }else if([model.bizType isEqualToString:@"doc_rcv_read"] || [model.bizType isEqualToString:@"doc_rcv_deal"]) {
        ID = model.bizPk;
        dealId = model.bizPk;
        storyboardId = @"detailRcv";
    }else{
        if(model.doUrl1){
            BaseWebViewController *webvc =  [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"BaseWebViewController"];
            webvc.url = [self getLoadUrl:model.doUrl1];
            [self.navigationController pushViewController:webvc animated:YES];
            return;
        }else{
            [MBManager showBriefAlert:@"不支持的操作，请到pc端配置待办操作地址！"];
            return;
        }
    }
    
    
    DetailController *vc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:storyboardId];
    vc.searchType = self.searchType;
    vc.ID = ID;
    vc.dealID = dealId;
    vc.bizKey = model.bizType;
    [self.parentViewController.navigationController pushViewController:vc animated:YES];
}
-(NSString *)getLoadUrl:(NSString *)sortUrl{
    NSString *url;
    NSString *userName = [[NSUserDefaults standardUserDefaults] objectForKey:@"user"];
    NSString *password = [[NSUserDefaults standardUserDefaults] objectForKey:@"password"];
    if ([[UserAgent DefaultAgent].sectionId isEqualToString:@""]) {
        url = [NSString stringWithFormat:@"%@%@&user=%@&pwd=%@&projectId=%@&projectCode=%@&projectName=%@", [UrlConfig URL:temMobileEmpty],sortUrl, [userName stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]], [password stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]], [UserAgent DefaultAgent].projectId, [UserAgent DefaultAgent].projectCode, [[UserAgent DefaultAgent].prjName stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]];
    } else {
        url = [NSString stringWithFormat:@"%@%@&user=%@&pwd=%@&projectId=%@&projectCode=%@&projectName=%@&sectionId=%@&sectionCode=%@&sectionName=%@", [UrlConfig URL:temMobileEmpty],sortUrl, [userName stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]], [password stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]], [UserAgent DefaultAgent].projectId, [UserAgent DefaultAgent].projectCode, [[UserAgent DefaultAgent].prjName stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]], [UserAgent DefaultAgent].sectionId, [UserAgent DefaultAgent].sectionCode, [[UserAgent DefaultAgent].sectionName stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]];
    }
    return url;
}

@end
