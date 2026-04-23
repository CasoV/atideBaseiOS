//
//  LoanSealListVc.m
//  PMPlatform_IOS
//
//  Created by 高小伟 on 2018/11/9.
//  Copyright © 2018 com.atide. All rights reserved.
//

#import "LoanSealListVc.h"
#import "LoanSealModel.h"
#import "SearchViewController.h"
#import "DetailController.h"
#import "LoanSealsCell.h"

@interface LoanSealListVc ()<UITableViewDelegate, UITableViewDataSource>


@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation LoanSealListVc {
    NSMutableArray <LoanSealModel *>*_dataSource;
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
- (IBAction)addSeal:(id)sender {

    [self pushAndNewSeal:SearchTypeSealLoan];

}

-(void)pushAndNewSeal:(SearchType)searchType{
    DetailController *vc = [[UIStoryboard storyboardWithName:@"DetailLoan" bundle:nil] instantiateViewControllerWithIdentifier: @"DetailLoanVc"];
    vc.searchType = searchType;
    vc.bizKey =  [SearchFactory getBizKeyTypeID:BizKeyTypeSealLoan];
    [self.parentViewController.navigationController pushViewController:vc animated:YES];
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
    [DataCollection mj_setupObjectClassInArray:^NSDictionary *{
        return @{@"rows":@"LoanSealModel"};
    }];
    [LoanSealModel mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
        return @{@"operat":@"operator"};
    }];
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
    
    if (self.searchParam[@"fromDate"]) {
        self.searchParam[@"startTime"] = self.searchParam[@"fromDate"];
        //        [self.searchParam removeObjectForKey:@"fromDate"];
    }
    if (self.searchParam[@"toDate"]) {
        self.searchParam[@"endTime"] = self.searchParam[@"toDate"];
        //        [self.searchParam removeObjectForKey:@"toDate"];
    }
}


#pragma mark - UITableViewDelegate, UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LoanSealsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LoanSealsCell" forIndexPath:indexPath];
    [cell loadDataModel:_dataSource[indexPath.row]];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 140.f;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    LoanSealModel *model = _dataSource[indexPath.row];
    DetailController *vc = [[UIStoryboard storyboardWithName:@"DetailLoan" bundle:nil] instantiateViewControllerWithIdentifier: @"DetailLoanVc"];
    vc.searchType = self.searchType;
    vc.ID = model.id;
    if (self.searchType == SearchTypeSealLoan) {
        vc.bizKey =  [SearchFactory getBizKeyTypeID:BizKeyTypeSealLoan];
    }
    [self.parentViewController.navigationController pushViewController:vc animated:YES];
}

@synthesize description;

@synthesize hash;

@synthesize superclass;

@end
