//
//  BaseListViewController.m
//  ycTest
//
//  Created by 末末班车 on 2018/9/12.
//  Copyright © 2018年 末末班车. All rights reserved.
//

#import "BaseListViewController.h"
#import "ListConditionViewController.h"
//#import "DetailAllowViewController.h"
//#import "AuditSecurityViewController.h"
#import "NoDataView.h"
#import "SiteModel.h"
#import "SideStationModel.h"
//#import "AllowedModel.h"
//#import "FDCalendarView.h"
//#import "ChangeInfoModel.h"
//#import "FormBaseController.h"
#import "FormBase1Controller.h"
//#import "EnumModel.h"
//#import "HazardAccidentModel.h"
//#import "SideStationModel.h"
#import "WebFlowBaseViewController.h"
#import "QDReportDetailController.h"
//#import "SupervisionModel.h"
//#import "SupervisionNewModel.h"
//#import "DetailPlanViewController.h"

#define KCell1Id @"baseListCell1"
#define KCell2Id @"baseListCell2"
#define KCell3Id @"problemListCell"
#define KCell4Id @"specialUseListCell"
#define KCell5Id @"logListCell"
#define KCell6Id @"safetyProblemCell"
#define KCell7Id @"dongTaiCell"
#define KCell8Id @"AllowedCell"

@interface BaseListViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *dataSource;

@end

@implementation BaseListViewController {
    BOOL _isFirst;
    
    NSInteger _page;
    NSInteger _rows;
    
    NSString *_partCode;
    
    NoDataView *_noDataView;
    UIView *_backColorView;
    ListConditionViewController *_conditionController;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _isFirst = YES;
    self.view.clipsToBounds = YES;
    [self.view addSubview:self.tableView];
    if ([FunctionFactory isShowAddBtn:self.type]) {
        [self.view addSubview:self.addBtn];
        [self.addBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.right.equalTo(self.view).offset(-15);
            make.width.height.equalTo(@(40));
        }];
    }
    
    if ([FunctionFactory isShowFilter:self.type]) {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"icon_filter"] style:UIBarButtonItemStylePlain target:self action:@selector(tapCondition)];
        self.navigationItem.rightBarButtonItem.enabled = NO;
        
        [self configCondition:[NSMutableArray array]];
    }
    
    if ([FunctionFactory isPriorityLoadPart:self.type]) {
        [self loadPartCode];
    }
    
    if (self.type == FunctionTypeQualityInspectionUnsubmitted || self.type == FunctionTypeQualityInspectionWaitRectification || self.type == FunctionTypeQualityInspectionWaitReview || self.type == FunctionTypeQualityInspectionFinished || self.type == FunctionTypeEquipmentSubType1 || self.type == FunctionTypeEquipmentSubType2 || self.type == FunctionTypeEquipmentSubType3 || self.type == FunctionTypeChangeMngA || self.type == FunctionTypeChangeMngB || self.type == FunctionTypeChangeMngC || self.type == FunctionTypeChangeMngD || self.type == FunctionTypeGreenProblemUnsubmitted || self.type == FunctionTypeGreenProblemWaitRectification || self.type == FunctionTypeGreenProblemWaitReview || self.type == FunctionTypeGreenProblemFinished || self.type == FunctionTypeSafetyDangerUnsubmitted || self.type == FunctionTypeSafetyDangerWaitRectification || self.type == FunctionTypeSafetyDangerWaitReview || self.type == FunctionTypeSafetyDangerFinished  || self.type == FunctionTypeWaterProblemUnsubmitted || self.type == FunctionTypeWaterProblemWaitRectification || self.type == FunctionTypeWaterProblemWaitReview || self.type == FunctionTypeWaterProblemFinished || self.type == FunctionTypeProgressAllowedDay || self.type == FunctionTypeProgressAllowedMonth|| self.type == FunctionTypeProgressAllowedWeek|| self.type == FunctionTypeProgressAllowedQuarter || self.type == FunctionTypeProgressAllowedYear || self.type == FunctionTypeSecurityCheck || self.type == FunctionTypeSecurityListSd || self.type == FunctionTypeSecurityList|| self.type == FunctionTypeSafecheckRecode || self.type == FunctionTypeProgressPlanMonth || self.type == FunctionTypeProgressPlanQuarter || self.type == FunctionTypeProgressPlanYear || self.type == FunctionTypeSupervisionListNew1 || self.type == FunctionTypeSupervisionListNew2) {
        [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.left.right.equalTo(self.view);
        }];
        self.line.hidden = YES;
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (_conditionController.view.frame.origin.x != 50) {
        if ([FunctionFactory isPriorityLoadPart:self.type]) {
            if (_isFirst) {
                _isFirst = NO;
            } else {
                [self.tableView.mj_header beginRefreshing];
            }
        } else {
            [self.tableView.mj_header beginRefreshing];
        }
    }
    self.navigationItem.title = [FunctionFactory titleOfFunctionType:self.type];
}

#pragma mark - 懒加载
- (UITableView *)tableView {
    if (!_tableView) {
        _page = 1;
        _rows = 15;
        
        CGFloat y = kStatusBarH + kNavBarH;
//        CGFloat y = 0;
        CGFloat tabH = 0;
        if (self.type == FunctionTypeSecurityListSd || self.type == FunctionTypeSecurityList) {
            tabH = 40;
        }
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, y, kScreen_Width, self.view.frame.size.height - y - tabH) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = UIColorBackground;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        if (self.type == FunctionTypeEngineeringDynamics) {
            _tableView.estimatedRowHeight = 200;
            _tableView.rowHeight = UITableViewAutomaticDimension;
        }
        
        [_tableView registerNib:[UINib nibWithNibName:@"BaseListCell1" bundle:nil] forCellReuseIdentifier:KCell1Id];
        [_tableView registerNib:[UINib nibWithNibName:@"BaseListCell2" bundle:nil] forCellReuseIdentifier:KCell2Id];
        [_tableView registerNib:[UINib nibWithNibName:@"ProblemListCell" bundle:nil] forCellReuseIdentifier:KCell3Id];
        [_tableView registerNib:[UINib nibWithNibName:@"SpecialUseListCell" bundle:nil] forCellReuseIdentifier:KCell4Id];
        [_tableView registerNib:[UINib nibWithNibName:@"LogListCell" bundle:nil] forCellReuseIdentifier:KCell5Id];
        [_tableView registerNib:[UINib nibWithNibName:@"SafetyProblemCell" bundle:nil] forCellReuseIdentifier:KCell6Id];
        [_tableView registerNib:[UINib nibWithNibName:@"DongTaiCell" bundle:nil] forCellReuseIdentifier:KCell7Id];
        [_tableView registerNib:[UINib nibWithNibName:@"AllowedCell" bundle:nil] forCellReuseIdentifier:KCell8Id];
        
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
    
    NSString *url = [FunctionFactory listURLOfFunctionType:self.type];
    if([url isEqualToString:@""]){
        return;
    }
    if([self.resourceTitle isEqualToString:@"环保问题整改"]){
        url = [UrlConfig URL:getGreeProblem];
    }else if ([self.resourceTitle isEqualToString:@"水保巡查整改"]) {
        url = [UrlConfig URL:getGreeWaterProblem];
    }else if ([self.resourceTitle isEqualToString:@"安全隐患"]) {
        url = [UrlConfig URL:getRisk];
    }

    // Get
    if (self.type == FunctionTypeProgressAllowedYear || self.type == FunctionTypeProgressAllowedMonth || self.type == FunctionTypeProgressAllowedQuarter || self.type == FunctionTypeProgressAllowedWeek || self.type == FunctionTypeProgressAllowedDay || self.type == FunctionTypeSafeAccidentReport || self.type == FunctionTypeHiddenAccidentReport || self.type == FunctionTypeSideStationRecord || self.type == FunctionTypePatrolInspectRecord || self.type == FunctionTypeSupervisionList || self.type == FunctionTypeNoticeList || self.type == FunctionTypeNoticeReplyList || self.type == FunctionTypeProgressPlanMonth || self.type == FunctionTypeProgressPlanQuarter || self.type == FunctionTypeProgressPlanYear || self.type == FunctionTypeControlEngineering || self.type == FunctionTypeSupervisionListNew1 || self.type == FunctionTypeSupervisionListNew2) {
        
        [[HttpManager manager] get:url param:[self params] success:^(NSData *data) {
            [DataCollection mj_setupObjectClassInArray:^NSDictionary *{
                return @{@"rows":[FunctionFactory modelOfFunctionType:weakSelf.type]};
            }];
            NSDictionary *content = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            DataCollection *datas = [DataCollection mj_objectWithKeyValues:content[@"data"]];
            if(self.type == FunctionTypeHiddenAccidentReport){
                //处理枚举
                [self reqDictId:datas isRefresh:isRefresh];
                return;
            }
            if(self.type == FunctionTypeNoticeReplyList){
                if (isRefresh) {
                    [weakSelf.tableView.mj_header endRefreshing];
                    [weakSelf.dataSource removeAllObjects];
                } else {
                    [weakSelf.tableView.mj_footer endRefreshing];
                }
                
//                [weakSelf.dataSource addObjectsFromArray:[SupervisionModel mj_objectArrayWithKeyValuesArray:content[@"data"]]];
//                [weakSelf.tableView reloadData];
                return;
            }
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
        return;
    }
    // POST
    [[HttpManager manager] post:url param:[self params] success:^(NSData *data) {
        [DataCollection mj_setupObjectClassInArray:^NSDictionary *{
            return @{@"rows":[FunctionFactory modelOfFunctionType:weakSelf.type]};
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
    if (self.type == FunctionTypeSupervisionListNew1) {
        return @{
            @"page":@(_page),
            @"rows":@(_rows),
            @"myTask": @"1",
            @"creatorFilter": @"0",
            @"_": [self currentTimeStr]
        };
    }
    if (self.type == FunctionTypeSupervisionListNew2) {
        return @{
            @"page":@(_page),
            @"rows":@(_rows),
            @"myTask": @"0",
            @"creatorFilter": @"1",
            @"_": [self currentTimeStr]
        };
    }
    
    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithDictionary:@{
                                                                                 @"page":@(_page),
                                                                                 @"rows":@(_rows),
                                                                                 @"projectId": [UserAgent DefaultAgent].projectId,
                                                                                 @"sectId":[UserAgent DefaultAgent].sectionId
                                                                                 }];
    
    if([self.resourceTitle isEqualToString:@"质量问题"] || [self.resourceTitle isEqualToString:@"质量隐患"]){
        [param setValue:[self.resourceTitle isEqualToString:@"质量问题"]?@"1":@"2" forKey:@"partId"];
    }
    if (self.type == FunctionTypeChangeListCard) {
        [param setObject:@"0" forKey:@"type"];
        [param setObject:@"1" forKey:@"status"];
    }
    if (self.type == FunctionTypeControlEngineering) {
        [param setObject:@(_page) forKey:@"pageNo"];
        [param setObject:@(_rows) forKey:@"pageSize"];
        [param setObject:[UserAgent DefaultAgent].sectionId forKey:@"sectionId"];
    }
    if (self.type == FunctionTypeCMS) {
        [param setObject:@"141419250177802240" forKey:@"columnId"];
    }
    if(self.type == FunctionTypeProgressPlanMonth){
        [param setObject:@"4" forKey:@"planOrReportType"];
        [param setObject:[UserAgent DefaultAgent].sectionId forKey:@"sectNo"];
    }else if(self.type == FunctionTypeProgressPlanQuarter){
         [param setObject:@"3" forKey:@"planOrReportType"];
        [param setObject:[UserAgent DefaultAgent].sectionId forKey:@"sectNo"];
    }else if(self.type == FunctionTypeProgressPlanYear){
         [param setObject:@"1" forKey:@"planOrReportType"];
        [param setObject:[UserAgent DefaultAgent].sectionId forKey:@"sectNo"];
    }
    
    
    if(self.type == FunctionTypeProgressAllowedDay){
        [param setObject:@"6" forKey:@"planOrReportType"];
        [param setObject:[UserAgent DefaultAgent].sectionId forKey:@"sectNo"];
    }else if(self.type == FunctionTypeProgressAllowedWeek){
         [param setObject:@"5" forKey:@"planOrReportType"];
        [param setObject:[UserAgent DefaultAgent].sectionId forKey:@"sectNo"];
    }else if(self.type == FunctionTypeProgressAllowedMonth){
         [param setObject:@"4" forKey:@"planOrReportType"];
        [param setObject:[UserAgent DefaultAgent].sectionId forKey:@"sectNo"];
    }else if(self.type ==FunctionTypeProgressAllowedQuarter ){
         [param setObject:@"3" forKey:@"planOrReportType"];
        [param setObject:[UserAgent DefaultAgent].sectionId forKey:@"sectNo"];
    }else if(self.type == FunctionTypeProgressAllowedYear){
         [param setObject:@"1" forKey:@"planOrReportType"];
        [param setObject:[UserAgent DefaultAgent].sectionId forKey:@"sectNo"];
    }
    
    if (self.type == FunctionTypeQualityInspectionUnsubmitted || self.type == FunctionTypeQualityInspectionWaitRectification || self.type == FunctionTypeQualityInspectionWaitReview || self.type == FunctionTypeQualityInspectionFinished) {
        [param setObject:@(self.type - 1) forKey:@"status"];
    }
    if (self.type == FunctionTypeGreenProblemUnsubmitted || self.type == FunctionTypeGreenProblemWaitRectification || self.type == FunctionTypeGreenProblemWaitReview || self.type == FunctionTypeGreenProblemFinished) {
        [param setObject:@(self.type - 23) forKey:@"status"];
    }
    if (self.type == FunctionTypeSafetyDangerUnsubmitted || self.type == FunctionTypeSafetyDangerWaitRectification || self.type == FunctionTypeSafetyDangerWaitReview || self.type == FunctionTypeSafetyDangerFinished) {
        [param setObject:@(self.type - 27) forKey:@"status"];
    }
    if (self.type == FunctionTypeWaterProblemUnsubmitted || self.type == FunctionTypeWaterProblemWaitRectification || self.type == FunctionTypeWaterProblemWaitReview || self.type == FunctionTypeWaterProblemFinished) {
        [param setObject:@(self.type - 36) forKey:@"status"];
    }
    
    if (self.type == FunctionTypeConstructionDesign || self.type == FunctionTypeChangeMngA || self.type == FunctionTypeChangeMngB || self.type == FunctionTypeChangeMngC || self.type == FunctionTypeChangeMngD || self.type == FunctionTypeConstructionPlan || self.type == FunctionTypeSpecialConstructionPlan || self.type == FunctionTypeOtherPrograms || self.type == FunctionTypeMeetingMinutes || self.type == FunctionTypeGreenInnovation) {
        switch (self.type) {
            case FunctionTypeConstructionDesign:
                [param setObject:@"ConOrgDesign" forKey:@"fileType"];
                break;
            case FunctionTypeChangeMngA:
                [param setObject:@"ChangeMngA" forKey:@"fileType"];
                break;
            case FunctionTypeChangeMngB:
                [param setObject:@"ChangeMngB" forKey:@"fileType"];
                break;
            case FunctionTypeChangeMngC:
                [param setObject:@"ChangeMngC" forKey:@"fileType"];
                break;
            case FunctionTypeChangeMngD:
                [param setObject:@"ChangeMngD" forKey:@"fileType"];
                break;
            case FunctionTypeConstructionPlan:
                [param setObject:@"tackManage" forKey:@"fileType"];
                break;
            case FunctionTypeSpecialConstructionPlan:
                [param setObject:@"specialPlan" forKey:@"fileType"];
                break;
            case FunctionTypeOtherPrograms:
                [param setObject:@"specialPlanOther" forKey:@"fileType"];
                break;
            case FunctionTypeMeetingMinutes:
                [param setObject:@"zhMeetingImportant" forKey:@"fileType"];
                break;
            case FunctionTypeGreenInnovation:
                [param setObject:@"greenInnovation" forKey:@"fileType"];
                break;
            default:
                break;
        }
    }
    
    if (_conditionController) {
        [param setValuesForKeysWithDictionary:[_conditionController params]];
    }
    
    if (param[@"title"]) {
        [param setObject:param[@"title"] forKey:[FunctionFactory searchOfFunctionType:self.type]];
    }
    
    if (param[@"partCode"]) {
        _partCode = param[@"partCode"];
    }
    
    if (self.pid) {
        [param setObject:self.pid forKey:@"pid"];
        if (self.type == FunctionTypeEquipmentSubType1) {
            [param setObject:@"1" forKey:@"type"];
        } else if (self.type == FunctionTypeEquipmentSubType2) {
            [param setObject:@"2" forKey:@"type"];
        } else if (self.type == FunctionTypeEquipmentSubType3) {
            [param setObject:@"3" forKey:@"type"];
        }
    }
    
    if (self.type == FunctionTypeEngineeringDynamics) {
        [param setObject:@"" forKey:@"projectId"];
        [param setObject:@"" forKey:@"sectId"];
    }
    
    if (self.type == FunctionTypeElectricianRegular || self.type == FunctionTypeSideStationRecord || self.type == FunctionTypePatrolInspectRecord) {
        [param setObject:[UserAgent DefaultAgent].sectionId forKey:@"sectionId"];
    }
    
    if((self.type == FunctionTypeSecurityListSd || self.type == FunctionTypeSecurityList || self.type == FunctionTypeSafecheckRecode) && self.pid){
        [param setObject:self.pid forKey:@"sgSignId"];
        [param setObject:[UserAgent DefaultAgent].sectionId forKey:@"sectionId"];
    }
    
    
    if(self.type == FunctionTypeFileInfo && self.pid){
        [param setObject:self.pid forKey:@"mid"];
    }
    if(self.type == FunctionTypeHiddenAccidentReport && self.pid){
          [param setObject:self.pid forKey:@"hazardListId"];
      }
      
    if(self.type == FunctionTypeSafecheckRecode){
        [param setObject:[UserAgent DefaultAgent].sectionId forKey:@"sectionId"];
        [param setObject:[UserAgent DefaultAgent].sectionCode forKey:@"sectionCode"];
        [param removeObjectForKey:@"sectId"];
    }
    if(self.type == FunctionTypeNoticeReplyList){
        [param setValue:self.noticeId forKey:@"noticeId"];
        [param setValue:self.pid forKey:@"id"];
    }
    return param;
}

- (void)loadPartCode {
    __weak typeof(self) weakSelf = self;
    [[HttpManager manager] post:[UrlConfig URL:getProjectListTree] param:@{@"id":[UserAgent DefaultAgent].sectionCode} success:^(NSData *data) {
        NSArray <SiteModel *>*temp = [SiteModel mj_objectArrayWithKeyValuesArray:data];
        if (temp && temp.count != 0) {
            SiteModel *model = temp.firstObject;
            [self->_conditionController.projectBtn setTitle:model.text forState:UIControlStateNormal];
            self->_conditionController.partCode = model.id;
            [weakSelf.tableView.mj_header beginRefreshing];
        }
    } faild:nil];
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
    _conditionController.showKeyword = [FunctionFactory isShowKeywordFilter:self.type];
    _conditionController.keyword = [FunctionFactory keywordOfFunctionType:self.type];
    _conditionController.showDate = [FunctionFactory isShowDateFilter:self.type];
    _conditionController.hiddenPartBtn = YES;
    _conditionController.conditionModels = conditionModels;
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

#pragma mark - UITableViewDelegate, UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [FunctionFactory cellHeightOfFunctionType:self.type];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.type == FunctionTypeSecurityCheckLog || self.type == FunctionTypeConstructionPlan || self.type == FunctionTypeSecurityCheckRecord || self.type == FunctionTypeSafetyDisclosure || self.type == FunctionTypeSafetyEducation || self.type == FunctionTypeSecurityCheck || self.type == FunctionTypeSecurityListSd || self.type == FunctionTypeSecurityList || self.type == FunctionTypeSafeAccidentReport || self.type == FunctionTypeHiddenAccidentReport|| self.type == FunctionTypeSafecheckRecode || self.type == FunctionTypeSideStationRecord || self.type == FunctionTypePatrolInspectRecord || self.type == FunctionTypeSupervisionList || self.type == FunctionTypeSupervisionListNew1 || self.type == FunctionTypeSupervisionListNew2) {
        BaseListCell2 *cell = [tableView dequeueReusableCellWithIdentifier:KCell2Id forIndexPath:indexPath];
        [FunctionFactory baseListCell2:cell setData:self.dataSource[indexPath.row] withType:self.type];
        __weak typeof(self) weakSelf = self;
        cell.callback = ^{
            UIViewController *vc = [FunctionFactory childViewControllerOfFunctionType:weakSelf.type withModel:weakSelf.dataSource[indexPath.row]];
            if (vc) {
                [weakSelf.navigationController pushViewController:vc animated:YES];
            }
        };
        return cell;
    } else if (self.type == FunctionTypeQualityInspectionUnsubmitted || self.type == FunctionTypeQualityInspectionWaitRectification || self.type == FunctionTypeQualityInspectionWaitReview || self.type == FunctionTypeQualityInspectionFinished || self.type == FunctionTypeGreenProblemUnsubmitted || self.type == FunctionTypeGreenProblemWaitRectification || self.type == FunctionTypeGreenProblemWaitReview || self.type == FunctionTypeGreenProblemFinished  || self.type == FunctionTypeSafetyDangerUnsubmitted || self.type == FunctionTypeSafetyDangerWaitRectification || self.type == FunctionTypeSafetyDangerWaitReview || self.type == FunctionTypeSafetyDangerFinished || self.type == FunctionTypeWaterProblemUnsubmitted || self.type == FunctionTypeWaterProblemWaitRectification || self.type == FunctionTypeWaterProblemWaitReview || self.type == FunctionTypeWaterProblemFinished) {
        ProblemListCell *cell = [tableView dequeueReusableCellWithIdentifier:KCell3Id forIndexPath:indexPath];
        [FunctionFactory problemListCell:cell setData:self.dataSource[indexPath.row] withType:self.type];
        if([self.resourceTitle isEqualToString:@"环保问题整改"] || [self.resourceTitle isEqualToString:@"水保巡查整改"]||[self.resourceTitle isEqualToString:@"安全隐患"]||[self.resourceTitle isEqualToString:@"安全检查"]){
           
            if([self.resourceTitle isEqualToString:@"安全检查"]){
                 cell.describeLabel.text = [self.dataSource[indexPath.row] valueForKey:@"name"];
            }else{
                cell.describeLabel.text = [self.dataSource[indexPath.row] valueForKey:@"describe"];
            }
        }
        
        return cell;
    } else if (self.type == FunctionTypeEquipment) {
        SpecialUseListCell *cell = [tableView dequeueReusableCellWithIdentifier:KCell4Id forIndexPath:indexPath];
        [FunctionFactory specialUseListCell:cell setData:self.dataSource[indexPath.row] withType:self.type];
        __weak typeof(self) weakSelf = self;
        cell.callback = ^{
            UIViewController *vc = [FunctionFactory childViewControllerOfFunctionType:weakSelf.type withModel:weakSelf.dataSource[indexPath.row]];
            if (vc) {
                [weakSelf.navigationController pushViewController:vc animated:YES];
            }
        };
        return cell;
    } else if (self.type == FunctionTypeConstructionLog || self.type == FunctionTypeSupervisionLog) {
        LogListcell *cell = [tableView dequeueReusableCellWithIdentifier:KCell5Id forIndexPath:indexPath];
        [FunctionFactory logListcell:cell setData:self.dataSource[indexPath.row] withType:self.type];
        return cell;
    } else if (self.type == FunctionTypeSafetyProblem) {
        SafetyProblemCell *cell = [tableView dequeueReusableCellWithIdentifier:KCell6Id forIndexPath:indexPath];
        [FunctionFactory safetyProblemListCell:cell setData:self.dataSource[indexPath.row] withType:self.type];
        return cell;
    } else if (self.type == FunctionTypeEngineeringDynamics) {
//        DongTaiCell *cell = [tableView dequeueReusableCellWithIdentifier:KCell7Id forIndexPath:indexPath];
//        [FunctionFactory dongtaiListcell:cell setData:self.dataSource[indexPath.row] withType:self.type];
//        return cell;
    }else if (self.type == FunctionTypeProgressAllowedYear || self.type == FunctionTypeProgressAllowedMonth || self.type == FunctionTypeProgressAllowedQuarter || self.type == FunctionTypeProgressAllowedWeek || self.type == FunctionTypeProgressAllowedDay) {
//        AllowedCell *cell = [tableView dequeueReusableCellWithIdentifier:KCell8Id forIndexPath:indexPath];
//        [FunctionFactory allowedListCell:cell setData:self.dataSource[indexPath.row] withType:self.type];
//        return cell;
    }else if (self.type == FunctionTypeProgressPlanMonth || self.type == FunctionTypeProgressPlanQuarter || self.type == FunctionTypeProgressPlanYear) {
//        AllowedCell *cell = [tableView dequeueReusableCellWithIdentifier:KCell8Id forIndexPath:indexPath];
//        [FunctionFactory planListCell:cell setData:self.dataSource[indexPath.row] withType:self.type];
//        return cell;
    } else {
        BaseListCell1 *cell = [tableView dequeueReusableCellWithIdentifier:KCell1Id forIndexPath:indexPath];
        [FunctionFactory baseListCell1:cell setData:self.dataSource[indexPath.row] withType:self.type];
        __weak typeof(self) weakSelf = self;
        cell.callback = ^{
            UIViewController *vc = [FunctionFactory childViewControllerOfFunctionType:weakSelf.type withModel:weakSelf.dataSource[indexPath.row]];
            if (vc) {
                [weakSelf.navigationController pushViewController:vc animated:YES];
            }
        };
        return cell;
    }
    return [UITableViewCell new];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (self.type == FunctionTypeSupervisionListNew1 || self.type == FunctionTypeSupervisionListNew2) {
//        SupervisionNewModel *model = (SupervisionNewModel *)self.dataSource[indexPath.row];
//        FormBaseController *vc = [FormBaseController new];
//        vc.urlStr = [FunctionFactory getUrlParamsSetData:self.dataSource[indexPath.row] Type:self.type mid:self.pid];
//        vc.resourceTitle = @"督查督办明细";
//        vc.attachment = YES;
//        vc.mId = model.id;
//        if (model.status != 1 && model.status != 2 && model.status != 4) {
//            vc.showComplete = YES;
//        }
//        [self pushTo:vc];
    } else if(self.type == FunctionTypeNoticeList || self.type == FunctionTypeSupervisionList){
//        FormBaseController *vc = [FormBaseController new];
//        vc.urlStr = [FunctionFactory getUrlParamsSetData:self.dataSource[indexPath.row] Type:self.type mid:self.pid];
//        vc.attachment = YES;
//        vc.resourceTitle = self.navigationItem.title;
//        if(self.type == FunctionTypeSupervisionList){
//            vc.markId = [self.dataSource[indexPath.row]  mj_keyValues][@"noticeId"];
//        }
//        [self pushTo:vc];
    }else if(self.type == FunctionTypeSideStationRecord || self.type == FunctionTypePatrolInspectRecord){
        SideStationModel *model = (SideStationModel *)self.dataSource[indexPath.row];
        if(!model.instId || model.status == 1){
            FormBase1Controller *vc = [FormBase1Controller new];
            vc.typeUrl = self.type == FunctionTypeSideStationRecord?@"sideStationRecord":@"tourRecord";
            vc.reTitle = self.navigationItem.title;
            vc.attachment = YES;
            vc.hasFLow = YES;
            vc.submitText = @"提交";
            vc.id = model.id;
            vc.bizPk = model.id;
            vc.isReadOnly = ![[self.dataSource[indexPath.row]  mj_keyValues][@"userId"] isEqualToString:[AppUser sharedInstance].userId];
            [self pushTo:vc];
        }else{
            if(model.status == 1){
                //审核
                WebFlowBaseViewController *flow = [[WebFlowBaseViewController
                                                    alloc]init];
                flow.typeUrl = self.type == FunctionTypeSideStationRecord?@"sideStationRecord":@"tourRecord";
                flow.navTitle = self.navigationItem.title;
                flow.id = model.id;
                flow.bizPk = model.instId;
                [self.navigationController pushViewController:flow animated:YES];
                return;
            }
            QDReportDetailController *detail = [[QDReportDetailController alloc] init];
            detail.bizPk = model.instId;
            detail.id = model.id;
            [[NSUserDefaults standardUserDefaults] setObject: model.id forKey:@"modelId"];
            detail.title = self.navigationItem.title;
            detail.status = [NSString stringWithFormat:@"%d",model.status];
            detail.bizKey = @"";
            detail.newFormFlag = NO;
            detail.callBack = ^() {
                [self getStatus:model.instId modelId:model.id];
            };
            detail.partCode = [UserAgent DefaultAgent].sectionCode ? [UserAgent DefaultAgent].sectionCode : @"";
            [self.navigationController pushViewController:detail animated:YES];

        }
    }else if (self.type == FunctionTypeProgressAllowedYear || self.type == FunctionTypeProgressAllowedMonth || self.type == FunctionTypeProgressAllowedQuarter || self.type == FunctionTypeProgressAllowedWeek || self.type == FunctionTypeProgressAllowedDay)
   {
//        DetailAllowViewController *vc = [DetailAllowViewController new];
//        AllowedModel *model = (AllowedModel *)self.dataSource[indexPath.row];
//        vc.resourceTitle =model.progressFinishName;
//        vc.model =model;
//       vc.type = self.type;
//        [self pushTo:vc];
   }else if (self.type == FunctionTypeProgressPlanMonth || self.type == FunctionTypeProgressPlanQuarter || self.type == FunctionTypeProgressPlanYear )
   {
//       DetailPlanViewController *vc = [DetailPlanViewController new];
//        PlanScheduleModel *model = (PlanScheduleModel *)self.dataSource[indexPath.row];
//        vc.resourceTitle = model.progressPlanName;
//        vc.model =model;
//        vc.type = self.type;
//        [self pushTo:vc];
   }else if(self.type == FunctionTypeChangeListCard){
//       DetailMainVc *dvc = [[UIStoryboard storyboardWithName:@"DetailMain" bundle:nil]instantiateViewControllerWithIdentifier:@"DetailMainVc"];
//       ChangeInfoModel *model = (ChangeInfoModel *)self.dataSource[indexPath.row];
//       dvc.info = model.mj_keyValues;
//       dvc.type = 8;
//       [self pushTo:dvc];
       
   }else if(self.type == FunctionTypeSecurityCheck || self.type == FunctionTypeFileInfo || self.type == FunctionTypeSafeAccidentReport ||self.type == FunctionTypeHiddenAccidentReport){
//       FormBaseController *vc = [FormBaseController new];
//       vc.urlStr = [FunctionFactory getUrlParamsSetData:self.dataSource[indexPath.row] Type:self.type mid:self.pid];
//       vc.resourceTitle = self.navigationItem.title;
//       if(self.type == FunctionTypeHiddenAccidentReport){
//           vc.markId = [self.dataSource[indexPath.row] mj_keyValues][@"accidentId"];
//       }else{
//           vc.markId = [self.dataSource[indexPath.row] mj_keyValues][@"id"];
//       }
//
//       vc.attachment = self.type != FunctionTypeSafeAccidentReport;
//       [self pushTo:vc];
       
   }else if(self.type == FunctionTypeSecurityList || self.type == FunctionTypeSecurityListSd|| self.type == FunctionTypeSafecheckRecode){
      
//       RecodelistSdModel *data = (RecodelistSdModel *)self.dataSource[indexPath.row];
//       if(data.instId){
//        AuditSecurityViewController *vc = [AuditSecurityViewController new];
//           vc.model = data;
//           vc.mid = self.pid;
//           vc.functionType = self.type;
//           vc.tableName =  self.type == FunctionTypeSecurityListSd?@"SAFE_CHECK_SD_RECODE":@"SAFE_CHECK_RECODE";
//           [[NSUserDefaults standardUserDefaults] setObject: [self.dataSource[indexPath.row] mj_keyValues][@"id"]  forKey:@"modelId"];
//           [self pushTo:vc];
//       }else{
//           FormBaseController *vc = [FormBaseController new];
//           vc.urlStr = [FunctionFactory getUrlParamsSetData:self.dataSource[indexPath.row] Type:self.type mid:self.pid];
//           vc.resourceTitle =  self.navigationItem.title;
//           vc.markId = [self.dataSource[indexPath.row] mj_keyValues][@"id"];
//           vc.attachment = false;
//           vc.isReadOnly = ![[self.dataSource[indexPath.row]  mj_keyValues][@"userId"] isEqualToString:[AppUser sharedInstance].userId];
//           vc.entityName = self.type == FunctionTypeSecurityListSd?@"SAFE_CHECK_SD_RECODE":@"SAFE_CHECK_RECODE";
//           vc.tableName =  self.type == FunctionTypeSecurityListSd?@"SAFE_CHECK_SD_RECODE":@"SAFE_CHECK_RECODE";
//
//           [self pushTo:vc];
//       }
   }else{
       UIViewController *vc = [FunctionFactory viewControllerOfFunctionType:self.type withModel:self.dataSource[indexPath.row]];
       if([vc isKindOfClass:[BaseViewController class]]){
           BaseViewController *baseVc = (BaseViewController *)vc;
           baseVc.resourceTitle = self.resourceTitle;
           [self pushTo:baseVc];
       }else{
           [self pushTo:vc];
       }
   }

}

-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.type == FunctionTypeSupervisionListNew1 || self.type == FunctionTypeSupervisionListNew2) {
//        SupervisionNewModel *model = (SupervisionNewModel *)self.dataSource[indexPath.row];
//        if (model != nil && model.status == 3 && model.replyCount == 0) {
//            return @"撤回";
//        } else {
//            return @"删除";
//        }
    } else {
        return @"删除";
    }
    return @"";
}

-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([FunctionFactory canDelete:self.type]) {
        return UITableViewCellEditingStyleDelete;
    } else {
        return UITableViewCellEditingStyleNone;
    }
}
- (void)tableView:(UITableView*)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath*)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        if (self.type == FunctionTypeSupervisionListNew1 || self.type == FunctionTypeSupervisionListNew2) {
//            SupervisionNewModel *model = (SupervisionNewModel *)self.dataSource[indexPath.row];
//            if (model.status == 3 && model.replyCount == 0) {
//                //撤回
//                __weak typeof(self) weakSelf = self;
//                UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"撤回提示" message:@"确定要撤回吗？" preferredStyle:UIAlertControllerStyleAlert];
//                [alertC addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//                    [SVProgressHUD showWithStatus:@"撤回中..."];
//                    NSString *url = [NSString stringWithFormat:@"%@%@", [UrlConfig URL:revokeNoticeNew], model.id];
//                    [[HttpManager manager] get:url param:@{@"status": @"2"} success:^(NSData *data) {
//                        if ([ResponseUtils success:data]) {
//                            [SVProgressHUD showSuccessWithStatus:@"撤回成功"];
//                             [weakSelf.tableView.mj_header beginRefreshing];
//                        } else {
//                            [SVProgressHUD showErrorWithStatus:[ResponseUtils getMsg]];
//                        }
//                    } faild:^(NSString *msg) {
//                        [SVProgressHUD showErrorWithStatus:msg];
//                    }];
//                }]];
//                [alertC addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
//                [self presentViewController:alertC animated:YES completion:nil];
//                return;
//            } else {
//                if (![model.createUserId isEqualToString:[AppUser sharedInstance].userId]) {
//                    [SVProgressHUD showErrorWithStatus:@"暂无操作权限!"];
//                    return;
//                }
//                if (model.status != 1 && model.status != 2) {
//                    [SVProgressHUD showErrorWithStatus:@"仅草稿状态可删除!"];
//                    return;
//                }
//            }
        }
        
        if(self.type == FunctionTypeQualityInspectionUnsubmitted || self.type == FunctionTypeSafecheckRecode) {
            if( ![[self.dataSource[indexPath.row]  mj_keyValues][@"userId"] isEqualToString:[AppUser sharedInstance].userId]){
                [SVProgressHUD showErrorWithStatus:@"暂无操作权限!"];
                return;
            }
        }
        
        
        
        if(self.type == FunctionTypeSupervisionList) {
            NSNumber *str = [self.dataSource[indexPath.row] mj_keyValues][@"status"];
            if(str && [str isEqualToNumber:@1]){
                [SVProgressHUD showErrorWithStatus:@"流程中数据暂不支持删除!"];
                return;
            }
        }
        
        if(self.type == FunctionTypeControlEngineering) {
            NSNumber *str = [self.dataSource[indexPath.row] mj_keyValues][@"status"];
            if(![str isEqualToNumber:@0] && ![str isEqualToNumber:@1]){
                [SVProgressHUD showErrorWithStatus:@"流程中数据暂不支持删除!"];
                return;
            }
        }
       
        if((self.type == FunctionTypeSecurityList ||self.type == FunctionTypeSecurityListSd|| self.type == FunctionTypeSafecheckRecode)) {
            NSString *str = [self.dataSource[indexPath.row] mj_keyValues][@"statu"];
            if(str || [str isEqualToString:@"0"]){
                [SVProgressHUD showErrorWithStatus:@"流程中数据暂不支持删除!"];
                return;
            }
        }
        if(self.type == FunctionTypeSideStationRecord || self.type == FunctionTypePatrolInspectRecord){
            NSNumber *str = [self.dataSource[indexPath.row] mj_keyValues][@"status"];
            if([str isEqualToNumber:@2] || [str isEqualToNumber:@3] || [str isEqualToNumber:@4]){
                [SVProgressHUD showErrorWithStatus:@"流程中数据暂不支持删除!"];
                return;
            }
            if( ![[self.dataSource[indexPath.row]  mj_keyValues][@"userId"] isEqualToString:[AppUser sharedInstance].userId]){
                [SVProgressHUD showErrorWithStatus:@"暂无操作权限!"];
                return;
            }
        }
        if(self.type == FunctionTypeQualityInspectionUnsubmitted){
            if(![[self.dataSource[indexPath.row]  mj_keyValues][@"userId"] isEqualToString:[AppUser sharedInstance].userId]){
                [SVProgressHUD showErrorWithStatus:@"无此操作权限!"];
                return;
            }
        }
        UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"删除提示" message:@"确定要删除吗？" preferredStyle:UIAlertControllerStyleAlert];
        [alertC addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            if (self.type == FunctionTypeSafeAccidentReport) {
                [self deleteData:[self.dataSource[indexPath.row] valueForKey:@"reportId"]];
                return;
            }else if (self.type == FunctionTypeHiddenAccidentReport) {
                [self deleteData:[self.dataSource[indexPath.row] valueForKey:@"accidentId"]];
                return;
            }else if (self.type == FunctionTypeSupervisionList) {
                [self deleteData:[self.dataSource[indexPath.row] valueForKey:@"noticeId"]];
                return;
            }else if (self.type == FunctionTypeSupervisionList) {
                [self deleteData:[self.dataSource[indexPath.row] valueForKey:@"noticeId"]];
                return;
            }else if (self.type == FunctionTypeProgressPlanYear || self.type == FunctionTypeProgressPlanQuarter || self.type == FunctionTypeProgressPlanMonth) {
                [self deleteData:[self.dataSource[indexPath.row] valueForKey:@"progressPlanId"]];
                return;
            }else if (self.type == FunctionTypeProgressPlanYear || self.type == FunctionTypeProgressPlanQuarter || self.type == FunctionTypeProgressPlanMonth) {
                [self deleteData:[self.dataSource[indexPath.row] valueForKey:@"progressPlanId"]];
                return;
            }else if (self.type == FunctionTypeProgressAllowedDay || self.type == FunctionTypeProgressAllowedWeek || self.type == FunctionTypeProgressAllowedMonth || self.type == FunctionTypeProgressAllowedQuarter || self.type == FunctionTypeProgressAllowedYear) {
                [self deleteData:[self.dataSource[indexPath.row] valueForKey:@"progressFinishId"]];
                return;
            }
            [self deleteData:[self.dataSource[indexPath.row] valueForKey:@"id"]];
        }]];
        [alertC addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
        [self presentViewController:alertC animated:YES completion:nil];
    }
}

#pragma mark - 点击新增按钮
- (void)addBtnClicked {
    if(self.type == FunctionTypeProgressPlanMonth || self.type == FunctionTypeProgressPlanQuarter || self.type == FunctionTypeProgressPlanYear){
//        FormBaseController *vc = [FormBaseController new];
//              vc.urlStr = [FunctionFactory getUrlParamsSetData:nil Type:self.type mid:self.pid];
//              vc.resourceTitle = @"选择期数";
//              vc.attachment = NO;
//              [self pushTo:vc];
          return;
    }else if (self.type == FunctionTypeSupervisionListNew2) {
//        FormBaseController *vc = [FormBaseController new];
//        vc.urlStr = [FunctionFactory getUrlParamsSetData:nil Type:self.type mid:self.pid];
//        vc.resourceTitle = @"督查督办明细";
//        vc.attachment = YES;
//        [self pushTo:vc];
        return;
    } else if(self.type == FunctionTypeSupervisionList) {
//        FormBaseController *vc = [FormBaseController new];
//              vc.urlStr = [FunctionFactory getUrlParamsSetData:nil Type:self.type mid:self.pid];
//              vc.resourceTitle = self.navigationItem.title;
//              vc.attachment = YES;
//              [self pushTo:vc];
          return;
    }else if(self.type == FunctionTypeSideStationRecord || self.type == FunctionTypePatrolInspectRecord){
     FormBase1Controller *vc = [FormBase1Controller new];
     vc.typeUrl =  self.type == FunctionTypeSideStationRecord?@"sideStationRecord":@"tourRecord";
     vc.reTitle = self.navigationItem.title;
     vc.attachment = YES;
     vc.hasFLow = YES;
     vc.submitText = @"提交";
     [self pushTo:vc];
     return;
  }else if(self.type == FunctionTypeProgressAllowedDay || self.type == FunctionTypeControlEngineering){
        [self showDate];
        return;
  }else if(self.type == FunctionTypeSecurityCheck||self.type == FunctionTypeFileInfo||self.type == FunctionTypeHiddenAccidentReport){
//      FormBaseController *vc = [FormBaseController new];
//            vc.urlStr = [FunctionFactory getUrlParamsSetData:nil Type:self.type mid:self.pid];
//            vc.resourceTitle = self.navigationItem.title;
//            vc.attachment = YES;
//            [self pushTo:vc];
        return;
  }else if(self.type == FunctionTypeSecurityListSd || self.type == FunctionTypeSecurityList||self.type == FunctionTypeSafeAccidentReport|| self.type == FunctionTypeSafecheckRecode){
//      FormBaseController *vc = [FormBaseController new];
//            vc.urlStr = [FunctionFactory getUrlParamsSetData:nil Type:self.type mid:self.pid];
//            vc.resourceTitle = self.navigationItem.title;
//            vc.attachment = NO;
//            [self pushTo:vc];
        return;
  }
    UIViewController *vc = [FunctionFactory viewControllerOfFunctionType:self.type withModel:nil];
    if([vc isKindOfClass:[BaseViewController class]]){
        BaseViewController *baseVc = (BaseViewController *)vc;
        baseVc.resourceTitle = self.resourceTitle;
        [self pushTo:baseVc];
    }else{
        [self pushTo:vc];
    }
}
#pragma mark - 显示日期选择器
- (void)showDate{
//    FDCalendarView *calendarView = [[FDCalendarView alloc] initWithFrame:[UIScreen mainScreen].bounds andCurrentDateStr:@"请选择日期" minimumDate:nil datePickerMode:UIDatePickerModeDate];
//    [[UIApplication sharedApplication].keyWindow addSubview:calendarView];
//    calendarView.block = ^(NSDate *date) {
//        if (date){
//            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//            formatter.locale = [NSLocale currentLocale];
//            formatter.timeZone = [NSTimeZone localTimeZone];
//            formatter.dateFormat = @"yyyy-MM-dd";
//
//            if(self.type == FunctionTypeControlEngineering){
//                [[HttpManager manager]jsonPost:[UrlConfig URL:saveReportMain] param:@{
//                    @"projectId": [UserAgent DefaultAgent].projectId,
//                    @"sectionId": [UserAgent DefaultAgent].sectionId,
//                    @"reportDate": [formatter stringFromDate:date],
//                    @"reportName":[NSString stringWithFormat:@"%@%@%@年%@月%@日控制性工程进度日报",[UserAgent DefaultAgent].prjName,[UserAgent DefaultAgent].sectionName,[[formatter stringFromDate:date] substringWithRange:NSMakeRange(0,4)],[[formatter stringFromDate:date] substringWithRange:NSMakeRange(5,2)],[[formatter stringFromDate:date] substringWithRange:NSMakeRange(8,2)]]
//                } success:^(NSData *data) {
//                    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
//                    if (dict) {
//                        if([[dict[@"succeed"] stringValue] isEqualToString:@"1"]){
//                            [SVProgressHUD showSuccessWithStatus:@"添加成功"];
//                            [self loadData:YES];
//                        }else{
//                            [SVProgressHUD showErrorWithStatus:dict[@"msg"]];
//                        }
//                    }
//                } faild:^(NSString *msg) {
//                    [SVProgressHUD showErrorWithStatus:msg];
//                }];
//
//                return;
//            }
//            [[HttpManager manager]post:[UrlConfig URL:saveDayFinish] param:@{
//                @"projectId": [UserAgent DefaultAgent].projectId,
//                @"sectNo": [UserAgent DefaultAgent].sectionId,
//                @"startDate": [formatter stringFromDate:date],
//                @"endDate": [formatter stringFromDate:date]
//            } success:^(NSData *data) {
//                NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
//                if (dict) {
//                    if([[dict[@"success"] stringValue] isEqualToString:@"1"]){
//                        [SVProgressHUD showSuccessWithStatus:@"添加成功"];
//                        [self loadData:YES];
//                    }else{
//                        [SVProgressHUD showErrorWithStatus:dict[@"msg"]];
//                    }
//                }
//            } faild:^(NSString *msg) {
//                [SVProgressHUD showErrorWithStatus:msg];
//            }];
//        }
//    };
//    [calendarView fadeIn];
}

#pragma mark - 删除数据
- (void)deleteData:(NSString *)ID {
    NSString *delid = @"id";
    
    if (self.type == FunctionTypeProcessTracking) {
        delid = @"fabricId";
    }
    __weak typeof(self) weakSelf = self;
    [SVProgressHUD showWithStatus:@"删除中..."];
    
    if(self.type == FunctionTypeSafeAccidentReport || self.type == FunctionTypeSideStationRecord || self.type == FunctionTypePatrolInspectRecord || self.type == FunctionTypeSupervisionList || self.type == FunctionTypeProgressPlanYear || self.type == FunctionTypeProgressPlanQuarter || self.type == FunctionTypeProgressPlanMonth  || self.type == FunctionTypeProgressAllowedDay|| self.type == FunctionTypeControlEngineering || self.type == FunctionTypeProgressAllowedWeek || self.type == FunctionTypeProgressAllowedMonth || self.type == FunctionTypeProgressAllowedQuarter || self.type == FunctionTypeProgressAllowedYear || self.type == FunctionTypeSupervisionListNew1 || self.type == FunctionTypeSupervisionListNew2){
        NSString *url = [NSString stringWithFormat:@"%@%@", [FunctionFactory deleteURLOfFunctionType:self.type],ID];
        [[HttpManager manager] del:url param:nil success:^(NSData *data) {
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
    
    if(self.type == FunctionTypeHiddenAccidentReport || self.type == FunctionTypeSideStationRecord || self.type == FunctionTypePatrolInspectRecord){
        NSString *url = [NSString stringWithFormat:@"%@%@", [FunctionFactory deleteURLOfFunctionType:self.type],ID];
        [[HttpManager manager] get:url param:nil success:^(NSData *data) {
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
    

    
    NSString *url = [FunctionFactory deleteURLOfFunctionType:self.type] ;
    if([self.resourceTitle isEqualToString:@"环保问题整改"]){
        url = [UrlConfig URL:delGreeProblem];
    }else if ([self.resourceTitle isEqualToString:@"水保巡查整改"]) {
        url = [UrlConfig URL:delGreeWaterProblem];
    }else if ([self.resourceTitle isEqualToString:@"安全隐患"]||[self.resourceTitle isEqualToString:@"安全检查"]) {
        url = [UrlConfig URL:delRisk];
    }
    [[HttpManager manager] post:url param:@{
                                                                                            delid:ID
                                                                                            }
                        success:^(NSData *data) {
                            [SVProgressHUD dismiss];
                            if ([ResponseUtils success:data]) {
                                [weakSelf.tableView.mj_header beginRefreshing];
                            } else {
                                [SVProgressHUD showErrorWithStatus:[ResponseUtils getMsg]];
                            }
                        } faild:^(NSString *msg) {
                            [SVProgressHUD dismiss];
                        }];
}

#pragma mark - 跳转
- (void)pushTo:(UIViewController *)vc {
    if (self.type == FunctionTypeProcessTracking) {
        [vc setValue:_partCode forKey:@"partCode"];
    }
    if (self.pid && self.type != FunctionTypeSecurityListSd && self.type != FunctionTypeSecurityList && self.type != FunctionTypeFileInfo && self.type != FunctionTypeHiddenAccidentReport && self.type != FunctionTypeSafecheckRecode) {
        [vc setValue:self.pid forKey:@"pid"];
    }
    
    [self.navigationController pushViewController:vc animated:YES];
}


#pragma mark - 请求DictId
- (void)reqDictId:(DataCollection *)datas isRefresh:(BOOL)isRefresh{
    __block NSArray *arr1;
    __block NSArray *arr2;
    [[HttpManager manager] post:[UrlConfig URL:getCategoryList] param:@{@"value":@"accidentType"} success:^(NSData *data) {
        if ([ResponseUtils success:data]) {
//             arr1  = [EnumModel mj_objectArrayWithKeyValuesArray:[ResponseUtils getData:@"data"]];
//            if(arr1 && arr2){
//                [self dealDataEnum:arr1 arr2:arr2 datas:datas isRefresh:isRefresh];
//            }
        } else {
            [SVProgressHUD showErrorWithStatus:[ResponseUtils getMsg]];
        }
    } faild:^(NSString *msg) {
        [SVProgressHUD showErrorWithStatus:msg];
    }];
    [[HttpManager manager] post:[UrlConfig URL:getCategoryList] param:@{@"value":@"accidentLevel"} success:^(NSData *data) {
        if ([ResponseUtils success:data]) {
//            arr2 = [EnumModel mj_objectArrayWithKeyValuesArray:[ResponseUtils getData:@"data"]];
//             if(arr1 && arr2){
//                 [self dealDataEnum:arr1 arr2:arr2 datas:datas isRefresh:isRefresh];
//             }
        } else {
            [SVProgressHUD showErrorWithStatus:[ResponseUtils getMsg]];
        }
    } faild:^(NSString *msg) {
        [SVProgressHUD showErrorWithStatus:msg];
    }];
}
-(void)dealDataEnum:(NSArray *)arr1 arr2:(NSArray *)arr2 datas:(DataCollection *)datas isRefresh:(BOOL)isRefresh{
//    for (HazardAccidentModel *model in datas.rows) {
//        for (EnumModel *item in arr1) {
//            if ([item.code isEqualToString:model.accidentType]) {
//                model.accidentTypeName = item.name;
//                break;
//            }
//        }
//        for (EnumModel *item in arr2) {
//            if ([item.code isEqualToString:model.accidentType]) {
//                model.accidentLevelName = item.name;
//                break;
//            }
//        }
//    }
//
//     __weak typeof(self) weakSelf = self;
//    if (datas) {
//        if (isRefresh) {
//            [weakSelf.tableView.mj_header endRefreshing];
//            [weakSelf.dataSource removeAllObjects];
//        } else {
//            [weakSelf.tableView.mj_footer endRefreshing];
//        }
//
//        [weakSelf.dataSource addObjectsFromArray:datas.rows];
//        if (weakSelf.dataSource.count >= datas.total) {
//            [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
//        }
//
//        [weakSelf.tableView reloadData];
//    } else {
//        if (isRefresh) {
//            [weakSelf.tableView.mj_header endRefreshing];
//        } else {
//            [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
//        }
//        [SVProgressHUD showErrorWithStatus:@"数据加载失败!"];
//    }
//    self->_noDataView.hidden = weakSelf.dataSource.count != 0;
    
}

- (void)getStatus:(NSString *)bizPk modelId:(NSString *)modelId {
    [[HttpManager manager] get:[UrlConfig URL:getInstBizByBizPk] param:@{@"bizPk": bizPk} success:^(NSData *data) {
        if ([ResponseUtils success:data]) {
            NSDictionary *dic  = [data mj_JSONObject];
            [self updateStatus:dic[@"data"][@"status"] instId:bizPk];
        }
    } faild:^(NSString *msg) {
        [SVProgressHUD showErrorWithStatus:msg];
    }];
}

#pragma mark - 同步更新状态
- (void)updateStatus:(NSString *)status instId:(NSString *)instId{
    NSString *url = self.type ==FunctionTypePatrolInspectRecord ? [UrlConfig URL:patrolInspectRecordUpdate]: [UrlConfig URL:updateSideStationRecord];
    [[HttpManager manager] jsonPost:url param:@{
        @"instId": instId,
        @"status": status
    } success:^(NSData *data) {
        [self loadData:YES];
    } faild:^(NSString *msg) {
        [SVProgressHUD showErrorWithStatus:msg];
    }];
}

//获取当前时间戳
- (NSString *)currentTimeStr{
    NSDate* date = [NSDate dateWithTimeIntervalSinceNow:0];//获取当前时间0秒后的时间
    NSTimeInterval time=[date timeIntervalSince1970]*1000;// *1000 是精确到毫秒，不乘就是精确到秒
    NSString *timeString = [NSString stringWithFormat:@"%.0f", time];
    return timeString;
}

@end
