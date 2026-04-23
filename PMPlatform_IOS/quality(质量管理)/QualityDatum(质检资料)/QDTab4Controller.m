//
//  QDTab4Controller.m
//  ycxm
//
//  Created by 高小伟 on 2019/3/14.
//  Copyright © 2019 末末班车. All rights reserved.
//

#import "QDTab4Controller.h"
#import "QDReportDetailController.h"
#import "WaitCheckBoxCell.h"
#import "ApprovalPopView.h"
#import "ApprovalModel.h"
#import "SiteModel.h"
#import "ApprovalCell.h"
@interface QDTab4Controller ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tab;
@property (nonatomic, strong) NSMutableArray<ApprovalModel *> *itemArray;

@property (weak, nonatomic) IBOutlet UIButton *allBtn;
@property (weak, nonatomic) IBOutlet UIButton *draftBtn;
@property (weak, nonatomic) IBOutlet UIButton *backBtn;
@property (weak, nonatomic) IBOutlet UIButton *circingBtn;
@property (weak, nonatomic) IBOutlet UIButton *passBtn;


@property (nonatomic, assign) NSInteger page;
@property (nonatomic, copy) NSString *status;
@end

@implementation QDTab4Controller

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    __weak __typeof(self) weakSelf = self;
    _tab.delegate = self;
    _tab.dataSource =self;
    _tab.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        weakSelf.page = 1;
        [weakSelf loadData];
    }];
    _tab.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        weakSelf.page ++;
        [weakSelf loadData];
    }];
    _tab.mj_footer.ignoredScrollViewContentInsetBottom = IS_IPhoneX_All ? 34 : 0;
    NSBundle *nib = [NSBundle bundleForClass:self.classForCoder];
    [self.tab registerNib:[UINib nibWithNibName:@"ApprovalCell" bundle:nib] forCellReuseIdentifier:@"ApprovalCell"];
    self.tab.estimatedRowHeight = 200;
    self.tab.rowHeight = UITableViewAutomaticDimension;
    [self.tab.mj_header beginRefreshing];
    [self setupBtns];
    
    //接收工程部位参数
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(filterData:) name:@"QDPart" object:nil];
}
-(void)filterData:(NSNotification *)noti{
    SiteModel *partModel = noti.object;
    self.partCode = partModel.id;
    self.page = 1;
    [self.tab.mj_header beginRefreshing];
    [self.tab.mj_footer resetNoMoreData];
}

-(void)setupBtns{
    for (int i=300; i<305; i++){
        UIButton *btn = [self.view viewWithTag:i];
        [btn setTitleColor:[UIColor colorWithRed:0/255.0 green:122/255.0 blue:255/255.0 alpha:1.0] forState:UIControlStateSelected];
        if(i == 300){
            btn.selected = YES;
        }
    }
}

- (IBAction)chooseType:(UIButton *)sender {
    for (int i=300; i<305; i++){
        UIButton *btn = [self.view viewWithTag:i];
        if (i == sender.tag) {
            btn.selected = YES;
            continue;
        }
        btn.selected = NO;
    }
    self.page = 1;
    self.status = sender.tag - 300 == 0?nil:[NSString stringWithFormat:@"%ld",sender.tag - 300];
    [self.tab.mj_header beginRefreshing];
    [self.tab.mj_footer resetNoMoreData];
    
}
- (void)loadData {
    __weak typeof(self) weakSelf = self;
    NSString *url = [UrlConfig URL:getApprovalListByParentCode];
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:[NSString stringWithFormat:@"%ld",weakSelf.page] forKey:@"page"];
    [param setObject:@"20" forKey:@"rows"];
    if (self.partCode) [param setObject:self.partCode forKey:@"partCode"];
    if (self.status) [param setObject:self.status forKey:@"status"];
    [[HttpManager manager] post:url param:param success:^(NSData *data) {
        [DataCollection mj_setupObjectClassInArray:^NSDictionary *{
            return @{@"rows":@"ApprovalModel"};
        }];
        DataCollection *dataCollection = [DataCollection mj_objectWithKeyValues:data];
        if (dataCollection) {
            NSArray *itemArray = dataCollection.rows;
            if (weakSelf.page == 1) {
                [weakSelf.itemArray removeAllObjects];
            }
            [weakSelf.itemArray addObjectsFromArray:itemArray];
            
            [weakSelf.tab reloadData];
            if (itemArray.count < 20) {
                [weakSelf.tab.mj_header endRefreshing];
                [weakSelf.tab.mj_footer endRefreshingWithNoMoreData];
                return;
            }
        }
        [weakSelf.tab.mj_header endRefreshing];
        [weakSelf.tab.mj_footer endRefreshing];
    } faild:^(NSString *msg) {
        [weakSelf.tab.mj_header endRefreshing];
        [weakSelf.tab.mj_footer endRefreshing];
        [SVProgressHUD showErrorWithStatus:msg];
    }];
}

#pragma mark -- datasource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.itemArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ApprovalCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ApprovalCell" forIndexPath:indexPath];
    ApprovalModel *model = self.itemArray[indexPath.row];
    cell.model = model;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [self pushToDetail:self.itemArray[indexPath.row]];
}


#pragma LazyLoad
-(NSMutableArray *)itemArray{
    if (!_itemArray) {
        _itemArray = [NSMutableArray new];
    }
    return  _itemArray;
}

#pragma mark - 跳转详情
- (void)pushToDetail:(ApprovalModel *)model {
    NSString *centerUrl = model.cotrollerName;
    NSString *urlParams = @"";
    NSArray<NSString *> *split = [centerUrl componentsSeparatedByString:@"?"];
    if (split.count>1) {
        centerUrl = split[0];
        urlParams = split[1];
    }
    
    __weak typeof(self) weakSelf = self;
    
    QDReportDetailController *detail = [[QDReportDetailController alloc] init];
    detail.hiddenTool = YES;
    for (SectionInfo *info in [UserAgent DefaultAgent].sectionInfos) {
        if ([info.sectionId isEqualToString:[UserAgent DefaultAgent].sectionId]) {
            detail.isUserXY = info.isUserXY;
            break;
        }
    }
    
    NSString *url = [NSString stringWithFormat:@"processapprovalnew/%@/editForm?id=%@&mainBizKey=%@",centerUrl,model.id,model.processCode];
    detail.code = model.cotrollerName;
    if (urlParams && urlParams.length>0) {
        url = [NSString stringWithFormat:@"%@&%@",url,urlParams];
        
        NSArray <NSString *>*tempArr = [urlParams componentsSeparatedByString:@"&"];
        for (NSString *tempStr in tempArr) {
            NSArray <NSString *>*tempArr2 = [tempStr componentsSeparatedByString:@"="];
            if (tempArr2.count > 1) {
                if ([tempArr2[0] isEqualToString:@"code"]) {
                    detail.code = tempArr2[1];
                } else if ([tempArr2[0] isEqualToString:@"formType"] || [tempArr2[0] isEqualToString:@"val"]) {
                    detail.formType = tempArr2[1];
                }
            }
        }
    }
    
    detail.url = url;
    detail.newFormFlag = NO;
    detail.bizPk = model.id;
    detail.title = model.name;
    detail.numId = model.numId;
    detail.bizUrl = centerUrl;
    detail.status = model.status;
    detail.showVideoMaterial = YES;
    detail.bizKey = model.processCode;
    detail.partCode = model.partCode;
    
    [self.navigationController pushViewController:detail animated:YES];
}

@end
