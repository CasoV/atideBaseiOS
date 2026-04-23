//
//  SupervisionPunishmentFlowController.m
//  ycxm
//
//  Created by 末末班车 on 2020/3/19.
//  Copyright © 2020 末末班车. All rights reserved.
//

#import "SupervisionPunishmentFlowController.h"
#import "SupervisionPunishmentDetailController.h"
#import "FlowApprovalCommentView.h"
#import "ApiGeneralManagement.h"
#import "PassViewController.h"
#import "UIView+BorderLine.h"
#import "HandleController.h"
#import "DocumentTabView.h"
#import "FilesScanView.h"
#import "HandleModel.h"
#import "ToolBar.h"
#import "ApiUpload.h"
#import <YTKNetwork/YTKNetwork.h>

#define tabHeight 40
#define bottomHeight 40

@interface SupervisionPunishmentFlowController ()<UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, strong) UIScrollView *commentScrollView;

@property (nonatomic, strong) FilesScanView *annexFV;

@property (nonatomic, copy) NSArray <ToolBar *>*toolBarDatas;

@property (nonatomic, copy) NSString *bizKey;

@property (nonatomic, assign) BOOL haveSave;

@property (nonatomic, copy) NSString *ID;

@end

@implementation SupervisionPunishmentFlowController {
    SupervisionPunishmentDetailController *_detailVc;
    HandleController *_handleVC;
    DocumentTabView *_tabView;
    UIView *_toolView;
    
    YTKBatchRequest *_batchRequest;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.bizKey = @"pm_rule_jl";
    self.isFirst = YES;
    
    if (self.newFormFlag) {
        [self getPkId];
    } else {
        self.ID = self.model.id;
        [self setupUI];
        [self setupContentView];
        [self getFlowToolbar];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationItem.title = @"违约处罚";
    self.tabBarController.tabBar.hidden = YES;
    
    if (!self.isFirst) {
        if (self.isAnnexPush) {
            self.isAnnexPush = NO;
        } else {
            [self getFlowToolbar];
        }
    }
    self.isFirst = NO;
}

- (void)dealloc {
    [_batchRequest stop];
}

#pragma mark - 初始化界面
- (void)setupUI {
    __weak typeof(self) weakSelf = self;
    NSArray *titles;
    if (self.newFormFlag) {
        titles = @[@"基本信息", @"附件信息"];
    } else {
        titles = @[@"基本信息", @"审核意见", @"办理过程", @"附件信息"];
    }
    _tabView = [[DocumentTabView alloc] initWithFrame:CGRectMake(0, kStatusBarH + kNavBarH, kScreen_Width, tabHeight) titles:titles];
    _tabView.callBack = ^(NSInteger selectIndex) {
        [weakSelf.scrollView setContentOffset:CGPointMake(selectIndex * kScreen_Width, 0) animated:YES];
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
    
    _toolView = [[UIView alloc] initWithFrame:CGRectMake(0, kScreen_Height - bottomHeight, kScreen_Width, bottomHeight)];
    _toolView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_toolView];
}

- (void)setupContentView {
    //加载第一个视图
    _detailVc = [[UIStoryboard storyboardWithName:@"Quality" bundle:nil] instantiateViewControllerWithIdentifier:@"SupervisionPunishmentDetailController"];
    _detailVc.view.frame = CGRectMake(0, 0, kScreen_Width, self.scrollView.frame.size.height);
    _detailVc.bizKey = self.bizKey;
    _detailVc.model = self.model;
    [self addChildViewController:_detailVc];
    [self.scrollView addSubview:_detailVc.view];
    
    __weak typeof(self) weakSelf = self;
    _detailVc.pushBlock = ^{
        weakSelf.isAnnexPush = YES;
    };
    
    //加载第二个视图
    if (!self.newFormFlag) {
        [self setupMidView];
    }
    
    //加载第三个视图
    if (!self.newFormFlag) {
        [self setupHandleView];
    }
}

#pragma mark - 加载第二个视图
- (void)setupMidView {
    __weak typeof(self) weakSelf = self;
    
    _commentScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(kScreen_Width, 0, kScreen_Width, self.scrollView.frame.size.height)];
    _commentScrollView.contentSize = CGSizeMake(kScreen_Width, 0);
    _commentScrollView.backgroundColor = UIColorBackground;
    _commentScrollView.showsVerticalScrollIndicator = NO;
    _commentScrollView.showsHorizontalScrollIndicator = NO;
    [self.scrollView addSubview:_commentScrollView];
    
    FlowApprovalCommentView *commentView = [[FlowApprovalCommentView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, 0)];
    [commentView request:self.ID type:0 callback:^(CGFloat height) {
        weakSelf.commentScrollView.contentSize = CGSizeMake(kScreen_Width, height);
    }];
    [_commentScrollView addSubview:commentView];
}

#pragma mark - 加载第三个视图
- (void)setupHandleView {
    _handleVC = [[HandleController alloc] initWithNibName:@"HandleController" bundle:nil];
    _handleVC.view.frame = CGRectMake(kScreen_Width * 2, 0, kScreen_Width, self.scrollView.frame.size.height);
    _handleVC.view.backgroundColor = UIColorFromRGB(0xDCE2EA);
    [self addChildViewController:_handleVC];
    [self.scrollView addSubview:_handleVC.view];
    
    
    ApiGeneralManagement *api =[[ApiGeneralManagement alloc] initWithRequestParams:@{
                                                                                     @"bizPk":self.ID,
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

#pragma mark - 加载附件视图
- (void)setupAnnex {
    if (self.annexFV) {
        [self.annexFV removeFromSuperview];
        self.annexFV = nil;
    }
    
    CGRect frame;
    if (self.newFormFlag) {
        frame = CGRectMake(kScreen_Width + 5, 0, kScreen_Width - 10, self.scrollView.frame.size.height);
    } else {
        frame = CGRectMake(kScreen_Width * 3 + 5, 0, kScreen_Width - 10, self.scrollView.frame.size.height);
    }
    
    __weak typeof(self) weakSelf = self;
    self.annexFV = [[FilesScanView alloc] initWithFrame:frame isHandle:self.haveSave];
    self.annexFV.markId = self.ID;
    self.annexFV.annexPushBlock = ^{
        weakSelf.isAnnexPush = YES;
    };
    
    [self.scrollView addSubview:self.annexFV];
    [self.annexFV updateData];
}

#pragma mark - 请求id
- (void)getPkId {
//    [SVProgressHUD showWithStatus:nil];
//    __weak typeof(self) weakSelf = self;
//    [[HttpManager manager] post:[UrlConfig URL:newGetPkId] param:nil success:^(NSData *data) {
//        [SVProgressHUD dismiss];
//        NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//        weakSelf.ID = [str stringByReplacingOccurrencesOfString:@"\"" withString:@""];
//
//        [weakSelf setupUI];
//        [weakSelf setupContentView];
//        [weakSelf getFlowToolbar];
//    } faild:^(NSString *msg) {
//        [SVProgressHUD showErrorWithStatus:msg];
//    }];
}

- (void)setHaveSave:(BOOL)haveSave {
    _haveSave = haveSave;
    _detailVc.canEdit = haveSave;
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    NSInteger index = (NSInteger)(scrollView.contentOffset.x / kScreen_Width);
    [_tabView selectBtn:index];
}

#pragma mark - 获取工具栏
- (void)getFlowToolbar {
    [SVProgressHUD showWithStatus:nil];
    __weak typeof(self) weakSelf = self;
    NSDictionary *params = @{
        @"bizKey":self.bizKey,
        @"bizPk":self.ID
    };
    [[HttpManager manager] post:[UrlConfig URL:getFlowToolbar] param:params success:^(NSData *data) {
        if ([ResponseUtils success:data]) {
            [SVProgressHUD dismiss];
            NSArray <ToolBar *>*result = [ToolBar mj_objectArrayWithKeyValuesArray:[ResponseUtils getData:@"data"]];
            weakSelf.toolBarDatas = result ? result : [NSArray array];
            weakSelf.haveSave = [weakSelf checkSave:result];
            [weakSelf setupAnnex];
            [weakSelf handleToolbarDatas];
            [weakSelf updateUI];
        } else {
            [SVProgressHUD showErrorWithStatus:[ResponseUtils getMsg]];
        }
    } faild:^(NSString *msg) {
        [SVProgressHUD showErrorWithStatus:msg];
    }];
}

#pragma mark - 判断是否有保存按钮
- (BOOL)checkSave:(NSArray *)tools {
    BOOL save = NO;
    if (tools.count > 0) {
        for (ToolBar *tool in tools) {
            if ([tool.pageId isEqualToString:@"button-save"]) {
                save = YES;
                break;
            }
        }
    }
    
    return save;
}

#pragma mark - 处理toolbar数据
- (void)handleToolbarDatas {
    _toolView.hidden = self.toolBarDatas.count == 0;
    CGRect frame = self.scrollView.frame;
    frame.size.height = self.toolBarDatas.count == 0 ? (kScreen_Height - kStatusBarH - kNavBarH - tabHeight) : (kScreen_Height - kStatusBarH - kNavBarH - tabHeight - bottomHeight);
    self.scrollView.frame = frame;
    for (UIView *view in self.scrollView.subviews) {
        CGRect fra = view.frame;
        fra.size.height = frame.size.height;
        view.frame = fra;
    }
    
    if (self.toolBarDatas.count > 0) {
        [_toolView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        
        CGFloat width = _toolView.frame.size.width / self.toolBarDatas.count;
        CGFloat height = (_toolView.frame.size.height == 0) ? 44 : _toolView.frame.size.height;
        
        for (int j = 0; j < self.toolBarDatas.count; j++) {
            UIButton *bottomItem = [[UIButton alloc] initWithFrame:CGRectMake(j * width, 0, width, height)];
            [bottomItem setTitle:self.toolBarDatas[j].name forState:UIControlStateNormal];
            [bottomItem setTitleColor:UIColorFromRGB(0x0096FF) forState:UIControlStateNormal];
            [bottomItem borderForColor:UIColorGrey_200 borderWidth:1 borderType:UIBorderSideTypeRight];
            bottomItem.titleLabel.font=[UIFont systemFontOfSize:12];
            bottomItem.tag = j + 100;
            [bottomItem addTarget:self action:@selector(bottomAction:) forControlEvents:UIControlEventTouchUpInside];
            [_toolView addSubview: bottomItem];
        }
        
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectZero];
        lineView.backgroundColor = UIColorGrey_200;
        [_toolView addSubview:lineView];
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.equalTo(self->_toolView);
            make.height.equalTo(@0.5);
        }];
    }
}

#pragma mark - 工具栏点击
- (void)bottomAction:(UIButton *)sender {
    ToolBar *item = self.toolBarDatas[sender.tag - 100];
    
    if ([item.pageId isEqualToString:@"button-save"]) {
        if ([_detailVc verify]) {
            [self save:[_detailVc params]];
        }
    } else if ([item.pageId isEqualToString:@"button-remove"]) {
        __weak typeof(self) weakSelf = self;
        UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"删除提示" message:@"确定要删除吗？" preferredStyle:UIAlertControllerStyleAlert];
        [alertC addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [weakSelf deleteData];
        }]];
        [alertC addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
        [self presentViewController:alertC animated:YES completion:nil];
    } else if ([item.pageId isEqualToString:@"button-submit"] || [item.pageId isEqualToString:@"button-pass"]) {
        PassViewController *vc = [[UIStoryboard storyboardWithName:@"Flow" bundle:nil] instantiateViewControllerWithIdentifier:@"pass"];
        vc.finalUrl = [UrlConfig URL:qualityRecordCompleteTask];
        vc.instanceId = self.ID;
        vc.bizKey = self.bizKey;
        vc.url = pass;
        if ([item.pageId isEqualToString:@"button-submit"]) {
            vc.title = @"违约处罚-提交";
        } else {
            vc.title = @"违约处罚-通过";
        }
        [self.navigationController pushViewController:vc animated:YES];
    } else if ([item.pageId isEqualToString:@"page-reject"]) {
        PassViewController *vc = [[UIStoryboard storyboardWithName:@"Flow" bundle:nil] instantiateViewControllerWithIdentifier:@"pass"];
        vc.finalUrl = [UrlConfig URL:qualityRecordRejectTask];
        vc.instanceId = self.ID;
        vc.bizKey = self.bizKey;
        vc.url = reject;
        vc.title = @"违约处罚-退回";
        [self.navigationController pushViewController:vc animated:YES];
    } else if ([item.pageId isEqualToString:@"button-revoke"]) {
        __weak typeof(self) weakSelf = self;
        UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"撤回提示" message:@"确定要撤回吗？" preferredStyle:UIAlertControllerStyleAlert];
        [alertC addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [weakSelf revoke];
        }]];
        [alertC addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
        [self presentViewController:alertC animated:YES completion:nil];
    } else {
        [SVProgressHUD showInfoWithStatus:@"暂无法处理该操作!"];
    }
}

#pragma mark - 保存数据
- (void)save:(NSDictionary *)param {
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:param];
    [params setObject:self.ID forKey:@"id"];
    [params setObject:self.ID forKey:@"bizPk"];
    [params setObject:self.bizKey forKey:@"bizKey"];
    
    if (self.newFormFlag) {
        [params setObject:@"1" forKey:@"newFormFlag"];
    } else {
        [params setObject:@"0" forKey:@"newFormFlag"];
    }
    
    [SVProgressHUD showWithStatus:nil];
    __weak typeof(self) weakSelf = self;
    if (self.newFormFlag) {
        [[HttpManager manager] post:[UrlConfig URL:qualityRecord] param:params success:^(NSData *data) {
            if ([ResponseUtils success:data]) {
                [weakSelf saveFiles:[ResponseUtils getData:@"data"]];
            } else {
                [SVProgressHUD showErrorWithStatus:[ResponseUtils getMsg]];
            }
        } faild:^(NSString *msg) {
            [SVProgressHUD showErrorWithStatus:msg];
        }];
    } else {
        NSString *url = [NSString stringWithFormat:@"%@/%@", [UrlConfig URL:qualityRecord], self.ID];
//        [[HttpManager manager] put:url param:params success:^(NSData *data) {
//            if ([ResponseUtils success:data]) {
//                [weakSelf saveFiles:[ResponseUtils getData:@"data"]];
//            } else {
//                [SVProgressHUD showErrorWithStatus:[ResponseUtils getMsg]];
//            }
//        } faild:^(NSString *msg) {
//            [SVProgressHUD showErrorWithStatus:msg];
//        }];
    }
}

#pragma mark - 保存文件
- (void)saveFiles:(NSString *)markId {
    NSMutableArray <BIMFile *>*files = [NSMutableArray array];
    [files addObjectsFromArray:[self.annexFV addFiles]];
    if (files.count == 0) {
        [SVProgressHUD showSuccessWithStatus:@"保存成功!"];
        if (self.newFormFlag) {
            [self.navigationController popViewControllerAnimated:YES];
        }
    } else {
        if (_batchRequest) {
            [_batchRequest stop];
        }
        
        __weak typeof(self) weakSelf = self;
        NSMutableArray <YTKRequest *>*requests = [NSMutableArray array];
        for (BIMFile *file in files) {
            NSDictionary *params = @{
                                     @"metaData.formId":markId
                                     };
            ApiUpload *api = [[ApiUpload alloc] initWithFile:file params:params];
            api.url = filesUpload;
            [requests addObject:api];
        }
        
        _batchRequest = [[YTKBatchRequest alloc] initWithRequestArray:requests];
        [_batchRequest startWithCompletionBlockWithSuccess:^(YTKBatchRequest * _Nonnull batchRequest) {
            [SVProgressHUD showSuccessWithStatus:@"保存成功!"];
            if (weakSelf.newFormFlag) {
                [weakSelf.navigationController popViewControllerAnimated:YES];
            }
        } failure:^(YTKBatchRequest * _Nonnull batchRequest) {
            [SVProgressHUD showSuccessWithStatus:@"保存成功!"];
            if (weakSelf.newFormFlag) {
                [weakSelf.navigationController popViewControllerAnimated:YES];
            }
        }];
    }
}

#pragma mark - 刷新页面
- (void)updateUI {
    [self updateCommon];
}

- (void)updateCommon {
    if (!self.newFormFlag) {
        [self.commentScrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        
        __weak typeof(self) weakSelf = self;
        FlowApprovalCommentView *commentView = [[FlowApprovalCommentView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, 0)];
        [commentView request:self.ID type:0 callback:^(CGFloat height) {
            weakSelf.commentScrollView.contentSize = CGSizeMake(kScreen_Width, height);
        }];
        [self.commentScrollView addSubview:commentView];
        
        ApiGeneralManagement *api =[[ApiGeneralManagement alloc] initWithRequestParams:@{
                                                                                         @"bizPk":self.ID,
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
    
    if (self.annexFV) {
        [self.annexFV updateData];
    }
}

#pragma mark - 删除
- (void)deleteData {
    __weak typeof(self) weakSelf = self;
    [SVProgressHUD showWithStatus:@"删除中"];
    NSString *url = [NSString stringWithFormat:@"%@/%@", [UrlConfig URL:qualityRecord], self.ID];
    [[HttpManager manager] del:url param:nil success:^(NSData *data) {
        if ([ResponseUtils success:data]) {
            [SVProgressHUD showSuccessWithStatus:@"删除成功!"];
            [weakSelf.navigationController popViewControllerAnimated:YES];
        } else {
            [SVProgressHUD showErrorWithStatus:[ResponseUtils getMsg]];
        }
    } faild:^(NSString *msg) {
        [SVProgressHUD showErrorWithStatus:msg];
    }];
}

#pragma mark - 撤回
- (void)revoke {
    __weak typeof(self) weakSelf = self;
    [SVProgressHUD showWithStatus:@"撤回中"];
    NSString *url = [UrlConfig URL:qualityRecordRevokeTask];
    NSDictionary *params = @{
        @"bizPk":self.ID,
        @"comment":@"撤回",
        @"flowType":@"finish"
    };
    
    [[HttpManager manager] post:url param:params success:^(NSData *data) {
        if ([ResponseUtils success:data]) {
            [SVProgressHUD showSuccessWithStatus:@"撤回成功!"];
            [weakSelf getFlowToolbar];
        } else {
            [SVProgressHUD showErrorWithStatus:[ResponseUtils getMsg]];
        }
    } faild:^(NSString *msg) {
        [SVProgressHUD showErrorWithStatus:msg];
    } headers:@{
        @"flow-token":@"REVOKE"
    }];
}

@end
