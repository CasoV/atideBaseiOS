//
//  LogSubListViewController.m
//  ycxm
//
//  Created by 高小伟 on 2020/11/25.
//  Copyright © 2020 末末班车. All rights reserved.
//

#import "LogSubListViewController.h"
#import "NoDataView.h"
#import "LogSubModel.h"
#import "EnumModel.h"
#import "FormBaseController.h"
#import "WebFlowBaseViewController.h"

@interface LogSubListViewController ()<UITableViewDelegate,UITableViewDataSource>{
    NSInteger _page;
    NSInteger _rows;
    NoDataView *_noDataView;
}
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) UIButton *addBtn;
@end

@implementation LogSubListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.addBtn];
    
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationItem.title = @"影像资料";
    [self loadData:YES];
}

#pragma mark - 懒加载
- (UITableView *)tableView {
    if (!_tableView) {
        _page = 1;
        _rows = 15;
        CGFloat y = 0;
        CGFloat tabH = 0;
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, y, kScreen_Width, self.view.frame.size.height - y - tabH) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = UIColorBackground;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerNib:[UINib nibWithNibName:@"BaseListCell2" bundle:nil] forCellReuseIdentifier:@"baseListCell2"];
        
        __weak typeof(self) weakSelf = self;
        _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            [weakSelf refresh];
        }];
        MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            [weakSelf loadMore];
        }];
        footer.stateLabel.font = [UIFont systemFontOfSize:12.f];
        footer.stateLabel.textColor = UIColorFromRGB(0x888888);
        _tableView.mj_footer = footer;
        
        _noDataView = [NoDataView viewWithTableView:_tableView];
    }
    return _tableView;
}

- (UIButton *)addBtn {
    if (!_addBtn) {
        CGFloat width = 40;
        CGFloat margin = 15;
        _addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _addBtn.frame = CGRectMake(kScreen_Width - width - margin, kScreen_Height - width - margin , width, width);
        _addBtn.backgroundColor = UIColorFromRGB(0x0295FF);
        _addBtn.clipsToBounds = YES;
        _addBtn.layer.cornerRadius = width / 2;
        [_addBtn setImage:[UIImage imageNamed:@"add_white"] forState:UIControlStateNormal];
        [_addBtn addTarget:self action:@selector(addBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    }
    return _addBtn;
}

- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    
    return _dataSource;
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
    [[HttpManager manager] post:[UrlConfig URL:ybgcList] param:[self params] success:^(NSData *data) {
        [DataCollection mj_setupObjectClassInArray:^NSDictionary *{
            return @{@"rows":@"LogSubModel"};
        }];
        DataCollection *datas = [DataCollection mj_objectWithKeyValues:data];
        if (datas) {
            if (isRefresh) {
                [weakSelf.tableView.mj_header endRefreshing];
                [weakSelf.dataSource removeAllObjects];
            } else {
                [weakSelf.tableView.mj_footer endRefreshing];
            }
            
            [weakSelf.dataSource addObjectsFromArray:datas.rows];
            if (weakSelf.dataSource.count >= datas.total) {
                [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
            }
            
            [weakSelf.tableView reloadData];
        } else {
            if (isRefresh) {
                [weakSelf.tableView.mj_header endRefreshing];
            } else {
                [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
            }
            [SVProgressHUD showErrorWithStatus:@"数据加载失败!"];
        }
        self->_noDataView.hidden = weakSelf.dataSource.count != 0;
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
    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithDictionary:@{
        @"page":@(_page),
        @"rows":@(_rows),
        @"categoryId": self.categoryId
    }];
    
    return param;
}
#pragma mark - 删除数据
- (void)deleteData:(NSString *)ID {
    __weak typeof(self) weakSelf = self;
    [SVProgressHUD showWithStatus:@"删除中..."];
    [[HttpManager manager] post:[UrlConfig URL:ybgcDelete] param:@{@"id":ID} success:^(NSData *data) {
        if ([ResponseUtils success:data]) {
            [SVProgressHUD showSuccessWithStatus:@"删除成功"];
            [weakSelf.tableView.mj_header beginRefreshing];
        } else {
            [SVProgressHUD showErrorWithStatus:[ResponseUtils getMsg]];
        }
    } faild:^(NSString *msg) {
        [SVProgressHUD showErrorWithStatus:msg];
    }];
    return;
    
}


#pragma mark - UITableViewDelegate, UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 90;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    BaseListCell2 *cell = [tableView dequeueReusableCellWithIdentifier:@"baseListCell2" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellAccessoryNone;
    LogSubModel *model = _dataSource[indexPath.row];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:model.pssj/1000];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSString *string = [dateFormatter stringFromDate:date];
    cell.label1.text = model.tpbh;
    cell.label3.text = [NSString stringWithFormat:@"工程名称:%@",model.gcmc?model.gcmc:@""];
    cell.label4.text = [NSString stringWithFormat:@"施工部位:%@",model.sgbw?model.sgbw:@""];
    cell.label5.text = [NSString stringWithFormat:@"摄影者:%@",model.syz];
    cell.label6.text = [NSString stringWithFormat:@"拍摄时间:%@",string];
    [cell.btn setImage:[UIImage imageNamed:@"right_gray_ico"] forState:UIControlStateNormal];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
   
    LogSubModel *model = _dataSource[indexPath.row];
    FormBaseController *vc = [FormBaseController new];
    NSMutableString *urlStr;
    NSString *userName = [[NSUserDefaults standardUserDefaults] objectForKey:USER_DEFAULT_USER_NAME];
    NSString *password = [[NSUserDefaults standardUserDefaults] objectForKey:USER_DEFAULT_PASSWORD];
    urlStr = [NSMutableString stringWithString:[UrlConfig URL:temMobile]];
    [urlStr appendString:@"yxzlDetail"];
    [urlStr appendFormat:@"?categoryId=%@", self.categoryId];
    [urlStr appendFormat:@"&type=%@",self.type];
    [urlStr appendFormat:@"&id=%@",model.datumId];
    [urlStr appendFormat:@"&projectName=%@", [UserAgent DefaultAgent].prjName];
    [urlStr appendFormat:@"&sectionCode=%@", [UserAgent DefaultAgent].sectionCode];
    [urlStr appendFormat:@"&user=%@", [userName stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]];
    [urlStr appendFormat:@"&pwd=%@", [password stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]];
    vc.urlStr = urlStr;
    vc.resourceTitle = self.navigationItem.title;
    vc.attachment = YES;
    vc.markId = model.datumId;
    vc.entityName = [self.type isEqualToString:@"1"]?@"QUALITY_RZ_SGRZ":@"QUALITY_RZ_JLRZ";
    [self.navigationController pushViewController:vc animated:YES];
}

-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return @"删除";
}

-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete;
    
}
- (void)tableView:(UITableView*)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath*)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSString *str = [self.dataSource[indexPath.row] mj_keyValues][@"statu"];
        if(str || [str isEqualToString:@"0"]){
            [SVProgressHUD showErrorWithStatus:@"流程中数据暂不支持删除!"];
            return;
        }
        UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"删除提示" message:@"确定要删除吗？" preferredStyle:UIAlertControllerStyleAlert];
        [alertC addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self deleteData:[self.dataSource[indexPath.row] valueForKey:@"datumId"]];
        }]];
        [alertC addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
        [self presentViewController:alertC animated:YES completion:nil];
    }
}

//#pragma mark - 点击新增按钮
-(void)addBtnClicked {
    
    FormBaseController *vc = [FormBaseController new];
    NSMutableString *urlStr;
    NSString *userName = [[NSUserDefaults standardUserDefaults] objectForKey:USER_DEFAULT_USER_NAME];
    NSString *password = [[NSUserDefaults standardUserDefaults] objectForKey:USER_DEFAULT_PASSWORD];
    urlStr = [NSMutableString stringWithString:[UrlConfig URL:temMobile]];
    [urlStr appendString:@"yxzlDetail"];
    [urlStr appendFormat:@"?categoryId=%@", self.categoryId];
    [urlStr appendFormat:@"&type=%@",self.type];
    [urlStr appendFormat:@"&projectName=%@", [UserAgent DefaultAgent].prjName];
    [urlStr appendFormat:@"&sectionCode=%@", [UserAgent DefaultAgent].sectionCode];
    [urlStr appendFormat:@"&user=%@", [userName stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]];
    [urlStr appendFormat:@"&pwd=%@", [password stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]];
    vc.urlStr = urlStr;
    vc.resourceTitle = self.navigationItem.title;
    vc.attachment = YES;
    [self.navigationController pushViewController:vc animated:YES];
    
}


@end
