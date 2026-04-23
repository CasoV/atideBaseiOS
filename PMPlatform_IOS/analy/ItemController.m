//
//  ItemController.m
//  PMPlatform_IOS
//
//  Created by 末末班车 on 2017/10/11.
//  Copyright © 2017年 com.atide. All rights reserved.
//

#import "ItemController.h"
#import "AnalyItemCell.h"
#import "VxgUIUtils.h"
#import "VxgCellData.h"
#import "JYAnalyData.h"
#import "SectModel.h"
#import "UUChart.h"
#import "JYAnalyDatabaseMng.h"
#import "SelectSectTenderController.h"


#define JYITEM_DESC_VIEW_HEIGHT     30
#define JYITEM_CHART_VIEW_HEIGHT    350
#define JYITEM_SCRREN_WIDTH         [[UIScreen mainScreen]bounds].size.width
#define JYITEM_SCRREN_HEIGHT        [[UIScreen mainScreen]bounds].size.height
#define JYITEM_CHART_VIEW_BAR_NUM   2

@interface ItemController ()<UUChartDataSource, SectDelegate>

@property (weak, nonatomic) IBOutlet UILabel *itemDesc;
@property (weak, nonatomic) IBOutlet UIView *quanlityItem;
@property (weak, nonatomic) IBOutlet UIView *chartView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation ItemController {
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
    m_type = 0 ;
    m_userInfo=[UserInfo getInstance];
    m_dbMng = [[JYAnalyDatabaseMng alloc]init];
    m_tbArray = [[NSMutableArray alloc]init];
    m_yBarValues = [[NSMutableArray alloc]init];
    m_xLabelName = [[NSMutableArray alloc]init];
    m_story = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    _itemDesc.text = m_itemDesc ;
    self.title = [NSString stringWithFormat:@"%@第%@期",m_sectName,m_session];
    m_title = self.title;
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
    
    if (0 == m_type) {
        for (Gatherdata *data in gatherList) {
            VxgCellData *cellData = [[VxgCellData alloc]init];
            cellData.name = data.mName;
            cellData.value = data.mHt;
            cellData.remark = data.mJl;
            [m_tbArray addObject:cellData];
        }
        [self setCell:m_tbArray];
    }else{
        [self setCell:monthList];
    }
}


#pragma mark - tableview
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
    VxgCellData *cellData=[m_tbArray objectAtIndex:[indexPath row]];
    AnalyItemCell *cell = [tableView dequeueReusableCellWithIdentifier:@"analyItemCell" forIndexPath:indexPath];
    cell.labelSection.text = cellData.name;
    cell.labelContract.text = cellData.value;
    cell.labelMeasure.text = cellData.remark;
    return cell;


}

- (void)setCell:(NSMutableArray *)datas{
    m_tbArray = datas;
    [_tableView reloadData];
    
    [self initUUChartData];
}

#pragma mark - UUChart

- (void)initUUChartData{
    
    m_maxValue = 0.0f;
    m_colors = [[NSMutableArray alloc]initWithObjects:VXG_COLOR_77A2D2_GRAYBLUE,VXG_COLOR_F08C89_PINK, nil];
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
    CGFloat chartViewHeight = screenH*0.42f - 20 ;
    m_chartView = [[UUChart alloc]initwithUUChartDataFrame:CGRectMake(5, ATIDE_TITLE_VIEW_HEIGHT+ATIDE_DESC_VIEW_HEIGHT, [UIScreen mainScreen].bounds.size.width-20, chartViewHeight)
                                                withSource:self
                                                 withStyle:UUChartBarStyle];
    m_chartView.itemSepWidth = 10 ;
    [m_chartView setBarNum:JYITEM_CHART_VIEW_BAR_NUM];
    [m_chartView setYBarLabelWidth:40.0f];
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

-(void)setItemParams:(NSDictionary *)nsd{
    
    m_type = [[nsd objectForKey:@"type"] integerValue];
    m_sect = (NSString *)[nsd objectForKey:@"sect"];
    m_session = (NSString *)[nsd objectForKey:@"session"];
    m_sectName = (NSString *)[nsd objectForKey:@"name"];
    if (m_type == 0) {
        m_itemDesc = @"计量支付统计图（汇总）";
    }else{
        m_type = 1;
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
