//
//  SupervisionPayDetailController.m
//  PMPlatform_IOS
//
//  Created by 末末班车 on 2017/10/20.
//  Copyright © 2017年 com.atide. All rights reserved.
//

#import "SupervisionPayDetailController.h"
#import "SupervisionPayDetailCell.h"
#import "SupervisionChargeModel.h"

@interface SupervisionPayDetailController ()<UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSMutableArray <SupervisionChargeModel *>*dataSource;

@end

@implementation SupervisionPayDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupUI];
    [self loadData];
}

#pragma mark - 初始化
- (void)setupUI {
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
    }];
    [self.tableView.mj_footer endRefreshingWithNoMoreData];
}

#pragma mark - 懒加载
- (NSMutableArray<SupervisionChargeModel *> *)dataSource {
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    
    return _dataSource;
}

#pragma mark - 加载数据
- (void)loadData {
    if(self.sectNo == nil || self.sessionCode == nil){
        return;
    }
    
    NSString *method = [UrlConfig MeteringURL:getSuperVisingPayCert];
    
    [[HttpManager manager] paramsGet:method param:@{
                                                    @"SessionCode":self.sessionCode,
                                                    @"SectNo":self.sectNo
                                                    }
                             success:^(NSData *data) {
                                 if ([ResponseUtils success:data]) {
                                     NSMutableArray <SupervisionChargeModel *>*dataArray = [SupervisionChargeModel mj_objectArrayWithKeyValuesArray:[ResponseUtils getData:@"data"]];
                                     if (dataArray!=nil && dataArray.count>0) {
                                         self.dataSource = dataArray;
                                         [self.tableView reloadData];
                                     }else{
                                         //设置没有数据的UI
                                     }
                                 } else {
                                     [MBManager showBriefAlert:[ResponseUtils getMsg]];
                                 }
                             } faild:^(NSString *msg) {
                                 [MBManager showBriefAlert:msg];
                             }];
}

#pragma mark - UITableViewDelegate, UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SupervisionPayDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:@"supervisionPayDetailCell" forIndexPath:indexPath];
    [cell loadDataModel:self.dataSource[indexPath.row]];
    return cell;
}

@end
