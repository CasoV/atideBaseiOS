//
//  DetailLoanVc.m
//  PMPlatform_IOS
//
//  Created by 高小伟 on 2018/11/9.
//  Copyright © 2018 com.atide. All rights reserved.
//

#import "DetailLoanVc.h"
#import "FlowApprovalCommentView.h"
#import "DocumentRcvModel.h"
#import "OrgListModel.h"
#import "AnnexModel.h"
#import "AnnexView.h"
#import "FlowApprovalToolBar.h"
#import "FileBrowsingController.h"
#import "FlowManagermentFactory.h"
#import <Masonry/Masonry.h>
#import "SealTypeModel.h"
#import "FDCalendarView.h"
#import "LoanSealModel.h"
#import "LoanTypeModel.h"

@interface DetailLoanVc ()


@property (weak, nonatomic) IBOutlet UIScrollView *firstScrollView;
@property (weak, nonatomic) IBOutlet UIView *secondView;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedControl2;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *content3Height;

@property (weak, nonatomic) IBOutlet UITextField *orgNameTf;
@property (weak, nonatomic) IBOutlet UITextField *fillerNameTf;
@property (weak, nonatomic) IBOutlet UITextField *appliReasonTf;
@property (weak, nonatomic) IBOutlet UIButton *loanDateBtn;
@property (weak, nonatomic) IBOutlet UIButton *estiReturnDateBtn;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *sealTypeHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *loanTypeHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *loanTypeTop;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *sealIdTitleHeight;

@property (weak, nonatomic) IBOutlet FlowApprovalCommentView *commentView;
@property (weak, nonatomic) IBOutlet UIView *sealTypesView;
@property (weak, nonatomic) IBOutlet UIView *loanTypesView;

@property (weak, nonatomic) IBOutlet UIView *returnView;
@property (weak, nonatomic) IBOutlet UITextField *returnManTf;
@property (weak, nonatomic) IBOutlet UIButton *actualReturnDateBtn;

@property (nonatomic, strong) UISegmentedControl *segmentedControl;
@property (nonatomic, strong) NSMutableArray *sealTypeSelect;
@property (nonatomic, strong) NSMutableArray *loanTypeSelect;
@property (nonatomic, strong) LoanSealModel *model;
@end
@implementation DetailLoanVc {
    NSArray <OrgListModel *>*_orgModels;
    CGFloat _bottomViewHeight;
    BOOL _isFlow;
    NSArray <SealTypeModel *>*_bizTypeArr;
    NSArray <LoanTypeModel *>*_loanTypeArr;
    LoanSealModel *_model;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _isFlow = NO;
    if (self.ID)[self loadData:NO];
    else{
        _model = [LoanSealModel new];
        [self setupUI];
        [self loadSvNavBar];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (_isFlow) {
        _isFlow = !_isFlow;
        [self.view bringSubviewToFront:self.firstScrollView];
        if (self.ID)[self loadData:NO];
        else{
            _model = [LoanSealModel new];
            [self setupUI];
            [self loadSvNavBar];
        }
    }
}

- (IBAction)chooseLoanDate:(id)sender {
    [self showDate:sender minDate:nil];
}
- (IBAction)chooseEstiReturnDate:(id)sender {
    [self showDate:sender minDate:nil];
}
- (IBAction)chooseActualReturnDate:(id)sender {
    [self showDate:sender minDate:nil];
}

-(void)loadSvNavBar{
    UIBarButtonItem *saveButton = [[UIBarButtonItem alloc]initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(save:)];
    [self.navigationItem setRightBarButtonItems:[NSArray arrayWithObjects: saveButton,nil]];
}
#pragma mark - 加载数据
- (void)loadData:(BOOL)loadOther {
    NSString *url;
    url = [UrlConfig URL:querySealLoanInfo];
    //加载基本信息数据
    [[HttpManager manager] post:url param:@{@"id":self.ID} success:^(NSData *data) {
        [MBManager hideAlert];
        if ([ResponseUtils success:data]) {
            _model = [LoanSealModel mj_objectWithKeyValues:[ResponseUtils getData:@"data"]];
            if (_model) {
                self.ID = _model.id;
                [self setupUI];
                [self setupModel];
                [self loadToolBar];
            }
        } else {
            [MBManager showBriefAlert:[ResponseUtils getMsg]];
        }
    } faild:^(NSString *msg) {
        [MBManager hideAlert];
        [MBManager showBriefAlert:msg];
    }];
}
/**
 获取外借印章类型列表
 */
-(void)LoadSealList{
    NSMutableArray *arr = [NSMutableArray array];
    for (SealTypeModel *model in self.sealTypeSelect ) {
        [arr addObject:model.id];
    }
    [[HttpManager manager] post:[UrlConfig URL:querySealList] param:@{@"jsonSealTypes":[arr componentsJoinedByString:@","],@"userId":@""} success:^(NSData *data) {
        [MBManager hideAlert];
        NSString *receiveStr = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        NSData * datas = [receiveStr dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:datas options:NSJSONReadingMutableLeaves error:nil];
        _loanTypeArr = [LoanTypeModel mj_objectArrayWithKeyValuesArray:jsonDict[@"rows"]];
        [self initLoanTypeView];

    } faild:^(NSString *msg) {
        [MBManager hideAlert];
        [MBManager showBriefAlert:msg];
    }];
    
}
-(void)initLoanTypeView{
    for (UIView *v in self.loanTypesView.subviews) {
        [v removeFromSuperview];
    }
    [self.loanTypeSelect removeAllObjects];
    self.loanTypeHeight.constant = _loanTypeArr.count * 30;
    self.sealIdTitleHeight.constant = _loanTypeArr.count * 30/2 - 15;
    NSArray *modelTypes = [_model.sealId componentsSeparatedByString:@","];
    int count = 0;
    for (LoanTypeModel *model in _loanTypeArr) {
        UIButton *typeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        typeBtn.frame = CGRectMake(0, count*30, self.loanTypesView.frame.size.width, 30);
        typeBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [typeBtn setTitle:model.name forState:UIControlStateNormal];
        [typeBtn setTitleColor:[UIColor colorWithRed:139/255.0 green:139/255.0 blue:141/255.0 alpha:1.0]forState:UIControlStateNormal];
        typeBtn.titleLabel.font=[UIFont systemFontOfSize:12];
        [typeBtn addTarget:self action:@selector(loantypeSelect:) forControlEvents:UIControlEventTouchUpInside];
        typeBtn.selected = [modelTypes indexOfObject:model.id] != NSNotFound && modelTypes;
        typeBtn.tag = 300 + count;
        [self.loanTypesView addSubview:typeBtn];
        
        UIImageView *imgV = [[UIImageView alloc]initWithFrame:CGRectMake(self.loanTypesView.frame.size.width - 44, 5 + 30 *count, 20, 20)];
        imgV.image =  [modelTypes indexOfObject:model.id] != NSNotFound && modelTypes ? [UIImage imageNamed:@"square_selected"] : [UIImage imageNamed:@"square_select"];
        imgV.tag = 400 + count;
        [self.loanTypesView addSubview:imgV];
        if ([modelTypes indexOfObject:model.id] != NSNotFound && modelTypes) {
            [self.loanTypeSelect addObject:model];
        }
        count ++;
    }
    
}
-(void)loantypeSelect:(UIButton *)btn{
    btn.selected = !btn.selected;
    UIImageView *imgSeV = (UIImageView *)[self.loanTypesView viewWithTag:btn.tag + 100];
    imgSeV.image = btn.selected ? [UIImage imageNamed:@"square_selected"] : [UIImage imageNamed:@"square_select"];
    LoanTypeModel *model = _loanTypeArr[btn.tag - 300];
    NSArray *modelTypes = [_model.sealId componentsSeparatedByString:@","];
    if ([modelTypes indexOfObject:model.id] != NSNotFound && modelTypes) {
        [self.loanTypeSelect removeObject:model];
    }else{
        [self.loanTypeSelect addObject:model];
    }
    NSMutableArray *arr = [NSMutableArray array];
    for (LoanTypeModel *model in self.loanTypeSelect) {
        [arr addObject:model.id];
    }
    _model.sealId = [arr componentsJoinedByString:@","];
}
#pragma mark - 初始化界面
- (void)setupUI {
    _orgModels = @[];
    _bottomViewHeight = 50;
    
    NSArray *strArr;
    self.segmentedControl2.selectedSegmentIndex = 0;
    strArr = @[@"基本信息", @"审核信息"];
    [self content3ValueChanged:self.segmentedControl2];
    if (_segmentedControl) {
        [_segmentedControl removeFromSuperview];
    }
    
    CGFloat y = kDevice_Is_iPhoneX ? 44 + 49 : 20 + 49;
    
    _segmentedControl = [[UISegmentedControl alloc] initWithItems:strArr];
    _segmentedControl.frame = CGRectMake(10, y, (ScreenWidth < ScreenHeight ? ScreenWidth : ScreenHeight) - 20, 28);
    _segmentedControl.selectedSegmentIndex = 0;
    [_segmentedControl addTarget:self action:@selector(segmentedControlChanged:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:_segmentedControl];
    
    self.firstScrollView.layer.borderColor = [UIColor hex:@"999999"].CGColor;
    self.firstScrollView.layer.borderWidth = 1;
    self.firstScrollView.layer.cornerRadius = 7;
    
    if (!self.ID) {
        self.orgNameTf.text =  [UserInfo getInstance].name;
        self.fillerNameTf.text = [UserInfo getInstance].orgName;
    }
    
    [[HttpManager manager] get:[UrlConfig URL:getEasyuiCombobox] param:@{@"key":@"sealType"} success:^(NSData *data) {
        _bizTypeArr = [SealTypeModel mj_objectArrayWithKeyValuesArray:data];
        [self initTypeView];
        [self LoadSealList];
        
    } faild:^(NSString *msg) {
        [MBManager showBriefAlert:msg];
    }];
}

- (void)setupModel {
    
    self.orgNameTf.text = self.model.orgName;
    self.fillerNameTf.text = self.model.fillerName;
    self.appliReasonTf.text = self.model.appliReason;
    [self.loanDateBtn setTitle:self.model.loanDate forState:UIControlStateNormal];
    [self.estiReturnDateBtn setTitle:self.model.estiReturnDate forState:UIControlStateNormal];
    self.loanDateBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    self.estiReturnDateBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    self.actualReturnDateBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;

    
//
//    CGFloat width = ScreenWidth - 96;
//    CGSize size = [self.model.remark boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12.f]} context:nil].size;
//    if (size.height + 10 < 30) {
//        self.remarkHeight.constant = 30;
//    }else {
//        self.remarkHeight.constant = size.height + 10;
//    }
    [FlowManagermentFactory config:self.navigationController symbol:@"" update:nil];
    [self updateConstraint1];
    [self loadToolBar];
}
-(void)initTypeView{
    self.sealTypeHeight.constant = _bizTypeArr.count * 30;
    NSArray *modelTypes = [_model.sealType componentsSeparatedByString:@","];
    int count = 0;
    for (SealTypeModel *model in _bizTypeArr) {
        UIButton *typeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        typeBtn.frame = CGRectMake(0, count*30, self.sealTypesView.frame.size.width, 30);
        typeBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [typeBtn setTitle:model.text forState:UIControlStateNormal];
        [typeBtn setTitleColor:[UIColor colorWithRed:139/255.0 green:139/255.0 blue:141/255.0 alpha:1.0]forState:UIControlStateNormal];
        typeBtn.titleLabel.font=[UIFont systemFontOfSize:12];
        [typeBtn addTarget:self action:@selector(typeSelect:) forControlEvents:UIControlEventTouchUpInside];
        typeBtn.selected = [modelTypes indexOfObject:model.id] != NSNotFound && modelTypes;
        typeBtn.tag = 100 + count;
        [self.sealTypesView addSubview:typeBtn];
        
        UIImageView *imgV = [[UIImageView alloc]initWithFrame:CGRectMake(self.sealTypesView.frame.size.width - 44, 5 + 30 *count, 20, 20)];
        imgV.image =  [modelTypes indexOfObject:model.id] != NSNotFound  && modelTypes? [UIImage imageNamed:@"square_selected"] : [UIImage imageNamed:@"square_select"];
        imgV.tag = 200 + count;
        [self.sealTypesView addSubview:imgV];
        if ([modelTypes indexOfObject:model.id] != NSNotFound && modelTypes) {
            [self.sealTypeSelect addObject:model];
        }
        count ++;
    }
    
}
-(void)typeSelect:(UIButton *)btn{
    btn.selected = !btn.selected;
    UIImageView *imgSeV = (UIImageView *)[self.sealTypesView viewWithTag:btn.tag + 100];
    imgSeV.image = btn.selected ? [UIImage imageNamed:@"square_selected"] : [UIImage imageNamed:@"square_select"];
    SealTypeModel *model = _bizTypeArr[btn.tag - 100];
    NSArray *modelTypes = [_model.sealType componentsSeparatedByString:@","];
    if ([modelTypes indexOfObject:model.id] != NSNotFound && modelTypes) {
        [self.sealTypeSelect removeObject:model];

    }else{
        [self.sealTypeSelect addObject:model];
    }
    NSMutableArray *arr = [NSMutableArray array];
    for (SealTypeModel *model in self.sealTypeSelect) {
        [arr addObject:model.id];
    }
    _model.sealType = [arr componentsJoinedByString:@","];
    [self LoadSealList];
}
#pragma mark - 获取工具栏
- (void)loadToolBar {
    FlowApprovalToolBar *toolBar = [[FlowApprovalToolBar alloc] init];
    if (self.bizKey == nil) {
        self.bizKey = @"use_seal_approval_inner";
        
    }
    [toolBar request:self.ID bizKey:self.bizKey callback:^(NSArray<Panel *> *items) {
        if (items) {
            NSMutableArray <Panel *>*arr = [NSMutableArray array];
            for (Panel *item in items) {
                if (![item.content isEqualToString:@"办理过程"]) {
                    [arr addObject:item];
                }
                if ([item.content isEqualToString:@"归还"]) {
                    self.returnView.hidden = NO;
                    self.returnManTf.text = _model.returnMan;
                    [self.actualReturnDateBtn setTitle:_model.actualReturnDate forState:UIControlStateNormal];
                }
            }
            [arr addObject:[[Panel alloc] init:@"button-process" text:@"办理过程" icon:@""]];
            
            [self showRightButton:arr];
        }
    }];
}

- (void)save:(UIBarButtonItem *)sender {
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    
    [param setObject:self.fillerNameTf.text forKey:@"fillerName"];
    [param setObject:self.appliReasonTf.text forKey:@"appliReason"];
    [param setObject:self.orgNameTf.text forKey:@"orgName"];
    if(_model.sealType)[param setObject:_model.sealType forKey:@"sealType"];

    if(self.loanDateBtn.currentTitle) [param setObject:self.loanDateBtn.currentTitle forKey:@"loanDate"];
    if(self.estiReturnDateBtn.currentTitle) [param setObject:self.estiReturnDateBtn.currentTitle forKey:@"estiReturnDate"];
    
    if (self.ID)  [param setObject:self.ID forKey:@"id"];
    if (self.ID)  [param setObject:@"2" forKey:@"newFormFlag"];
    else  [param setObject:@"1" forKey:@"newFormFlag"];

    if(_model.sealId)[param setObject:_model.sealId forKey:@"sealId"];
    if([sender.title isEqualToString:@"保存"]){
        [[HttpManager manager]post:[UrlConfig URL:saveSealLoan] param:param success:^(NSData *data) {
            if ([ResponseUtils success:data]) {
                [self.navigationController popViewControllerAnimated:YES];
                [MBManager showBriefAlert:@"保存成功"];
            } else {
                [MBManager showBriefAlert:[ResponseUtils getMsg]];
            }
        } faild:^(NSString *msg) {
            [MBManager showBriefAlert:@"保存失败"];
        }];
    }else{
        if(self.actualReturnDateBtn.currentTitle) [param setObject:self.loanDateBtn.currentTitle forKey:@"actualReturnDate"];
        [param setObject:self.returnManTf.text forKey:@"returnMan"];
        [param setObject:@"4" forKey:@"status"];
        [[HttpManager manager]post:[UrlConfig URL:saveSealLoan] param:param success:^(NSData *data) {
            if ([ResponseUtils success:data]) {
                [self.navigationController popViewControllerAnimated:YES];
                [MBManager showBriefAlert:@"归还成功"];
            } else {
                [MBManager showBriefAlert:[ResponseUtils getMsg]];
            }
        } faild:^(NSString *msg) {
            [MBManager showBriefAlert:@"归还失败"];
        }];
    }

}

#pragma mark - 更新约束
- (void)updateConstraint1 {
    self.contentHeight.constant = self.sealTypeHeight.constant +  self.loanTypeHeight.constant + 330 + _bottomViewHeight;
}

#pragma mark - 点击事件
- (void)segmentedControlChanged:(UISegmentedControl *)sender {
    switch (sender.selectedSegmentIndex) {
        case 0:
            [self.view bringSubviewToFront:self.firstScrollView];
            break;
        case 1:
            [self.view bringSubviewToFront:self.secondView];
            break;
            
            break;
    }
}

#pragma mark - 显示日期选择器
- (void)showDate:(UIButton *)textUI minDate:(NSString *)minDate {
    NSDate *minimumDate = nil;
    if (minDate) {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.locale = [NSLocale currentLocale];
        formatter.timeZone = [NSTimeZone localTimeZone];
        formatter.dateFormat = @"yyyy-MM-dd";
        minimumDate = [formatter dateFromString:minDate];
    }
    
    NSString *dateStr = textUI.currentTitle;
    FDCalendarView *calendarView = [[FDCalendarView alloc] initWithFrame:[UIScreen mainScreen].bounds andCurrentDateStr:dateStr minimumDate:minimumDate datePickerMode:UIDatePickerModeDate];
    [[UIApplication sharedApplication].keyWindow addSubview:calendarView];
    calendarView.block = ^(NSDate *date) {
        if (date){
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            formatter.locale = [NSLocale currentLocale];
            formatter.timeZone = [NSTimeZone localTimeZone];
            formatter.dateFormat = @"yyyy-MM-dd";
            [textUI setTitle:[formatter stringFromDate:date] forState:UIControlStateNormal];
        }
    };
    [calendarView fadeIn];
}


- (IBAction)content3ValueChanged:(UISegmentedControl *)sender {
    __weak typeof(self) weakself = self;
    if (self.ID) {
        [self.commentView request:self.ID type:sender.selectedSegmentIndex callback:^(CGFloat height) {
            weakself.content3Height.constant = height;
        }];
    }
}


- (void)rightButtonItemClick:(Panel *)item {
    if (_model) {
        _isFlow = YES;
        if ([item.ID isEqualToString:@"button-revoke"]) {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"确认撤回？" preferredStyle:UIAlertControllerStyleAlert];
            [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
            [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [MBManager showLoading];
                [[HttpManager manager] post:[UrlConfig URL:sealRevokeTask] param:@{@"bizPk":self.ID,@"userId":@""} success:^(NSData *data) {
                    [MBManager hideAlert];
                    if ([ResponseUtils success:data]) {
                        [MBManager showBriefAlert:@"撤回成功"];
                    } else {
                        [MBManager showBriefAlert:[ResponseUtils getMsg]];
                    }
                    [self loadToolBar];
                } faild:^(NSString *msg) {
                    [MBManager hideAlert];
                    [MBManager showBriefAlert:msg];
                    [self loadToolBar];
                }];
            }]];
            [self presentViewController:alert animated:YES completion:nil];
        } else if ([item.ID isEqualToString:@"button-result"]) {
//            [FlowManagermentFactory factory:item bizPk:self.bizKey instanceId:self.ID];
        }else {
//            [FlowManagermentFactory factory:item bizPk:self.bizKey instanceId:self.ID];
        }
        if ([item.ID isEqualToString:@"button-process"]) {
            _isFlow = NO;
        }
    }
}
#pragma LazyLoad
-(NSMutableArray *)sealTypeSelect{
    if (!_sealTypeSelect) {
        _sealTypeSelect = [NSMutableArray new];
    }
    return _sealTypeSelect;
}
-(NSMutableArray *)loanTypeSelect{
    if (!_loanTypeSelect) {
        _loanTypeSelect = [NSMutableArray new];
    }
    return _loanTypeSelect;
}

@end
