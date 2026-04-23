//
//  ReviewBaseController.m
//  HBConstructionApp
//
//  Created by 末末班车 on 2018/3/29.
//  Copyright © 2018年 atide. All rights reserved.
//

#import "ReviewBaseController.h"
#import "QDOriginalRecordController.h"
#import "FlowApprovalCommentView.h"
#import "ApiGeneralManagement.h"
#import "FlowApprovalToolBar.h"
#import "HandleController.h"
#import "DocumentTabView.h"
#import "FilesScanView.h"
#import "BaseListCell1.h"
#import "HandleModel.h"
#import "FormBaseController.h"

#import <AMapLocationKit/AMapLocationKit.h>

#define tabHeight 40
#define bottomHeight 50

@interface ReviewBaseController ()<UIScrollViewDelegate, UITableViewDelegate, UITableViewDataSource, AMapLocationManagerDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, strong) UIScrollView *commentScrollView;

@property (nonatomic, strong) AMapLocationManager *locationManager;
@property (nonatomic, copy) AMapLocatingCompletionBlock completionBlock;

@property (nonatomic, strong) FilesScanView *annexFV;

@property (nonatomic, assign) BOOL isAnnexPush;

@end

@implementation ReviewBaseController {
    HandleController *_handleVC;
    
    DocumentTabView *_tabView;
    
    NSString *_tempTitle;
    NSInteger _page;
    NSInteger _rows;
    
    BOOL _isFrist;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _tempTitle = self.title;
    _isFrist = YES;
    
    [self setupUI];
    [self setupContentView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.title = _tempTitle;
    self.tabBarController.tabBar.hidden = YES;
    if (!self.newFormFlag) {
        [self loadToolBar];
    } else {
        [self checkSaveBtn:nil];
    }
    
    if (!_isFrist) {
        if (_isAnnexPush) {
            _isAnnexPush = NO;
        } else {
            [self updateUI];
        }
    }
    _isFrist = NO;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.title = @"";
}

#pragma mark - 初始化界面
- (void)setupUI {
    __weak typeof(self) weakSelf = self;
    NSArray *titles;
    if (self.showVideoMaterial) {
        titles = @[@"基本信息", @"审核意见", @"办理过程", @"附件信息"];
    } else {
        titles = @[@"基本信息", @"审核意见", @"办理过程"];
    }
    _tabView = [[DocumentTabView alloc] initWithFrame:CGRectMake(0, kStatusBarH + kNavBarH, kScreen_Width, tabHeight) titles:titles];
    _tabView.callBack = ^(NSInteger selectIndex) {
        [weakSelf.scrollView setContentOffset:CGPointMake(selectIndex * kScreen_Width, 0) animated:YES];
        if (weakSelf.showSaveBtn) {
            switch (selectIndex) {
                case 0:{
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [weakSelf checkSaveBtn:weakSelf.toolView.data];
                    });
                }
                    break;
                default:
                    weakSelf.navigationItem.rightBarButtonItem = nil;
                    break;
            }
        }
    };
    [self.view addSubview:_tabView];
    
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, tabHeight + kStatusBarH + kNavBarH, kScreen_Width, kScreen_Height - kStatusBarH - kNavBarH - tabHeight - bottomHeight)];
    _scrollView.contentSize = CGSizeMake(kScreen_Width * titles.count, _scrollView.frame.size.height);
    _scrollView.delegate = self;
    _scrollView.pagingEnabled = YES;
    _scrollView.bounces = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:_scrollView];
    if (IS_IPHONE_X) {
        _scrollView.contentInset = UIEdgeInsetsMake(0, 0, -34, 0);
    }
    
    _toolView = [[DocumentToolView alloc] initWithFrame:CGRectMake(0, kScreen_Height - bottomHeight, kScreen_Width, bottomHeight)];
    _toolView.backgroundColor = [UIColor whiteColor];
    _toolView.bizUrl = self.bizUrl;
    _toolView.bizKey = self.bizKey;
    _toolView.bizPk = self.bizPk;
    _toolView.type = self.type;
    _toolView.status = self.status;
    _toolView.block = ^(BOOL isRemove) {
        if (weakSelf.handleCallBack) {
            [weakSelf flowCallBack:YES];
        } else {
            if (weakSelf.callBack) {
                weakSelf.callBack();
            }
            [weakSelf.navigationController popViewControllerAnimated:YES];
        }
    };
    
    [self.view addSubview:_toolView];
}

- (void)setupContentView {
    //加载第一个视图
    [self addChildViewController:self.firstVC];
     self.firstVC.view.frame = CGRectMake(0, 0, kScreen_Width, self.scrollView.frame.size.height);
    if([self.firstVC isKindOfClass:[FormBaseController class]]){
        self.firstVC.view.frame = CGRectMake(0, -kNavBarH-kStatusBarH, kScreen_Width, self.scrollView.frame.size.height - 40 );
    }
    [self.scrollView addSubview:self.firstVC.view];
    
    //加载第二个视图
    if (self.secondVC) {
        [self addChildViewController:self.secondVC];
        self.secondVC.view.frame = CGRectMake(kScreen_Width, 0, kScreen_Width, self.scrollView.frame.size.height);
        [self.scrollView addSubview:self.secondVC.view];
    } else {
        if (!self.newFormFlag) {
            [self setupMidView];
        }
    }
    
    //加载第三个视图
    if (self.thirdVC) {
        [self addChildViewController:self.thirdVC];
        self.thirdVC.view.frame = CGRectMake(kScreen_Width * 2, 0, kScreen_Width, self.scrollView.frame.size.height);
        [self.scrollView addSubview:self.thirdVC.view];
    } else {
        if (!self.newFormFlag) {
            [self setupHandleView];
        }
    }
    
    //加载第四个视图
    if (self.showVideoMaterial) {
        if (self.fourthVC) {
            [self addChildViewController:self.fourthVC];
            self.fourthVC.view.frame = CGRectMake(kScreen_Width * 3, 0, kScreen_Width, self.scrollView.frame.size.height);
            [self.scrollView addSubview:self.fourthVC.view];
        } else {
            [self setupAnnex];
        }
    }
}

#pragma mark - 默认content
- (UIViewController *)firstVC {
    if (!_firstVC) {
        _firstVC = [[UIViewController alloc] init];
    }
    return _firstVC;
}

- (void)setupMidView {
    __weak typeof(self) weakSelf = self;
    
    _commentScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(kScreen_Width, 0, kScreen_Width, self.scrollView.frame.size.height)];
    _commentScrollView.contentSize = CGSizeMake(kScreen_Width, 0);
    _commentScrollView.backgroundColor = UIColorBackground;
    _commentScrollView.showsVerticalScrollIndicator = NO;
    _commentScrollView.showsHorizontalScrollIndicator = NO;
    [self.scrollView addSubview:_commentScrollView];
    
    FlowApprovalCommentView *commentView = [[FlowApprovalCommentView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, 0)];
    [commentView request:self.bizPk type:0 callback:^(CGFloat height) {
        weakSelf.commentScrollView.contentSize = CGSizeMake(kScreen_Width, height);
    }];
    [_commentScrollView addSubview:commentView];
}

- (void)setupHandleView {
    _handleVC = [[HandleController alloc] initWithNibName:@"HandleController" bundle:nil];
    _handleVC.view.frame = CGRectMake(kScreen_Width * 2, 0, kScreen_Width, self.scrollView.frame.size.height);
    _handleVC.view.backgroundColor = UIColorFromRGB(0xDCE2EA);
    [self addChildViewController:_handleVC];
    [self.scrollView addSubview:_handleVC.view];
    
    
    ApiGeneralManagement *api =[[ApiGeneralManagement alloc] initWithRequestParams:@{
                                                                                     @"bizPk":self.bizPk,
                                                                                     @"sectId":[UserAgent DefaultAgent].sectionId,
                                                                                     @"sectionId":self.sectionId,
                                                                                     @"projectId":self.projectId
                                                                                     } flag:HandleHis bizKey:self.bizKey];
    [SVProgressHUD showWithStatus:@"请求中..."];
    
    [api startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        [SVProgressHUD dismiss];
        if ([request resultIsSuccess]) {
            [HandleModel mj_setupObjectClassInArray:^NSDictionary *{
                return @{
                         @"taskAssignees":NSStringFromClass([TaskAssignees class]),
                         @"unFinishTaskAssignees":NSStringFromClass([UnFinishTaskAssignees class]),
                         @"opinions":NSStringFromClass([Opinions class]),
                         };
            }];
            self->_handleVC.data = [HandleModel mj_objectArrayWithKeyValuesArray:request.resultDataArray];
        }
    } failure:nil];
}

- (void)setupAnnex {
    [self.scrollView addSubview:self.annexFV];
    [self.annexFV updateData];
}

- (void)updateAnnexView {
    if (self.annexFV) {
        [self.annexFV updateData];
    }
}

#pragma mark - 懒加载
- (FilesScanView *)annexFV {
    if (!_annexFV) {
        __weak typeof(self) weakSelf = self;
        _annexFV = [[FilesScanView alloc] initWithFrame:CGRectMake(kScreen_Width * 3 + 5, 0, kScreen_Width - 10, self.scrollView.frame.size.height) isHandle:NO];
        _annexFV.markId = self.bizPk;
        _annexFV.annexPushBlock = ^{
            weakSelf.isAnnexPush = YES;
        };
    }
    return _annexFV;
}

#pragma mark - 获取工具栏
- (void)loadToolBar {
    __weak typeof(self) weakSelf = self;
    FlowApprovalToolBar *toolBar = [[FlowApprovalToolBar alloc] init];
    toolBar.isMatter = self.isMatter;
    
    [toolBar request:self.bizPk bizKey:self.bizKey callback:^(NSArray<Panel *> *items) {
        [weakSelf checkSaveBtn:items];
        self->_toolView.data = items;
        self->_toolView.hidden = items.count == 0 || self.hiddenTool;
        CGRect frame = weakSelf.scrollView.frame;
        frame.size.height = items.count == 0 ? (kScreen_Height - kStatusBarH - kNavBarH - tabHeight) : (kScreen_Height - kStatusBarH - kNavBarH - tabHeight - bottomHeight);
        weakSelf.scrollView.frame = frame;
        
        for (UIView *view in weakSelf.scrollView.subviews) {
            CGRect fra = view.frame;
            fra.size.height = frame.size.height;
            view.frame = fra;
        }
    }];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    NSInteger index = (NSInteger)(scrollView.contentOffset.x / kScreen_Width);
    [_tabView selectBtn:index];
    if (self.showSaveBtn) {
        switch (index) {
            case 0:
                [self checkSaveBtn:self.toolView.data];
                break;
            default:
                self.navigationItem.rightBarButtonItem = nil;
                break;
        }
    }
}

#pragma mark - 点击保存
- (void)save {
    if ([self.firstVC respondsToSelector:@selector(save)]) {
        [self.firstVC performSelector:@selector(save) withObject:nil afterDelay:0];
    } else if ([self.firstVC respondsToSelector:@selector(save:)]) {
        NSArray *files;
        if (self.annexFV) {
            files = self.annexFV.addFiles;
        }
        [self.firstVC performSelector:@selector(save:) withObject:files afterDelay:0];
    }
}

#pragma mark - 刷新页面
- (void)updateUI {
    if ([self.firstVC respondsToSelector:@selector(reload)]) {
        [self.firstVC performSelector:@selector(reload)];
    }
    
    [self updateCommon];
}

- (void)updateUI2{
    if ([self.firstVC respondsToSelector:@selector(newReload)]) {
        [self.firstVC performSelector:@selector(newReload)];
    } else {
        if ([self.firstVC respondsToSelector:@selector(reload)]) {
            [self.firstVC performSelector:@selector(reload)];
        }
    }
    
    [self updateCommon];
}

- (void)updateCommon {
    if (self.secondVC) {
        if ([self.secondVC respondsToSelector:@selector(reload)]) {
            [self.secondVC performSelector:@selector(reload)];
        }
    } else {
        [self.commentScrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        
        __weak typeof(self) weakSelf = self;
        FlowApprovalCommentView *commentView = [[FlowApprovalCommentView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, 0)];
        [commentView request:self.bizPk type:0 callback:^(CGFloat height) {
            weakSelf.commentScrollView.contentSize = CGSizeMake(kScreen_Width, height);
        }];
        [self.commentScrollView addSubview:commentView];
    }
    
    if (self.thirdVC) {
        if ([self.thirdVC respondsToSelector:@selector(reload)]) {
            [self.thirdVC performSelector:@selector(reload)];
        }
    } else {
        ApiGeneralManagement *api =[[ApiGeneralManagement alloc] initWithRequestParams:@{
                                                                                         @"bizPk":self.bizPk,
                                                                                         @"sectId":self.sectionId,
                                                                                         @"sectionId":self.sectionId,
                                                                                         @"projectId":self.projectId
                                                                                         } flag:HandleHis bizKey:self.bizKey];
        [api startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
            if ([request resultIsSuccess]) {
                [HandleModel mj_setupObjectClassInArray:^NSDictionary *{
                    return @{
                             @"taskAssignees":NSStringFromClass([TaskAssignees class]),
                             @"unFinishTaskAssignees":NSStringFromClass([UnFinishTaskAssignees class]),
                             @"opinions":NSStringFromClass([Opinions class]),
                             };
                }];
                self->_handleVC.data = [HandleModel mj_objectArrayWithKeyValuesArray:request.resultDataArray];
            }
        } failure:nil];
    }
    
    if (self.showVideoMaterial) {
        if (self.fourthVC) {
            if ([self.fourthVC respondsToSelector:@selector(reload)]) {
                [self.fourthVC performSelector:@selector(reload)];
            }
        } else {
            [self.annexFV updateData];
        }
    }
}

- (void)checkSaveBtn:(NSArray <Panel *>*)items {
    self.navigationItem.rightBarButtonItem = nil;
    if (self.isUserXY) {
        ApprovalPartModel *model = [UserAgent DefaultAgent].approvalPartModel;
        if (model) {
            if ([model.CODE_ isEqualToString:self.partCode]) {
                if (!self.locationManager) {
                    [self configLocationManager];
                }
                [self initCompleteBlock:items];
                
                //进行单次定位
                [self.locationManager requestLocationWithReGeocode:NO completionBlock:self.completionBlock];
            }
        }
    } else {
        [self newCheckSaveBtn:items];
    }
}

- (void)newCheckSaveBtn:(NSArray <Panel *>*)items {
    NSInteger index = (NSInteger)(self.scrollView.contentOffset.x / kScreen_Width);
    if (items) {
        for (Panel *panel in items) {
            if ([panel.content isEqualToString:@"保存"] && index == 0) {
                if (self.showSaveBtn) {
                    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"save"] style:UIBarButtonItemStylePlain target:self action:@selector(save)];
                }
            }
        }
    } else {
        if (self.newFormFlag && index == 0) {
            self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"save"] style:UIBarButtonItemStylePlain target:self action:@selector(save)];
        }
    }
}

- (void)initCompleteBlock:(NSArray <Panel *>*)items {
    __weak typeof(self) weakSelf = self;
    self.completionBlock = ^(CLLocation *location, AMapLocationReGeocode *regeocode, NSError *error) {
        if (error) {
            return;
        }
        
        if (location) {
            UserAgent *user = [UserAgent DefaultAgent];
            CGFloat gpsRanger = 0;
            for (ProjectInfo *prjInfo in user.projectInfos) {
                if ([prjInfo.id isEqualToString:user.approvalPartModel.PRJID]) {
                    for (ProjectInfo *secInfo in prjInfo.children) {
                        if ([secInfo.id isEqualToString:user.approvalPartModel.SECTION_ID]) {
//                            gpsRanger = secInfo.gpsRanger;
                            break;
                        }
                    }
                }
            }
            
            if (gpsRanger >= [weakSelf distanceBetweenOrderBy:user.approvalPartModel.Y_POINT :location.coordinate.latitude :user.approvalPartModel.X_POINT :location.coordinate.longitude]) {
                [weakSelf newCheckSaveBtn:items];
            } else {
                [SVProgressHUD showErrorWithStatus:@"未在指定范围内!"];
            }
        } else {
            [SVProgressHUD showErrorWithStatus:@"定位失败!"];
        }
    };
}

- (void)configLocationManager {
    self.locationManager = [[AMapLocationManager alloc] init];
    
    [self.locationManager setDelegate:self];
    
    //设置期望定位精度
    [self.locationManager setDesiredAccuracy:kCLLocationAccuracyNearestTenMeters];
}

- (double)distanceBetweenOrderBy:(double) lat1 :(double) lat2 :(double) lng1 :(double) lng2{
    
    CLLocation *curLocation = [[CLLocation alloc] initWithLatitude:lat1 longitude:lng1];
    
    CLLocation *otherLocation = [[CLLocation alloc] initWithLatitude:lat2 longitude:lng2];
    
    double  distance  = [curLocation distanceFromLocation:otherLocation];
    
    return  distance;
}

- (void)setTaskId:(NSString *)taskId {
    self.toolView.taskId = taskId;
    self.toolView.vcTitle = self.navigationItem.title;
}

- (void)flowCallBack:(BOOL)isRevoke {
    
}

@end
