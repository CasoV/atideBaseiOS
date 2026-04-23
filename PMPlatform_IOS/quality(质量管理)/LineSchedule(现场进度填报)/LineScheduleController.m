//
//  LineScheduleController.m
//  ycxm
//
//  Created by 末末班车 on 2019/1/15.
//  Copyright © 2019 末末班车. All rights reserved.
//

#import "LineScheduleController.h"
#import "LineScheduleCell.h"
//#import "PartSeleterVc.h"

@interface LineScheduleController ()<UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *partBtn;
@property (weak, nonatomic) IBOutlet UIButton *allBtn;

@property (nonatomic, strong) SiteModel *partModel;

@property (nonatomic, strong) NSMutableArray<LineScheduleModel *> *dataSource;

@property (nonatomic, assign) NSInteger status;

@end

@implementation LineScheduleController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor = UIColorBackground;
    __weak __typeof(self) weakSelf = self;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.allBtn setTitle:@"  全选" forState:UIControlStateNormal];
    [self.allBtn setTitle:@"  取消" forState:UIControlStateSelected];
    [self.allBtn setImage:[UIImage imageNamed:@"cbox_def"] forState:UIControlStateNormal];
    [self.allBtn setImage:[UIImage imageNamed:@"cbox_blue_pro"] forState:UIControlStateSelected];
    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf loadData];
    }];
    [self.tableView registerNib:[UINib nibWithNibName:@"LineScheduleCell" bundle:nil] forCellReuseIdentifier:@"cellid"];
    self.tableView.estimatedRowHeight = 200;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.navigationItem.title = @"现场进度填报";
    [self.tableView.mj_header beginRefreshing];
}

#pragma mark - 懒加载
- (NSMutableArray<LineScheduleModel *> *)dataSource {
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

- (void)setPartModel:(SiteModel *)partModel{
    _partModel = partModel;
    [self.partBtn setTitle:_partModel.text forState:UIControlStateNormal];
}

- (void)loadData {
    NSString *partCode = [UserAgent DefaultAgent].sectionCode;
    if (self.partModel) {
        partCode = self.partModel.id;
    }
    
    __weak typeof(self) weakSelf = self;
    [[HttpManager manager] post:[UrlConfig URL:getLineScheduleList] param:@{@"partCode":partCode} success:^(NSData *data) {
        [weakSelf.tableView.mj_header endRefreshing];
        [DataCollection mj_setupObjectClassInArray:^NSDictionary *{
            return @{@"rows":@"LineScheduleModel"};
        }];
        DataCollection *dataCollection = [DataCollection mj_objectWithKeyValues:data];
        if (dataCollection) {
            NSArray *itemArray = dataCollection.rows;
            if(weakSelf.allBtn.isSelected){
                for (LineScheduleModel *bean in itemArray) {
                    bean.isSelected = YES;
                }
            }
            [weakSelf.dataSource removeAllObjects];
            [weakSelf.dataSource addObjectsFromArray:itemArray];
            
            [weakSelf.tableView reloadData];
        }
    } faild:^(NSString *msg) {
        [weakSelf.tableView.mj_header endRefreshing];
        [SVProgressHUD showErrorWithStatus:msg];
    }];
}

#pragma mark - 点击事件
- (IBAction)partAction:(UIButton *)sender {
//    __weak typeof(self) weakSelf = self;
//    PartSeleterVc *vc = [[UIStoryboard storyboardWithName:@"PartSeleter" bundle:nil] instantiateViewControllerWithIdentifier:@"PartSeleterVc"];
//    vc.type = Screening;
//    vc.block = ^(SiteModel *site) {
//        weakSelf.partModel = site;
//    };
//    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)allAction:(UIButton *)sender {
    sender.selected = !sender.isSelected;
    
    for (LineScheduleModel *bean in self.dataSource) {
        bean.isSelected = sender.isSelected;
    }
    [self.tableView reloadData];
}
- (IBAction)statusAciton:(UIButton *)sender {
    NSString *idString = @"";
    for (LineScheduleModel *model in self.dataSource) {
        if (model.isSelected) {
            if ([idString isEqualToString:@""]) {
                idString = model.code;
            } else {
                idString = [NSString stringWithFormat:@"%@,%@", idString, model.code];
            }
        }
    }
    
    if ([idString isEqualToString:@""]) {
        [SVProgressHUD showInfoWithStatus:@"未选择任何记录!"];
        return;
    }
    
    self.status = sender.tag - 100;
    NSString *message = [NSString stringWithFormat:@"确定设置为%@状态吗?", sender.currentTitle];
    
    __weak typeof(self) weakSelf = self;
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:message preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        [SVProgressHUD showWithStatus:@"请求中"];
        
        [[HttpManager manager] post:[UrlConfig URL:batchLineScheduleInsert] param:@{@"idString":idString, @"status":[NSString stringWithFormat:@"%ld", weakSelf.status]} success:^(NSData *data) {
            if ([ResponseUtils success:data]) {
                [SVProgressHUD dismiss];
                [weakSelf.tableView.mj_header beginRefreshing];
            } else {
                [SVProgressHUD showErrorWithStatus:[ResponseUtils getMsg]];
            }
        } faild:^(NSString *msg) {
            [SVProgressHUD showErrorWithStatus:msg];
        }];
    }]];
    
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark - UITableViewDelegate, UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    LineScheduleCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellid" forIndexPath:indexPath];
    cell.model = self.dataSource[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    LineScheduleModel *bean = self.dataSource[indexPath.row];
    bean.isSelected = !bean.isSelected;
    if (!bean.isSelected) {
        self.allBtn.selected = NO;
    }
    [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:NO];
}

@end
