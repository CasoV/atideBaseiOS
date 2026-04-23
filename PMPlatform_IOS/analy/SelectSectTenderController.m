//
//  SelectSectTenderController.m
//  PMPlatform_IOS
//
//  Created by 末末班车 on 2017/10/11.
//  Copyright © 2017年 com.atide. All rights reserved.
//

#import "SelectSectTenderController.h"
#import "SelectSectTenderCell.h"
#import "VxgCellData.h"
#import "VxgColor.h"

#define SCREEN_WIDTH [[UIScreen mainScreen]bounds].size.width
#define SCREEN_HEIGHT [[UIScreen mainScreen]bounds].size.height
#define HEADER_HEIGHT 40
#define CELL_HEIGHT 40
#define KEY_SECT_NO @"sectNo"

@interface SelectSectTenderController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation SelectSectTenderController {
    UserInfo                *m_userInfo;
    NSInteger               m_groupSection;
    NSMutableArray          *m_tbArray;
    NSMutableArray          *m_group;
    NSMutableArray          *m_child;
    NSMutableDictionary     *m_showDic;//用来判断分组展开与收缩的
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if (!self.childBussinessFlag) {
        self.childBussinessFlag = @"1";
    }
    
    m_groupSection = 0 ;
    m_group = [[NSMutableArray alloc]init];
    m_child = [[NSMutableArray alloc]init];
    m_userInfo = [UserInfo getInstance];
    m_tbArray = [[NSMutableArray alloc]init];
    self.tableView.separatorStyle = NO;
    self.tableView.tableFooterView = [[UIView alloc]init];
    [self initData];
}

- (void) initData{
    [[HttpManager manager] paramsGet:[UrlConfig MeteringURL:getAvaliableByUser] param:@{@"BussinessFlag":@"1",
                                                                                        @"ChildBussinessFlag":self.childBussinessFlag,
                                                                                        @"UserCode":[UserInfo getInstance].code
                                                                                       }
                             success:^(NSData *data) {
                                 if ([ResponseUtils success:data]) {
                                     [m_tbArray removeAllObjects];
                                     if ([[ResponseUtils getData:@"data"] isKindOfClass:[NSDictionary class]]) {
                                         NSDictionary *data = [ResponseUtils getData:@"data"];
                                         [m_tbArray addObjectsFromArray:[data objectForKey:@"rows"]];
                                         [self setCellData];
                                     }
                                 } else {
                                     [MBManager showBriefAlert:[ResponseUtils getMsg]];
                                 }
                             } faild:^(NSString *msg) {
                                 [MBManager showBriefAlert:msg];
                             }];
}

- (void)setCellData{
    [m_group removeAllObjects];
    [m_child removeAllObjects];
    NSMutableArray *sectSessions = [[NSMutableArray alloc]init];
    for (NSDictionary *nsd in m_tbArray ) {
        SectModel *sectData = [[SectModel alloc]init];
        [sectData setData:nsd];
        [sectSessions addObject:sectData];
    }
    
    //获取不重复的作为group
    for (SectModel *sect in sectSessions) {
        if (![m_group containsObject:sect.sectName]) {
            [m_group addObject:sect.sectName];
        }
    }
    
    //添加session数据
    for(NSString *sectName in m_group){
        NSMutableArray *child = [[NSMutableArray alloc]init];
        for (SectModel *sect in sectSessions) {
            if ([sectName isEqualToString:sect.sectName]) {
                [child addObject:sect];
            }
        }
        [m_child addObject:child];
    }
    
    [self.tableView reloadData];
}

#pragma mark - <UITableViewDelegate, UITableViewDataSource>
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return m_group.count;
}

//每组的个数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section+1 > m_child.count) {
        return 0 ;
    }
    
    NSMutableArray * child = [m_child objectAtIndex:section];
    return child.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SelectSectTenderCell *cell = [tableView dequeueReusableCellWithIdentifier:@"selectSectTenderCell" forIndexPath:indexPath];
    cell.separatorInset=UIEdgeInsetsZero;
    cell.clipsToBounds = YES;
    
    NSMutableArray *rowArray = [m_child objectAtIndex:indexPath.section];
    SectModel *data = rowArray[indexPath.row];
    NSString *session = [NSString stringWithFormat:@"第%@期",data.sessionCode];
    cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame];
    cell.selectedBackgroundView.backgroundColor = VXG_COLOR_ABC0DA_GRAYBLUE;
    cell.labelSect.text = session;
    
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
    NSMutableArray *child = [m_child objectAtIndex:section];
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
    [btn setTitle:m_group[section] forState:UIControlStateNormal];
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
        m_groupSection = indexPath.section;
        return CELL_HEIGHT;
    }
    
    return 0;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSMutableArray *childs = [m_child objectAtIndex:m_groupSection];
    SectModel *sectData = [childs objectAtIndex:[indexPath row]];
    [self.delegate getSect:sectData];
    [self.navigationController popViewControllerAnimated:YES];
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

@end
