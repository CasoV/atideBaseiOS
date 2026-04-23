//
//  ApprovalMidMeasureController.m
//  PMPlatform_IOS
//
//  Created by 末末班车 on 2017/10/12.
//  Copyright © 2017年 com.atide. All rights reserved.
//

#import "ApprovalMidMeasureController.h"

#import "ApprovalMidMeasureDetailContorller.h"
#import "SelectSectTenderController.h"
#import "ApprovalMidMeasureCell.h"
#import "MidMeasureInfo.h"
#import "VxgUIUtils.h"
#import "VxgColor.h"

#define MID_MEASURE_CELL_TITLE_HEIGHT   30
#define MID_MEASURE_CELL_ITEM_HEIGHT    20

@interface ApprovalMidMeasureController ()<SectDelegate,UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UIButton *btnSectSession;
@property (weak, nonatomic) IBOutlet UIButton *btnWaitingApproval;
@property (weak, nonatomic) IBOutlet UIButton *btnOthers;
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UIView *switchBtnsView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UITableView *otherTableView;

@end

@implementation ApprovalMidMeasureController {
    NSInteger           PageNo;
    NSInteger           otherPageNo;
    
    NSInteger           m_approvalType;
    NSString            *m_type;
    NSString            *m_sect;
    NSString            *m_session;
    NSString            *m_sectName;
    UIStoryboard        *m_story;
    NSMutableArray      *m_tbArray;
    NSMutableArray      *m_otbArray;
    NSMutableArray      *m_waitingDatas;
    NSMutableArray      *m_otherDatas;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    m_approvalType = 0 ;//待审核
    
    m_story = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    _switchBtnsView.layer.borderColor = [VXG_COLOR_3f92e9_GRAYBLUE CGColor];
    _switchBtnsView.layer.borderWidth = 1.0f;
    
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    m_tbArray = [[NSMutableArray alloc]init];
    m_otbArray = [[NSMutableArray alloc]init];
    m_waitingDatas = [[NSMutableArray alloc]init];
    m_otherDatas = [[NSMutableArray alloc]init];
    
    if (![m_type isEqual:@"0"]) {
        self.title = @"变更/废置处理";
    }
    
    [_btnSectSession setTitle:[NSString stringWithFormat:@"%@第%@期",m_sectName,m_session] forState:UIControlStateNormal];
    __weak typeof(self) weakself = self;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakself refresh:0];
    }];
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [weakself loadMore:0];
    }];
    self.otherTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakself refresh:1];
    }];
    self.otherTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [weakself loadMore:1];
    }];
    
    
    [self initSectData];
}

#pragma mark - datas
- (void)initSectData {
    [[HttpManager manager] paramsGet:[UrlConfig MeteringURL:getAvaliableByUser] param:@{
                                                                                        @"BussinessFlag":@"1",
                                                                                        @"ChildBussinessFlag":@"1",
                                                                                        @"UserCode":[UserInfo getInstance].code
                                                                                        }
                             success:^(NSData *data) {
                                 if ([ResponseUtils success:data]) {
                                     NSMutableArray *arr = [SectModel mj_objectArrayWithKeyValuesArray:[[ResponseUtils getData:@"data"] objectForKey:@"rows"]];
                                     if (arr != nil && arr.count != 0) {
                                         SectModel *model = arr.firstObject;
                                         m_sect = model.sectNo;
                                         m_session = model.sessionCode;
                                         [self.btnSectSession setTitle:[NSString stringWithFormat:@"%@第%@期",model.sectName,m_session] forState:UIControlStateNormal];
                                         [self.tableView.mj_header beginRefreshing];
                                         [self.otherTableView.mj_header beginRefreshing];
                                     } else {
                                         [MBManager showBriefAlert:@"无数据"];
                                     }
                                 } else {
                                     [MBManager showBriefAlert:[ResponseUtils getMsg]];
                                 }
                             } faild:^(NSString *msg) {
                                 [MBManager showBriefAlert:msg];
                             }];
}

- (void)refresh:(NSInteger)order {
    if (order == 1) {
        [self.otherTableView.mj_footer resetNoMoreData];
        otherPageNo = 0;
    } else {
        [self.tableView.mj_footer resetNoMoreData];
        PageNo = 0;
    }
    [self getWebData:order isRefresh:YES];
}

- (void)loadMore:(NSInteger)order {
    if (order == 1) {
        otherPageNo++;
    } else {
        PageNo++;
    }
    [self getWebData:order isRefresh:NO];
}

-(void)getWebData:(NSInteger)order isRefresh:(BOOL)isRefresh {
    UserInfo *userInfo = [UserInfo getInstance];
    
    NSString *method = nil;
    NSInteger page;
    if ( 0 == order ) {//待审核
        page = PageNo;
        method = [UrlConfig MeteringURL:getMidMeaListByCode];
    }else{
        page = otherPageNo;
        method = [UrlConfig MeteringURL:getOtherListByCode];
    }
    
    [[HttpManager manager] paramsGet:method param:@{
                                                    @"SectNo":m_sect,
                                                    @"SessionCode":m_session,
                                                    @"PageNo":@(page),
                                                    @"PageSize":@"10",
                                                    @"UserId":userInfo.ID
                                                    }
                             success:^(NSData *data) {
                                 if (0 == order) {
                                     [self.tableView.mj_header endRefreshing];
                                     [self.tableView.mj_footer endRefreshing];
                                 } else {
                                     [self.otherTableView.mj_header endRefreshing];
                                     [self.otherTableView.mj_footer endRefreshing];
                                 }
                                 if ([ResponseUtils success:data]) {
                                     if ([[ResponseUtils getData:@"data"] isKindOfClass:[NSDictionary class]]) {
                                         NSMutableArray *dataArray = [[ResponseUtils getData:@"data"] objectForKey:@"rows"];
                                         
                                         if (dataArray != nil && dataArray.count > 0) {
                                             if (dataArray.count < 10) {
                                                 if (0 == order) {
                                                     [self.tableView.mj_footer endRefreshingWithNoMoreData];
                                                 } else {
                                                     [self.otherTableView.mj_footer endRefreshingWithNoMoreData];
                                                 }
                                             }
                                             [self setDatas:dataArray type:order isRefresh:isRefresh];
                                         }else {
                                             if (0 == order) {
                                                 [self.tableView.mj_footer endRefreshingWithNoMoreData];
                                             } else {
                                                 [self.otherTableView.mj_footer endRefreshingWithNoMoreData];
                                             }
                                         }
                                     }
                                 } else {
                                     [MBManager showBriefAlert:[ResponseUtils getMsg]];
                                 }
                             } faild:^(NSString *msg) {
                                 if (0 == order) {
                                     [self.tableView.mj_header endRefreshing];
                                     [self.tableView.mj_footer endRefreshing];
                                 } else {
                                     [self.otherTableView.mj_header endRefreshing];
                                     [self.otherTableView.mj_footer endRefreshing];
                                 }
                                 [MBManager showBriefAlert:msg];
                             }];
}

-(void)setDatas:(NSMutableArray *)datas type:(NSInteger)type isRefresh:(BOOL)isRefresh{
    if (isRefresh) {
        if (0 == type) {
            [m_waitingDatas removeAllObjects];
        } else {
            [m_otherDatas removeAllObjects];
        }
    }
    
    for (NSDictionary *nsd in datas) {
        if ( 0 == type) {
            [m_waitingDatas addObject:nsd];
        }else{
            [m_otherDatas addObject:nsd];
        }
    }
    [self setCellData:type];
}

-(void)setCellData:(NSInteger)type{
    if (0 == type) {
        [m_tbArray removeAllObjects];
        for (NSDictionary *nsd in m_waitingDatas) {
            MidMeasureInfo *info = [[MidMeasureInfo alloc]init];
            [info setData:nsd];
            [m_tbArray addObject:info];
        }
        [self.tableView reloadData];
    }else{
        [m_otbArray removeAllObjects];
        for (NSDictionary *nsdOther in m_otherDatas) {
            MidMeasureInfo *info = [[MidMeasureInfo alloc]init];
            [info setData:nsdOther];
            [m_otbArray addObject:info];
        }
        [self.otherTableView reloadData];
    }
}


- (void)setApprovalMidMeasureParams:(NSDictionary *)dic{
    m_type = [dic objectForKey:@"type"];
    m_sect = [dic objectForKey:@"sect"];
    m_session = [dic objectForKey:@"session"];
    m_sectName = [dic objectForKey:@"name"];
}

#pragma mark - 点击事件
- (IBAction)selectSectSession:(id)sender {
    SelectSectTenderController *nextView = [m_story instantiateViewControllerWithIdentifier:@"selectSectTender"];
    nextView.delegate = self;
    [self.navigationController pushViewController:nextView animated:YES];
}

- (IBAction)clickWatingApproval:(id)sender {
    m_approvalType = 0;
    [self changeBtnStyle:0];
    self.tableView.hidden = NO;
    self.otherTableView.hidden = YES;
}

- (IBAction)clickOthers:(id)sender {
    m_approvalType = 1;
    [self changeBtnStyle:1];
    self.tableView.hidden = YES;
    self.otherTableView.hidden = NO;
}

- (void)changeBtnStyle:(NSInteger)type{
    UIColor *colorSelected = VXG_COLOR_3f92e9_GRAYBLUE;
    UIColor *colorUnselected = [UIColor whiteColor];
    if (0 == type) { //待审核
        [_btnWaitingApproval setBackgroundColor:colorSelected];
        [_btnWaitingApproval setTitleColor:colorUnselected forState:UIControlStateNormal];
        [_btnOthers setBackgroundColor:colorUnselected];
        [_btnOthers setTitleColor:VXG_COLOR_999999_GRAY forState:UIControlStateNormal];
    }else{
        [_btnWaitingApproval setBackgroundColor:colorUnselected];
        [_btnWaitingApproval setTitleColor:VXG_COLOR_999999_GRAY forState:UIControlStateNormal];
        [_btnOthers setBackgroundColor:colorSelected];
        [_btnOthers setTitleColor:colorUnselected forState:UIControlStateNormal];
    }
}

#pragma mark - sectDelegate
-(void)getSect:(SectModel *)data{
    m_sect = data.sectNo ;
    m_session = data.sessionCode;
    
    [_btnSectSession setTitle:[NSString stringWithFormat:@"%@第%@期",data.sectName,m_session] forState:UIControlStateNormal];
    [self.tableView.mj_header beginRefreshing];
    [self.otherTableView.mj_header beginRefreshing];
}

#pragma mark table view datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == self.tableView) {
        return m_tbArray.count;
    } else {
        return m_otbArray.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ApprovalMidMeasureCell *cell;
    NSMutableArray *arr;
    NSString *str;
    if (tableView == self.tableView) {
        arr = m_tbArray;
        str = @"审核";
        cell = [tableView dequeueReusableCellWithIdentifier:@"approvalMidMeasureCell" forIndexPath:indexPath];
    } else {
        arr = m_otbArray;
        str = @"查看详情";
        cell = [tableView dequeueReusableCellWithIdentifier:@"approvalMidMeasureCell2" forIndexPath:indexPath];
    }
    
    NSInteger row = [indexPath row];
    MidMeasureInfo *data = [arr objectAtIndex:row];
    
    [VxgUIUtils s_vxg_view_set_corner:cell.view1 cornerRadius:5.0f borderWidth:1.0f borderColor:UUTwitterColor];
    
    [VxgUIUtils s_vxg_view_set_corner:cell.text1 cornerRadius:5.0f borderWidth:1.0f borderColor:[UIColor clearColor]];
    [VxgUIUtils s_vxg_view_set_corner:cell.text8 cornerRadius:5.0f borderWidth:1.0f borderColor:[UIColor clearColor]];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.text1.text = [NSString stringWithFormat:@"%ld.%@",row + 1,data.listName];
    cell.text2.text = [NSString stringWithFormat:@"%@",data.codeNo];
    cell.text3.text = [NSString stringWithFormat:@"%@",data.listCode];
    cell.text4.text = [NSString stringWithFormat:@"%@",data.listName];
    cell.text5.text = [NSString stringWithFormat:@"%@",data.monitPicket];
    cell.text6.text = [NSString stringWithFormat:@"%@",data.compPile];
    cell.text7.text = [NSString stringWithFormat:@"%@",data.compQuantity];
    cell.text8.text = str;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSMutableArray *arr;
    if (tableView == self.tableView) {
        arr = m_tbArray;
    } else {
        arr = m_otbArray;
    }
    ApprovalMidMeasureDetailContorller *nextView = [m_story instantiateViewControllerWithIdentifier:@"approvalMidMeasureDetail"];
    [nextView setApprovalMidMeasureDetailParams:[arr objectAtIndex:[indexPath row]]];
    [self.navigationController pushViewController:nextView animated:YES];
}

- (UIView *)createCellFooter:(CGRect)frame{
    
    UIFont *font = [UIFont systemFontOfSize:10.0f];
    CGFloat width = frame.size.width;
    CGFloat x = 3;
    CGFloat footY = MID_MEASURE_CELL_TITLE_HEIGHT; //frame.size.height - 31;
    CGRect rectFoot = CGRectMake(x, footY, width, MID_MEASURE_CELL_TITLE_HEIGHT);
    UIView *footView = [[UIView alloc]initWithFrame:rectFoot];
    UILabel *action = [[UILabel alloc]initWithFrame:CGRectMake(x, footY, 100, MID_MEASURE_CELL_TITLE_HEIGHT)];
    action.text = @"审核";
    action.font = font;
    action.textColor = [UIColor whiteColor];
    action.backgroundColor = VXG_COLOR_3f92e9_GRAYBLUE;
    action.textAlignment = NSTextAlignmentCenter;
    [VxgUIUtils s_vxg_view_set_corner:action cornerRadius:5.0f borderWidth:1.0f borderColor:[UIColor clearColor]];
    UILabel *narrow = [[UILabel alloc]initWithFrame:CGRectMake(51, footY, width-52, MID_MEASURE_CELL_TITLE_HEIGHT)];
    narrow.text = @">";
    narrow.font = [UIFont systemFontOfSize:13.0f];
    narrow.textColor = VXG_COLOR_3f92e9_GRAYBLUE;
    narrow.textAlignment = NSTextAlignmentRight;
    
    [footView addSubview:action];
    [footView addSubview:narrow];
    
    return footView;
}

- (UIView *)createItem:(UIView*)view frame:(CGRect)frame x:(CGFloat)x y:(CGFloat)y height:(CGFloat)itemHeight{
    
    UIFont *font = [UIFont systemFontOfSize:9.0f];
    CGFloat width = frame.size.width;
    CGRect rect = CGRectMake(x, y, width, itemHeight);
    UIView *item = [[UIView alloc]initWithFrame:rect];
    CGPoint center = view.center;
    center.y = y;
    [item setCenter:center];
    UILabel *name = [[UILabel alloc]initWithFrame:CGRectMake(x, y, 50, itemHeight-1)];
    name.text = @"清单号";
    name.font = font;
    name.textColor = [UIColor blackColor];
    UILabel *value = [[UILabel alloc]initWithFrame:CGRectMake(51, y, width-52, itemHeight-1)];
    value.text = @"ohahaah";
    value.textColor = [UIColor blackColor];
    value.font = font;
    value.textAlignment = NSTextAlignmentRight;
    y = y+itemHeight;
    UIImageView *imgSep = [[UIImageView alloc]initWithFrame:CGRectMake(x,y-1 , width, 1)];
    [imgSep setImage:[UIImage imageNamed:@"login_back_line"]];
    
    [item addSubview:name];
    [item addSubview:value];
    [item addSubview:imgSep];
    
    return item;
}


@end
