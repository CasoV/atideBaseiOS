//
//  ProjectOutlineController.m
//  PMPlatform_IOS
//
//  Created by vxg on 2017/09/05.
//  Copyright © 2017年 com.atide. All rights reserved.
//

#import "ProjectOutlineController.h"
#import "SearchBarView.h"
#import <Charts/Charts-Swift.h>
#import "SysConfig.h"
#import "ProjectInfo.h"
#import "ProjectProgressController.h"

@interface ProjectOutlineController ()<JSDropDownMenuDelegate, JSDropDownMenuDataSource>{
    JSDropDownMenu *menu;
    UIView *top;
    UIView *tip;
    UIView *bottom;
    SearchBarView *searchView;
}

@end

@implementation ProjectOutlineController
static NSString *tipTxt = @"选择项目";
- (void)viewDidLoad {
    [super viewDidLoad];
    self.projectDataSource = [[NSMutableArray alloc] init];
    [self initHeaderView];
    [self initSearchBarView];
    [self initTopDataView];
    [self initBottomTip];
    [self initBottomDataView];
    [self adjustView];
     self.tabBarController.navigationItem.title = @"项目概况";
}
- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    //[self adjustView];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    self.navigationController.navigationBar.hidden = NO;
    self.tabBarController.tabBarController.tabBar.hidden = YES;
}

- (void)initHeaderView {
    menu = [[JSDropDownMenu alloc] initWithOrigin:CGPointMake(0, 0) width:ScreenWidth andHeight:40];
    menu.indicatorColor = [UIColor colorWithRed:175.0f/255.0f green:175.0f/255.0f blue:175.0f/255.0f alpha:1.0];
    menu.separatorColor = [UIColor colorWithRed:210.0f/255.0f green:210.0f/255.0f blue:210.0f/255.0f alpha:1.0];
    menu.textColor = [UIColor colorWithRed:83.f/255.0f green:83.f/255.0f blue:83.f/255.0f alpha:1.0f];
    menu.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self.contentView addSubview:menu];
    
}
- (void)initSearchBarView {
    searchView = [[SearchBarView alloc] initWithFrame:CGRectMake(0, 40, ScreenWidth, 40) controller:self block:^{
        [self refresh];
    }];
    searchView.sectIsHidden = [self sectIsHidden];
    searchView.backgroundColor = [UIColor hex:@"e8edf3"];
    
    
    [self.contentView addSubview:searchView];
}

- (void)initTopDataView{
    top = [[UIView alloc] init];
    top.translatesAutoresizingMaskIntoConstraints = NO;
    [self.contentView addSubview:top];
    UIView *topView = [self topView];
    if (topView) {
        [top addSubview:topView];
        if ([topView isKindOfClass:[HorizontalBarChartView class]]) {
            [self addConstraint:top subView:topView top:5 bottom:-5 left:5 right:-10];
        }else{
            [self addConstraint:top subView:topView top:0 bottom:0 left:0 right:0];
        }
    }
}
- (void)initBottomTip{
    tip = [[UIView alloc] init];
    tip.translatesAutoresizingMaskIntoConstraints = NO;
    tip.backgroundColor = [UIColor hex:@"adbfd9"];
    [self.contentView addSubview:tip];
    UILabel *label = [[UILabel alloc] init];
    label.text = [self bottomTip];
    label.textColor = [UIColor whiteColor];
    [tip addSubview:label];
    [self addConstraint:tip subView:label top:0 bottom:0 left:10 right:0];
}
- (void)initBottomDataView{
    bottom = [[UIView alloc] init];
    bottom.translatesAutoresizingMaskIntoConstraints = NO;
    [self.contentView addSubview:bottom];
    UIView *bottomView = [self bottomView];
    if (bottomView) {
        [bottom addSubview:bottomView];
        if ([bottomView isKindOfClass:[HorizontalBarChartView class]]) {
            [self addConstraint:bottom subView:bottomView top:5 bottom:-5 left:5 right:-5];
        }else{
            [self addConstraint:bottom subView:bottomView top:0 bottom:0 left:0 right:0];
        }
        
    }
    
    
}
- (void)adjustView{
    NSLayoutConstraint *top1 = [NSLayoutConstraint constraintWithItem:top attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeTop multiplier:1 constant:80];
    NSLayoutConstraint *left1 = [NSLayoutConstraint constraintWithItem:top attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeLeft multiplier:1 constant:0];
    NSLayoutConstraint *right1 = [NSLayoutConstraint constraintWithItem:top attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeRight multiplier:1 constant:0];
    
    
    NSLayoutConstraint *top2 = [NSLayoutConstraint constraintWithItem:tip attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:top attribute:NSLayoutAttributeBottom multiplier:1 constant:0];
    NSLayoutConstraint *left2 = [NSLayoutConstraint constraintWithItem:tip attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeLeft multiplier:1 constant:0];
    NSLayoutConstraint *right2 = [NSLayoutConstraint constraintWithItem:tip attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeRight multiplier:1 constant:0];
    NSLayoutConstraint *height2 = [NSLayoutConstraint constraintWithItem:tip attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:40];
    
    
    NSLayoutConstraint *top3 = [NSLayoutConstraint constraintWithItem:bottom attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:tip attribute:NSLayoutAttributeBottom multiplier:1 constant:0];
    NSLayoutConstraint *left3 = [NSLayoutConstraint constraintWithItem:bottom attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeLeft multiplier:1 constant:0];
    NSLayoutConstraint *right3 = [NSLayoutConstraint constraintWithItem:bottom attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeRight multiplier:1 constant:0];
    NSLayoutConstraint *bottom3 = [NSLayoutConstraint constraintWithItem:bottom attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeBottom multiplier:1 constant:0];
    NSLayoutConstraint *height3 = [NSLayoutConstraint constraintWithItem:bottom attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:top attribute:NSLayoutAttributeHeight multiplier:1 constant:0];
    
    [self.contentView addConstraints:[NSArray arrayWithObjects:left1,top1,right1,top2,left2,right2,height2,top3,left3,right3,height3,bottom3,nil, nil]];
}

- (NSString *)bottomTip{
    return @"项目汇总";
}
#pragma 底部view初始化
- (UIView *)topView{
    return nil;
}
#pragma 底部view初始化
- (UIView *)bottomView{
    return nil;
}
- (void)addConstraint:(UIView *)view subView:(UIView *)subView top:(NSInteger)top bottom:(NSInteger)bottom left:(NSInteger)left right:(NSInteger)right{
    subView.translatesAutoresizingMaskIntoConstraints = NO;
    NSLayoutConstraint *top1 = [NSLayoutConstraint constraintWithItem:subView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeTop multiplier:1 constant:top];
    NSLayoutConstraint *left1 = [NSLayoutConstraint constraintWithItem:subView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeLeft multiplier:1 constant:left];
    NSLayoutConstraint *right1 = [NSLayoutConstraint constraintWithItem:subView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeRight multiplier:1 constant:right];
    NSLayoutConstraint *bottom1 = [NSLayoutConstraint constraintWithItem:subView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeBottom multiplier:1 constant:bottom];
    [view addConstraints:[NSArray arrayWithObjects:top1,left1,right1,bottom1,nil, nil]];
}
- (void)initProjects{
    [self.projectDataSource removeAllObjects];
    for (ProjectInfo *info in [SysConfig getInstance].projectInfos) {
        [self.projectDataSource addObject:info.prjname];
    }
    [self refresh];
}

- (void)refresh{
    menu.dataSource = self;
    menu.delegate = self;
    
}
- (BOOL)sectIsHidden{
    return true;
}

- (NSString *)time{
    return searchView.time;
}
- (NSArray *)sects{
    return searchView.sects;
}

//MARK: JSDropDownMenuDelegate, JSDropDownMenuDataSource

- (NSInteger)numberOfColumnsInMenu:(JSDropDownMenu *)menu {
    
    return 1;
}

-(BOOL)haveRightTableViewInColumn:(NSInteger)column{
    return NO;
}

-(CGFloat)widthRatioOfLeftColumn:(NSInteger)column{
    return 1;
}

-(NSInteger)currentLeftSelectedRow:(NSInteger)column{
    return self._currentData1Index;
    
}

- (NSInteger)menu:(JSDropDownMenu *)menu numberOfRowsInColumn:(NSInteger)column leftOrRight:(NSInteger)leftOrRight leftRow:(NSInteger)leftRow{
    
    return self.projectDataSource.count;
}

- (NSString *)menu:(JSDropDownMenu *)menu titleForColumn:(NSInteger)column{
    
    return self.projectDataSource[self._currentData1Index];
}

- (NSString *)menu:(JSDropDownMenu *)menu titleForRowAtIndexPath:(JSIndexPath *)indexPath {
    
    return self.projectDataSource[indexPath.row];
}

- (void)menu:(JSDropDownMenu *)menu didSelectRowAtIndexPath:(JSIndexPath *)indexPath {
    //self._currentData1Index = indexPath.row;
    ProjectInfo *info = [SysConfig getInstance].projectInfos[indexPath.row];
    [SysConfig getInstance].projectId = info.prjid;
    
    for (ProjectOutlineController *controller in self.tabBarController.viewControllers) {
        controller._currentData1Index = indexPath.row;
        
        if (controller.isViewLoaded) {
            [controller reset];
            [controller refresh];
        }
        
    }
    
}
- (void)reset{
    [searchView reset];
}
@end
