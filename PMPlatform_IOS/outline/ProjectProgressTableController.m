//
//  ProjectProgressTableController.m
//  PMPlatform_IOS
//
//  Created by vxg on 2017/11/29.
//  Copyright © 2017年 com.atide. All rights reserved.
//

#import "ProjectProgressTableController.h"
#import "SysConfig.h"
#import "WebServiceConfig.h"
#import "WebserviceManager.h"
#import "XMLParser.h"
#import "ProjectSect.h"
#import "CustomXCMultiTableView.h"
#import "NSString+trim.h"
#import "ProjectProgressTable.h"

@interface ProjectProgressTableController ()<XCMultiTableViewDataSource>{
    NSArray *headData;
    NSMutableArray *leftTableData;
    NSMutableArray *rightTableData;
    CustomXCMultiTableView *tableView;
    NSMutableArray *mSectsData;
}

@end

@implementation ProjectProgressTableController

- (void)viewDidLoad {
    [self initData];
    [super viewDidLoad];
    [self initProjects];
    
    
}
- (void)initData{
    NSArray *item1 = [NSArray arrayWithObjects:@"工程量",@"设计工程量" ,@"变更工程量",@"变更后工程量", nil];
    NSArray *item2 = [NSArray arrayWithObjects:@"本阶段计划完成" ,@"数量",@"完成(%)", nil];
    NSArray *item3 = [NSArray arrayWithObjects:@"本月完成" ,@"数量",@"完成(%)", nil];
    NSArray *item4 = [NSArray arrayWithObjects:@"本阶段累计完成" ,@"数量",@"完成(%)", nil];
    NSArray *item5 = [NSArray arrayWithObjects:@"开工至本月累计完成" ,@"完成工程量",@"完成(%)", nil];
    headData = [NSArray arrayWithObjects:@"单位",item1,item2,item3,item4,item5, nil];
    leftTableData = [[NSMutableArray alloc] init];
    rightTableData = [[NSMutableArray alloc] init];
}
- (void)refresh:(BOOL)isRefresh{
    [super refresh:isRefresh];
    if (isRefresh) {
        [self fetchProjectSect];
    }
    else{
        [self fetchProjectProgress];
    }
}
- (void)fetchProjectProgress{
    if (mSectsData == nil) {
        return;
    }
    if ([self isVisible]) {
        [MBManager showLoading];
    }
    NSMutableArray *sects = [[NSMutableArray alloc] init];
    for (ProjectSect *sect in mSectsData) {
        if (sect.issect) {
            [sects addObject:sect.sectno];
        }
    }
    __weak typeof(self) weakSelf = self;
    NSDictionary *config = [WebServiceConfig config:WebServiceConfig.ProgressService];
    [WebserviceManager dataTaskWithSoapRequest:[@{@"prjID":[SysConfig getInstance].projectId,@"progressSession":self.time,@"sectNos":sects} mutableCopy] url:config[@"url"] method:config[@"GetPrjQuantity"] nameSpace:config[@"nameSpace"] completed:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf dealWithResponse:@[]];
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
                        NSArray *ps = [ProjectProgressTable mj_objectArrayWithKeyValuesArray:[ResponseUtils getData:@"data"]];
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
    
    for (ProjectProgressTable *invest in data) {
    
        DataItem *item = [[DataItem alloc] initWith:invest.displaycode keyName:invest.dsiname tag:invest];
        [leftTableData addObject:item];
        NSArray *item1 = [NSArray arrayWithObjects:invest.fillnote_0 ,invest.fillnote_1,invest.fillnote_2, nil];
        NSArray *item2 = [NSArray arrayWithObjects:invest.fillnote_15,invest.fillnote_16, nil];
        NSArray *item3 = [NSArray arrayWithObjects:invest.fillnote_5,invest.fillnote_6, nil];
        NSArray *item4 = [NSArray arrayWithObjects:invest.fillnote_17,invest.fillnote_18, nil];
        NSArray *item5 = [NSArray arrayWithObjects:invest.fillnote_9,invest.fillnote_10, nil];
        NSArray *values = [NSArray arrayWithObjects:invest.dsiuname,item1,item2,item3,item4,item5, nil];
        [rightTableData addObject:values];
    }
    [tableView reloadData];
}
- (UIView *)childView{
    tableView = [[CustomXCMultiTableView alloc] initWithFrame:CGRectInset(self.view.bounds, 5.0f, 5.0f)];
    tableView.leftHeaderWidth = ScreenWidth/3;
    tableView.leftHeaderEnable = YES;
    tableView.datasource = self;
    return tableView;
    
}

- (BOOL)sectIsHidden{
    return NO;
}
- (void)fetchProjectSect{
    [MBManager showLoading];
    __weak typeof(self) weakSelf = self;
    NSDictionary *config = [WebServiceConfig config:WebServiceConfig.PrjectOverViewService];
    [WebserviceManager dataTaskWithSoapRequest:[@{@"projectKey":[SysConfig getInstance].projectId} mutableCopy] url:config[@"url"] method:config[@"GetSectDatas"] nameSpace:config[@"nameSpace"] completed:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
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
                        mSectsData = [ProjectSect mj_objectArrayWithKeyValuesArray:[ResponseUtils getData:@"data"]];
                        if (mSectsData!=nil) {
                            for (ProjectSect *sect in mSectsData) {
                                sect.issect = YES;
                            }
                            [SysConfig getInstance].sectInfos = mSectsData;
                        }
                        [weakSelf fetchProjectProgress];
                        
                    } else {
                        [MBManager showBriefAlert:[ResponseUtils getMsg]];
                    }
                });
            }];
        }
    }];
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
    if (column==0) {
        return ScreenWidth/5;
    }else if(column==1){
        return ScreenWidth/2;
    }
    return ScreenWidth/3;
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
   
}

@end
