//
//  AuditOpinionController.m
//  PMPlatform_IOS
//
//  Created by 末末班车 on 2017/10/17.
//  Copyright © 2017年 com.atide. All rights reserved.
//

#import "AuditOpinionController.h"
#import "MidMeasureDetilFlowInfo.h"
#import "MidMeasureDetilApprovalInfo.h"
#import "SupervisionPayDetailController.h"
#import "MidMeasureDetilAttachment.h"
#import "DLScrollTabbarView.h"
#import "DLCustomSlideView.h"
#import "DLLRUCache.h"

#define ITEM_HEIGHT 40

@interface AuditOpinionController ()<DLCustomSlideViewDelegate>

@property (weak, nonatomic) IBOutlet DLCustomSlideView *slideView;

@end

@implementation AuditOpinionController {
    NSMutableArray  *itemArray_;
    MidMeasureInfo  *m_info;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    DLLRUCache *cache = [[DLLRUCache alloc] initWithCount:2];
    DLScrollTabbarView *tabbar = [[DLScrollTabbarView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, ITEM_HEIGHT)];
    tabbar.tabItemNormalColor = [UIColor blackColor];
    tabbar.tabItemSelectedColor = [UIColor redColor];
    tabbar.tabItemNormalFontSize = 14.0f;
    tabbar.trackColor = [UIColor redColor];
    itemArray_ = [NSMutableArray array];
    NSMutableArray *titles = [[NSMutableArray alloc]initWithObjects:@"查看审核意见",@"流程信息", nil];
    
    if (m_info) {
        if ([m_info.type isEqualToString:ZQZF]) {//中期支付
            titles = [[NSMutableArray alloc]initWithObjects:@"流程信息",@"审核信息", nil];
            self.title = @"审核意见";
        }
        if ([m_info.type isEqualToString:JLFYZF]) {//监理费用支付
            titles = [[NSMutableArray alloc]initWithObjects:@"监理支付情况",@"附件", nil];
            self.title = @"监理费用支付";
        }
    }
    
    for (int i=0; i<titles.count; i++) {
        DLScrollTabbarItem *item = [DLScrollTabbarItem itemWithTitle:[NSString stringWithFormat:@"%@", [titles objectAtIndex:i]] width:ScreenWidth / 2];
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
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, ITEM_HEIGHT, ScreenWidth, 1)];
    line.backgroundColor = [UIColor applicationColor];
    [self.slideView addSubview:line];
}

#pragma mark options
- (void)setParams:(MidMeasureInfo *)info{
    m_info = info;
}

- (NSInteger)numberOfTabsInDLCustomSlideView:(DLCustomSlideView *)sender{
    return itemArray_.count;
}

- (UIViewController *)DLCustomSlideView:(DLCustomSlideView *)sender controllerAt:(NSInteger)index{
    
    UIViewController *ctrl = nil;
    
    if(0 == index){
        MidMeasureDetilApprovalInfo *approvalInfo = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"MidMeasureDetilApprovalInfo"];
        [approvalInfo setParams:m_info];
        ctrl = approvalInfo;
        
        if ([m_info.type isEqualToString:ZQZF]) {
            MidMeasureDetilFlowInfo *flow = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"MidMeasureDetilFlowInfo"];
            [flow setParams:m_info];
            ctrl = flow;
        }
        if ([m_info.type isEqualToString:JLFYZF]) {
            SupervisionPayDetailController *supervisionPayDetail = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"supervisionPayDetail"];
            supervisionPayDetail.sectNo = m_info.sectNo;
            supervisionPayDetail.sessionCode = m_info.sessionCode;
            ctrl = supervisionPayDetail;
        }
    }else if(1 == index){
        MidMeasureDetilFlowInfo *flow = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"MidMeasureDetilFlowInfo"];
        [flow setParams:m_info];
        ctrl = flow;
        
        if ([m_info.type isEqualToString:ZQZF]) {
            MidMeasureDetilApprovalInfo *approvalInfo = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"MidMeasureDetilApprovalInfo"];
            [approvalInfo setParams:m_info];
            ctrl = approvalInfo;
        }
        
        if ([m_info.type isEqualToString:JLFYZF]) {
            MidMeasureDetilAttachment *attachment = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"MidMeasureDetilAttachment"];
            [attachment setParams:m_info bizFlag:BIZFLAG_AFFIX_MIDPAY];
            ctrl = attachment;
        }
    }
    
    return ctrl;
}

@end
