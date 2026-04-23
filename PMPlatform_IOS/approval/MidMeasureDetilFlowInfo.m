//
//  MidMeasureDetilFlowInfo.m
//  TrafficMs
//
//  Created by apple on 2015/11/15.
//  Copyright © 2015年 com. All rights reserved.
//

#import "MidMeasureDetilFlowInfo.h"
#import "SelectSectTenderCell.h"
#import "BussinessFlow.h"
#import "VxgUIUtils.h"
#import "VxgColor.h"

#define HEADER_HEIGHT 40
#define SCREEN_WIDTH [[UIScreen mainScreen]bounds].size.width
#define SCREEN_HEIGHT [[UIScreen mainScreen]bounds].size.height

@interface MidMeasureDetilFlowInfo (){
    NSMutableArray          *m_parents;
    NSMutableArray          *m_childs;
    NSMutableArray          *m_tbArray;
    MidMeasureInfo          *m_info;
    NSMutableDictionary     *m_showDic;
}

@end

@implementation MidMeasureDetilFlowInfo

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    m_parents = [[NSMutableArray alloc]init];
    m_childs = [[NSMutableArray alloc]init];
    m_tbArray = [[NSMutableArray alloc]init];
        
    [self getWebData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)getWebData{
    if(m_info == nil || m_info.flowID == nil || m_info.approvalGrpId == nil
       || m_info.approvalUnitId == nil){
        return;
    }
    
    NSString *method = [UrlConfig MeteringURL:getBussFlowListByCode];
    
    [[HttpManager manager] paramsGet:method param:@{
                                                    @"FlowID":m_info.flowID,
                                                    @"ApprovalGrpID":m_info.approvalGrpId,
                                                    @"ApprovalUnitID":m_info.approvalUnitId,
                                                    @"CurrencyFlag":@"1"
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
    
    [m_parents removeAllObjects];
    [m_childs removeAllObjects];
    [m_tbArray removeAllObjects];
    
    for (NSDictionary *nsd in datas) {
        BussinessFlow *flow = [[BussinessFlow alloc]init];
        [flow setData:nsd];
        [m_tbArray addObject:flow];
    }
    
    for (BussinessFlow *flow in m_tbArray) {
        NSInteger count = m_parents.count;
        if ( count > 0 ) {
            BussinessFlow *parent = [m_parents objectAtIndex:count-1];
            if ( parent!=nil && [parent.unitName isEqualToString:flow.unitName] ) {
                NSMutableArray *tmpChild = [m_childs objectAtIndex:count-1];
                if (tmpChild == nil) {
                    tmpChild = [[NSMutableArray alloc]init];
                }
                [tmpChild addObject:flow];
                [m_childs setObject:tmpChild atIndexedSubscript:count-1];
            }else{
                [m_parents addObject:flow];
                NSMutableArray *tmpList = [[NSMutableArray alloc]init];
                [tmpList addObject:flow];
                [m_childs addObject:tmpList];
            }
        }else{
            [m_parents addObject:flow];
            NSMutableArray *tmpList = [[NSMutableArray alloc]init];
            [tmpList addObject:flow];
            [m_childs addObject:tmpList];
        }
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
    return m_parents.count;
}

//每组的个数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section+1 > m_childs.count) {
        return 0 ;
    }
    
    NSMutableArray * child = [m_childs objectAtIndex:section];
    return child.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SelectSectTenderCell *cell = [tableView dequeueReusableCellWithIdentifier:@"selectSectTenderCell" forIndexPath:indexPath];
    
    cell.separatorInset=UIEdgeInsetsZero;
    cell.clipsToBounds = YES;
    NSMutableArray *rowArray = [m_childs objectAtIndex:indexPath.section];
    BussinessFlow *data = rowArray[indexPath.row];
    cell.labelSect.text = data.cnname;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

//section头部高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return HEADER_HEIGHT;
}

//section头部显示的内容
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView *header = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, HEADER_HEIGHT)];
    header.backgroundColor = [UIColor whiteColor];
    
    CGFloat width = header.frame.size.width * 0.5f;
    CGFloat height = HEADER_HEIGHT*0.4f;
    CGFloat textViewY = HEADER_HEIGHT*0.5-height*0.2;
    CGRect rect = CGRectMake(10, textViewY, height, height);
    UILabel *textView = [[UILabel alloc]initWithFrame:rect];
    NSMutableArray *child = [m_childs objectAtIndex:section];
    textView.text = [NSString stringWithFormat:@"%lu",(unsigned long)child.count];
    textView.textAlignment = NSTextAlignmentCenter;
    textView.backgroundColor = VXG_COLOR_ORANGE_RED;
    textView.textColor = [UIColor whiteColor];
    textView.font = [UIFont systemFontOfSize:8.0f];
    textView.layer.cornerRadius = 3;
    textView.layer.masksToBounds = YES;
    
    CGPoint headerCenter = header.center;
    headerCenter.x = 20;
    [textView setCenter:headerCenter];
    
    
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(header.frame.size.width*0.4f, 0, width, HEADER_HEIGHT)];
    [btn addTarget:self action:@selector(expandButtonClicked:)
  forControlEvents:UIControlEventTouchUpInside];
    btn.tag = section;
    
    //设置图标
    //根据是否展开，切换按钮显示图片
    if ([self isExpanded:section])
        [btn setImage: [UIImage imageNamed:@"an_expand_expand"]forState:UIControlStateNormal];
    else
        [btn setImage: [UIImage imageNamed:@"an_expand_collapse_icon"]forState:UIControlStateNormal];
    
    //设置分组标题
    BussinessFlow *data = m_parents[section];
    [btn setTitle:data.unitName forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blackColor]forState:UIControlStateNormal];
    
    //设置button的图片和标题的相对位置
    //4个参数是到上边界，左边界，下边界，右边界的距离
    btn.contentHorizontalAlignment =UIControlContentHorizontalAlignmentLeft;
    //    [btn setTitleEdgeInsets:UIEdgeInsetsMake(0,0,0,0)];
    [btn setImageEdgeInsets:UIEdgeInsetsMake(4,width-10,0,0)];
    
    btn.titleLabel.font = [UIFont systemFontOfSize:12.0f];
    btn.titleLabel.textColor = [UIColor clearColor];
    
    
    CGRect sepRect = CGRectMake(0, HEADER_HEIGHT-1, [[UIScreen mainScreen]bounds].size.width, 1);
    UIView *sep = [[UIView alloc]initWithFrame:sepRect];
    sep.backgroundColor = VXG_COLOR_77A2D2_GRAYBLUE;
    
    [header addSubview:sep];
    [header addSubview:textView];
    [header addSubview:btn];
    
    return header;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self isExpanded:indexPath.section]) {
//        m_groupSection = indexPath.section;
        return 40;
    }
    
    return 0;
}

#pragma mark 展开收缩section中cell 手势监听

- (Boolean)isExpanded:(NSInteger)section{
    
    if ([m_showDic objectForKey:[NSString stringWithFormat:@"%ld",section]]) {
        return YES;
    }
    return NO;
}

-(void)expandButtonClicked:(id)sender{
    
    UIButton* btn= (UIButton*)sender;
    NSInteger didSection= btn.tag;//取得tag知道点击对应哪个块
    
    //    [self collapseOrExpand:section];
    if (!m_showDic) {
        m_showDic = [[NSMutableDictionary alloc]init];
    }
    
    NSString *key = [NSString stringWithFormat:@"%ld",didSection];
    if (![m_showDic objectForKey:key]) {
        [m_showDic removeAllObjects];
        [m_showDic setObject:@"1" forKey:key];
        
    }else{
        [m_showDic removeObjectForKey:key];
    }
    
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:didSection] withRowAnimation:UITableViewRowAnimationFade];
    
    
    //刷新tableview
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:didSection] withRowAnimation:UITableViewRowAnimationFade];
    
}

-(void)setParams:(MidMeasureInfo *)info{
    m_info = info;
}
@end
