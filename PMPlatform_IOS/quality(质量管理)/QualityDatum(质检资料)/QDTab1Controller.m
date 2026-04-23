//
//  QDTab1Controller.m
//  HBConstructionApp
//
//  Created by vxg on 2018/03/28.
//  Copyright © 2018年 atide. All rights reserved.
//

#import "QDTab1Controller.h"
#import "QDReportDetailController.h"
//#import "ChooseApprovalPartController.h"
#import "QDTab1Cell.h"

@interface QDTab1Controller ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) SiteModel *partModel;
@property (weak, nonatomic) IBOutlet UIImageView *arrowImageView;

@end

@implementation QDTab1Controller {
    BOOL _newFormFlag;
    BOOL _isFirst;
    NSMutableArray *headerData;
    NSMutableArray<NSArray *> *dataSource;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _isFirst = YES;
    self.view.backgroundColor = UIColor.whiteColor;
    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectZero];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.tableView registerNib:[UINib nibWithNibName:@"QDTab1Cell" bundle:nil] forCellReuseIdentifier:@"QDTab1Cell"];
    headerData = [[NSMutableArray alloc] init];
    dataSource = [[NSMutableArray alloc] init];
    
    if (self.isFromScan) {
        self.partBtn.userInteractionEnabled = NO;
        self.arrowImageView.hidden = YES;
        
        ApprovalPartModel *apm = [UserAgent DefaultAgent].approvalPartModel;
        
        SiteModel *model = [[SiteModel alloc] init];
        model.text = apm.NAME_;
        model.type = apm.TYPE_;
        model.id = apm.CODE_;
        
        self.partModel = model;
    } else {
//        [self fetchPart];
         [self fetchData];
    }
    
    //接收筛选参数
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(filterData:) name:@"QDPart" object:nil];
}
-(void)filterData:(NSNotification *)noti{
    self.partModel = noti.object;
}
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationItem.title = @"质检资料";
    
    if (self.isFromScan && ![UserAgent DefaultAgent].approvalPartModel) {
        [SVProgressHUD showInfoWithStatus:@"扫描部位已失效!"];
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }
    
    if (_isFirst) {
        _isFirst = NO;
    } else {
        [self fetchData];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationItem.title = @"";
}

- (void)setPartModel:(SiteModel *)partModel{
    _partModel = partModel;
    [self.partBtn setTitle:_partModel.text forState:UIControlStateNormal];
    [self fetchData];
}


- (IBAction)partAction:(UIButton *)sender {
//    __weak typeof(self) weakSelf = self;
//    ChooseApprovalPartController *vc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"ChooseApprovalPart"];
//    vc.block = ^(SiteModel *site) {
//        weakSelf.partModel = site;
//    };
//    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark -- 网络请求
- (void)fetchPart{
    __weak __typeof(self) weakSelf = self;
    [SVProgressHUD showWithStatus:@"加载中..."];
    [[HttpManager manager] post:[UrlConfig URL:getApprovalPartTree] param:@{@"id":[UserAgent DefaultAgent].sectionCode, @"type":@"1"} success:^(NSData *data) {
        [SVProgressHUD dismiss];
        
        NSArray <SiteModel *>*temp = [SiteModel mj_objectArrayWithKeyValuesArray:data];
        if (temp && temp.count != 0) {
            weakSelf.partModel = [temp objectAtIndex:0];
            
        }
    } faild:^(NSString *msg) {
        [SVProgressHUD dismiss];
    }];
}

- (void)fetchData{
    if (!self.partModel) {
        return;
    }
    
    __weak __typeof(self) weakSelf = self;
    [SVProgressHUD showWithStatus:@"加载中..."];
    
    NSString *projectId = [UserAgent DefaultAgent].projectId;
    NSString *sectionId = [UserAgent DefaultAgent].sectionId;
    if (self.isFromScan) {
        projectId = [UserAgent DefaultAgent].approvalPartModel.PRJID;
        sectionId = [UserAgent DefaultAgent].approvalPartModel.SECTION_ID;
    }
    NSMutableDictionary *param = [[NSMutableDictionary alloc] initWithDictionary:@{@"projectId":projectId, @"sectId":sectionId}];
    [param setValue:_partModel.type ? _partModel.type : @"" forKey:@"partType"];
    [param setValue:_partModel.id ? _partModel.id : @"" forKey:@"partCode"];
    [param setValue:[_partModel.otherInfo objectForKey:@"projectType"] ? [_partModel.otherInfo objectForKey:@"projectType"] : @"" forKey:@"partTypeCode"];

    [[HttpManager manager] post:[UrlConfig URL:getQualityDatumList] param:param success:^(NSData *data) {
        [SVProgressHUD dismiss];
        [self->headerData removeAllObjects];
        [self->dataSource removeAllObjects];
        id jsonObject = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
        NSArray *arr = (NSArray *)jsonObject;
        for (NSArray *tempArr in arr) {
            CheckListBean *bean = [[CheckListBean alloc] init];
            
            NSArray *beanArr = [CheckListBean mj_objectArrayWithKeyValuesArray:tempArr];
            [self->dataSource addObject:beanArr];
            
            CheckListBean *firstBean = beanArr.firstObject;
            bean.tableName = firstBean.PNAME ? firstBean.PNAME : @"未知";
            [self->headerData addObject:bean];
        }
        
        [weakSelf.tableView reloadData];
    } faild:^(NSString *msg) {
        [SVProgressHUD dismiss];
        [self->headerData removeAllObjects];
        [self->dataSource removeAllObjects];
        [weakSelf.tableView reloadData];
    }];
}

#pragma mark -- datasource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return headerData.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return dataSource[section].count;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UITableViewHeaderFooterView *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"header"];
    if (!header) {
        header = [[UITableViewHeaderFooterView alloc] initWithReuseIdentifier:@"header"];
    }
    CheckListBean *bean = headerData[section];
    header.textLabel.text = bean.tableName;
    return header;
}
- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section {
    if ([view isMemberOfClass:[UITableViewHeaderFooterView class]]) {
        ((UITableViewHeaderFooterView *)view).backgroundView.backgroundColor = UIColor.whiteColor;
        ((UITableViewHeaderFooterView *)view).textLabel.textColor =  UIColor.blackColor;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    QDTab1Cell *cell = [tableView dequeueReusableCellWithIdentifier:@"QDTab1Cell" forIndexPath:indexPath];
    [cell setModel:dataSource[indexPath.section][indexPath.row] indexPath:indexPath];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 40;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    CheckListBean *bean = dataSource[indexPath.section][indexPath.row];
    
    if (bean.id) {
        _newFormFlag = NO;
        [self pushToDetail:bean bizPk:bean.id];
    } else {
        if ([bean.controllerName containsString:@"inspectyc"]) {
            [SVProgressHUD showInfoWithStatus:@"移动端暂时无法新增评定表!"];
            return;
        }
        
        __weak typeof(self) weakSelf = self;
        [SVProgressHUD showWithStatus:nil];
        _newFormFlag = YES;
        [[HttpManager manager] post:[UrlConfig URL:getProcessApprovalId] param:nil success:^(NSData *data) {
            [SVProgressHUD dismiss];
            NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            NSString *bizPk = [str stringByReplacingOccurrencesOfString:@"\"" withString:@""];
            [weakSelf pushToDetail:bean bizPk:bizPk];
        } faild:^(NSString *msg) {
            [SVProgressHUD dismiss];
        }];
    }
}

- (void)pushToDetail:(CheckListBean *)bean bizPk:(NSString *)bizPk {
    if (!bean.controllerName) {
        [SVProgressHUD showInfoWithStatus:@"数据错误!"];
        return;
    }
    
    NSString *centerUrl = bean.controllerName;
    NSString *urlParams = @"";
    NSArray<NSString *> *split = [centerUrl componentsSeparatedByString:@"?"];
    if (split.count>1) {
        centerUrl = split[0];
        urlParams = split[1];
    }

//    __weak typeof(self) weakSelf = self;
//
//    QDReportDetailController *detail = [[QDReportDetailController alloc] init];
//
//    if (self.isFromScan) {
//        detail.isUserXY = YES;
//        detail.projectId = [UserAgent DefaultAgent].approvalPartModel.PRJID;
//        detail.sectionId = [UserAgent DefaultAgent].approvalPartModel.SECTION_ID;
//    } else {
//        for (SectionInfo *info in [UserAgent DefaultAgent].sectionInfos) {
//            if ([info.sectionId isEqualToString:[UserAgent DefaultAgent].sectionId]) {
//                detail.isUserXY = info.isUserXY;
//                break;
//            }
//        }
//    }
//
//    NSString *url = [NSString stringWithFormat:@"processapprovalnew/%@/editForm?id=%@&mainBizKey=%@",centerUrl,bizPk,bean.processCode];
//    detail.code = bean.controllerName;
//    if (urlParams && urlParams.length>0) {
//        url = [NSString stringWithFormat:@"%@&%@",url,urlParams];
//
//        NSArray <NSString *>*tempArr = [urlParams componentsSeparatedByString:@"&"];
//        for (NSString *tempStr in tempArr) {
//            NSArray <NSString *>*tempArr2 = [tempStr componentsSeparatedByString:@"="];
//            if (tempArr2.count > 1) {
//                if ([tempArr2[0] isEqualToString:@"code"]) {
//                    detail.code = tempArr2[1];
//                } else if ([tempArr2[0] isEqualToString:@"formType"] || [tempArr2[0] isEqualToString:@"val"]) {
//                    detail.formType = tempArr2[1];
//                }
//            }
//        }
//    }
//
//    detail.url = url;
//    detail.bizPk = bizPk;
//    detail.title = bean.name;
//    detail.numId = bean.numId;
//    detail.bizUrl = centerUrl;
//    detail.status = bean.status;
//    detail.showVideoMaterial = YES;
//    detail.bizKey = bean.processCode;
//    detail.newFormFlag = _newFormFlag;
//    detail.partCode = self.partModel.id;
//
//    detail.callBack = ^{
//        [weakSelf fetchData];
//    };
//
//    [self.navigationController pushViewController:detail animated:YES];
}

@end
