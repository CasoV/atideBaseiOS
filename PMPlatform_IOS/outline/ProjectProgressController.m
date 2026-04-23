//
//  ProjectProgressController.m
//  PMPlatform_IOS
//
//  Created by vxg on 2017/09/05.
//  Copyright © 2017年 com.atide. All rights reserved.
//

#import "ProjectProgressController.h"
#import "SysConfig.h"
#import "WebServiceConfig.h"
#import "WebserviceManager.h"
#import "XMLParser.h"
#import "ProjectProgress.h"
#import "ProjectSect.h"
#import "XCMultiSortTableView.h"
#import "NSString+trim.h"
#import <Charts/Charts-Swift.h>
#import "BarChartsHelper.h"


@interface ProjectProgressController ()<XCMultiTableViewDataSource>{
    NSArray *headData;
    NSMutableArray *leftTableData;
    NSMutableArray *rightTableData;
    XCMultiTableView *tableView;
    HorizontalBarChartView *chartView;
}

@end

@implementation ProjectProgressController

- (void)viewDidLoad {
    [self initData];
    [super viewDidLoad];
    [self initProjects];
    
}
- (void)initData{
    headData = [NSArray arrayWithObjects:@"单位",@"合同情况",@"设计情况",@"变更情况",@"合计",@"完成情况",@"剩余情况",nil, nil];
    leftTableData = [[NSMutableArray alloc] init];
    rightTableData = [[NSMutableArray alloc] init];
}
- (void)refresh{
    [super refresh];
    [self fetchProjectProgress];
}
- (void)fetchProjectProgress{
    if ([self isVisible]) {
        [MBManager showLoading];
    }
    __weak typeof(self) weakSelf = self;
    NSDictionary *config = [WebServiceConfig config:WebServiceConfig.PrjectOverViewService];
    [WebserviceManager dataTaskWithSoapRequest:[@{@"projectKey":[SysConfig getInstance].projectId,@"statMonth":self.time,@"SectNo":self.sects} mutableCopy] url:config[@"url"] method:config[@"StatProgressFinished"] nameSpace:config[@"nameSpace"] completed:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
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
                        NSArray *ps = [ProjectProgress mj_objectArrayWithKeyValuesArray:[ResponseUtils getData:@"data"]];
                        [weakSelf dealWithResponse:ps];
                        
                    } else {
                        [weakSelf dealWithResponse:@[]];
                        if ([self isVisible])
                        [MBManager showBriefAlert:[ResponseUtils getMsg]];
                    }
                });
            }];
        }
    }];
}

- (BOOL)isVisible{
    return self.tabBarController.selectedIndex == 1;
}

#pragma 处理返回结果
- (void)dealWithResponse:(NSArray *)data{
    if (!data) {
        return;
    }
    [leftTableData removeAllObjects];
    [rightTableData removeAllObjects];
    NSArray *xValues = nil;
    for (ProjectProgress *invest in data) {
        if (xValues == nil) {
            xValues = [NSArray arrayWithObjects:invest.contractquantity.trim,invest.designquantity.trim,invest.changequantity.trim,invest.accountquantity.trim,invest.finishedquantity.trim,nil, nil];
        }
        DataItem *item = [[DataItem alloc] initWith:invest.dsiid keyName:invest.dsiname tag:invest];
        [leftTableData addObject:item];
        NSArray *values = [NSArray arrayWithObjects:invest.dsiuname,invest.contractquantity.trim,invest.designquantity.trim,invest.changequantity.trim,invest.accountquantity.trim,invest.finishedquantity.trim,invest.unfinishedquantity.trim,nil, nil];
        [rightTableData addObject:values];
    }
    [BarChartsHelper initCharts:chartView xValue:xValues yValue:[NSArray arrayWithObjects:@"合同数量",@"设计数量",@"变更数量",@"总数量",@"完成数量",nil, nil] divison:1 color:nil];
    [tableView reloadData];
}
- (UIView *)topView{
    tableView = [[XCMultiTableView alloc] initWithFrame:CGRectInset(self.view.bounds, 5.0f, 5.0f)];
    tableView.leftHeaderWidth = ScreenWidth/3;
    tableView.leftHeaderEnable = YES;
    tableView.datasource = self;
    return tableView;
 
}
- (NSString *)bottomTip{
    return @"项目汇总(万元)";
}
- (UIView *)bottomView{
    chartView = [[HorizontalBarChartView alloc] init];
    [BarChartsHelper setupBarLineChartView:chartView];
    return chartView;

}
- (BOOL)sectIsHidden{
    return NO;
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
    
    return ScreenWidth/5;
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
    return @"工程类别";
}
- (void)tableViewForLeft:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    DataItem *row = [leftTableData objectAtIndex:indexPath.row];
    ProjectProgress *invest = row.tag;
    NSArray *xValues = [NSArray arrayWithObjects:invest.contractquantity.trim,invest.designquantity.trim,invest.changequantity.trim,invest.accountquantity.trim,invest.finishedquantity.trim,nil, nil];
    [BarChartsHelper initCharts:chartView xValue:xValues yValue:[NSArray arrayWithObjects:@"合同数量",@"设计数量",@"变更数量",@"总数量",@"完成数量",nil, nil] divison:1 color:nil];
}

@end
