//
//  LogMainViewController.m
//  ycxm
//
//  Created by 高小伟 on 2020/11/25.
//  Copyright © 2020 末末班车. All rights reserved.
//

#import "LogMainViewController.h"
#import "NoDataView.h"
#import "LogListModel.h"
#import "EnumModel.h"
#import "FormBaseController.h"
#import "WebFlowBaseViewController.h"
#import "LogSubListViewController.h"
#import "QDReportDetailController.h"
#import "LogCategoryTreeController.h"
#import "LogTreeModel.h"
//#import "ChooseProjectViewController.h"

@interface LogMainViewController ()<UITableViewDelegate,UITableViewDataSource>{
    NSInteger _page;
    NSInteger _rows;
    NoDataView *_noDataView;
    NSArray *_tqArr;
}
@property (weak, nonatomic) IBOutlet UIButton *categoryBtn;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) UIButton *addBtn;
@property(nonatomic,copy)NSString *treeId;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *categoryHeight;

@end

@implementation LogMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.addBtn];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nav_seciton"] style:UIBarButtonItemStylePlain target:self action:@selector(rightItemClicked)];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationItem.title = self.type == 1?@"施工日志":@"监理日志";
    [self reqEnum];
    
    if(self.type == 2){
        //监理不选择目录
        self.treeId = @"";
        self.categoryHeight.constant = 0;
    }
    
    if(!self.treeId && self.type == 1){
        NSString *url = [UrlConfig URL:listTree];
        NSDictionary *params = @{
            @"projectId": self.projectId,
            @"sectionId": self.sectionId,
            @"pid":@"-1"
        };
        [[HttpManager manager] post:url param:params success:^(NSData *data) {
            NSArray <LogTreeModel *>*datas = [LogTreeModel mj_objectArrayWithKeyValuesArray:[data mj_JSONObject]];
            if(datas && datas.count >0){
                self.treeId = datas[0].id;
                [self.categoryBtn setTitle:datas[0].name forState:UIControlStateNormal];
                [self loadData:YES];
            }
        } faild:^(NSString *msg) {
            [SVProgressHUD showErrorWithStatus:msg];
        }];
    }else{
        [self loadData:YES];
    }
  
    
}
//选择目录
- (IBAction)chooseCategory:(id)sender {
    __weak typeof(self) weakSelf = self;
    LogCategoryTreeController *vc = [[LogCategoryTreeController alloc] init];
    vc.callBack = ^(LogTreeModel * _Nonnull item) {
        weakSelf.treeId = item.id;
        [weakSelf.categoryBtn setTitle:item.name forState:UIControlStateNormal];
        [weakSelf loadData:YES];
    };
    [self.navigationController pushViewController:vc animated:YES];
    
}

#pragma mark - 懒加载
- (UITableView *)tableView {
    if (!_tableView) {
        _page = 1;
        _rows = 15;
        CGFloat topH = self.type == 1?40:0;
        CGFloat y = kStatusBarH + kNavBarH + topH;
        CGFloat tabH = 0;
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, y, kScreen_Width, self.view.frame.size.height - y - tabH) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = UIColorBackground;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerNib:[UINib nibWithNibName:@"BaseListCell1" bundle:nil] forCellReuseIdentifier:@"baseListCell1"];
        
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
    NSString *url = self.type == 1?[UrlConfig URL:logList]:[UrlConfig URL:jlrzList];
    [[HttpManager manager] post:url param:[self params] success:^(NSData *data) {
        [DataCollection mj_setupObjectClassInArray:^NSDictionary *{
            return @{@"rows":@"LogListModel"};
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
        @"projectId": [UserAgent DefaultAgent].projectId,
        @"sectionId":[UserAgent DefaultAgent].sectionId,
        @"treeId":self.treeId
    }];
    
    return param;
}
#pragma mark - 删除数据
- (void)deleteData:(NSString *)ID {
    __weak typeof(self) weakSelf = self;
    [SVProgressHUD showWithStatus:@"删除中..."];
    NSString *url = self.type == 1 ? [NSString stringWithFormat:@"%@%@", [UrlConfig URL:logDel],ID] : [NSString stringWithFormat:@"%@%@", [UrlConfig URL:jlrzDelete],ID];
    [[HttpManager manager] post:url param:nil success:^(NSData *data) {
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
    return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    BaseListCell1 *cell = [tableView dequeueReusableCellWithIdentifier:@"baseListCell1" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellAccessoryNone;
    LogListModel *model = _dataSource[indexPath.row];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:model.checkDate/1000];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *string = [dateFormatter stringFromDate:date];
    cell.label1.text = string;
    NSInteger status = model.statu.integerValue;
    switch (status) {
        case 0:
            cell.label2.text = @"未提交";
            cell.label2.textColor = UIColorFromRGB(0xffa438);
            break;
        case 1:
            cell.label2.text = @"未提交";
            cell.label2.textColor = UIColorFromRGB(0xffa438);
            break;
        case 2:
            cell.label2.text = @"退回";
            cell.label2.textColor = UIColorFromRGB(0xf0685c);
            break;
        case 3:
            cell.label2.text = @"流转中";
            cell.label2.textColor = UIColorTextBlue;
            break;
        case 4:
            cell.label2.text = @"审核完成";
            cell.label2.textColor = UIColorFromRGB(0x70ba6f);
            break;
        default:
            cell.label2.text = @"未知";
            cell.label2.textColor = UIColorFromRGB(0xababab);
            break;
    }
    if (self.type == 1) {
        cell.label3.text = [NSString stringWithFormat:@"施工范围（桩号）：%@",model.scope];
    }else{
        cell.label3.text = [NSString stringWithFormat:@"主要施工情况：%@", model.sgqk?model.sgqk:@""];
    }
    NSArray *modelTqArr = [model.tq componentsSeparatedByString:@","];
    NSString *tqStr = @"";
    for (EnumModel *enumModel in _tqArr) {
        for (NSString *tq in modelTqArr) {
            if ([enumModel.code isEqualToString:tq] ||[enumModel.name isEqualToString:tq]) {
                if (tqStr.length == 0) {
                    tqStr = enumModel.name;
                } else {
                    tqStr = [NSString stringWithFormat:@"%@,%@",tqStr,enumModel.name];
                }
            }
        }
    }
//    cell.label4.text = [NSString stringWithFormat:@"天气:%@",tqStr];
    cell.label4.text = [NSString stringWithFormat:@"记录人:%@",model.userName];
    
    [cell.btn setImage:[UIImage imageNamed:@"ico_contentB"] forState:UIControlStateNormal];
    __weak typeof(self) weakSelf = self;
    cell.callback = ^{
        LogSubListViewController *vc = [LogSubListViewController new];
        vc.categoryId = model.id;
        if (weakSelf.type == 1) {
            vc.type = @"yxzl_sgcj";
        } else  {
            vc.type = @"yxzl_jlcj";
        }
        [self.navigationController pushViewController:vc animated:YES];
    };
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    LogListModel *model = _dataSource[indexPath.row];
//    if(model.instId && ![model.statu isEqualToString:@"1"]){
    if(model.instId){
        //审核
//        WebFlowBaseViewController *flow = [[WebFlowBaseViewController
//                                            alloc]init];
//        flow.typeUrl = self.type == 1?@"constructionLog":@"supervisionLog";
//        flow.navTitle = self.navigationItem.title;
//        flow.entityName = self.type == 1?@"QUALITY_RZ_SGRZ":@"QUALITY_RZ_JLRZ";
//        flow.id = model.id;
//        flow.bizPk = model.instId;
//        [self.navigationController pushViewController:flow animated:YES];
        QDReportDetailController *detail = [[QDReportDetailController alloc] init];
        detail.bizPk = model.instId;
        detail.id = model.id;
        detail.title = self.navigationItem.title;
        detail.status = model.statu;
        detail.bizKey = @"";
        detail.newFormFlag = NO;
        detail.callBack = ^() {
//            [self getStatus:model.instId modelId:model.id];
        };
        detail.partCode = [UserAgent DefaultAgent].sectionCode ? [UserAgent DefaultAgent].sectionCode : @"";
        [self.navigationController pushViewController:detail animated:YES];
    }
//    else if([model.statu isEqualToString:@"1"]){
//                WebFlowBaseViewController *flow = [[WebFlowBaseViewController
//                                                    alloc]init];
//                flow.typeUrl = self.type == 1?@"constructionLog":@"supervisionLog";
//                flow.navTitle = self.navigationItem.title;
//                flow.entityName = self.type == 1?@"QUALITY_RZ_SGRZ":@"QUALITY_RZ_JLRZ";
//                flow.id = model.id;
//                flow.bizPk = model.instId;
//                [self.navigationController pushViewController:flow animated:YES];
//    }
    else{
        FormBaseController *vc = [FormBaseController new];
        NSMutableString *urlStr;
        NSString *projectId = [UserAgent DefaultAgent].projectId;
        NSString *sectionId = [UserAgent DefaultAgent].sectionId;
        NSString *userName = [[NSUserDefaults standardUserDefaults] objectForKey:@"user"];
        NSString *password = [[NSUserDefaults standardUserDefaults] objectForKey:USER_DEFAULT_PASSWORD];
        urlStr = [NSMutableString stringWithString:[UrlConfig URL:self.type ==1?logUrl1:logUrl2]];
        [urlStr appendFormat:@"?projectId=%@", projectId];
        [urlStr appendFormat:@"&sectionId=%@",sectionId];
        [urlStr appendFormat:@"&user=%@", [userName stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]];
        [urlStr appendFormat:@"&pwd=%@", [password stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]];
        [urlStr appendFormat:@"&id=%@",model.id];
        vc.urlStr = urlStr;
        vc.resourceTitle = self.navigationItem.title;
        vc.attachment = NO;
        vc.entityId = @"";
        vc.entityName = self.type == 1?@"QUALITY_RZ_SGRZ":@"QUALITY_RZ_JLRZ";
        vc.tableName = vc.entityName;
        vc.markId = model.id;
        vc.isReadOnly = ![model.userId isEqualToString:[AppUser sharedInstance].userId];
        [self.navigationController pushViewController:vc animated:YES];
        return;
        NSString *url = self.type == 1?[UrlConfig URL:sgrzUsekey]:[UrlConfig URL:jlrzUseKey];
        //保存 提交
        [[HttpManager manager]post:url param:nil success:^(NSData *data) {
            NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            NSArray *arr = [str componentsSeparatedByString:@":"];
            if (arr.count > 1) {
                FormBaseController *vc = [FormBaseController new];
                NSMutableString *urlStr;
                NSString *projectId = [UserAgent DefaultAgent].projectId;
                NSString *sectionId = [UserAgent DefaultAgent].sectionId;
                NSString *userName = [[NSUserDefaults standardUserDefaults] objectForKey:@"user"];
                NSString *password = [[NSUserDefaults standardUserDefaults] objectForKey:USER_DEFAULT_PASSWORD];
                urlStr = [NSMutableString stringWithString:[UrlConfig URL:self.type ==1?logUrl1:logUrl2]];
                [urlStr appendFormat:@"?projectId=%@", projectId];
                [urlStr appendFormat:@"&sectionId=%@",sectionId];
                [urlStr appendFormat:@"&user=%@", [userName stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]];
                [urlStr appendFormat:@"&pwd=%@", [password stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]];
                [urlStr appendFormat:@"&id=%@",model.id];
                vc.urlStr = urlStr;
                vc.resourceTitle = self.navigationItem.title;
                vc.attachment = NO;
                vc.entityId = arr[1];
                vc.entityName = self.type == 1?@"QUALITY_RZ_SGRZ":@"QUALITY_RZ_JLRZ";
                vc.tableName = vc.entityName;
                vc.markId = model.id;
                vc.isReadOnly = ![model.userId isEqualToString:[AppUser sharedInstance].userId];
                [self.navigationController pushViewController:vc animated:YES];
            } else {
                [SVProgressHUD showErrorWithStatus:@"模版id获取失败!"];
            }
        } faild:^(NSString *msg) {
        }];
    }
}

-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return @"删除";
}

-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete;
    
}
- (void)tableView:(UITableView*)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath*)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        if(![[self.dataSource[indexPath.row] mj_keyValues][@"userId"] isEqualToString:[AppUser sharedInstance].userId]){
            [SVProgressHUD showErrorWithStatus:@"暂无操作权限!"];
            return;
        }
        NSString *str = [self.dataSource[indexPath.row] mj_keyValues][@"statu"];
        if([str isEqualToString:@"3"] || [str isEqualToString:@"2"]|| [str isEqualToString:@"4"]){
            [SVProgressHUD showErrorWithStatus:@"流程中数据暂不支持删除!"];
            return;
        }
        UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"删除提示" message:@"确定要删除吗？" preferredStyle:UIAlertControllerStyleAlert];
        [alertC addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self deleteData:[self.dataSource[indexPath.row] valueForKey:@"id"]];
        }]];
        [alertC addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
        [self presentViewController:alertC animated:YES completion:nil];
    }
}

//#pragma mark - 点击新增按钮
-(void)addBtnClicked {
    
    FormBaseController *vc = [FormBaseController new];
    NSMutableString *urlStr;
    NSString *projectId = [UserAgent DefaultAgent].projectId;
    NSString *sectionId = [UserAgent DefaultAgent].sectionId;
    NSString *userName = [[NSUserDefaults standardUserDefaults] objectForKey:@"user"];
    NSString *password = [[NSUserDefaults standardUserDefaults] objectForKey:USER_DEFAULT_PASSWORD];
    urlStr = [NSMutableString stringWithString:[UrlConfig URL:self.type ==1?logUrl1:logUrl2]];
    [urlStr appendFormat:@"?projectId=%@", projectId];
    [urlStr appendFormat:@"&sectionId=%@",sectionId];
    [urlStr appendFormat:@"&user=%@", [userName stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]];
    [urlStr appendFormat:@"&pwd=%@", [password stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]];
    [urlStr appendFormat:@"&treeId=%@",self.treeId];
    vc.urlStr = urlStr;
    vc.resourceTitle = self.navigationItem.title;
    vc.attachment = NO;
    [self.navigationController pushViewController:vc animated:YES];
    
}

#pragma mark - 请求DictId
- (void)reqEnum{
    [[HttpManager manager] post:[UrlConfig URL:getCategoryList] param:@{@"value":@"svweather"} success:^(NSData *data) {
        if ([ResponseUtils success:data]) {
            self->_tqArr  = [EnumModel mj_objectArrayWithKeyValuesArray:[ResponseUtils getData:@"data"]];
        } else {
            [SVProgressHUD showErrorWithStatus:[ResponseUtils getMsg]];
        }
    } faild:^(NSString *msg) {
        [SVProgressHUD showErrorWithStatus:msg];
        
    }];
}

#pragma mark - 点击事件
- (void)rightItemClicked {
//    ChooseProjectViewController *vc = [[ChooseProjectViewController alloc] init];
//    vc.type = [NSString stringWithFormat:@"%d",_type];
//    [self.navigationController pushViewController:vc animated:YES];
}

@end
