//
//  ApprovalMidMeasureDetailContorller.m
//  PMPlatform_IOS
//
//  Created by 末末班车 on 2017/10/13.
//  Copyright © 2017年 com.atide. All rights reserved.
//

#import "ApprovalMidMeasureDetailContorller.h"

#import "DLCustomSlideView.h"
#import "DLScrollTabbarView.h"
#import "DLLRUCache.h"
#import "MidMeasureDetilBasic.h"
#import "MidMeasureDetilPerformance.h"
#import "MidMeasureDetilFlowInfo.h"
#import "MidMeasureDetilApprovalInfo.h"
#import "MidMeasureDetilAttachment.h"

#define MID_MEASURE_ITEM_HEIGHT 40
#define MID_MEASURE_ITEM_WIDTH 80

@interface ApprovalMidMeasureDetailContorller ()<DLCustomSlideViewDelegate>

@property (weak, nonatomic) IBOutlet DLCustomSlideView *slideView;

@end

@implementation ApprovalMidMeasureDetailContorller {
    NSMutableArray  *itemArray_;
    MidMeasureInfo  *m_info;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO; // 如果你使用了UITabBarController, 系统会自动调整scrollView的inset。加上这个如果出错的话。
    
    // Do any additional setup after loading the view from its nib.
    DLLRUCache *cache = [[DLLRUCache alloc] initWithCount:6];
    DLScrollTabbarView *tabbar = [[DLScrollTabbarView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, MID_MEASURE_ITEM_HEIGHT)];
    tabbar.tabItemNormalColor = [UIColor blackColor];
    tabbar.tabItemSelectedColor = [UIColor redColor];
    tabbar.tabItemNormalFontSize = 14.0f;
    tabbar.trackColor = [UIColor redColor];
    itemArray_ = [NSMutableArray array];
    NSMutableArray *titles = [[NSMutableArray alloc]initWithObjects:@"基本信息",@"完成情况",@"流程信息",@"审核信息",@"附件", nil];
    
    for (int i=0; i<titles.count; i++) {
        DLScrollTabbarItem *item = [DLScrollTabbarItem itemWithTitle:[NSString stringWithFormat:@"%@", [titles objectAtIndex:i]] width:MID_MEASURE_ITEM_WIDTH];
        [itemArray_ addObject:item];
    }
    tabbar.tabbarItems = itemArray_;
    
    self.slideView.tabbar = tabbar;
    self.slideView.cache = cache;
    self.slideView.tabbarBottomSpacing = 1;
    self.slideView.baseViewController = self;
    self.slideView.delegate = self;
    [self.slideView setup];
    self.slideView.selectedIndex = 0;
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, MID_MEASURE_ITEM_HEIGHT, ScreenWidth, 1)];
    line.backgroundColor = [UIColor applicationColor];
    [self.slideView addSubview:line];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark options
- (void)setApprovalMidMeasureDetailParams:(MidMeasureInfo *)info{
    m_info = info;
}

- (NSInteger)numberOfTabsInDLCustomSlideView:(DLCustomSlideView *)sender{
    return itemArray_.count;
}

- (UIViewController *)DLCustomSlideView:(DLCustomSlideView *)sender controllerAt:(NSInteger)index{
    
    UIViewController *ctrl = nil;
    
    if(0==index){
        MidMeasureDetilBasic *basic = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"MidMeasureDetilBasic"];
        [basic setParams:m_info];
        ctrl = basic;
        
    }else if(1==index){
        MidMeasureDetilPerformance *performance = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"MidMeasureDetilPerformance"];
        [performance setPerformanceParams:m_info];
        ctrl = performance;
        
    }else if(2==index){
        MidMeasureDetilFlowInfo *flow = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"MidMeasureDetilFlowInfo"];
        [flow setParams:m_info];
        ctrl = flow;
        
    }else if(3==index){
        MidMeasureDetilApprovalInfo *approvalInfo = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"MidMeasureDetilApprovalInfo"];
        [approvalInfo setParams:m_info];
        ctrl = approvalInfo;
        
    }else if(4==index){
        MidMeasureDetilAttachment *attachment = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"MidMeasureDetilAttachment"];
        [attachment setParams:m_info bizFlag:BIZFLAG_AFFIX_MIDPAY];
        ctrl = attachment;
    }
    
    return ctrl;
}

@end
