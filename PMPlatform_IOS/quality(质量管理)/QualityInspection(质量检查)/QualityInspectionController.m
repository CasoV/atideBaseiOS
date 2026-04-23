//
//  QualityInspectionViewController.m
//  ycxm
//
//  Created by 末末班车 on 2018/9/20.
//  Copyright © 2018年 末末班车. All rights reserved.
//

#import "QualityInspectionController.h"
#import "QualityProblemReplyViewController.h"
#import "QualityInspectionPopView.h"
#import "QualityInspectionView.h"
#import <YTKNetwork/YTKNetwork.h>
#import "DocumentTabView.h"
#import "ApiImageUpload.h"
#import "PopoverView.h"

#define tabHeight 35

@interface QualityInspectionController ()<UIScrollViewDelegate>

@property (nonatomic, strong) QualityInspectionView *qualityInspectionView;

//@property (nonatomic, strong) IFlyHelper *iflyHelper;
@property (nonatomic, strong) UITextView *textView;

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIScrollView *infoScrollView;
@property (nonatomic, strong) DocumentTabView *tabView;

@property (nonatomic, copy) NSArray *titles;

@end

@implementation QualityInspectionController {
    NSString *_newFormFlag;
    NSString *_ID;
    
    YTKBatchRequest *_batchRequest;
    QualityProblemReplyViewController *_replyVC;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    // 底部按钮
    if (self.type == FunctionTypeQualityInspectionUnsubmitted) {
        if (self.model) {
            if([self.model.userId isEqualToString:[AppUser sharedInstance].userId]){
                self.titles = @[@"保存", @"提交"];
            } else {
                self.titles = @[];
            }
        } else {
            self.titles = @[@"保存", @"提交"];
        }
        
    } else if (self.type == FunctionTypeQualityInspectionWaitRectification) {
        self.titles = @[@"确认整改", @"退回"];
    } else if (self.type == FunctionTypeQualityInspectionWaitReview) {
        self.titles = @[@"复查确认"];
    } else {
        self.titles = @[@"回复"];
    }
    
    if (self.type == FunctionTypeQualityInspectionUnsubmitted) {
        [self setupSingleUI];
//        self.iflyHelper = [[IFlyHelper alloc] initWithView:self.view delegate:self];
    } else {
        [self setupMultipleUI:NO];
    }
    
    if (self.model) {
        _newFormFlag = @"0";
        _ID = self.model.id;
        self.qualityInspectionView.imagesView.markId = _ID;
        [self.qualityInspectionView.imagesView updateData];
    } else {
        _newFormFlag = @"1";
        [self getPkId];
    }
//    右上方按钮
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"icon_add"] style:UIBarButtonItemStylePlain target:self action:@selector(rightClicked:)];
    
    // 底部按钮
    for (int i = 0;i< self.titles.count;i++) {
        NSString *title = self.titles[i];
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.backgroundColor = UIColor.whiteColor;
        [btn setTitleColor:UIColorTextBlue forState:UIControlStateNormal];
        btn.frame = CGRectMake(i * kScreen_Width/self.titles.count, kScreen_Height - 35, kScreen_Width/self.titles.count, 35);
        [btn setTitle:title forState:UIControlStateNormal];
        [self.view addSubview:btn];
        [self.view bringSubviewToFront:btn];
        btn.titleLabel.font = [UIFont systemFontOfSize:13.f];
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
}
-(void)btnClick:(UIButton *)btn{
    NSString *title = btn.currentTitle;
    if ([title isEqualToString:@"保存"]) {
        [self save:NO];
    } else if ([title isEqualToString:@"提交"]) {
        [self save:YES];
    } else if ([title isEqualToString:@"回复"]) {
        [self reply];
    }else if ([title isEqualToString:@"退回"]) {
        if(![self.model.reformUser isEqualToString:[AppUser sharedInstance].userId]){
            [SVProgressHUD showErrorWithStatus:@"无此操作权限!"];
            return;
        }
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"确认退回？" preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
        [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self dataReturn];
        }]];
        [self presentViewController:alert animated:YES completion:nil];
    } else {
        [self rectificationReview];
    }
    
}
-(void)dataReturn{
    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithDictionary:@{
        @"id":self.model.id?self.model.id:@"",
        @"name":self.model.name?self.model.name:@"",
        @"projectId":[UserAgent DefaultAgent].projectId,
        @"sectId":[UserAgent DefaultAgent].sectionId,
        @"newFormFlag":_newFormFlag,
        @"partName":self.model.partName?self.model.partName:@"",
        @"level":self.model.level?self.model.level:@"",
        @"isReform":self.model.isReform?self.model.isReform:@"",
        @"reformUser":self.model.reformUser?self.model.reformUser:@"",
        @"reformUserName":self.model.reformUserName?self.model.reformUserName:@"",
        @"limitDate":self.model.limitDate?self.model.limitDate:@"",
        @"describe":self.model.describe?self.model.describe:@"",
        @"measure":self.model.measure?self.model.measure:@"",
        @"createTime":self.model.createTime?self.model.createTime:@""
    }];
    NSString *url = [UrlConfig URL:saveQualityProblem];
    if ([self.resourceTitle isEqualToString:@"环保问题整改"]) {
        url = [UrlConfig URL:saveGreeProblem];
    }else if ([self.resourceTitle isEqualToString:@"水保巡查整改"]) {
        url = [UrlConfig URL:saveGreeWaterProblem];
    }else if ([self.resourceTitle isEqualToString:@"安全隐患"]||[self.resourceTitle isEqualToString:@"安全检查"]) {
        url = [UrlConfig URL:saveRisk];
    }else{
        [param setValue:[self.resourceTitle isEqualToString:@"质量问题"]?@"1":@"2" forKey:@"partId"];
    }
    
    
    [[HttpManager manager] post:url param:param success:^(NSData *data) {
        if ([ResponseUtils success:data]) {
            self->_newFormFlag = @"0";
            [SVProgressHUD showSuccessWithStatus:@"操作成功！"];
            [self.navigationController popViewControllerAnimated:YES];
        } else {
            [SVProgressHUD showErrorWithStatus:[ResponseUtils getMsg]];
        }
    } faild:^(NSString *msg) {
        [SVProgressHUD showErrorWithStatus:msg];
    }];
}
- (void)dealloc {
    [_batchRequest stop];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationItem.title = self.resourceTitle;
}

#pragma mark - 初始化页面
- (void)setupSingleUI {
    [self.view addSubview:self.infoScrollView];
    [self.infoScrollView addSubview:self.qualityInspectionView];
}

- (void)setupMultipleUI:(BOOL)isChange {
    [self.view addSubview:self.tabView];
    [self.view addSubview:self.scrollView];
    if (isChange) {
        [self.infoScrollView removeFromSuperview];
    } else {
        [self.infoScrollView addSubview:self.qualityInspectionView];
    }
    self.qualityInspectionView.canEdit = NO;
    self.infoScrollView.frame = CGRectMake(0, 0, kScreen_Width, self.scrollView.frame.size.height);
    [self.scrollView addSubview:self.infoScrollView];
    
    _replyVC = [[UIStoryboard storyboardWithName:@"Quality" bundle:nil] instantiateViewControllerWithIdentifier:@"qualityProblemReply"];
    _replyVC.id = self.model.id ? self.model.id : _ID;
    _replyVC.resourceTitle = self.resourceTitle;
    [self addChildViewController:_replyVC];
    CGRect frame = self.scrollView.frame;
    _replyVC.view.frame = CGRectMake(frame.size.width, 0, frame.size.width, frame.size.height);
    [self.scrollView addSubview:_replyVC.view];
}

#pragma mark - 懒加载
- (UIScrollView *)infoScrollView {
    if (!_infoScrollView) {
        CGFloat height = kScreen_Height - kStatusBarH - kNavBarH;
        if (self.titles.count > 0) {
            height -= 35;
        }
        
        _infoScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, kStatusBarH + kNavBarH, kScreen_Width, height)];
        _infoScrollView.bounces = NO;
        _infoScrollView.contentSize = CGSizeMake(0, 530);
        _infoScrollView.backgroundColor = UIColorBackground;
        _infoScrollView.showsVerticalScrollIndicator = NO;
        _infoScrollView.showsHorizontalScrollIndicator = NO;
    }
    return _infoScrollView;
}

- (QualityInspectionView *)qualityInspectionView {
    if (!_qualityInspectionView) {
        __weak typeof(self) weakSelf = self;
        _qualityInspectionView = [[NSBundle mainBundle] loadNibNamed:@"QualityInspectionView" owner:nil options:nil].firstObject;
        _qualityInspectionView.resourceTitle = self.resourceTitle;
        if([self.resourceTitle isEqualToString:@"质量问题"] || [self.resourceTitle isEqualToString:@"环保问题整改"] || [self.resourceTitle isEqualToString:@"水保巡查整改"] ){
            _qualityInspectionView.nameTitleLb.text = @"问题名称";
            _qualityInspectionView.partTitleLb.text = @"问题部位";
            _qualityInspectionView.levelTitleLb.text = @"问题等级";
        }
        
        if([self.resourceTitle isEqualToString:@"安全隐患"] || [self.resourceTitle isEqualToString:@"环保问题整改"] || [self.resourceTitle isEqualToString:@"水保巡查整改"]){
            _qualityInspectionView.partViewTop.constant = 5.0;
        }
        _qualityInspectionView.frame = CGRectMake(0, 0, kScreen_Width, 530);
        if (self.type == FunctionTypeQualityInspectionUnsubmitted) {
            if (self.model) {
                _qualityInspectionView.canEdit = [self.model.userId isEqualToString:[AppUser sharedInstance].userId];
            } else {
                _qualityInspectionView.canEdit = YES;
            }
        } else {
            _qualityInspectionView.canEdit = NO;
        }
        _qualityInspectionView.model = self.model;
        _qualityInspectionView.voiceClicked = ^(UIButton *btn) {
            for (UIView *view in btn.superview.subviews) {
                if ([view isKindOfClass:[UITextView class]]) {
                    weakSelf.textView = (UITextView *)view;
//                    [weakSelf.iflyHelper speech];
                    break;
                }
            }
        };
        _qualityInspectionView.imagesView.block = ^(CGFloat oldHeight, CGFloat newHeight) {
            weakSelf.infoScrollView.contentSize = CGSizeMake(0, 460 + newHeight);
            weakSelf.infoScrollView.subviews.firstObject.frame = CGRectMake(0, 0, kScreen_Width, 460 + newHeight);
        };
    }
    return _qualityInspectionView;
}

- (DocumentTabView *)tabView {
    if (!_tabView) {
        __weak typeof(self) weakSelf = self;
        NSArray *titles = @[@"基本信息", @"回复记录"];
        
        _tabView = [[DocumentTabView alloc] initWithFrame:CGRectMake(0, kStatusBarH + kNavBarH, kScreen_Width, tabHeight) titles:titles];
        _tabView.callBack = ^(NSInteger selectIndex) {
            [weakSelf.scrollView setContentOffset:CGPointMake(selectIndex * kScreen_Width, 0) animated:YES];
        };
    }
    return _tabView;
}

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        CGFloat height = kScreen_Height - kStatusBarH - kNavBarH - tabHeight;
        if (self.titles.count > 0) {
            height -= 35;
        }
    
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, kStatusBarH + kNavBarH + tabHeight, kScreen_Width, kScreen_Height - kStatusBarH - kNavBarH - tabHeight)];
        _scrollView.contentSize = CGSizeMake(kScreen_Width * 2, _scrollView.frame.size.height);
        _scrollView.delegate = self;
        _scrollView.pagingEnabled = YES;
        _scrollView.bounces = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
//        if (IS_IPhoneX_All) {
//            _scrollView.contentInset = UIEdgeInsetsMake(0, 0, -34, 0);
//        }
    }
    return _scrollView;
}

#pragma mark - 获取id
- (void)getPkId {
    __weak typeof(self) weakSelf = self;
    [[HttpManager manager] post:[UrlConfig URL:getQualityProblemId] param:nil success:^(NSData *data) {
        NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        self->_ID = [str stringByReplacingOccurrencesOfString:@"\"" withString:@""];
        weakSelf.qualityInspectionView.imagesView.markId = self->_ID;
        [weakSelf.qualityInspectionView.imagesView updateData];
    } faild:^(NSString *msg) {
//        [weakSelf getPkId];
    }];
}

#pragma mark - 点击事件
- (void)rightClicked:(UIBarButtonItem *)sender {
    __weak typeof(self) weakSelf = self;
    NSMutableArray <PopoverAction *>*actionArr = [NSMutableArray array];
    NSArray *titles;
    if (self.type == FunctionTypeQualityInspectionUnsubmitted) {
        titles = @[@"保存", @"提交"];
    } else if (self.type == FunctionTypeQualityInspectionWaitRectification) {
        titles = @[@"确认整改", @"回复"];
    } else if (self.type == FunctionTypeQualityInspectionWaitReview) {
        titles = @[@"复查确认", @"回复"];
    } else {
        titles = @[@"回复"];
    }
    for (NSString *title in titles) {
        PopoverAction *action = [PopoverAction actionWithTitle:title handler:^(PopoverAction *action) {
            if ([title isEqualToString:@"保存"]) {
                [weakSelf save:NO];
            } else if ([title isEqualToString:@"提交"]) {
                [weakSelf save:YES];
            } else if ([title isEqualToString:@"回复"]) {
                [weakSelf reply];
            } else {
                [weakSelf rectificationReview];
            }
        }];
        [actionArr addObject:action];
    }
    PopoverView *popoverView = [PopoverView popoverView];
    popoverView.showShade = YES; // 显示阴影背景
    popoverView.style = PopoverViewStyleDark; // 设置为黑色风格
    // 有两种显示方法
    [popoverView showToPoint:CGPointMake(kScreen_Width - 20, kStatusBarH + 44) withActions:actionArr];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    NSInteger index = (NSInteger)(scrollView.contentOffset.x / kScreen_Width);
    [self.tabView selectBtn:index];
}

#pragma mark - 语音协议
//- (void)onError:(IFlySpeechError *)error {
////    NSString *result = [self.iflyHelper onError:error];
//    NSString *str = self.textView.text;
//    if (str.length > 3) {
//        if ([[str substringToIndex:3] isEqualToString:@"请输入"]) {
//            str = @"";
//        }
//    }
//    self.textView.text = [NSString stringWithFormat:@"%@%@", str, result];
//}
//
//- (void)onResult:(NSArray *)resultArray isLast:(BOOL)isLast {
//    [self.iflyHelper onResult:resultArray isLast:isLast];
//}

#pragma mark - 右侧按钮处理
- (void)save:(BOOL)isSubmit {
//    if (!_ID) {
//
//    }
    
    NSDictionary *dic = [_qualityInspectionView params];
    if (dic) {
        __weak typeof(self) weakSelf = self;
        NSMutableDictionary *param = [NSMutableDictionary dictionaryWithDictionary:dic];
//        [params setValuesForKeysWithDictionary:@{
//                                                 @"id":_ID,
//                                                 @"newFormFlag":_newFormFlag,
//                                                 @"projectId": [UserAgent DefaultAgent].projectId,
//                                                 @"sectId":[UserAgent DefaultAgent].sectionId,
//                                                 @"partId":[self.resourceTitle isEqualToString:@"质量问题"]?@"1":@"2"
//                                                 }];
        [SVProgressHUD showWithStatus:@"请求中..."];
        
        
        [param setValuesForKeysWithDictionary:@{
        @"id":_ID,
        @"newFormFlag":_newFormFlag,
        @"projectId": [UserAgent DefaultAgent].projectId,
        @"sectId":[UserAgent DefaultAgent].sectionId
        }];
        NSString *url = [UrlConfig URL:saveQualityProblem];
        if ([self.resourceTitle isEqualToString:@"环保问题整改"]) {
            url = [UrlConfig URL:saveGreeProblem];
        }else if ([self.resourceTitle isEqualToString:@"水保巡查整改"]) {
            url = [UrlConfig URL:saveGreeWaterProblem];
        }else if ([self.resourceTitle isEqualToString:@"安全隐患"]||[self.resourceTitle isEqualToString:@"安全检查"]) {
            url = [UrlConfig URL:saveRisk];
        }else{
            [param setValue:[self.resourceTitle isEqualToString:@"质量问题"]?@"1":@"2" forKey:@"partId"];
        }
        
        
        
        [[HttpManager manager] post:url param:param success:^(NSData *data) {
            if ([ResponseUtils success:data]) {
                self->_newFormFlag = @"0";
                [weakSelf saveFiles:[ResponseUtils getData:@"data"] isSubmit:isSubmit isReform:dic[@"isReform"]];
            } else {
                [SVProgressHUD showErrorWithStatus:[ResponseUtils getMsg]];
            }
        } faild:^(NSString *msg) {
            [SVProgressHUD showErrorWithStatus:msg];
        }];
    }
}

- (void)submit {
    __weak typeof(self) weakSelf = self;
    
    NSString *url = [UrlConfig URL:commitQualityProblem];
    if([self.resourceTitle isEqualToString:@"环保问题整改"]){
        url = [UrlConfig URL:commitGreeProblem];
    }else if ([self.resourceTitle isEqualToString:@"水保巡查整改"]) {
        url = [UrlConfig URL:commitGreeWaterProblem];
    }else if ([self.resourceTitle isEqualToString:@"安全隐患"]||[self.resourceTitle isEqualToString:@"安全检查"]) {
        url = [UrlConfig URL:commitRisk];
    }
    
    [[HttpManager manager] post:url param:@{@"id":_ID} success:^(NSData *data) {
        if ([ResponseUtils success:data]) {
            [SVProgressHUD showInfoWithStatus:@"提交成功!"];
            NSDictionary *dic = [weakSelf.qualityInspectionView params];
            if ([dic[@"reformUserName"] isEqualToString:[AppUser sharedInstance].name]) {
                weakSelf.type = FunctionTypeQualityInspectionWaitRectification;
                [weakSelf setupMultipleUI:YES];
            } else {
                [weakSelf.navigationController popViewControllerAnimated:YES];
            }
        } else {
            [SVProgressHUD showErrorWithStatus:[ResponseUtils getMsg]];
        }
    } faild:^(NSString *msg) {
        [SVProgressHUD showErrorWithStatus:msg];
    }];
}

- (void)rectificationReview {
    __weak typeof(self) weakSelf = self;
    QualityInspectionPopView *popView = [[QualityInspectionPopView alloc] init];
    popView.type = self.type;
    popView.controller = self;
    popView.id = _ID;
    popView.resourceTitle = self.resourceTitle;
    popView.block = ^(BOOL reviewSuccess) {
        if (weakSelf.type == FunctionTypeQualityInspectionWaitReview) {
            if (reviewSuccess) {
                weakSelf.type = FunctionTypeQualityInspectionFinished;
            } else {
                weakSelf.type = FunctionTypeQualityInspectionWaitRectification;
            }
        } else {
            weakSelf.type = FunctionTypeQualityInspectionWaitReview;
        }
        [self.navigationController popViewControllerAnimated:YES];
        [self->_replyVC.tableView.mj_header beginRefreshing];
    };
    [popView show];
}

- (void)reply {
    QualityInspectionPopView *popView = [[QualityInspectionPopView alloc] init];
    popView.resourceTitle = self.resourceTitle;
    popView.type = FunctionTypeQualityInspectionUnsubmitted;
    popView.controller = self;
    popView.id = _ID;
    popView.block = ^(BOOL reviewSuccess) {
        [self->_replyVC.tableView.mj_header beginRefreshing];
    };
    [popView show];
}

#pragma mark - 保存图片
- (void)saveFiles:(NSString *)markId isSubmit:(BOOL)isSubmit isReform:(NSString *)isReform {
    NSMutableArray <BIMFile *>*files = [NSMutableArray array];
    [files addObjectsFromArray:[self.qualityInspectionView.imagesView addFiles]];
    if (files.count == 0) {
        if (isSubmit) {
//            if ([isReform isEqualToString:@"1"]) {
                [self submit];
//            } else {
//                [SVProgressHUD showInfoWithStatus:@"不需要整改，无需提交!"];
//            }
        } else {
            [SVProgressHUD showInfoWithStatus:@"保存成功!"];
            [self.navigationController popViewControllerAnimated:YES];
        }
    } else {
        if (_batchRequest) {
            [_batchRequest stop];
        }
        
        int x = arc4random() % 1000000;
        
        NSMutableArray <YTKRequest *>*requests = [NSMutableArray array];
        for (BIMFile *file in files) {
            ApiImageUpload *api = [[ApiImageUpload alloc] initWithImageData:file.data fileName:[NSString stringWithFormat:@"%d.jpg", x++] markId:markId];
            if (api) {
                [requests addObject:api];
            }
        }
        
        __weak typeof(self) weakSelf = self;
        _batchRequest = [[YTKBatchRequest alloc] initWithRequestArray:requests];
        [_batchRequest startWithCompletionBlockWithSuccess:^(YTKBatchRequest * _Nonnull batchRequest) {
            if (isSubmit) {
                if ([isReform isEqualToString:@"1"]) {
                    [self submit];
                } else {
                    [SVProgressHUD showInfoWithStatus:@"不需要整改，无需提交!"];
                }
            } else {
                [SVProgressHUD showInfoWithStatus:@"保存成功!"];
            }
//            [weakSelf.qualityInspectionView.imagesView updateData];
            [weakSelf.navigationController popViewControllerAnimated:YES];
        } failure:^(YTKBatchRequest * _Nonnull batchRequest) {
            if (isSubmit) {
                if ([isReform isEqualToString:@"1"]) {
                    [self submit];
                } else {
                    [SVProgressHUD showInfoWithStatus:@"不需要整改，无需提交!"];
                }
            } else {
                [SVProgressHUD showInfoWithStatus:@"保存成功!"];
            }
            [weakSelf.navigationController popViewControllerAnimated:YES];
        }];
    }
}

@end
