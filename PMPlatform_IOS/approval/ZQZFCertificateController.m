//
//  ZQZFCertificateController.m
//  PMPlatform_IOS
//
//  Created by 末末班车 on 2017/10/19.
//  Copyright © 2017年 com.atide. All rights reserved.
//

#import "ZQZFCertificateController.h"
#import "ZQZFCertificateModel.h"
#import "ZQZFCertificateCell.h"
#import "ZQZFpzModel.h"
#import "ZQZFpzCell.h"
#import "VxgColor.h"

@interface ZQZFCertificateController ()<UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UIButton *leftBtn;
@property (weak, nonatomic) IBOutlet UIButton *rightBtn;
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UIView *switchBtnsView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UITableView *oTableView;

@property (nonatomic, strong) NSMutableArray <ZQZFpzModel *>*tbArray;
@property (nonatomic, strong) NSMutableArray <ZQZFCertificateModel *>*otbArray;

@end

@implementation ZQZFCertificateController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _switchBtnsView.layer.borderColor = [VXG_COLOR_3f92e9_GRAYBLUE CGColor];
    _switchBtnsView.layer.borderWidth = 1.0f;
    
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
    }];
    [self.tableView.mj_footer endRefreshingWithNoMoreData];
    self.oTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
    }];
    [self.oTableView.mj_footer endRefreshingWithNoMoreData];
    
    [self loadLeftData];
    [self loadRightData];
}

#pragma mark - 懒加载
- (NSMutableArray<ZQZFpzModel *> *)tbArray {
    if (!_tbArray) {
        _tbArray = [NSMutableArray array];
    }
    return _tbArray;
}

- (NSMutableArray<ZQZFCertificateModel *> *)otbArray {
    if (!_otbArray) {
        _otbArray = [NSMutableArray array];
    }
    return _otbArray;
}

#pragma mark - 加载数据
- (void)loadLeftData {
    [[HttpManager manager] paramsGet:[UrlConfig MeteringURL:getPayCertBill] param:@{@"SessionCode":self.sessionCode, @"SectNo":self.sectNo} success:^(NSData *data) {
        if ([ResponseUtils success:data]) {
            NSMutableArray <ZQZFpzModel *>*arr = [ZQZFpzModel mj_objectArrayWithKeyValuesArray:[[ResponseUtils getData:@"data"]objectForKey:@"rows"] ];
            if (arr) {
                self.tbArray = arr;
                [self.tableView reloadData];
            }
        } else {
            [MBManager showBriefAlert:[ResponseUtils getMsg]];
        }
    } faild:^(NSString *msg) {
        [MBManager showBriefAlert:msg];
    }];
}

- (void)loadRightData {
    [[HttpManager manager] paramsGet:[UrlConfig MeteringURL:getPayCert] param:@{@"SessionCode":self.sessionCode, @"SectNo":self.sectNo} success:^(NSData *data) {
        if ([ResponseUtils success:data]) {
            NSMutableArray <ZQZFCertificateModel *>*arr = [ZQZFCertificateModel mj_objectArrayWithKeyValuesArray:[[ResponseUtils getData:@"data"]objectForKey:@"rows"] ];
            if (arr) {
                self.otbArray = arr;
                [self.oTableView reloadData];
            }
        } else {
            [MBManager showBriefAlert:[ResponseUtils getMsg]];
        }
    } faild:^(NSString *msg) {
        [MBManager showBriefAlert:msg];
    }];
}

#pragma mark - 点击事件
- (IBAction)buttonClicked:(UIButton *)sender {
    if (sender == self.leftBtn) {
        [self changeBtnStyle:0];
        self.tableView.hidden = NO;
        self.oTableView.hidden = YES;
    } else {
        [self changeBtnStyle:1];
        self.tableView.hidden = YES;
        self.oTableView.hidden = NO;
    }
}

- (void)changeBtnStyle:(NSInteger)type{
    UIColor *colorSelected = VXG_COLOR_3f92e9_GRAYBLUE;
    UIColor *colorUnselected = [UIColor whiteColor];
    if (0 == type) { //待审核
        [self.leftBtn setBackgroundColor:colorSelected];
        [self.leftBtn setTitleColor:colorUnselected forState:UIControlStateNormal];
        [self.rightBtn setBackgroundColor:colorUnselected];
        [self.rightBtn setTitleColor:VXG_COLOR_999999_GRAY forState:UIControlStateNormal];
    }else{
        [self.leftBtn setBackgroundColor:colorUnselected];
        [self.leftBtn setTitleColor:VXG_COLOR_999999_GRAY forState:UIControlStateNormal];
        [self.rightBtn setBackgroundColor:colorSelected];
        [self.rightBtn setTitleColor:colorUnselected forState:UIControlStateNormal];
    }
}

#pragma mark - UITableViewDelegate, UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == self.tableView) {
        return self.tbArray.count;
    } else {
        return self.otbArray.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.tableView) {
        ZQZFpzCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ZQZFpzCell" forIndexPath:indexPath];
        [cell loadDataModel:self.tbArray[indexPath.row]];
        return cell;
    } else {
        ZQZFCertificateCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ZQZFCertificateCell" forIndexPath:indexPath];
        [cell loadDataModel:self.otbArray[indexPath.row]];
        return cell;
    }
}

@end
