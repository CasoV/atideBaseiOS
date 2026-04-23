//
//  MidMeasureDetilApprovalInfo.m
//  TrafficMs
//
//  Created by apple on 2015/11/15.
//  Copyright © 2015年 com. All rights reserved.
//

#import "MidMeasureDetilApprovalInfo.h"
#import "MidMeasureDetilApprovalInfoCell.h"
#import "ApprovalIdeal.h"
#import "VxgUIUtils.h"
#import "VxgColor.h"

#define FLOW_BACK_COLOR         VXG_COLOR_FF5313_OGANGE
#define FLOW_AGREEN_COLOR       VXG_COLOR_3f92e9_GRAYBLUE

@interface MidMeasureDetilApprovalInfo (){
    NSMutableArray *m_tbArray;
    MidMeasureInfo *m_info;
}

@end

@implementation MidMeasureDetilApprovalInfo

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    m_tbArray = [[NSMutableArray alloc]init];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
//    _tableView.estimatedRowHeight = 120;
//    _tableView.rowHeight = UITableViewAutomaticDimension;
    
    [self getWebData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)getWebData{
    if(m_info == nil || m_info.compId == nil){
        return;
    }
    
    NSString *method = [UrlConfig MeteringURL:getApprovalIdealByKey];
    
    [[HttpManager manager] paramsGet:method param:@{
                                                    @"ObjectKey":[NSString stringWithFormat:@"%@",m_info.compId],
                                                    @"BussinessFlag":@"1",
                                                    @"ChildBussinessFlag":m_info.childBussinessFlag ? m_info.childBussinessFlag : @"0"
                                                   }
                             success:^(NSData *data) {
                                 if ([ResponseUtils success:data]) {
                                     if ([[ResponseUtils getData:@"data"] isKindOfClass:[NSDictionary class]]) {
                                         NSMutableArray *dataArray = [[ResponseUtils getData:@"data"] objectForKey:@"rows"];
                                         
                                         if (dataArray!=nil && dataArray.count>0) {
                                             [self setDatas:dataArray];
                                         }else{
                                             //设置没有数据的UI
                                             [self setNullDataView];
                                         }
                                     }
                                 } else {
                                     [MBManager showBriefAlert:[ResponseUtils getMsg]];
                                 }
                             } faild:^(NSString *msg) {
                                 [MBManager showBriefAlert:msg];
                             }];
}

- (void)setDatas:(NSMutableArray *)datas{
    for (NSDictionary *nsd in datas) {
        ApprovalIdeal *ideal = [[ApprovalIdeal alloc]init];
        [ideal setData:nsd];
        [m_tbArray addObject:ideal];
    }
    
    [_tableView reloadData];
}

-(void)setNullDataView{
    _tableView.hidden = YES;
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


#pragma mark table view datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return m_tbArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MidMeasureDetilApprovalInfoCell *cell=[tableView dequeueReusableCellWithIdentifier:@"midMeasureDetilApprovalInfoCell" forIndexPath:indexPath];
    ApprovalIdeal *data = [m_tbArray objectAtIndex:[indexPath row]];
    cell.text1.text = [NSString stringWithFormat:@"%@ %@",data.unitName,data.userName];
    NSString *time = [NSString stringWithFormat:@"审核时长:%@",data.approvalTime];
    [time stringByReplacingOccurrencesOfString:@" " withString:@""];
    cell.text2.text = time;
    if ([data.isPass  isEqual: @"true"]) {
        cell.text3.textColor = FLOW_AGREEN_COLOR;
        cell.text3.text = @"同意";
    }else{
        cell.text3.textColor = FLOW_BACK_COLOR;
       cell.text3.text = @"退回";
    }
    cell.text4.text = [NSString stringWithFormat:@"意见:%@",data.approvalIdea];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(void)setParams:(MidMeasureInfo *)info{
    m_info = info;
}

@end
