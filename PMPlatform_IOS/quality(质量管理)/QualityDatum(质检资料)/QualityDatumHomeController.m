//
//  QualityDatumHomeController.m
//  ycxm
//
//  Created by 末末班车 on 2018/9/25.
//  Copyright © 2018年 末末班车. All rights reserved.
//

#import "QualityDatumHomeController.h"
#import <PPBadgeView/PPBadgeView.h>
#import "QDTab1Controller.h"
#import "QDTab2Controller.h"
#import "QDTab3Controller.h"

@interface QualityDatumHomeController ()

@property (nonatomic, strong) QDTab1Controller *tab1;
@property (nonatomic, strong) QDTab2Controller *tab2;
@property (nonatomic, strong) QDTab3Controller *tab3;
@property (nonatomic, strong) UIViewController *currentController;
@property (nonatomic, strong) UISegmentedControl *segmentedControl;

@end

@implementation QualityDatumHomeController {
    NSInteger tag;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self createSegMentController];

    [self addChildViewController:self.tab1];
    [self addChildViewController:self.tab2];
    [self addChildViewController:self.tab3];
    _currentController = _tab1;
    [self fitFrameForChildViewController:_tab1];
    [self.view addSubview:_currentController.view];
    [self fetchCount];
}

- (QDTab1Controller *)tab1{
    if (!_tab1) {
        _tab1 = [[QDTab1Controller alloc] initWithNibName:@"QDTab1Controller" bundle:nil];
    }
    return _tab1;
}

- (QDTab2Controller *)tab2{
    __weak __typeof(self) weakself = self;
    if (!_tab2) {
        _tab2 = [[QDTab2Controller alloc] initWithNibName:@"QDTab2Controller" bundle:nil];
        _tab2.block = ^(NSNumber *count) {
            if(count.intValue > 99){
                [weakself.segmentedControl pp_addBadgeWithText:@"99+"];
            }else{
                [weakself.segmentedControl pp_addBadgeWithText:[count stringValue]];
            }
        };
    }
    return _tab2;
}

- (QDTab3Controller *)tab3{
    if (!_tab3) {
        _tab3 = [[QDTab3Controller alloc] initWithNibName:@"QDTab3Controller" bundle:nil];
    }
    return _tab3;
}

//创建导航栏分栏控件
-(void)createSegMentController {
    NSArray *segmentedArray = [NSArray arrayWithObjects:@"质检资料",@"影像资料",@"审核列表",@"当前用户审核",nil];
    
    _segmentedControl = [[UISegmentedControl alloc]initWithItems:segmentedArray];
    
    _segmentedControl.frame = CGRectMake(0, 0, kScreen_Width - 100, 30);
    
    _segmentedControl.selectedSegmentIndex = 0;
    _segmentedControl.tintColor = UIColorTextBlue;
    [_segmentedControl pp_moveBadgeWithX:-10 Y:5];
    
    [_segmentedControl addTarget:self action:@selector(indexDidChangeForSegmentedControl:) forControlEvents:UIControlEventValueChanged];
    
    [self.navigationItem setTitleView:_segmentedControl];
}

-(void)indexDidChangeForSegmentedControl:(UISegmentedControl *)sender {
    __weak typeof(self) weakSelf = self;
    //我定义了一个 NSInteger tag，是为了记录我当前选择的是分段控件的左边还是右边。
    UIViewController *oldController = _currentController;
    tag = sender.selectedSegmentIndex;
    
    if (tag==0) {
        
        if (_currentController == _tab1) {
            return;
        }
        [self fitFrameForChildViewController:_tab1];
        [self transitionFromViewController:_currentController toViewController:_tab1 duration:0.1 options:UIViewAnimationOptionTransitionNone animations:nil completion:^(BOOL finished) {
            if (finished) {
                [self->_tab1 didMoveToParentViewController:weakSelf];
                self->_currentController =self->_tab1;
            }else{
                self->_currentController = oldController;
            }
        }];
    } else if (tag == 1) {
        if (_currentController == _tab3) {
            return;
        }
        [self fitFrameForChildViewController:_tab3];
        [self transitionFromViewController:_currentController toViewController:_tab3 duration:0.1 options:UIViewAnimationOptionTransitionNone animations:nil completion:^(BOOL finished) {
            if (finished) {
                [self->_tab3 didMoveToParentViewController:weakSelf];
                self->_currentController =self->_tab3;
            }else{
                self->_currentController = oldController;
            }
        }];
    } else {
        if (_currentController == _tab2) {
            return;
        }
        [self fitFrameForChildViewController:_tab2];
        [self transitionFromViewController:_currentController toViewController:_tab2 duration:0.1 options:UIViewAnimationOptionTransitionNone animations:nil completion:^(BOOL finished) {
            if (finished) {
                [self->_tab2 didMoveToParentViewController:weakSelf];
                self->_currentController =self->_tab2;
            }else{
                self->_currentController = oldController;
            }
        }];
    }
}

- (void)fitFrameForChildViewController:(UIViewController *)chileViewController{
    CGRect frame = CGRectMake(0, kStatusBarH + kNavBarH, self.view.bounds.size.width, kScreen_Height - kStatusBarH - kNavBarH);
    chileViewController.view.frame = frame;
}

- (void)fetchCount{
    __weak __typeof(self) weakself = self;
    [[HttpManager manager] post:[UrlConfig URL:getQIApprovalList] param:@{@"page":@"1",@"rows":@"10"} success:^(NSData *data) {
        DataCollection *dataCollection = [DataCollection mj_objectWithKeyValues:data];
        if (dataCollection) {
            if(dataCollection.total > 99){
                [weakself.segmentedControl pp_addBadgeWithText:@"99+"];
            }else{
                [weakself.segmentedControl pp_addBadgeWithText:[NSString stringWithFormat:@"%ld", dataCollection.total]];
            }
            [weakself.segmentedControl pp_moveBadgeWithX:7 Y:3];
        }
    } faild:nil];
}

@end
