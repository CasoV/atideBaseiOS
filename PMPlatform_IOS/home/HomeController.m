//
//  HomeController.m
//  PMPlatform_IOS
//
//  Created by 末末班车 on 2017/9/4.
//  Copyright © 2017年 com.atide. All rights reserved.
//

#import "HomeController.h"
#import "SearchViewController.h"
#import "DetailController.h"
#import "HomeModel.h"
#import "HomeCell.h"
#import "BaseWebViewController.h"

@interface HomeController ()<UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation HomeController {
    DataCollection *_todoData;
    DataCollection *_doingData;
    DataCollection *_doneData;
    
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupTableView];
    [self loadProjectInfos];
}
- (void)loadProjectInfos {
    __weak typeof(self) weakSelf = self;
    [[HttpManager manager] post:[UrlConfig URL:getProjects] param:@{@"async":@0,@"topKey":@"project",@"keyPrefix":@"project,section"} success:^(NSData *data) {
        [DataCollection mj_setupObjectClassInArray:^NSDictionary *{
            return @{@"rows":@"ProjectInfo"};
        }];
        NSArray *content = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        NSMutableArray <ProjectInfo *>*dataCollection = [NSMutableArray array];
        for (NSDictionary *dic in content) {
            ProjectInfo *model = [ProjectInfo mj_objectWithKeyValues:dic];
            [weakSelf getProjectDataTempChildren:model];
            [weakSelf handleProjectData:model];
            NSMutableArray <ProjectInfo *>*childArr = [NSMutableArray array];
            [weakSelf getProjectDataChildren:model.tempChildren rootChildren:childArr];
            model.children =  childArr;
        
            [dataCollection addObject:model];
        }
        [UserAgent DefaultAgent].projectInfos = dataCollection;
        ProjectInfo *projectInfo = nil;
        ProjectInfo *sectionInfo = nil;
        for (ProjectInfo *info in dataCollection) {
            if ([info.id isEqualToString:[UserAgent DefaultAgent].projectId]) {
                projectInfo = info;
                break;
            }
        }
        if (!projectInfo) {
            projectInfo = dataCollection.firstObject;
        }
        projectInfo.selected = YES;
        [UserAgent DefaultAgent].sectionInfos = projectInfo.children;
        
        for (ProjectInfo *sect in projectInfo.children) {
            if ([sect.id isEqualToString:[UserAgent DefaultAgent].sectionId]) {
                sectionInfo = sect;
                break;
            }
        }
        
        [UserAgent DefaultAgent].projectId = projectInfo.id;
        [UserAgent DefaultAgent].projectCode = projectInfo.otherInfo[@"projectCode"];
        [UserAgent DefaultAgent].typeKey = projectInfo.attributes[@"key"];
        [UserAgent DefaultAgent].projectPlanSn = projectInfo.otherInfo[@"projectPlanSn"];
        if (!sectionInfo) {
            [UserAgent DefaultAgent].sectionId = @"";
            [UserAgent DefaultAgent].sectionCode = @"";
        } else {
            sectionInfo.selected = YES;
            [UserAgent DefaultAgent].sectionId = sectionInfo.id;
            [UserAgent DefaultAgent].sectionCode = sectionInfo.otherInfo[@"sectCode"];
        }
        [[UserAgent DefaultAgent] saveValuesToCache];
        [weakSelf setSeviceProjectInfo:projectInfo section:sectionInfo];
        if ([weakSelf isLoadedProjectsAndSections]) {
//            [weakSelf setProjectAndSiteName];
        }
    } faild:^(NSString *msg) {
//        [SVProgressHUD showErrorWithStatus:msg];
    }];
}

#pragma mark - 数据验证
- (BOOL)isLoadedProjectsAndSections {
    if ([UserAgent DefaultAgent].projectInfos && [UserAgent DefaultAgent].sectionId) {
        for (ProjectInfo *info in [UserAgent DefaultAgent].projectInfos) {
            if (!info.children) {
                return NO;
            }
        }
        return YES;
    } else {
        return NO;
    }
}
-(void)setSeviceProjectInfo:(ProjectInfo *)project section:(ProjectInfo *)sectionInfo{
    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithDictionary:@{
        @"typeKey":project.attributes[@"key"],
        @"projectId": project.id,
        @"mainPrjName": project.text,
        @"mainPrjCode": project.otherInfo[@"projectCode"],
        @"projectPlanSn": project.otherInfo[@"projectPlanSn"]
    }];
    if (sectionInfo) {
        [param setObject:sectionInfo.id forKey:@"mainSectionId"];
        [param setObject:sectionInfo.text forKey:@"mainSectionName"];
        [param setObject:sectionInfo.otherInfo[@"sectCode"] forKey:@"mainSectionCode"];
        [param setObject:sectionInfo.otherInfo[@"stdVersion"] forKey:@"stdVersion"];
        [param setObject:sectionInfo.otherInfo[@"sectMajor"] forKey:@"sectionMajor"];
    }
    //切换服务器项目
    [[HttpManager manager]post:[UrlConfig URL:setPrjInfo] param:param success:^(NSData *data) {} faild:^(NSString *msg) {}];
}
- (void)getProjectDataChildren:(NSMutableArray <ProjectInfo *>*)children rootChildren:(NSMutableArray <ProjectInfo *>*)rootChildren {
    for (ProjectInfo *sect in children) {
        if (![sect.id hasSuffix:@"_other"]) {
            [rootChildren addObject:sect];
        }
        
        if (sect.tempChildren.count > 0) {
            [self getProjectDataChildren:sect.tempChildren rootChildren:rootChildren];
        }
    }
}
- (void)handleProjectData:(ProjectInfo *)project {
    NSMutableArray <ProjectInfo *>*tempChild = [NSMutableArray array];
    ProjectInfo *otherSect = [ProjectInfo new];
    otherSect.id = [NSString stringWithFormat:@"%@_other", project.id];
    otherSect.label = @"其他";
    otherSect.text = @"其他";
    otherSect.parentId = project.id;
    NSMutableArray <ProjectInfo *>*otherSectChild = [NSMutableArray array];
    for (ProjectInfo *sect in project.tempChildren) {
        if ([sect.attributes[@"key"]  isEqual:@"section_zbb"]) {
            [tempChild addObject:sect];
        } else {
            [otherSectChild addObject:sect];
        }
    }
    
    if (otherSectChild.count > 0) {
        otherSect.tempChildren = otherSectChild;
        [tempChild addObject:otherSect];
    }

    project.tempChildren = tempChild;
}
- (void)getProjectDataTempChildren:(ProjectInfo *)project {
    if (project.children != nil) {
        project.tempChildren = [ProjectInfo mj_objectArrayWithKeyValuesArray:project.children];
        for (ProjectInfo *child in project.tempChildren) {
            [self getProjectDataTempChildren:child];
        }
    }
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self loadData];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    self.navigationController.navigationBar.hidden = YES;
    self.tabBarController.tabBar.hidden = NO;
}

#pragma mark - 初始化界面
- (void)setupTableView {
    __weak typeof(self) weakself = self;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakself loadData];
    }];
}

#pragma mark - 加载数据
- (void)loadData {
    [[HttpManager manager] post:[UrlConfig URL:getTodoList] param:@{@"page":@"1", @"rows":@"3"} success:^(NSData *data) {
        [self.tableView.mj_header endRefreshing];
        [DataCollection mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
            return @{@"ID":@"id"};
        }];
        [DataCollection mj_setupObjectClassInArray:^NSDictionary *{
            return @{@"rows":@"HomeModel"};
        }];
        _todoData = [DataCollection mj_objectWithKeyValues:data];
        [self.tableView reloadData];
    } faild:^(NSString *msg) {
        [self.tableView.mj_header endRefreshing];
        [MBManager showBriefAlert:msg];
    }];
    [[HttpManager manager] get:[UrlConfig URL:getTodoMsgList] param:@{@"page":@"1", @"rows":@"3"} success:^(NSData *data) {
        [self.tableView.mj_header endRefreshing];
        
        [DataCollection mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
            return @{@"ID":@"id"};
        }];
        [DataCollection mj_setupObjectClassInArray:^NSDictionary *{
            return @{@"rows":@"HomeModel"};
        }];
        NSDictionary *dic = [data mj_JSONObject];
        _doingData = [DataCollection mj_objectWithKeyValues:dic[@"data"]];
        for (HomeModel *model in _doingData.rows) {
            if (model.content) {
                model.title = model.content;
            }
            model.bizTypeName = model.noticeTypeName;
            model.bizType = model.noticeType;
            model.createTime = model.sendTime;
            
            model.bizPk = model.bizId;
            model.isNoty = YES;
        }
        [self.tableView reloadData];
    } faild:^(NSString *msg) {
        [self.tableView.mj_header endRefreshing];
        [MBManager showBriefAlert:msg];
    }];
//    [[HttpManager manager] post:[UrlConfig URL:getDoneList] param:@{@"page":@"1", @"rows":@"3"} success:^(NSData *data) {
//        [self.tableView.mj_header endRefreshing];
//        [DataCollection mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
//            return @{@"ID":@"id"};
//        }];
//        [DataCollection mj_setupObjectClassInArray:^NSDictionary *{
//            return @{@"rows":@"HomeModel"};
//        }];
//        _doneData = [DataCollection mj_objectWithKeyValues:data];
//        [self.tableView reloadData];
//    } faild:^(NSString *msg) {
//        [self.tableView.mj_header endRefreshing];
//        [MBManager showBriefAlert:msg];
//    }];
}

#pragma mark - UITableViewDelegate, UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    DataCollection *data = nil;
    switch (section) {
        case 0:
            data = _todoData;
            break;
        case 1:
            data = _doingData;
            break;
        case 2:
            data = _doneData;
            break;
        default:
            break;
    }
    if (!data) {
        return 0;
    }
    return data.rows.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HomeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"homeCell" forIndexPath:indexPath];
    DataCollection *data = nil;
    switch (indexPath.section) {
        case 0:
            data = _todoData;
            break;
        case 1:
            data = _doingData;
            break;
        case 2:
            data = _doneData;
            break;
        default:
            break;
    }
    [cell loadDataModel:data.rows[indexPath.row]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    DataCollection *data = nil;
    switch (indexPath.section) {
        case 0:
            data = _todoData;
            break;
        case 1:
            data = _doingData;
            break;
        case 2:
            data = _doneData;
            break;
        default:
            break;
    }
    if (!data) {
        return ;
    }
    
    NSString *storyboardId;
    NSString *ID;
    NSString *dealId;
    HomeModel *model = data.rows[indexPath.row];
    
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
    vc.searchType = SearchTypeToDo;
    vc.ID = ID;
    vc.dealID = dealId;
    vc.bizKey = model.bizType;
    [self.navigationController pushViewController:vc animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 30;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 30)];
    headerView.tag = 100 + section;
    
    UITapGestureRecognizer *tapG = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(headerViewClicked:)];
    [headerView addGestureRecognizer:tapG];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(8, 0, ScreenWidth / 2, 30)];
    titleLabel.font = [UIFont boldSystemFontOfSize:14];
    titleLabel.textColor = [UIColor navigationBgColor];
    [headerView addSubview:titleLabel];
    
    UILabel *subLabel = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth / 2 - 21, 0, ScreenWidth / 2, 30)];
    subLabel.font = [UIFont boldSystemFontOfSize:14];
    subLabel.textColor = [UIColor navigationBgColor];
    subLabel.textAlignment = NSTextAlignmentRight;
    [headerView addSubview:subLabel];
    
    UIImageView *iv = [[UIImageView alloc] initWithFrame:CGRectMake(ScreenWidth - 13, 10, 5, 10)];
    iv.image = [UIImage imageNamed:@"next_icon"];
    [headerView addSubview:iv];
    
    DataCollection *data = nil;
    switch (section) {
        case 0:
            titleLabel.text = @"待办";
            data = _todoData;
            break;
        case 1:
            titleLabel.text = @"消息";
            data = _doingData;
            break;
        case 2:
            titleLabel.text = @"已办";
            data = _doneData;
            break;
        default:
            break;
    }
    
    if (data) {
        subLabel.text = data.total;
    }
    
    return headerView;
}

#pragma mark - 点击事件
- (void)headerViewClicked:(UITapGestureRecognizer *)sender {
    SearchType type;
    switch (sender.view.tag) {
        case 100:
            type = SearchTypeToDo;
            break;
        case 101:
            type = SearchTypeDoing;
            break;
        case 102:
            type = SearchTypeDone;
            break;
        default:
            type = SearchTypeToDo;
            break;
    }
    SearchViewController *searchVC = [[SearchViewController alloc] initWithNibName:@"SearchViewController" bundle:nil];
    searchVC.searchType = type;
    [self.navigationController pushViewController:searchVC animated:YES];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

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
