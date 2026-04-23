//
//  ProjectInvestDetailController.m
//  PMPlatform_IOS
//
//  Created by vxg on 2017/09/08.
//  Copyright © 2017年 com.atide. All rights reserved.
//

#import "ProjectInvestDetailController.h"
#import <Charts/Charts-Swift.h>
#import "BarChartsHelper.h"
#import "ProjectInvestDetailCell.h"

@interface ProjectInvestDetailController ()<UITableViewDelegate,UITableViewDataSource>{
    HorizontalBarChartView *chartView;
    NSMutableArray *dataSource;
}
@property (weak, nonatomic) IBOutlet UITableView *topView;
@property (weak, nonatomic) IBOutlet UIView *bottomView;

@end

@implementation ProjectInvestDetailController
static NSString *cellIdentify = @"ProjectInvestDetailCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.edgesForExtendedLayout = UIRectEdgeBottom;
    self.navigationItem.title = self.projectInvest[@"sectname"];
    _topView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _topView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectZero];
    _topView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [_topView registerNib:[UINib nibWithNibName:@"ProjectInvestDetailCell" bundle:nil] forCellReuseIdentifier:cellIdentify];
    [self top];
    [self initData];
}

- (void)initData{

     NSArray *item_code = @[ @"contractamt", @"designamt",
        @"finishedamt", @"compamt", @"payamt", @"changeamt", @"accountamt",
        @"bargainamt" ];
    NSArray *ITEM_NAMES = @[@"合同金额", @"设计金额", @"完成金额",
        @"计量金额", @"支付金额", @"变更金额", @"合计金额", @"完善金额"];
    dataSource = [[NSMutableArray alloc] initWithCapacity:item_code.count];
    NSMutableArray *xValue = [[NSMutableArray alloc] initWithCapacity:5];
    NSMutableArray *yValue = [[NSMutableArray alloc] initWithCapacity:5];
    for (int i=0;i<item_code.count;i++) {
        NSString *name = ITEM_NAMES[i];
        NSString *value = self.projectInvest[item_code[i]];
        NSDictionary *item = @{@"name":name,@"value":value};
        [dataSource addObject:item];
        if (i<5) {
            [xValue addObject:name];
            [yValue addObject:value];
        }
    }
    
    [BarChartsHelper initCharts:chartView xValue:yValue yValue:xValue divison:10000 color:[UIColor hex:@"009900"]];
}


- (void)top{
    chartView = [[HorizontalBarChartView alloc] init];
    [BarChartsHelper setupBarLineChartView:chartView];
    [self.bottomView addSubview:chartView];
    [self addConstraint:self.bottomView subView:chartView top:5 bottom:-5 left:5 right:-5];
}

- (void)addConstraint:(UIView *)view subView:(UIView *)subView top:(NSInteger)top bottom:(NSInteger)bottom left:(NSInteger)left right:(NSInteger)right{
    subView.translatesAutoresizingMaskIntoConstraints = NO;
    NSLayoutConstraint *top1 = [NSLayoutConstraint constraintWithItem:subView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeTop multiplier:1 constant:top];
    NSLayoutConstraint *left1 = [NSLayoutConstraint constraintWithItem:subView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeLeft multiplier:1 constant:left];
    NSLayoutConstraint *right1 = [NSLayoutConstraint constraintWithItem:subView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeRight multiplier:1 constant:right];
    NSLayoutConstraint *bottom1 = [NSLayoutConstraint constraintWithItem:subView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeBottom multiplier:1 constant:bottom];
    [view addConstraints:[NSArray arrayWithObjects:top1,left1,right1,bottom1,nil, nil]];
}

#pragma uitableview delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 40;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return dataSource == nil ? 0 : dataSource.count;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ProjectInvestDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentify forIndexPath:indexPath];
    NSDictionary *item = [dataSource objectAtIndex:indexPath.row];
    [cell initData:[item objectForKey:@"name"] value:[item objectForKey:@"value"]];
    return cell;
}

@end
