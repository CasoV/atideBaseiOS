//
//  PrjController.m
//  PMPlatform_IOS
//
//  Created by 末末班车 on 2017/10/12.
//  Copyright © 2017年 com.atide. All rights reserved.
//

#import "PrjController.h"
#import "UUChart.h"
#import "AnalyItemCell.h"
#import "VxgSelector.h"
#import "VxgCellData.h"
#import "SectModel.h"
#import "StringUtils.h"
#import "VxgColor.h"
#import "VxgUIUtils.h"

@interface PrjController ()<UUChartDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *labelTitle;
@property (weak, nonatomic) IBOutlet UILabel *itemDesc;
@property (weak, nonatomic) IBOutlet UIView *chartView;
@property (weak, nonatomic) IBOutlet UILabel *totalContract;
@property (weak, nonatomic) IBOutlet UILabel *totalMeasure;

@end

@implementation PrjController {
    float              m_maxValue;
    UUChart            *m_chartView;
    UserInfo           *m_userInfo;
    NSString           *m_type;
    NSString           *m_itemDesc;
    UITableView        *m_tableView;
    NSMutableArray     *m_tbArray;
    NSMutableArray     *m_xLabelName;
    NSMutableArray     *m_yBarValues;
    NSMutableArray     *m_colors;
    NSMutableArray     *m_colorLabels;
    NSMutableArray     *m_paramSects;
    NSMutableArray     *m_paramSectSessions;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    m_userInfo=[UserInfo getInstance];
    m_yBarValues = [[NSMutableArray alloc]init];
    m_xLabelName = [[NSMutableArray alloc]init];
    _itemDesc.text = m_itemDesc ;
    _tableView.tableFooterView = [[UIView alloc]init];
    
    self.navigationItem.rightBarButtonItem  = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"jlzf_select"] style:UIBarButtonItemStylePlain target:self action:@selector(rightButtonClicked)];
    
    [self initData];
}

- (void)initData{
    
    [[HttpManager manager] paramsGet:[UrlConfig MeteringURL:getPrjData] param:@{
                                                                                @"sectNos":m_paramSects,
                                                                                @"sectSessionsList":m_paramSectSessions
                                                                               }
                             success:^(NSData *data) {
                                 if ([ResponseUtils success:data]) {
                                     if ([[ResponseUtils getData:@"data"] isKindOfClass:[NSDictionary class]]) {
                                         NSDictionary *data = [ResponseUtils getData:@"data"];
                                         [self setCell:data];
                                     }
                                 } else {
                                     [MBManager showBriefAlert:[ResponseUtils getMsg]];
                                 }
                             } faild:^(NSString *msg) {
                                 [MBManager showBriefAlert:msg];
                             }];
}

- (void)setCell:(NSDictionary *)data{
    //汇总
    NSMutableArray *gatherList = [data objectForKey:@"gatherData"];
    NSMutableArray *gathers = [[NSMutableArray alloc]init];
    for (NSDictionary *nsd in gatherList) {
        VxgCellData *data = [[VxgCellData alloc]init];
        data.name = [nsd objectForKey:@"mName"];
        data.value = [nsd objectForKey:@"mHt"];
        data.remark = [nsd objectForKey:@"mJl"];
        [gathers addObject:data];
    }
    
    //合同段
    NSMutableArray *sectList = [data objectForKey:@"sectData"];
    NSMutableArray *sects = [[NSMutableArray alloc]init];
    for (NSDictionary *nsd in sectList) {
        VxgCellData *data = [[VxgCellData alloc]init];
        data.name = [nsd objectForKey:@"mName"];
        data.value = [nsd objectForKey:@"mHt"];
        data.remark = [nsd objectForKey:@"mJl"];
        [sects addObject:data];
    }
    //统计
    NSDictionary *totals = [data objectForKey:@"totalAmt"];
    if ( [m_type isEqual:@"0"] ) { //汇总
        m_tbArray = gathers;
        _totalContract.text = [totals objectForKey:@"gatherJL"];
        _totalMeasure.text = [totals objectForKey:@"gatherHT"];
    }else{
        m_tbArray = sects;
        _totalContract.text = [totals objectForKey:@"sectJL"];
        _totalMeasure.text = [totals objectForKey:@"sectHT"];
    }
    [_tableView reloadData];
    
    [self initUUChartData];
}

#pragma mark - UITableViewDelegate, UITableViewDataSource
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
    AnalyItemCell *cell = [tableView dequeueReusableCellWithIdentifier:@"analyItemCell" forIndexPath:indexPath];
    VxgCellData *data = [m_tbArray objectAtIndex:[indexPath row]];
    cell.labelSection.text = data.name;
    cell.labelContract.text = data.value;
    cell.labelMeasure.text = data.remark;
    return cell;
}


#pragma mark - UUChart
- (void)initUUChartData{
    m_maxValue = 0.0f;
    m_colors = [[NSMutableArray alloc]initWithObjects:VXG_COLOR_77D28A_GREEN,VXG_COLOR_ORANGE_RED, nil];
    
    if (m_colorLabels==nil) {
        m_colorLabels = [NSMutableArray arrayWithObjects:@"合同金额",@"计量金额", nil];
    }
    
    [m_yBarValues removeAllObjects];
    [m_xLabelName removeAllObjects];
    NSMutableArray *contractArray = [[NSMutableArray alloc]init];
    NSMutableArray *measureArray = [[NSMutableArray alloc]init];
    
    int k = 0;
    for(VxgCellData *data in m_tbArray){
        [m_xLabelName addObject:data.name];
        [contractArray addObject:data.value];
        [measureArray addObject:data.remark];
        m_maxValue = ([data.value floatValue] < m_maxValue) ? m_maxValue : [data.value floatValue];
        m_maxValue = ([data.remark floatValue] < m_maxValue) ? m_maxValue : [data.remark floatValue];
        m_maxValue = ([data.value floatValue] < m_maxValue) ? m_maxValue : [data.value floatValue];
        k++;
    }
    
    [m_yBarValues addObject:contractArray];
    [m_yBarValues addObject:measureArray];
    [self configUUChartUI];
}

- (void)configUUChartUI{
    
    if (m_chartView) {
        [m_chartView removeFromSuperview];
        m_chartView = nil;
    }
    
    CGFloat screenH = [UIScreen mainScreen].bounds.size.height;
    CGFloat chartViewHeight = screenH*0.4f - 20;
    m_chartView = [[UUChart alloc]initwithUUChartDataFrame:CGRectMake(5, ATIDE_TITLE_VIEW_HEIGHT+ATIDE_DESC_VIEW_HEIGHT, [UIScreen mainScreen].bounds.size.width-20, chartViewHeight)
                                                withSource:self
                                                 withStyle:UUChartBarStyle];
    m_chartView.itemSepWidth = 10 ;
    [m_chartView setBarNum:2];
    [m_chartView setYBarLabelWidth:50.0f];
    [m_chartView showInView:self.view];
    
    [VxgUIUtils s_uuchart_bar_init_item_desc:self.view y:chartViewHeight+ ATIDE_DESC_VIEW_HEIGHT labelWidth:0 colors:m_colors labels:m_colorLabels];
    
}
//横坐标标题数组
- (NSArray *)UUChart_xLableArray:(UUChart *)chart
{
    
    return m_xLabelName;
}

//数值多重数组
- (NSArray *)UUChart_yValueArray:(UUChart *)chart
{
    return m_yBarValues;
}

//颜色数组
- (NSArray *)UUChart_ColorArray:(UUChart *)chart
{
    return m_colors;
}

- (CGRange)UUChartChooseRangeInLineChart:(UUChart *)chart
{
    return CGRangeMake(m_maxValue, 0);
}

#pragma mark params
- (void)setPrjParams:(NSDictionary *)nsd{
    m_type = [nsd objectForKey:@"type"];
    
    NSMutableArray *sectSessions = (NSMutableArray *)[nsd objectForKey:@"sectSessions"];
    [self setHttpParams:sectSessions];
    
    if ([m_type  isEqual: @"0"]) {
        m_itemDesc = @"计量支付情况统计（汇总）";
    }else{
        m_itemDesc = @"计量支付情况统计（合同段）";
    }
}

- (void)setHttpParams:(NSMutableArray *)datas{
    if (datas == nil || datas.count <1) {
        return;
    }
    if (m_paramSects == nil ) {
        m_paramSects = [[NSMutableArray alloc]init];
        m_paramSectSessions = [[NSMutableArray alloc]init];
    }
    if (m_paramSectSessions == nil) {
        m_paramSectSessions = [[NSMutableArray alloc]init];
    }
    [m_paramSects removeAllObjects];
    [m_paramSectSessions removeAllObjects];
    for (VxgCellData *data in datas) {
        [m_paramSects addObject:data.remark1];
        [m_paramSectSessions addObject:[[NSDictionary alloc]initWithObjectsAndKeys:data.remark1,@"sectNo",data.value,@"sessionCode", nil]];
    }
}

#pragma mark - 点击事件
- (void)rightButtonClicked {
    NSMutableArray *arrays = [[NSMutableArray alloc]init];
    [[HttpManager manager] paramsGet:[UrlConfig MeteringURL:getAvaliableByUser] param:@{
                                                                                        @"BussinessFlag":@"1",
                                                                                        @"ChildBussinessFlag":@"1",
                                                                                        @"UserCode":[UserInfo getInstance].code
                                                                                       }
                             success:^(NSData *data) {
                                 [arrays removeAllObjects];
                                 if ([ResponseUtils success:data]) {
                                     if ([[ResponseUtils getData:@"data"] isKindOfClass:[NSDictionary class]]) {
                                         [arrays addObjectsFromArray:[[ResponseUtils getData:@"data"] objectForKey:@"rows"]];
                                         
                                         NSMutableArray *selectorDatas = [StringUtils VxgGetSectNewstSession:[SectModel mj_objectArrayWithKeyValuesArray:arrays]];
                                         VxgSelector *vxgSelector = [[VxgSelector alloc]initVxgSelector:self title:@"选择统计工区(最新期,可多选)" btnName:@"确定" datas:selectorDatas];
                                         [vxgSelector setValue];
                                         [vxgSelector show];
                                     }
                                 } else {
                                     [MBManager showBriefAlert:[ResponseUtils getMsg]];
                                 }
                             } faild:^(NSString *msg) {
                                 [MBManager showBriefAlert:msg];
                             }];
}

- (void)alertView:(VxgSelector *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (1==buttonIndex) {
        NSMutableArray *selectors = [alertView getData];
        [self setHttpParams:selectors];
        [self initData];
    }
}

@end
