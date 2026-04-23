//
//  QDTab3Controller.m
//  HBConstructionApp
//
//  Created by 末末班车 on 2018/6/6.
//  Copyright © 2018年 atide. All rights reserved.
//

#import "QDTab3Controller.h"
#import "VideoMaterialModel.h"
//#import "QDVideoMaterialController.h"
//#import "ChooseApprovalPartController.h"
#import "BaseListCell1.h"

#define KCellId @"baseListCell"

@interface QDTab3Controller ()
//@property (nonatomic, strong) SiteModel *partModel;
@property (nonatomic, strong) NSMutableArray <VideoMaterialModel *>*dataSource;
@end

@implementation QDTab3Controller {
    NSInteger _page;
    NSInteger _rows;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.addBtn.layer.cornerRadius = 20;
    [self setUpTableView];
//    [self fetchPart];
    //接收工程f部位参数
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(filterData:) name:@"QDPart" object:nil];
}

-(void)filterData:(NSNotification *)noti{
    SiteModel *model = noti.object;
    self.partCode = model.id;
    [self.tableView.mj_header beginRefreshing];
}

- (void)setUpTableView {
    __weak typeof(self) weakSelf = self;
    _page = 1;
    _rows = 15;
    [_tableView registerNib:[UINib nibWithNibName:@"BaseListCell1" bundle:nil] forCellReuseIdentifier:KCellId];

    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf refresh];
    }];
    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [weakSelf loadMore];
    }];
    footer.stateLabel.font = [UIFont systemFontOfSize:12.f];
    footer.stateLabel.textColor = UIColorFromRGB(0x888888);
    _tableView.mj_footer = footer;
}

#pragma mark -- 网络请求
- (void)fetchPart {
//    __weak __typeof(self) weakSelf = self;
//    [SVProgressHUD showWithStatus:@"加载中..."];
//    [[HttpManager manager] post:[UrlConfig URL:getApprovalPartTree] param:@{@"id":[UserAgent DefaultAgent].sectionCode, @"type":@"1"} success:^(NSData *data) {
//        [SVProgressHUD dismiss];
//
//        NSArray <SiteModel *>*temp = [SiteModel mj_objectArrayWithKeyValuesArray:data];
//        if (temp && temp.count != 0) {
//            weakSelf.partModel = [temp objectAtIndex:0];
//        }
//    } faild:^(NSString *msg) {
//        [SVProgressHUD dismiss];
//    }];
}

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
    [[HttpManager manager] post:[UrlConfig URL:getQIPhotoFilesList] param:[self params] success:^(NSData *data) {
        [DataCollection mj_setupObjectClassInArray:^NSDictionary *{
            return @{@"rows":@"VideoMaterialModel"};
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
            
            [weakSelf.tableView reloadData];
        } else {
            if (isRefresh) {
                [weakSelf.tableView.mj_header endRefreshing];
            } else {
                [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
            }
            [SVProgressHUD showErrorWithStatus:[ResponseUtils getMsg]];
        }
    } faild:^(NSString *msg) {
        if (isRefresh) {
            [weakSelf.tableView.mj_header endRefreshing];
        } else {
            [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
        }
        [SVProgressHUD showErrorWithStatus:msg];
    }];
}

- (NSDictionary *)params {
    NSMutableDictionary *paraDic = [NSMutableDictionary dictionary];
    [paraDic setObject:@(_page) forKey:@"page"];
    [paraDic setObject:@(_rows) forKey:@"rows"];
    [paraDic setObject:[UserAgent DefaultAgent].projectId forKey:@"projectId"];
    [paraDic setObject:[UserAgent DefaultAgent].sectionId forKey:@"sectId"];
    if (_partCode) [paraDic setObject:_partCode forKey:@"partCode"];
    return paraDic;
}

#pragma mark - 懒加载
- (NSMutableArray<VideoMaterialModel *> *)dataSource {
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

//- (void)setPartModel:(SiteModel *)partModel{
//    _partModel = partModel;
//    [self.partBtn setTitle:_partModel.text forState:UIControlStateNormal];
//    [self.tableView.mj_header beginRefreshing];
//}

- (IBAction)partAction:(UIButton *)sender {
//    __weak typeof(self) weakSelf = self;
//    ChooseApprovalPartController *vc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"ChooseApprovalPart"];
//    vc.block = ^(SiteModel *site) {
//        weakSelf.partModel = site;
//    };
//    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - UITableViewDelegate, UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BaseListCell1 *cell = [tableView dequeueReusableCellWithIdentifier:KCellId forIndexPath:indexPath];
    
    VideoMaterialModel *model = self.dataSource[indexPath.row];
    cell.label1.text = model.title;
    cell.label3.text = [NSString stringWithFormat:@"创建人:%@", model.userName];
    cell.label4.text = [NSString stringWithFormat:@"备注:%@", model.remark];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    [self pushToDetail:self.dataSource[indexPath.row]];
}

-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return @"删除";
}

-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete;
}

- (void)tableView:(UITableView*)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath*)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"删除提示" message:@"确定要删除吗？" preferredStyle:UIAlertControllerStyleAlert];
        [alertC addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self deleteData:self.dataSource[indexPath.row].id];
        }]];
        [alertC addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
        [self presentViewController:alertC animated:YES completion:nil];
    }
}

#pragma mark - 删除数据
- (void)deleteData:(NSString *)ID {
    __weak typeof(self) weakSelf = self;
    [SVProgressHUD showWithStatus:@"删除中..."];
    [[HttpManager manager] post:[UrlConfig URL:delQIPhotoFilesList] param:@{@"id":ID} success:^(NSData *data) {
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

- (IBAction)addAction:(UIButton *)sender {
    [self pushToDetail:nil];
}

#pragma mark - 进入详情
- (void)pushToDetail:(VideoMaterialModel *)model {
//    if (!self.partCode) {
//        [SVProgressHUD showErrorWithStatus:@"未选择质检部位"];
//        return;
//    }
//
//    __weak typeof(self) weakSelf = self;
//    QDVideoMaterialController *vc = [[UIStoryboard storyboardWithName:@"Quality" bundle:nil] instantiateViewControllerWithIdentifier:@"QDVideoMaterial"];
//
//    vc.partCode = self.partCode;
//    vc.model = model;
//    vc.block = ^{
//        [weakSelf.tableView.mj_header beginRefreshing];
//    };
//
//    [self.navigationController pushViewController:vc animated:YES];
}

@end
