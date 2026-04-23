//
//  QDTab2Controller.m
//  HBConstructionApp
//
//  Created by vxg on 2018/03/28.
//  Copyright © 2018年 atide. All rights reserved.
//

#import "QDTab2Controller.h"
#import "QDReportDetailController.h"
#import "WaitCheckBoxCell.h"
#import "ApprovalPopView.h"
//#import "PartSeleterVc.h"
//#import "SitesNameView.h"
#import "WaitCheckBean.h"
#import "NewQDKeyModel.h"
#import "SiteModel.h"
#import "PartModel.h"

#define kChoosePartBtn_Height 40

@interface QDTab2Controller ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) NSMutableArray<WaitCheckBean *> *itemArray;
@property (nonatomic, assign) NSInteger page;
@property (weak, nonatomic) IBOutlet UIButton *todoBtn;
@property (weak, nonatomic) IBOutlet UIButton *doingBtn;
@property (weak, nonatomic) IBOutlet UIButton *doneBtn;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewTop;
//@property (nonatomic, strong) PartSeleterVc *seleterVc;

@property (nonatomic, assign) BOOL isFirst;
@end

@implementation QDTab2Controller

- (void)viewDidLoad {
    [super viewDidLoad];
    self.isFirst = YES;
    __weak __typeof(self) weakSelf = self;
    self.itemArray = [NSMutableArray array];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.allBtn setTitle:@"  全选" forState:UIControlStateNormal];
    [self.allBtn setTitle:@"  取消" forState:UIControlStateSelected];
    [self.allBtn setImage:[UIImage imageNamed:@"cbox_def"] forState:UIControlStateNormal];
    [self.allBtn setImage:[UIImage imageNamed:@"cbox_blue_pro"] forState:UIControlStateSelected];
    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        weakSelf.page = 1;
        [weakSelf loadData];
    }];
    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        weakSelf.page++;
        [weakSelf loadData];
    }];
    footer.stateLabel.font = [UIFont systemFontOfSize:12.f];
    footer.stateLabel.textColor = UIColorFromRGB(0x888888);
    _tableView.mj_footer = footer;
    _tableView.mj_footer.ignoredScrollViewContentInsetBottom = IS_IPhoneX_All ? 34 : 0;
    [self.tableView registerNib:[UINib nibWithNibName:@"WaitCheckBoxCell" bundle:nil] forCellReuseIdentifier:@"cellid"];
    self.tableView.estimatedRowHeight = 200;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    [self setupBtns];
    
    //接收工程部位参数
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(filterData:) name:@"QDPart" object:nil];
    
    _viewTop.constant = IS_IPhoneX_All ? 88 + kChoosePartBtn_Height : 64 + kChoosePartBtn_Height;
    [self setUpChoosePartView];
    [self loadDefaultPart];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationItem.title = self.resourceTitle ? self.resourceTitle : @"审核质检资料";
    if (self.isFirst) {
        self.isFirst = NO;
    } else {
        [self.tableView.mj_header beginRefreshing];
    }
}

#pragma mark - 初始化质检部位选择
- (void)setUpChoosePartView {
    CGFloat navHeight = IS_IPhoneX_All?88:64;
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, navHeight, kScreen_Width, kChoosePartBtn_Height)];
    
    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 70, kChoosePartBtn_Height)];
    label.font = [UIFont systemFontOfSize:13.f];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = UIColorFromRGB(0x686868);
    label.text = @"工程部位";
    [view addSubview:label];
    
    [view addSubview:self.scrollView];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(70, 10, 1, 20)];
    line.backgroundColor = UIColorBackground;
    [view addSubview:line];
    
//    UIView *line1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, 0.5)];
//    line1.backgroundColor = UIColorBackground;
//    [view addSubview:line1];
    UIView *line2 = [[UIView alloc] initWithFrame:CGRectMake(0, kChoosePartBtn_Height - 0.5, kScreen_Width, 0.5)];
    line2.backgroundColor = UIColorBackground;
    [view addSubview:line2];
    
    [self.view addSubview:view];
}
-(void)filterData{
    self.page = 1;
    [self.tableView.mj_footer resetNoMoreData];
    [self.tableView.mj_header beginRefreshing];
}
-(void)setupBtns{
    [self.todoBtn setTitleColor:[UIColor colorWithRed:0/255.0 green:122/255.0 blue:255/255.0 alpha:1.0] forState:UIControlStateSelected];
    [self.doingBtn setTitleColor:[UIColor colorWithRed:0/255.0 green:122/255.0 blue:255/255.0 alpha:1.0] forState:UIControlStateSelected];
    [self.doneBtn setTitleColor:[UIColor colorWithRed:0/255.0 green:122/255.0 blue:255/255.0 alpha:1.0] forState:UIControlStateSelected];
    self.todoBtn.selected = YES;
}
- (IBAction)getList:(id)sender {
    self.todoBtn.selected = YES;
    self.doingBtn.selected = NO;
    self.doneBtn.selected = NO;
    self.page = 1;
    [self.tableView.mj_footer resetNoMoreData];
    [self.tableView.mj_header beginRefreshing];
}
- (IBAction)getDoingList:(id)sender {
    self.todoBtn.selected = NO;
    self.doingBtn.selected = YES;
    self.doneBtn.selected = NO;
    self.page = 1;
    [self.tableView.mj_footer resetNoMoreData];
    [self.tableView.mj_header beginRefreshing];
}
- (IBAction)getDoneList:(id)sender {
    self.todoBtn.selected = NO;
    self.doingBtn.selected = NO;
    self.doneBtn.selected = YES;
    self.page = 1;
    [self.tableView.mj_footer resetNoMoreData];
    [self.tableView.mj_header beginRefreshing];
}

- (void)loadData {
    __weak typeof(self) weakSelf = self;
    NSString *url;
    if (self.todoBtn.selected) {
        url = [UrlConfig URL:getTodoList];
    }else if (self.doingBtn.selected) {
        url = [UrlConfig URL:getApprovalDoingList];
    }else{
        url = [UrlConfig URL:getApprovalDoneList];
    }

    NSDictionary *params = @{
        @"jsonInstProps": [@[@{@"propName":@"partCode", @"propValueLike":self.partCode}] mj_JSONString],
        @"bizKeyPreLike": @"Quality",
        @"page": [NSString stringWithFormat:@"%ld",weakSelf.page],
        @"rows": @"10"
    };
    [[HttpManager manager] post:url param:params success:^(NSData *data) {
        [DataCollection mj_setupObjectClassInArray:^NSDictionary *{
            return @{@"rows":@"WaitCheckBean"};
        }];
        DataCollection *dataCollection = [DataCollection mj_objectWithKeyValues:data];
        if (dataCollection) {
            NSArray *itemArray = dataCollection.rows;
            if(weakSelf.block){
//                weakSelf.block(@(dataCollection.total));
            }
            weakSelf.allBtn.selected = NO;
            if (weakSelf.page == 1) {
                [weakSelf.itemArray removeAllObjects];
            }
            [weakSelf.itemArray addObjectsFromArray:itemArray];
            [weakSelf.tableView reloadData];
            if (itemArray.count < 20) {
                [weakSelf.tableView.mj_header endRefreshing];
                [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
                return;
            }
        }
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf.tableView.mj_footer endRefreshing];
    } faild:^(NSString *msg) {
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf.tableView.mj_footer endRefreshing];
        [SVProgressHUD showErrorWithStatus:msg];
    }];
}

- (IBAction)allAction:(UIButton *)sender {
    sender.selected = !sender.isSelected;
    for (WaitCheckBean *bean in self.itemArray) {
        bean.isSelected = sender.isSelected;
    }
    [self.tableView reloadData];
}

#pragma mark -- datasource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.itemArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    WaitCheckBoxCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellid" forIndexPath:indexPath];
    WaitCheckBean *bean = self.itemArray[indexPath.row];
    cell.model = bean;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(chooseItem:)];
    [cell.checkBoxBgV addGestureRecognizer:tap];
    cell.checkBoxBgV.tag = indexPath.row + 400;
    return cell;
}
-(void)chooseItem:(UITapGestureRecognizer *)tap{
    WaitCheckBean *bean = self.itemArray[tap.view.tag - 400];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:tap.view.tag - 400 inSection:0];
    [self.tableView deselectRowAtIndexPath:indexPath animated:NO];
    bean.isSelected = !bean.isSelected;
    if (!bean.isSelected) {
        self.allBtn.selected = NO;
    }
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:NO];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    WaitCheckBean *bean = self.itemArray[indexPath.row];
    [self pushToDetail:bean];
}

#pragma mark - 跳转详情
- (void)pushToDetail:(WaitCheckBean *)model {
    if (model.flowStatus == 1 || (model.flowStatus == 2 && [model.variables.target isEqualToString:@"usertask1"])) {
        //未提交、退回
        [SVProgressHUD showInfoWithStatus:@"移动端待办暂无法处理未提交表单!"];
    } else {
        //退回、流转中
        QDReportDetailController *vc = [[QDReportDetailController alloc] init];
        NewQDKeyModel *item = [NewQDKeyModel new];
        item.instId = model.bizPk;
        item.name = model.title;
        item.numId = @"";
        item.testStatus = [NSString stringWithFormat:@"%ld", model.flowStatus];
        item.processCode = model.bizType;
        item.partCode = @"";
        vc.model = item;
        vc.hiddenTool = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (IBAction)passAction:(UIButton *)sender {
    NSPredicate *p = [NSPredicate predicateWithFormat:@"isSelected=YES"];
    NSArray *result = [self.itemArray filteredArrayUsingPredicate:p];
    if (result.count < 1) {
        [SVProgressHUD showInfoWithStatus:@"请先选择待审核项"];
        return;
    }
    
    for (WaitCheckBean *item in result) {
        if (item.flowStatus == 1 || (item.flowStatus == 2 && [item.variables.target isEqualToString:@"usertask1"])) {
            [SVProgressHUD showInfoWithStatus:@"选中数据中存在未提交或退回到提交步骤的数据!"];
            return;
        }
    }
    
//    NSString *bizPk = @"";
//    NSString *numIdAndPartCode = @"";
//    for (WaitCheckBean *bean in result) {
//        if (bizPk.length<1) {
//            bizPk = bean.bizPk;
//        }else{
//            bizPk = [NSString stringWithFormat:@"%@,%@",bizPk,bean.bizPk];
//        }
//
//        if (numIdAndPartCode.length<1) {
//            numIdAndPartCode = [NSString stringWithFormat:@"%@:%@,%@",bean.bizPk,bean.variables.numId,bean.variables.partCode];
//        }else{
//            numIdAndPartCode = [NSString stringWithFormat:@"%@～%@:%@,%@",numIdAndPartCode,bean.bizPk,bean.variables.numId,bean.variables.partCode];
//        }
//    }
    __weak typeof(self) weakSelf = self;
    ApprovalPopView *popView = [[ApprovalPopView alloc] init];
//    popView.numIdAndPartCode = numIdAndPartCode;
//    popView.bizPk = bizPk;
    popView.beans = result;
    popView.block = ^{
        [weakSelf.tableView.mj_header beginRefreshing];
    };
    [popView show];
}
-(void)choosePart{
//    if(self.seleterVc){
//        [self.navigationController pushViewController:self.seleterVc animated:YES];
//        return;
//    }
//    __weak typeof(self) weakSelf = self;
//    PartSeleterVc *vc = [[UIStoryboard storyboardWithName:@"PartSeleter" bundle:nil] instantiateViewControllerWithIdentifier:@"PartSeleterVc"];
//    vc.type = SelectQD;
//    vc.block = ^(SiteModel *site) {
//        self.partCode = site.id;
//        [self filterData];
//    };
//    vc.vcBlock= ^(PartSeleterVc *selectVc){
//        weakSelf.seleterVc = selectVc;
//    };
//    vc.callback = ^(NSArray * _Nonnull arr) {
//        [weakSelf handlePartArr:arr];
//    };
//    [self.navigationController pushViewController:vc animated:YES];
}

- (CGSize)calculateSize:(NSString *)content width:(CGFloat)width fontSize:(CGFloat)fontSize {
    return [content boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:fontSize]} context:nil].size;
}
#pragma LazyLoad
- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(75, 0, kScreen_Width - 85, kChoosePartBtn_Height)];
        _scrollView.bounces = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        [_scrollView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(choosePart)]];

        UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, _scrollView.frame.size.width, kChoosePartBtn_Height)];
        label.font = [UIFont systemFontOfSize:13.f];
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = UIColorFromRGB(0x686868);
        label.text = @"请选择工程部位";
        [_scrollView addSubview:label];
    }
    return _scrollView;
}

#pragma mark - 处理获取到的工程部位
- (void)handlePartArr:(NSArray *)arr {
    [self.scrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    for (NSString *siteName in arr) {
        CGSize size = [self calculateSize:siteName width:CGFLOAT_MAX fontSize:13];
        
        CGFloat x;
        if (self.scrollView.subviews.count == 0) {
            x = 0;
        } else {
            x = self.scrollView.subviews.lastObject.frame.origin.x + self.scrollView.subviews.lastObject.frame.size.width;
        }
        
//        SitesNameView *partView = [[SitesNameView alloc] initWithFrame:CGRectMake(x, 0, size.width + 15, kChoosePartBtn_Height)];
//        partView.nameLabel.text = siteName;
//        partView.userInteractionEnabled = NO;
//        self.scrollView.contentSize = CGSizeMake(x + size.width + 15, 0);
//        [self.scrollView addSubview:partView];
    }
    if (self.scrollView.contentSize.width > self.scrollView.frame.size.width) {
        [self.scrollView setContentOffset:CGPointMake(self.scrollView.contentSize.width - self.scrollView.frame.size.width, 0) animated:YES];
    }
}

#pragma mark - 加载默认部位
- (void)loadDefaultPart {
    NSString *partCode = @"";
    if (self.sectionCode) {
        partCode = self.sectionCode;
    } else {
        partCode = self.projectCode;
    }
    
    NSDictionary *params = nil;
    if (self.code) {
        params = @{@"useCompany": self.code};
    }
    
//    __weak typeof(self) weakSelf = self;
//    [[HttpManager manager] post:[NSString stringWithFormat:[UrlConfig URL:qualityDatumPartDoc], partCode] param:params success:^(NSData *data) {
//        NSArray <PartModel *>*datas = [PartModel mj_objectArrayWithKeyValuesArray:data];
//        if (datas.count > 0) {
//            weakSelf.partCode = datas[0].id;
//            [weakSelf filterData];
//            [weakSelf handlePartArr:@[datas[0].text]];
//        }
//    } faild:^(NSString *msg) {
//        [SVProgressHUD showErrorWithStatus:msg];
//    }];
}

@end
