//
//  MediumPaymentVoucherController.m
//  PMPlatform_IOS
//
//  Created by 末末班车 on 2017/10/17.
//  Copyright © 2017年 com.atide. All rights reserved.
//

#import "MediumPaymentVoucherController.h"
#import "MediumPaymentVoucherModel.h"
#import "MediumPaymentVoucherCell.h"

@interface MediumPaymentVoucherController ()<UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSMutableArray <MediumPaymentVoucherModel *>*dataSource;

@end

@implementation MediumPaymentVoucherController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self loadData];
}

#pragma mark - 懒加载
- (NSMutableArray<MediumPaymentVoucherModel *> *)dataSource {
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

#pragma mark - 加载数据
- (void)loadData {
    [[HttpManager manager] paramsGet:[UrlConfig MeteringURL:getSuperVisingPayCert] param:@{
                                                                                           @"SessionCode":self.model.sessionCode,
                                                                                           @"SectNo":self.model.sectNo,
                                                                                           @"SpecialtyCode":self.specialtyCode
                                                                                          }
                             success:^(NSData *data) {
                                 if ([ResponseUtils success:data]) {
                                     NSMutableArray <MediumPaymentVoucherModel *>*arr = [MediumPaymentVoucherModel mj_objectArrayWithKeyValuesArray:[ResponseUtils getData:@"data"]];
                                     if (arr != nil && arr.count != 0) {
                                         self.dataSource = arr;
                                         [self.tableView reloadData];
                                     } else {
                                         [self setNullDataView];
                                     }
                                 } else {
                                     [MBManager showBriefAlert:[ResponseUtils getMsg]];
                                 }
                             } faild:^(NSString *msg) {
                                 [MBManager showBriefAlert:msg];
                             }];
}

-(void)setNullDataView{
    self.tableView.hidden = YES;
    CGPoint center = self.view.center;
    CGRect rect = CGRectMake(0, 0, 250, 250);
    UIView *content = [[UIView alloc]initWithFrame:rect];
    UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectMake(25, 0, content.frame.size.width-50, content.frame.size.height-50)];
    [imgView setImage:[UIImage imageNamed:@"none"]];
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(content.frame.origin.x, content.frame.size.height-50, content.frame.size.width, 50)];
    label.text = @"暂时没有数据！";
    label.font = [UIFont systemFontOfSize:11.0f];
    label.textAlignment = NSTextAlignmentCenter;
    
    [content setCenter:center];
    [content addSubview:imgView];
    [content addSubview:label];
    
    [self.view addSubview:content];
}

#pragma mark - UITableViewDelegate, UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MediumPaymentVoucherCell *cell = [tableView dequeueReusableCellWithIdentifier:@"mediumPaymentVoucherCell" forIndexPath:indexPath];
    [cell setDataModel:self.dataSource[indexPath.row]];
    return cell;
}

@end
