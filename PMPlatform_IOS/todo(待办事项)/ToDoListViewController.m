//
//  ToDoListViewController.m
//  ycxm
//
//  Created by 末末班车 on 2018/10/19.
//  Copyright © 2018年 末末班车. All rights reserved.
//

#import "ToDoListViewController.h"
#import "ListConditionViewController.h"
//#import "ConstructionLogController.h"
//#import "SupervisionLogController.h"
#import "QDReportDetailController.h"
//#import "DynViewEntityModel.h"
//#import "DynFlowController.h"
#import "DOPDropDownMenu.h"
//#import "DynViewModel.h"
#import "ToDoListCell.h"
#import "MatterModel.h"
#import "ProjectInfo.h"
#import "NoDataView.h"
#import "BizTypeModel.h"
//#import "ycxm-Swift.h"
#define kMenu_Height 40

@interface ToDoListViewController ()<UITableViewDelegate, UITableViewDataSource, DOPDropDownMenuDelegate, DOPDropDownMenuDataSource>

@property (nonatomic, strong) DOPDropDownMenu *prjMenu;

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray <MatterModel *>*dataSource;

@property (nonatomic, strong) NSArray <ProjectInfo *>*menuArray;

@property (nonatomic, copy)NSString *bizKeyPreLike;

//@property (nonatomic, strong) DynViewEntityModel *viewEntity;

@property (nonatomic, assign) BOOL showPentaho;

@end

@implementation ToDoListViewController {
    NSInteger _page;
    NSInteger _rows;
    
    NoDataView *_noDataView;
    UIView *_backColorView;
    ListConditionViewController *_conditionController;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.clipsToBounds = YES;
    [self.view addSubview:self.prjMenu];
    [self.view addSubview:self.tableView];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"icon_filter"] style:UIBarButtonItemStylePlain target:self action:@selector(tapCondition)];
    self.navigationItem.rightBarButtonItem.enabled = NO;
    
    [self configCondition:[NSMutableArray array]];
    [self.prjMenu selectIndexPath:[DOPIndexPath indexPathWithCol:0 row:0] triggerDelegate:NO];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.navigationItem.title = @"待办事项";
    
    
    [self getTodoStatisticsCount];
}
-(void)getTodoStatisticsCount{
    __weak typeof(self) weakSelf = self;
    [[HttpManager manager] post:[UrlConfig URL:getTodoStatistics] param:@{
        @"userId":[AppUser sharedInstance].userId,
        @"status":@"2,3"
    } success:^(NSData *data) {
        NSArray *arr = [data mj_JSONObject];
        NSArray *modelArr = [BizTypeModel mj_objectArrayWithKeyValuesArray:arr];
        if (modelArr) {
            self.menuArray = [NSArray arrayWithArray:[self staticMenuArray]];
            for (ProjectInfo *menuModel in self.menuArray) {
                int count = 0;
                for (BizTypeModel *model in modelArr) {
                    if([model.bizKey isEqualToString:menuModel.id]){
                        count = model.count;
                        break;
                    }else if([model.bizKey rangeOfString:menuModel.id].location != NSNotFound){
                        count += model.count;
                    }
                }
                if (count > 0) {
                    menuModel.text = [NSString stringWithFormat:@"%@(%d)",menuModel.text,count];
                }
            }
        } else {
            [SVProgressHUD showErrorWithStatus:@"数据错误!"];
        }
        weakSelf.bizKeyPreLike = weakSelf.menuArray[0].id;
        [weakSelf.tableView.mj_header beginRefreshing];
    } faild:^(NSString *msg) {
        [SVProgressHUD showErrorWithStatus:msg];
    }];
    
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

- (UITableView *)tableView {
    if (!_tableView) {
        _page = 1;
        _rows = 15;
        
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, kStatusBarH + kNavBarH + kMenu_Height, kScreen_Width, kScreen_Height - kStatusBarH - kNavBarH - kMenu_Height) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerNib:[UINib nibWithNibName:@"ToDoListCell" bundle:nil] forCellReuseIdentifier:@"ToDoListCell"];
        
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

- (NSMutableArray<MatterModel *> *)dataSource {
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

- (NSArray<ProjectInfo *> *)staticMenuArray {
    
    ProjectInfo *info0 = [[ProjectInfo alloc] init];
    info0.text = @"全部";
    info0.id = @"";
    
    ProjectInfo *info1 = [[ProjectInfo alloc] init];
    info1.text = @"施工日志";
    info1.id = @"QUALITY_RZ_SGRZ";
    
    ProjectInfo *info2 = [[ProjectInfo alloc] init];
    info2.text = @"监理日志";
    info2.id = @"QUALITY_RZ_JLRZ";
    
    ProjectInfo *info3 = [[ProjectInfo alloc] init];
    info3.text = @"旁站记录";
    info3.id = @"Quality_H10_Aside_Auditor";
    
    ProjectInfo *info4 = [[ProjectInfo alloc] init];
    info4.text = @"巡视记录";
    info4.id = @"Quality_H9_Patrol_Auditor";
    
    ProjectInfo *info5 = [[ProjectInfo alloc] init];
    info5.text = @"安全检查";
    info5.id = @"SAFE_CHECK";
    
    ProjectInfo *info6 = [[ProjectInfo alloc] init];
    info6.text = @"质检资料";
    info6.id = @"Quality";
    
    ProjectInfo *info7 = [[ProjectInfo alloc] init];
    info7.text = @"中间计量单";
    info7.id = @"intermediate_measurement";
    
    ProjectInfo *info8 = [[ProjectInfo alloc] init];
    info8.text = @"中期支付报表";
    info8.id = @"YX_TWO";
    
    ProjectInfo *info9 = [[ProjectInfo alloc] init];
    info9.text = @"监理计量支付";
    info9.id = @"supervisorPayFlow";
    
    ProjectInfo *info10 = [[ProjectInfo alloc] init];
    info10.text = @"第三方支付";
    info10.id = @"serversPayFlow";
    
    NSArray *staticMenuArray = @[info0,info1,info2,info3,info4,info5,info6,info7,info8,info9,info10];
    
    
    return staticMenuArray;
}

#pragma mark - 初始化界面
- (void)configCondition:(NSMutableArray *)conditionModels {
    self.navigationItem.rightBarButtonItem.enabled = YES;
    /* 创建一个阴影 */
    _backColorView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    _backColorView.backgroundColor = [UIColor blackColor];
    _backColorView.alpha = 0;   //开始透明度为0,后面通过动画逐渐变黑
    UITapGestureRecognizer *tapG = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeTap)];
    [_backColorView addGestureRecognizer:tapG]; //加入触摸手势,点阴影区域时关闭右侧导航栏
    [self.view addSubview:_backColorView];
    
    /* 创建第二页对象 */
    __weak typeof(self) weakself = self;
    _conditionController = [[ListConditionViewController alloc] initWithNibName:@"ListConditionViewController" bundle:nil];
    _conditionController.conditionModels = conditionModels;
    _conditionController.hiddenPartBtn = YES;
    _conditionController.showKeyword = YES;
    _conditionController.showDate = YES;
    _conditionController.callback = ^{
        [weakself closeTap];
        [weakself.tableView.mj_header beginRefreshing];
    };
    _conditionController.view.frame = CGRectMake(kScreen_Width, kStatusBarH + kNavBarH, kScreen_Width - 50, kScreen_Height - kStatusBarH - kNavBarH);
    [self addChildViewController:_conditionController];
    /* 把第二个导航栏控制器的视图加到本导航栏控制器的view上(事实上导航栏控制器的view是包含了导航栏,视图控制器的视图 */
    [self.view addSubview:_conditionController.view];
    
    self.navigationItem.rightBarButtonItem.enabled = YES;
    
}

- (void)tapCondition {
    self.navigationItem.rightBarButtonItem.enabled = NO;
    [self.view bringSubviewToFront:_backColorView];
    [self.view bringSubviewToFront:_conditionController.view];
    /* 出现的动画 */
    [UIView animateWithDuration:0.5 animations:^{
        self->_backColorView.alpha = 0.3;
        self->_conditionController.view.frame = CGRectMake(50, kStatusBarH + kNavBarH, kScreen_Width - 50, kScreen_Height - kStatusBarH - kNavBarH);
    }];
}

- (void)closeTap {
    self.navigationItem.rightBarButtonItem.enabled = YES;
    /* 关闭操作,先动画后移除 */
    [UIView animateWithDuration:0.5 animations:^{
        self->_backColorView.alpha = 0;
        self->_conditionController.view.frame = CGRectMake(kScreen_Width, kStatusBarH + kNavBarH, kScreen_Width - 50, kScreen_Height - kStatusBarH - kNavBarH);
    }];
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
    [[HttpManager manager] post:[UrlConfig URL:newGetTodoList] param:[self params] success:^(NSData *data) {
        [DataCollection mj_setupObjectClassInArray:^NSDictionary *{
            return @{@"rows":@"MatterModel"};
        }];
        DataCollection *dataCollection = [DataCollection mj_objectWithKeyValues:data];
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
            if( [self.menuArray[0].text isEqualToString:@"全部"]){
                self.menuArray[0].text =  [NSString stringWithFormat:@"%@(%ld)", self.menuArray[0].text,(long)dataCollection.total];
                [weakSelf.prjMenu selectIndexPath:[DOPIndexPath indexPathWithCol:0 row:0] triggerDelegate:NO];
                
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
                                                                                 @"rows":@(_rows),                          @"userId":[AppUser sharedInstance].userId,                     @"status":@"2,3",
                                                                                 @"bizKeyPreLike":self.bizKeyPreLike
    }];
    if (_conditionController) {
        [param setValuesForKeysWithDictionary:[_conditionController params]];
    }
    if (param[@"title"]) {
        [param setObject:param[@"title"] forKey:@"bizTitle"];
        
    }
    if (param[@"startTime"]) {
        [param setObject:param[@"startTime"] forKey:@"submitFromTime"];
    }
    if (param[@"endTime"]) {
        [param setObject:param[@"endTime"] forKey:@"submitToTime"];
    }
    
    return param;
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
    cell.label1.text = self.dataSource[indexPath.row].title;
    cell.label2.text = self.dataSource[indexPath.row].flowStatusName;
    cell.label3.text = self.dataSource[indexPath.row].drafterName;
    cell.label4.text = self.dataSource[indexPath.row].submitTime;
    UIImage *image = nil;
    
    switch (self.dataSource[indexPath.row].flowStatus) {
        case 1:
            image = [UIImage imageNamed:@"icon_draft"];
            break;
        case 2:
            image = [UIImage imageNamed:@"icon_back"];
            break;
        case 3:
            image = [UIImage imageNamed:@"icon_wait"];
            break;
        case 4:
            image = [UIImage imageNamed:@"icon_pass"];
            break;
        default:
            break;
    }
    
    cell.iv.image = image;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    MatterModel *model = self.dataSource[indexPath.row];
    
    //质量检验评定表
    if ([model.bizType isEqualToString:@"Quality_Checklist"]) {
        [SVProgressHUD showInfoWithStatus:@"移动端暂不支持质量检验评定表编辑与审核!"];
        return;
    }
    
    //施工日志
//    if ([model.bizType isEqualToString:@"Quality_supervisionB"]) {
//        __weak typeof(self) weakSelf = self;
//        [SVProgressHUD showWithStatus:nil];
//        [[HttpManager manager] post:[UrlConfig URL:getSingleConstructionLog] param:@{@"id":model.bizPk} success:^(NSData *data) {
//            if ([ResponseUtils success:data]) {
//                LogModel *logModel = [LogModel mj_objectWithKeyValues:[ResponseUtils getData:@"data"]];
//                if (logModel) {
//                    [SVProgressHUD dismiss];
//                    ConstructionLogController *vc = [[UIStoryboard storyboardWithName:@"Complex" bundle:nil] instantiateViewControllerWithIdentifier:@"ConstructionLog"];
//                    vc.hidesBottomBarWhenPushed = YES;
//                    vc.model = logModel;
//                    [weakSelf.navigationController pushViewController:vc animated:YES];
//                } else {
//                    [SVProgressHUD showInfoWithStatus:@"数据有误!"];
//                }
//            } else {
//                [SVProgressHUD showErrorWithStatus:[ResponseUtils getMsg]];
//            }
//        } faild:^(NSString *msg) {
//            [SVProgressHUD showErrorWithStatus:msg];
//        }];
//        return;
//    }
    
    //监理日志
//    if ([model.bizType isEqualToString:@"Quality_supervisionA"]) {
//        __weak typeof(self) weakSelf = self;
//        [SVProgressHUD showWithStatus:nil];
//        [[HttpManager manager] post:[UrlConfig URL:getSingleSupervisorLog] param:@{@"id":model.bizPk} success:^(NSData *data) {
//            if ([ResponseUtils success:data]) {
//                LogModel *logModel = [LogModel mj_objectWithKeyValues:[ResponseUtils getData:@"data"]];
//                if (logModel) {
//                    [SVProgressHUD dismiss];
//                    SupervisionLogController *vc = [[UIStoryboard storyboardWithName:@"Complex" bundle:nil] instantiateViewControllerWithIdentifier:@"SupervisionLog"];
//                    vc.hidesBottomBarWhenPushed = YES;
//                    vc.model = logModel;
//                    [weakSelf.navigationController pushViewController:vc animated:YES];
//                } else {
//                    [SVProgressHUD showInfoWithStatus:@"数据有误!"];
//                }
//            } else {
//                [SVProgressHUD showErrorWithStatus:[ResponseUtils getMsg]];
//            }
//        } faild:^(NSString *msg) {
//            [SVProgressHUD showErrorWithStatus:msg];
//        }];
//        return;
//    }
    
    //动态表单待办
    if ([model.bizType isEqualToString:@"Design_Submission"] ||
        [model.bizType isEqualToString:@"Retest_Results"] ||
        [model.bizType isEqualToString:@"Special_Scheme"] ||
        [model.bizType isEqualToString:@"DYN_LAND_SPOIL_GROUND_RECORD"] ||
        [model.bizType isEqualToString:@"SJ_PROJECT_SUMMARY_APPROVAL"] ||
        [model.bizType isEqualToString:@"SJ_PROJECT_CONSTRUCTION_APPROVAL"]) {
        [self handleDynFlow:model];
        return;
    }
    
    QDReportDetailController *detail = [[QDReportDetailController alloc] init];
    detail.hiddenTool = NO;
    detail.url = model.doUrl ;
    detail.bizPk = model.bizPk;
    detail.title = model.bizTypeName;
    detail.numId = model.variables.numId;
    detail.bizUrl = [model.variables.tableUrlStr componentsSeparatedByString:@"/"][2];
    detail.status = [NSString stringWithFormat:@"%ld", (long)model.flowStatus];
    detail.showVideoMaterial = model.variables.partCode ? YES : NO;
    detail.bizKey = model.bizType;
    detail.newFormFlag = NO;
    detail.partCode = model.variables.partCode;

    [self.navigationController pushViewController:detail animated:YES];
}

#pragma mark -- dropmenu datasource
- (NSInteger)numberOfColumnsInMenu:(DOPDropDownMenu *)menu {
    return 1;
}

- (NSInteger)menu:(DOPDropDownMenu *)menu numberOfRowsInColumn:(NSInteger)column{
    return self.menuArray.count;
}

- (NSString *)menu:(DOPDropDownMenu *)menu titleForRowAtIndexPath:(DOPIndexPath *)indexPath{
    return self.menuArray[indexPath.row].text;
}

#pragma mark -- dropmenu delegate
- (void)menu:(DOPDropDownMenu *)menu didSelectRowAtIndexPath:(DOPIndexPath *)indexPath{
    self.bizKeyPreLike = self.menuArray[indexPath.row].id;
    [self.tableView.mj_header beginRefreshing];
}

- (void)handleDynFlow:(MatterModel *)model {
//    self.showPentaho = NO;
//    if (model.variables.entityName != nil) {
//        __weak typeof(self) weakSelf = self;
//        [SVProgressHUD showWithStatus:nil];
//        NSString *url = [UrlConfig URL:dynDefinitionGet];
//        [[HttpManager manager] get:url param:@{@"entityName":model.variables.entityName} success:^(NSData *data) {
//            if ([ResponseUtils success:data]) {
//                [DynViewEntityModel mj_setupObjectClassInArray:^NSDictionary *{
//                    return @{ @"tagContentList": @"EnumModel" };
//                }];
//                [DynViewModel mj_setupObjectClassInArray:^NSDictionary *{
//                    return @{@"fields":@"DynViewFieldsModel"};
//                }];
//                DynViewModel *viewModel = [DynViewModel mj_objectWithKeyValues:[ResponseUtils getData:@"data"]];
//                weakSelf.viewEntity = viewModel.entity;
//
//                if (weakSelf.viewEntity && weakSelf.viewEntity.tagContentList) {
//                    for (EnumModel *item in weakSelf.viewEntity.tagContentList) {
//                        if ([item.name isEqualToString: @"pentaho_row"]) {
//                            weakSelf.showPentaho = YES;
//                        }
//                    }
//                }
//                if (weakSelf.viewEntity.listViewEntity == nil) {
//                    [weakSelf toDynFlow:model viewEntityId:@""];
//                } else {
//                    [weakSelf getViewEntityId:model listViewEntity:weakSelf.viewEntity.listViewEntity];
//                }
//            } else {
//                [SVProgressHUD showErrorWithStatus:[ResponseUtils getMsg]];
//            }
//        } faild:^(NSString *msg) {
//            [SVProgressHUD showErrorWithStatus:msg];
//        }];
//    } else {
//        [SVProgressHUD showErrorWithStatus:@"配置获取失败！"];
//    }
}

- (void)getViewEntityId:(MatterModel *)model listViewEntity:(NSString *)listViewEntity {
    __weak typeof(self) weakSelf = self;
    [[HttpManager manager] get:[UrlConfig URL:dynDefinitionGet] param:@{@"entityName":listViewEntity} success:^(NSData *data) {
        if ([ResponseUtils success:data]) {
//            DynViewModel *viewModel = [DynViewModel mj_objectWithKeyValues:[ResponseUtils getData:@"data"]];
//            [weakSelf toDynFlow:model viewEntityId:viewModel.entity.id];
        } else {
            [SVProgressHUD showErrorWithStatus:[ResponseUtils getMsg]];
        }
    } faild:^(NSString *msg) {
        [SVProgressHUD showErrorWithStatus:msg];
    }];
}

- (void)toDynFlow:(MatterModel *)model viewEntityId:(NSString *)viewEntityId {
    if (model.doUrl != nil && [model.doUrl containsString:@"pentahoFlow"]) {
        self.showPentaho = YES;
    }
    
    NSDictionary *params = @{
//        @"entityId": [viewEntityId isEqualToString:@""] ? self.viewEntity.id : viewEntityId,
//        @"or":@[
//            @{
//                @"and": @[
//                    @{
//                        @"fn": self.viewEntity.idField,
//                        @"operator":@"EQ",
//                        @"value": model.bizPk
//                    }
//                ]
//            }
//        ]
    };
    __weak typeof(self) weakSelf = self;
    NSString *url = [NSString stringWithFormat:@"%@?page=1&rows=1", [UrlConfig URL:dynRecordQuery]];
    [[HttpManager manager] jsonPost:url param:params success:^(NSData *data) {
        if ([ResponseUtils success:data]) {
            [DataCollection mj_setupObjectClassInArray:^NSDictionary *{
                return @{@"rows":@"DynListModel"};
            }];
            DataCollection *dataCollection = [DataCollection mj_objectWithKeyValues:data];
            if (dataCollection && dataCollection.rows != nil && dataCollection.rows.count > 0) {
//                DynFlowController *vc = [[DynFlowController alloc] init];
//                vc.sendSectId = model.variables.own_section_id;
//                vc.bizKey = model.bizType;
//                vc.entity = weakSelf.viewEntity;
//                vc.title = model.title;
//                vc.showVideoMaterial = YES;
//                vc.showPentaho = weakSelf.showPentaho;
//                vc.model = dataCollection.rows.firstObject;
//                vc.id = model.bizPk;
//                vc.bizPk = model.bizPk;
//                [weakSelf.navigationController pushViewController:vc animated:YES];
            } else {
                [SVProgressHUD showErrorWithStatus:@"数据获取失败！"];
            }
        } else {
            [SVProgressHUD showErrorWithStatus:[ResponseUtils getMsg]];
        }
    } faild:^(NSString *msg) {
        [SVProgressHUD showErrorWithStatus:msg];
    }];
}

@end
