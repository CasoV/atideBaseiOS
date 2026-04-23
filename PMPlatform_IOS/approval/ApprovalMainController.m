//
//  ApprovalMainController.m
//  PMPlatform_IOS
//
//  Created by 末末班车 on 2017/10/10.
//  Copyright © 2017年 com.atide. All rights reserved.
//

#import "ApprovalMainController.h"
#import "ApprovalMidMeasureController.h"
#import "TunnelPileFoundationController.h"
#import "ChangeWasteDisposalController.h"
#import "SupervisionController.h"
#import "ZQZFController.h"
#import "MeteringCell.h"
#import "StringUtils.h"
#import "VxgUIUtils.h"
#import "SectModel.h"

#define  DIC_EXPANDED @"expanded" //是否是展开 0收缩 1展开
#define  DIC_ARARRY @"array"
#define  DIC_TITILESTRING @"title"

#define  CELL_HEIGHT 48.0f

@interface ApprovalMainController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation ApprovalMainController {
    NSString                *m_sect;
    NSString                *m_session;
    NSString                *m_sectName;
    NSMutableDictionary     *m_showDic;
    NSMutableArray          *m_sectSessions;
    
    NSMutableArray *tbArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    tbArray=[[NSMutableArray alloc]init];
    _tableView.tableFooterView = [[UIView alloc]init];
    [_tableView registerNib:[UINib nibWithNibName:@"MeteringCell" bundle:nil] forCellReuseIdentifier:@"meteringCell"];
    
    [self initDataSource];
    [self initSectData];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    self.navigationController.navigationBar.hidden = NO;
    self.tabBarController.tabBar.hidden = YES;
}

- (void)initDataSource
{
    NSMutableArray *array=[[NSMutableArray alloc]init];
    NSString *string=@"中间计量表";
    [array addObject:string];
    string=@"中期支付";
    [array addObject:string];
    string=@"变更/废置处理";
    [array addObject:string];
    string=@"    计量审核";
    
    NSMutableDictionary *dic=[[NSMutableDictionary alloc]initWithObjectsAndKeys:array,DIC_ARARRY,string,DIC_TITILESTRING,[NSNumber numberWithInt:0],DIC_EXPANDED,nil];
    [tbArray addObject:dic];
    
    array=[[NSMutableArray alloc]init];
    string=@"第三方试验检测费用支付";
    [array addObject:string];
    string=@"隧道检测费用支付";
    [array addObject:string];
    string=@"桩基检测费用支付";
    [array addObject:string];
    string=@"    其他费用支付";
    
    dic=[[NSMutableDictionary alloc]initWithObjectsAndKeys:array,DIC_ARARRY,string,DIC_TITILESTRING,[NSNumber numberWithInt:0],DIC_EXPANDED,nil];
    [tbArray addObject:dic];
    
    array=[[NSMutableArray alloc]init];
    string=@"    监理费用支付";
    
    dic=[[NSMutableDictionary alloc]initWithObjectsAndKeys:array,DIC_ARARRY,string,DIC_TITILESTRING,[NSNumber numberWithInt:0],DIC_EXPANDED,nil];
    //将字典加入数组
    [tbArray addObject:dic];
    
}

- (void)initSectData{
    
    [[HttpManager manager] paramsGet:[UrlConfig MeteringURL:getAvaliableByUser] param:@{@"BussinessFlag":@"1",
                                                                                        @"ChildBussinessFlag":@"1",
                                                                                        @"UserCode":[UserInfo getInstance].code
                                                                                        }
                             success:^(NSData *data) {
                                 if ([ResponseUtils success:data]) {
                                     NSMutableArray *dataArray  = [SectModel mj_objectArrayWithKeyValuesArray:[[ResponseUtils getData:@"data"] objectForKey:@"rows"]];
                                     
                                     if (dataArray!=nil && dataArray.count>0) {
                                         SectModel *sectData = dataArray[dataArray.count - 1];
                                         m_sect = [NSString stringWithFormat:@"%@",sectData.sectNo];
                                         //sectData.sectNo;
                                         m_session = [NSString stringWithFormat:@"%@",sectData.sessionCode];
                                         //m_session = sectData.sessionCode;
                                         m_sectName = [NSString stringWithFormat:@"%@",sectData.sectName];
                                         // m_sectName = sectData.sectName;
                                         
                                         m_sectSessions = [StringUtils VxgGetSectNewstSession:dataArray];
                                     }
                                     
                                 }
                             }
                               faild:^(NSString *msg) {
                                   [MBManager showBriefAlert:msg];
                               }];
    
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return tbArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSMutableDictionary *dic=[tbArray objectAtIndex:section];
    NSArray *array=[dic objectForKey:DIC_ARARRY];
    
    if ( [m_showDic objectForKey:[dic objectForKey:@"title"]]) {
        return array.count;
    }else{
        return 0;
    }
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MeteringCell *cell = [tableView dequeueReusableCellWithIdentifier:@"meteringCell" forIndexPath:indexPath];
    NSArray *array=[[tbArray objectAtIndex:indexPath.section] objectForKey:DIC_ARARRY];
    cell.label.text=[array objectAtIndex:indexPath.row];
    return cell;
}

//设置分组头的视图
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    UIView *hView = [[UIView alloc]initWithFrame:CGRectMake(0,0,MAIN_SCREEN_WIDTH, CELL_HEIGHT)];
    hView.backgroundColor=[UIColor whiteColor];
    UIButton* eButton = [[UIButton alloc]init];
    //按钮填充整个视图
    eButton.frame = hView.frame;
    [eButton addTarget:self action:@selector(expandButtonClicked:)
      forControlEvents:UIControlEventTouchUpInside];
    
    hView = [VxgUIUtils s_create_header_view:tbArray view:hView eButton:eButton section:section isExpanded:[self isExpanded:section]];
    
    return hView;
}
//单元行内容递进
- (NSInteger)tableView:(UITableView *)tableView indentationLevelForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 2;
    //    return 0;
}
//控制表头分组表头高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return CELL_HEIGHT;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UIViewController *nextView = nil;
    NSInteger row = [indexPath row];
    NSInteger section = [indexPath section];
    NSString *type = [NSString stringWithFormat:@"%ld",(long)row];
    
    if ((m_sect == nil || m_sect.length < 1)
        || (m_sectName == nil || m_sectName.length < 1)
        || (m_session == nil || m_session.length < 1)){
        [self showAlert:@"暂时没有数据，请联系项目管理员或稍候再试。"];
        return;
    }
    
    NSDictionary *param = [[NSDictionary alloc]initWithObjectsAndKeys:m_sectName,@"name",m_sect,@"sect",m_session,@"session",type,@"type", nil];
    
    if ( 0 == section ) {
        if ( 0 == row ) {//中间计量
            if (![self authorityJudgment:@"中间计量表"]) {
                [self showAlert:@"非常抱歉，您无权限查看该内容。"];
                return;
            }
            
            ApprovalMidMeasureController *view = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"approvalMidMeasure"];
            [view setApprovalMidMeasureParams:param];
            nextView = view;
        } else if( 1 == row ){//中期支付
            if (![self authorityJudgment:@"中期支付报表"]) {
                [self showAlert:@"非常抱歉，您无权限查看该内容。"];
                return;
            }
            ZQZFController *view = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"zqzf"];
            nextView = view;
        } else if (2 == row) {//变更废置
            if (![self authorityJudgment:@"审核"]) {
                [self showAlert:@"非常抱歉，您无权限查看该内容。"];
                return;
            }
            
            ChangeWasteDisposalController *view = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"changeWasteDisposal"];
            nextView = view;
        }
    } else if (section == 1) {
        if (row == 0) {//第三方试验检测费用支付
            if (![self authorityJudgment:@"第三方试验检测费用支付"]) {
                [self showAlert:@"非常抱歉，您无权限查看该内容。"];
                return;
            }
        } else if (row == 1) {//隧道检测费用支付
            if (![self authorityJudgment:@"隧道检测费用支付"]) {
                [self showAlert:@"非常抱歉，您无权限查看该内容。"];
                return;
            }

        } else if (row == 2) {//桩基检测费用支付
            if (![self authorityJudgment:@"桩基检测费用支付"]) {
                [self showAlert:@"非常抱歉，您无权限查看该内容。"];
                return;
            }
        }
        
        TunnelPileFoundationController *view = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"tunnelPileFoundation"];
        [view setTunnelPileFoundationParams:param];
        nextView = view;
    }
    
    if (nil != nextView) {
        [self.navigationController pushViewController:nextView animated:YES];
    }
    
}

#pragma mark -- 内部调用
//对指定的节进行“展开/折叠”操作,若原来是折叠的则展开，若原来是展开的则折叠
-(void)collapseOrExpand:(NSInteger)section{
    if (section == 2) {
        if (![self authorityJudgment:@"监理费用支付"]) {
            [self showAlert:@"非常抱歉，您无权限查看该内容。"];
            return;
        }
        SupervisionController *vc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"supervision"];
        [self.navigationController pushViewController:vc animated:YES];
        return;
    }
    NSMutableDictionary *dic=[tbArray objectAtIndex:section];
    
    if (!m_showDic) {
        m_showDic = [[NSMutableDictionary alloc]init];
    }
    
    NSString *key = [dic objectForKey:@"title"];
    
    if (![m_showDic objectForKey:key]) {
        [m_showDic removeAllObjects];
        [m_showDic setObject:@"1" forKey:key];
        
    }else{
        [m_showDic removeObjectForKey:key];
    }
}
//返回指定节是否是展开的
-(NSInteger)isExpanded:(NSInteger)section{
    NSDictionary *dic=[tbArray objectAtIndex:section];
    int expanded=[[m_showDic objectForKey:[dic objectForKey:@"title"]]intValue];
    return expanded;
}

//按钮被点击时触发
-(void)expandButtonClicked:(id)sender{
    
    UIButton* btn= (UIButton*)sender;
    NSInteger section= btn.tag;//取得tag知道点击对应哪个块
    
    [self collapseOrExpand:section];
    
    //刷新tableview
    [_tableView reloadData];
    
}

#pragma mark - 权限判断
- (BOOL)authorityJudgment:(NSString *)str {
    NSString *userFunc = [UserInfo getInstance].userFunc;
    if (userFunc == nil || [userFunc isEqualToString:@""]) {
        return NO;
    }
    
    BOOL authority = NO;
    for (NSString *item in [userFunc componentsSeparatedByString:@","]) {
        if ([item isEqualToString:str]) {
            authority = YES;
        }
    }
    
    return authority;
}

#pragma mark - 弹出提示框
- (void)showAlert:(NSString *)str {
    //初始化提示框；
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:str preferredStyle: UIAlertControllerStyleAlert];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //点击按钮的响应事件；
    }]];
    
    //弹出提示框；
    [self presentViewController:alert animated:true completion:nil];
}

@end
