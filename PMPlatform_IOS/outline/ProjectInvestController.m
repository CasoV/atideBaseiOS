//
//  ProjectInvestController.m
//  PMPlatform_IOS
//
//  Created by vxg on 2017/09/05.
//  Copyright © 2017年 com.atide. All rights reserved.
//

#import "ProjectInvestController.h"
#import "WebserviceManager.h"
#import "XMLParser.h"
#import "WebServiceConfig.h"
#import "ProjectInfo.h"
#import "SysConfig.h"
#import "ProjectInvest.h"
#import "CustomXCMultiTableView.h"
#import <Charts/Charts-Swift.h>
#import "BarChartsHelper.h"
#import "ProjectInvestDetailController.h"


@interface ProjectInvestController ()<XCMultiTableViewDataSource>{
    NSArray *headData;
    NSMutableArray *leftTableData;
    NSMutableArray *rightTableData;
    CustomXCMultiTableView *tableView;
    HorizontalBarChartView *chartView;
}
@end

@implementation ProjectInvestController
- (void)viewDidLoad {
    [self initData];
    [super viewDidLoad];
    [self fetchProjects];
   
}

- (void)initData{
    headData = [NSArray arrayWithObjects:@"合同金额",@"设计金额",@"完善金额",@"变更设计金额",@"合计",@"计量金额",@"完成金额",@"支付金额",nil, nil];
    leftTableData = [[NSMutableArray alloc] init];
    rightTableData = [[NSMutableArray alloc] init];
}
- (void)refresh{
    [super refresh];
    [self fetchProjectInvest];
}
- (void)fetchProjects{
    [MBManager showLoading];
    __weak typeof(self) weakSelf = self;
    NSDictionary *config = [WebServiceConfig config:WebServiceConfig.SecurityService];
    [WebserviceManager dataTaskWithSoapRequest:[@{@"userKey":UserInfo.getInstance.ID} mutableCopy] url:config[@"url"] method:config[@"GetProjectsByUserKeys"] nameSpace:config[@"nameSpace"] completed:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [MBManager hideAlert];
                [MBManager showBriefAlert:[NSString stringWithFormat:@"%@", error]];
            });
        }else {
            
            [[[XMLParser alloc] init] analysisXMLData:data handleBlock:^(NSData *jsonData) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [MBManager hideAlert];
                    if ([ResponseUtils success:jsonData]) {
                        NSArray *ps = [ProjectInfo mj_objectArrayWithKeyValuesArray:[ResponseUtils getData:@"data"]];
                        if (!ps || ps.count<1) {
                            return;
                        }
                        [SysConfig getInstance].projectInfos = ps;
                        ProjectInfo *info = ps[0];
                        [SysConfig getInstance].projectId = info.prjid;
                        [weakSelf initProjects];
                        //[weakSelf fetchProjectInvest];
                        
                    } else {
                        [MBManager showBriefAlert:[ResponseUtils getMsg]];
                    }
                });
            }];
        }
    }];
}
- (BOOL)isVisible{
    return self.tabBarController.selectedIndex == 0;
}
- (void)fetchProjectInvest{
    if ([self isVisible]) {
        [MBManager showLoading];
    }
    //
    __weak typeof(self) weakSelf = self;

    NSDictionary *config = [WebServiceConfig config:WebServiceConfig.PrjectOverViewService];
    [WebserviceManager dataTaskWithSoapRequest:[@{@"projectKey":[SysConfig getInstance].projectId,@"statMonth":self.time} mutableCopy] url:config[@"url"] method:config[@"StatProjectInvestFinished"] nameSpace:config[@"nameSpace"] completed:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if ([self isVisible]) {
                [MBManager hideAlert];
                [MBManager showBriefAlert:[NSString stringWithFormat:@"%@", error]];
                }
            });
        }else {
            
            [[[XMLParser alloc] init] analysisXMLData:data handleBlock:^(NSData *jsonData) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if ([self isVisible])
                    [MBManager hideAlert];
                    if ([ResponseUtils success:jsonData]) {
                        NSArray *ps = [ProjectInvest mj_objectArrayWithKeyValuesArray:[ResponseUtils getData:@"data"]];
                        [weakSelf dealWithResponse:ps];
                        
                    } else {
                        [weakSelf dealWithResponse:@[]];
                        if ([self isVisible]) {
                        [MBManager showBriefAlert:[ResponseUtils getMsg]];
                        }
                    }
                });
            }];
        }
    }];
}

- (void)dealWithResponse:(NSArray *)data{
    if (!data) {
        return;
    }
    [leftTableData removeAllObjects];
    [rightTableData removeAllObjects];
    NSArray *xValues = nil;
    for (ProjectInvest *pi in data) {
        ProjectInvest *invest = [pi trim];
        if (xValues == nil) {
            xValues = [NSArray arrayWithObjects:invest.contractamt,invest.designamt,invest.finishedamt,invest.compamt,invest.payamt,nil, nil];
        }
        
        DataItem *item = [[DataItem alloc] initWith:invest.sectno keyName:invest.sectname tag:invest];
        [leftTableData addObject:item];
        NSArray *values = [NSArray arrayWithObjects:invest.contractamt,invest.designamt,invest.bargainamt,invest.changeamt,invest.accountamt,invest.compamt,invest.finishedamt,invest.payamt,nil, nil];
        [rightTableData addObject:values];
    }
    
    [BarChartsHelper initCharts:chartView xValue:xValues yValue:[NSArray arrayWithObjects:@"合同金额",@"设计金额",@"完成金额",@"计量金额",@"支付金额",nil, nil] divison:10000 color:nil];
    [tableView reloadData];
}

- (NSString *)bottomTip{
    return @"项目汇总(元)";
}
- (UIView *)bottomView{
    tableView = [[CustomXCMultiTableView alloc] initWithFrame:CGRectInset(self.view.bounds, 5.0f, 5.0f)];
    tableView.leftHeaderWidth = ScreenWidth/3;
    tableView.leftHeaderEnable = YES;
    tableView.datasource = self;
    return tableView;
}
- (UIView *)topView{
    chartView = [[HorizontalBarChartView alloc] init];
    [BarChartsHelper setupBarLineChartView:chartView];
    return chartView;
}
#pragma mark - XCMultiTableViewDataSource

- (NSArray *)arrayDataForTopHeaderInTableView:(XCMultiTableView *)tableView {
    return headData;
}
- (NSArray *)arrayDataForLeftHeaderInTableView:(XCMultiTableView *)tableView InSection:(NSUInteger)section {
    return leftTableData;
}

- (NSArray *)arrayDataForContentInTableView:(XCMultiTableView *)tableView InSection:(NSUInteger)section {
    return rightTableData;
}


- (NSUInteger)numberOfSectionsInTableView:(XCMultiTableView *)tableView {
    return 1;
}

- (CGFloat)tableView:(XCMultiTableView *)tableView contentTableCellWidth:(NSUInteger)column {
    
    return ScreenWidth/2;
}


- (CGFloat)tableView:(XCMultiTableView *)tableView cellHeightInRow:(NSUInteger)row InSection:(NSUInteger)section {
    return 40;
}

- (UIColor *)tableView:(XCMultiTableView *)tableView bgColorInSection:(NSUInteger)section InRow:(NSUInteger)row InColumn:(NSUInteger)column {
    
    return [UIColor whiteColor];
}

- (UIColor *)tableView:(XCMultiTableView *)tableView headerBgColorInColumn:(NSUInteger)column {
    
    return [UIColor whiteColor];
}

- (NSString *)leftHeaderTextInTableView:(XCMultiTableView *)tableView{
    return @"标段";
}
- (void)tableViewForLeft:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    DataItem *data = [leftTableData objectAtIndex:indexPath.row];
    ProjectInvestDetailController *detailController = [[ProjectInvestDetailController alloc] initWithNibName:@"ProjectInvestDetailController" bundle:nil];
    detailController.projectInvest = data.tag;
    [self.navigationController pushViewController:detailController animated:YES];
}
@end
