//
//  ItemMonthController.m
//  PMPlatform_IOS
//
//  Created by 末末班车 on 2017/10/11.
//  Copyright © 2017年 com.atide. All rights reserved.
//

#import "ItemMonthController.h"
#import "VxgUIUtils.h"
#import "VxgCellData.h"
#import "JYAnalyData.h"
#import "SectModel.h"
#import "VxgColor.h"
#import "UUChart.h"
#import "SelectSectTenderController.h"
#import "JYAnalyDatabaseMng.h"

@interface ItemMonthController ()<UUChartDataSource, SectDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *itemDesc;
@property (weak, nonatomic) IBOutlet UIView *chartView;

@end

@implementation ItemMonthController {
    float                   m_maxValue;
    NSInteger               m_type;
    UUChart                 *m_chartView;
    UserInfo                *m_userInfo;
    NSString                *m_sect;
    NSString                *m_session;
    NSString                *m_sectName;
    NSString                *m_itemDesc;
    UITableView             *m_tableView;
    UIStoryboard            *m_story;
    NSMutableArray          *m_tbArray;
    NSMutableArray          *m_xLabelName;
    NSMutableArray          *m_yBarValues;
    NSMutableArray          *m_colors;
    NSMutableArray          *m_colorLabels;
    JYAnalyDatabaseMng      *m_dbMng;
    NSString                *m_title;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    m_userInfo=[UserInfo getInstance];
    m_dbMng = [[JYAnalyDatabaseMng alloc]init];
    m_tbArray = [[NSMutableArray alloc]init];
    m_yBarValues = [[NSMutableArray alloc]init];
    m_xLabelName = [[NSMutableArray alloc]init];
    m_story = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    _itemDesc.text = m_itemDesc ;
    self.title = [NSString stringWithFormat:@"%@第%@期",m_sectName,m_session];
    m_title = self.title;
    _tableView.tableFooterView = [[UIView alloc]init];
    
    self.navigationItem.rightBarButtonItem  = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"jlzf_select"] style:UIBarButtonItemStylePlain target:self action:@selector(rightButtonClicked)];
    [self initData];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.title = m_title;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    m_title = self.title;
    self.title = @"";
}

- (void)initData{
    
    NSMutableArray *datas = [m_dbMng query:m_sect session:m_session type:m_type];
    
    if (datas != nil && datas.count >0) {
        [self setCell:datas];
        return;
    }
    
    [[HttpManager manager] paramsGet:[UrlConfig MeteringURL:getAnalyData] param:@{
                                                                                  @"SectNo":m_sect,
                                                                                  @"SessionCode":m_session
                                                                                  }
                             success:^(NSData *data) {
                                 if ([ResponseUtils success:data]) {
                                     if ([[ResponseUtils getData:@"data"] isKindOfClass:[NSDictionary class]]) {
                                         NSDictionary *data = [ResponseUtils getData:@"data"];
                                         
                                         NSMutableArray *dataArrays = [[NSMutableArray alloc]init];
                                         [dataArrays addObject:[data objectForKey:@"gatherData"]];
                                         [dataArrays addObject:[data objectForKey:@"monthData"]];
                                         [dataArrays addObject:[data objectForKey:@"sessionData"]];
                                         
                                         [self saveData:dataArrays];
                                     }
                                 }else {
                                     [MBManager showBriefAlert:[ResponseUtils getMsg]];
                                 }
                             } faild:^(NSString *msg) {
                                 [MBManager showBriefAlert:msg];
                             }];
}

- (void)saveData:(NSMutableArray *)datas{
    //gather
    NSMutableArray *gatherList = [[NSMutableArray alloc]init];
    NSMutableArray *monthList = [[NSMutableArray alloc]init];
    NSMutableArray *sessionList = [[NSMutableArray alloc]init];
    
    NSMutableArray *gathers = [datas objectAtIndex:0];
    for(NSDictionary *nsdG in gathers){
        Gatherdata *data = [[Gatherdata alloc]init];
        [data setData:nsdG];
        data.sectNo = m_sect;
        data.session = m_session;
        [gatherList addObject:data];
    }
    //month
    NSMutableArray *months = [datas objectAtIndex:1];
    for(NSDictionary *nsdG in months){
        Monthdata *data = [[Monthdata alloc]init];
        [data setData:nsdG];
        data.sectNo = m_sect;
        data.session = m_session;
        [monthList addObject:data];
    }
    //session
    NSMutableArray *sessions = [datas objectAtIndex:2];
    for(NSDictionary *nsdG in sessions){
        Sessiondata *data = [[Sessiondata alloc]init];
        [data setData:nsdG];
        data.sectNo = m_sect;
        data.session = m_session;
        [sessionList addObject:data];
    }
    
    [m_dbMng addList:gatherList type:0];
    [m_dbMng addList:sessionList type:1];
    [m_dbMng addList:monthList type:2];
    
    if (1 == m_type) { //分期
        for (Sessiondata *data in sessionList) {
            VxgCellData *cellData = [[VxgCellData alloc]init];
            cellData.name = data.name;
            cellData.value = data.value1;
            [m_tbArray addObject:cellData];
        }
    }else{//分月
        for (Monthdata *data in monthList) {
            VxgCellData *cellData = [[VxgCellData alloc]init];
            cellData.name = data.name;
            cellData.value = data.value1;
            [m_tbArray addObject:cellData];
        }
    }
    [self setCell:m_tbArray];
}

- (void)setCell:(NSMutableArray *)datas{
    m_tbArray = datas;
    [_tableView reloadData];
    
    [self initUUChartData];
}

#pragma mark - UUChart

- (void)initUUChartData{
    
    m_maxValue = 0.0f;
    m_colors = [[NSMutableArray alloc]init];
    if (m_colorLabels==nil) {
        m_colorLabels = [[NSMutableArray alloc]init];
    }
    
    [m_yBarValues removeAllObjects];
    [m_xLabelName removeAllObjects];
    //    [m_xLabelName addObject:[NSString stringWithFormat:@"%@第%@期",m_sectName,m_session]];
    NSMutableArray *array = [[NSMutableArray alloc]init];
    int k = 0;
    for(VxgCellData *data in m_tbArray){
        [m_xLabelName addObject:data.name];
        [array addObject:data.value];
        [m_colorLabels addObject:[data.name stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]];
        [m_colors addObject:[VXG_COLORS_ARRAY objectAtIndex:k % 17]];
        m_maxValue = ([data.value floatValue] < m_maxValue) ? m_maxValue : [data.value floatValue];
        k++;
    }
    [m_yBarValues addObject:array];
    [self configUUChartUI:k];
}

- (void)configUUChartUI:(NSInteger)num{
    
    if (m_chartView) {
        [m_chartView removeFromSuperview];
        m_chartView = nil;
    }
    
    CGFloat screenH = [UIScreen mainScreen].bounds.size.height;
    CGFloat chartViewHeight = screenH*0.4f - 20;
    m_chartView = [[UUChart alloc]initwithUUChartDataFrame:CGRectMake(5, ATIDE_TITLE_VIEW_HEIGHT+ATIDE_DESC_VIEW_HEIGHT, [UIScreen mainScreen].bounds.size.width-20, chartViewHeight)
                                                withSource:self
                                                 withStyle:UUChartBarStyle];
    if (1 == m_type) {
        m_chartView.itemSepWidth = 25 ;
    }else{
        m_chartView.itemSepWidth = 40 ;
    }
    
    [m_chartView setBarNum:1];
    [m_chartView setYBarLabelWidth:50.0f];
    [m_chartView showInView:self.view];
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, chartViewHeight + ATIDE_TITLE_VIEW_HEIGHT +ATIDE_DESC_VIEW_HEIGHT, [[UIScreen mainScreen]bounds].size.width, 1)];
    view.backgroundColor = VXG_COLOR_77A2D2_GRAYBLUE;
    [self.view addSubview:view];
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

#pragma mark tableview
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
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
    }
    VxgCellData *data = [m_tbArray objectAtIndex:[indexPath row]];
    cell.textLabel.font = [UIFont systemFontOfSize:11.0f];
    cell.textLabel.text = data.name;
    cell.detailTextLabel.textColor = VXG_COLOR_77A2D2_GRAYBLUE;
    cell.detailTextLabel.text = data.value;
    cell.detailTextLabel.font = [UIFont systemFontOfSize:11.0f];
    return cell;
}

#pragma mark - params
-(void)setItemMonthParams:(NSDictionary *)nsd{
    
    m_type = [(NSString *)[nsd objectForKey:@"type"]intValue];
    m_sect = (NSString *)[nsd objectForKey:@"sect"];
    m_session = (NSString *)[nsd objectForKey:@"session"];
    m_sectName = (NSString *)[nsd objectForKey:@"name"];
    if (1 == m_type) {
        m_itemDesc = @"计量支付统计图（分期）";
    }else{
        m_itemDesc = @"计量支付统计图（分月）";
    }
}

#pragma mark - 点击事件
- (void)rightButtonClicked {
    SelectSectTenderController *nextView = [m_story instantiateViewControllerWithIdentifier:@"selectSectTender"];
    nextView.delegate = self;
    [self.navigationController pushViewController:nextView animated:YES];
}

#pragma mark sectDelegate
-(void)getSect:(SectModel *)data{
    m_sect = data.sectNo ;
    m_session = data.sessionCode;
    
    m_title = [NSString stringWithFormat:@"%@第%@期",data.sectName,m_session];
    [self initData];
}

@end
