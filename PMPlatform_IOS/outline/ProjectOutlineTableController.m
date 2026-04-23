//
//  ProjectOutlineTableController.m
//  PMPlatform_IOS
//
//  Created by vxg on 2017/11/30.
//  Copyright © 2017年 com.atide. All rights reserved.
//

#import "ProjectOutlineTableController.h"
#import "JSDropDownMenu.h"
#import "SearchBarView.h"
#import "ProjectInfo.h"
#import "SysConfig.h"

@interface ProjectOutlineTableController ()<JSDropDownMenuDelegate, JSDropDownMenuDataSource>{
    JSDropDownMenu *menu;
    UIView *top;
    UIView *tip;
    UIView *bottom;
    SearchBarView *searchView;
}

@end

@implementation ProjectOutlineTableController

static NSString *tipTxt = @"选择项目";
- (void)viewDidLoad {
    [super viewDidLoad];
    self.projectDataSource = [[NSMutableArray alloc] init];
    [self initHeaderView];
    [self initSearchBarView];
    [self addChildView];
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
    if (self.sectIsHidden) {
        return;
    }
    searchView = [[SearchBarView alloc] initWithFrame:CGRectMake(0, 40, ScreenWidth, 40) controller:self block:^{
        [self refresh:NO];
    }];
    searchView.sectIsHidden = [self sectIsHidden];
    searchView.backgroundColor = [UIColor hex:@"e8edf3"];
    
    
    [self.contentView addSubview:searchView];
}

- (UIView *)childView{
    return [[UIView alloc] init];
}
- (void)addChildView{
    UIView *child = self.childView;
    [self.contentView addSubview:child];
    if (self.sectIsHidden) {
        [self addConstraint:self.contentView subView:child top:40 bottom:0 left:0 right:0];
    }else{
       [self addConstraint:self.contentView subView:child top:80 bottom:0 left:0 right:0];
    }
    
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
    [self refresh:YES];
}

- (void)refresh:(BOOL)isrefresh{
    menu.dataSource = self;
    menu.delegate = self;
    
}
- (BOOL)sectIsHidden{
    return true;
}

- (NSString *)time{
    return searchView.time;
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
    [SysConfig getInstance].projectCode = info.prjcode;
    
    for (ProjectOutlineTableController *controller in self.tabBarController.viewControllers) {
        controller._currentData1Index = indexPath.row;
        
        if (controller.isViewLoaded) {
            [controller reset];
            [controller refresh:YES];
        }
        
    }
    
}
- (void)reset{
    if (searchView == nil) {
        return;
    }
    [searchView reset];
}

@end
