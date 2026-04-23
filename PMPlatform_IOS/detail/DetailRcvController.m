//
//  DetailRcvController.m
//  PMPlatform_IOS
//
//  Created by 末末班车 on 2017/9/8.
//  Copyright © 2017年 com.atide. All rights reserved.
//

#import "DetailRcvController.h"
#import "FlowApprovalCommentView.h"
#import "DocumentRcvModel.h"
#import "OrgListModel.h"
#import "AnnexModel.h"
#import "AnnexView.h"
#import "FlowApprovalToolBar.h"
#import "FileBrowsingController.h"
#import "FlowManagermentFactory.h"
#import <Masonry/Masonry.h>

@interface DetailRcvController ()

@property (weak, nonatomic) IBOutlet UIScrollView *firstScrollView;
@property (weak, nonatomic) IBOutlet UIScrollView *secondScrollView;
@property (weak, nonatomic) IBOutlet UIView *thirdView;

@property (nonatomic, strong) UISegmentedControl *segmentedControl;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *content2Height;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *content3Height;

@property (weak, nonatomic) IBOutlet UILabel *sendCode;
@property (weak, nonatomic) IBOutlet UILabel *sendCodeLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *itemTypeName;
@property (weak, nonatomic) IBOutlet UILabel *originOrg;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *secretLevel;
@property (weak, nonatomic) IBOutlet UILabel *urgency;
@property (weak, nonatomic) IBOutlet UILabel *orgName;
@property (weak, nonatomic) IBOutlet UILabel *rcvTime;
@property (weak, nonatomic) IBOutlet UILabel *summary;
@property (weak, nonatomic) IBOutlet UILabel *fileTypeLabel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *summaryHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleHeight;

@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet UILabel *label1;
@property (weak, nonatomic) IBOutlet UILabel *label2;
@property (weak, nonatomic) IBOutlet UILabel *label3;
@property (weak, nonatomic) IBOutlet UILabel *label4;

@property (weak, nonatomic) IBOutlet UILabel *tipLabel;
@property (weak, nonatomic) IBOutlet UIImageView *docImageView;
@property (weak, nonatomic) IBOutlet UILabel *docLabel;
@property (weak, nonatomic) IBOutlet UIView *annexViews;

@property (weak, nonatomic) IBOutlet FlowApprovalCommentView *commentView;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedControl3;

@end

@implementation DetailRcvController {
    DocumentRcvModel *_model;
    NSArray <OrgListModel *>*_orgModels;
    CGFloat _bottomViewHeight;
    BOOL _isFlow;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _isFlow = NO;
    [self loadData:YES];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (_isFlow) {
        _isFlow = !_isFlow;
        [MBManager showLoading];
        [self.view bringSubviewToFront:self.firstScrollView];
        [self loadData:NO];
    }
}

#pragma mark - 加载数据
- (void)loadData:(BOOL)loadOther {
    NSString *url;
    if (self.searchType == SearchTypeRcvPublicity) {
        url = [UrlConfig URL:queryRcvInfo];
    }else {
        url = [UrlConfig URL:queryRcvDealInfo];
    }
    
    //加载基本信息数据
    [[HttpManager manager] post:url param:@{@"dealId":self.dealID, @"id":self.dealID} success:^(NSData *data) {
        [MBManager hideAlert];
        if ([ResponseUtils success:data]) {
            [DocumentRcvModel mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
                return @{@"ID":@"id"};
            }];
            _model = [DocumentRcvModel mj_objectWithKeyValues:[ResponseUtils getData:@"data"]];
            if (_model) {
                self.ID = _model.ID;
                if (self.searchType != SearchTypeRcvPublicity && ![_model.originType isEqualToString:@"3"]) {
                    [FlowManagermentFactory config:self.navigationController symbol:@"" update:nil];
                    [self loadToolBar];
                }
                [self setupUI];
                [self setupModel];
                if (loadOther) {
                    [self loadOtherData];
                }
            }
        } else {
            [MBManager showBriefAlert:[ResponseUtils getMsg]];
        }
    } faild:^(NSString *msg) {
        [MBManager hideAlert];
        [MBManager showBriefAlert:msg];
    }];
}

- (void)loadOtherData {
    if(!self.ID)return;
    //加载项目单位数组
    [[HttpManager manager] post:[UrlConfig URL:queryRcvOrgList] param:@{@"docRcvId":self.ID} success:^(NSData *data) {
        [DataCollection mj_setupObjectClassInArray:^NSDictionary *{
            return @{@"rows":@"OrgListModel"};
        }];
        DataCollection *result = [DataCollection mj_objectWithKeyValues:data];
        if (result != nil && result.rows != nil) {
            _orgModels = (NSArray <OrgListModel *>*)result.rows;
            [self setupOrgModel];
        }
    } faild:^(NSString *msg) {
        [MBManager showBriefAlert:msg];
    }];
    
    //加载附件
    [[HttpManager manager] post:[UrlConfig URL:getFileListByBizPk] param:@{@"bizPk":self.ID} success:^(NSData *data) {
        if ([ResponseUtils success:data]) {
            [AnnexModel mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
                return @{@"ID":@"id"};
            }];
            NSArray <AnnexModel *>*models = [AnnexModel mj_objectArrayWithKeyValuesArray:[ResponseUtils getData:@"data"]];
            if (models != nil) {
                [self setupAnnexModel:models];
            }
        }else {
            [MBManager showBriefAlert:[ResponseUtils getMsg]];
        }
    } faild:^(NSString *msg) {
        [MBManager showBriefAlert:msg];
    }];
}

#pragma mark - 初始化界面
- (void)setupUI {
    _orgModels = @[];
    _bottomViewHeight = 50;
    
    NSArray *strArr;
    self.segmentedControl3.selectedSegmentIndex = 0;
    if (self.searchType == SearchTypeRcvPublicity || [_model.originType isEqualToString:@"3"]) {
        strArr = @[@"基本信息", @"公文及附件"];
    }else {
        strArr = @[@"基本信息", @"公文及附件", @"审核信息"];
        [self content3ValueChanged:self.segmentedControl3];
    }
    if (_segmentedControl) {
        [_segmentedControl removeFromSuperview];
    }
    
    CGFloat y = kDevice_Is_iPhoneX ? 44 + 49 : 20 + 49;
    
    _segmentedControl = [[UISegmentedControl alloc] initWithItems:strArr];
    _segmentedControl.frame = CGRectMake(10, y, ScreenWidth - 20 , 28);
    _segmentedControl.selectedSegmentIndex = 0;
    [_segmentedControl addTarget:self action:@selector(segmentedControlChanged:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:_segmentedControl];
    
    self.firstScrollView.layer.borderColor = [UIColor hex:@"999999"].CGColor;
    self.firstScrollView.layer.borderWidth = 1;
    self.firstScrollView.layer.cornerRadius = 7;
    
    self.secondScrollView.layer.borderColor = [UIColor hex:@"999999"].CGColor;
    self.secondScrollView.layer.borderWidth = 1;
    self.secondScrollView.layer.cornerRadius = 7;
    
    self.thirdView.layer.borderColor = [UIColor hex:@"999999"].CGColor;
    self.thirdView.layer.borderWidth = 1;
    self.thirdView.layer.cornerRadius = 7;
    
    self.label1.layer.borderWidth = 0.5;
    self.label1.layer.borderColor = [UIColor hex:@"999999"].CGColor;
    self.label2.layer.borderWidth = 0.5;
    self.label2.layer.borderColor = [UIColor hex:@"999999"].CGColor;
    self.label3.layer.borderWidth = 0.5;
    self.label3.layer.borderColor = [UIColor hex:@"999999"].CGColor;
    self.label4.layer.borderWidth = 0.5;
    self.label4.layer.borderColor = [UIColor hex:@"999999"].CGColor;
}

- (void)setupModel {
    self.sendCode.text = _model.sendCode;
    self.sendCodeLabel.text = _model.sendCode;
    self.titleLabel.text = _model.title;
    self.itemTypeName.text = _model.docNatrueName;
    self.fileTypeLabel.text = _model.itemTypeName;
    self.originOrg.text = _model.originOrg;
    self.name.text = _model.rcvUserName;
    self.nameLabel.text = _model.rcvUserName;
    self.secretLevel.text = [SearchFactory getSecretLevelTypeName:_model.secretLevel.integerValue];
    self.urgency.text = [SearchFactory getUrgencyTypeName:_model.urgency.integerValue];
    self.orgName.text = _model.rcvOrgName;
    self.rcvTime.text = _model.rcvTime;
    self.summary.text = _model.summary;
    
    CGFloat width = ScreenWidth - 96;
    CGSize size = [_model.title boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12.f]} context:nil].size;
    if (size.height + 10 < 30) {
        self.titleHeight.constant = 30;
    }else {
        self.titleHeight.constant = size.height + 10;
    }
    
    size = [_model.summary boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12.f]} context:nil].size;
    if (size.height + 10 < 30) {
        self.summaryHeight.constant = 30;
    }else {
        self.summaryHeight.constant = size.height + 10;
    }
    
    [self updateConstraint1];
    
    self.docLabel.text = _model.title;
    self.docImageView.image = [self chooseDocImage:[_model.fileName componentsSeparatedByString:@"."].lastObject];
}

- (void)setupOrgModel {
    CGRect frame1 = self.label1.frame;
    CGRect frame2 = self.label2.frame;
    CGRect frame3 = self.label3.frame;
    CGRect frame4 = self.label4.frame;
    
    for (OrgListModel *model in _orgModels) {
        CGFloat rowHeight;
        CGSize size = [model.orgName boundingRectWithSize:CGSizeMake(frame1.size.width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:11.f]} context:nil].size;
        if (size.height + 10 < 25) {
            rowHeight = 25;
        }else {
            rowHeight = size.height + 10;
        }
        
        frame1 = CGRectMake(frame1.origin.x, frame1.origin.y + frame1.size.height, frame1.size.width, rowHeight);
        frame2 = CGRectMake(frame2.origin.x, frame2.origin.y + frame2.size.height, frame2.size.width, rowHeight);
        frame3 = CGRectMake(frame3.origin.x, frame3.origin.y + frame3.size.height, frame3.size.width, rowHeight);
        frame4 = CGRectMake(frame4.origin.x, frame4.origin.y + frame4.size.height, frame4.size.width, rowHeight);
        
        UILabel *label1 = [[UILabel alloc] initWithFrame:frame1];
        label1.font = [UIFont systemFontOfSize:11];
        label1.numberOfLines = 0;
        label1.textAlignment = NSTextAlignmentCenter;
        label1.layer.borderWidth = 0.5;
        label1.layer.borderColor = [UIColor hex:@"999999"].CGColor;
        label1.text = model.orgName;
        [self.bottomView addSubview:label1];
        UILabel *label2 = [[UILabel alloc] initWithFrame:frame2];
        label2.font = [UIFont systemFontOfSize:11];
        label2.textAlignment = NSTextAlignmentCenter;
        label2.layer.borderWidth = 0.5;
        label2.layer.borderColor = [UIColor hex:@"999999"].CGColor;
        label2.text = model.codeName;
        [self.bottomView addSubview:label2];
        UILabel *label3 = [[UILabel alloc] initWithFrame:frame3];
        label3.font = [UIFont systemFontOfSize:11];
        label3.textAlignment = NSTextAlignmentCenter;
        label3.layer.borderWidth = 0.5;
        label3.layer.borderColor = [UIColor hex:@"999999"].CGColor;
        label3.text = model.year;
        [self.bottomView addSubview:label3];
        UILabel *label4 = [[UILabel alloc] initWithFrame:frame4];
        label4.font = [UIFont systemFontOfSize:11];
        label4.textAlignment = NSTextAlignmentCenter;
        label4.layer.borderWidth = 0.5;
        label4.layer.borderColor = [UIColor hex:@"999999"].CGColor;
        label4.text = model.sn;
        [self.bottomView addSubview:label4];
    }
    
    _bottomViewHeight = frame1.origin.y + frame1.size.height;
    
    [self updateConstraint1];
}

- (void)setupAnnexModel:(NSArray <AnnexModel *>*)annexModels {
    self.content2Height.constant = annexModels.count * 60 + 120;
    
    for (int i = 0; i < annexModels.count; i++) {
        AnnexView *annexView = [[AnnexView alloc] initWithFrame:CGRectMake(0, i * 60, ScreenWidth - 20, 60)];;
        [annexView loadDataModel:annexModels[i]];
        UITapGestureRecognizer *tapG = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(annexVIewClicked:)];
        [annexView addGestureRecognizer:tapG];
        [self.annexViews addSubview:annexView];
    }
    
    
    if (annexModels.count == 0) {
        self.tipLabel.hidden = NO;
    } else {
        self.tipLabel.hidden = YES;
    }
}

#pragma mark - 获取工具栏
- (void)loadToolBar {
    FlowApprovalToolBar *toolBar = [[FlowApprovalToolBar alloc] init];
    
    if (self.bizKey == nil) {
        if (self.searchType == SearchTypeRcvCirculated) {
            self.bizKey = @"doc_rcv_read";
        }else {
            self.bizKey = @"doc_rcv_deal";
        }
    }
    
    [toolBar request:self.dealID bizKey:self.bizKey callback:^(NSArray<Panel *> *items) {
        if (items) {
            NSMutableArray <Panel *>*arr = [NSMutableArray array];
            for (Panel *item in items) {
                if (![item.content isEqualToString:@"办理过程"]) {
                    [arr addObject:item];
                }
            }
            if (![_model.originType isEqualToString:@"3"]) {
                [arr addObject:[[Panel alloc] init:@"button-process" text:@"办理过程" icon:@""]];
            }
            [self showRightButton:arr];
        }
    }];
}

#pragma mark - 更新约束
- (void)updateConstraint1 {
    self.contentHeight.constant = self.titleHeight.constant + self.summaryHeight.constant + 330 + _bottomViewHeight;
}

#pragma mark - 点击事件
- (void)segmentedControlChanged:(UISegmentedControl *)sender {
    switch (sender.selectedSegmentIndex) {
        case 0:
            [self.view bringSubviewToFront:self.firstScrollView];
            break;
        case 1:
            [self.view bringSubviewToFront:self.secondScrollView];
            break;
        case 2:
            [self.view bringSubviewToFront:self.thirdView];
            break;
        default:
            break;
    }
}

- (void)annexVIewClicked:(UITapGestureRecognizer *)sender {
    AnnexView *annex = (AnnexView *)sender.view;
    
    NSString *path = [NSString stringWithFormat:@"%@/Documents/%@", NSHomeDirectory(), annex.model.originalName];
    if ([self checkDownload:annex.model.originalName]) {
        FileBrowsingController *vc = [[FileBrowsingController alloc] init];
        vc.filePath = path;
        [self.navigationController pushViewController:vc animated:YES];
    }else {
        [MBManager showLoading];
        [[HttpManager manager] post:[UrlConfig URL:fileDownload] param:@{@"id":annex.model.ID} success:^(NSData *data) {
            [MBManager hideAlert];
            if ([data writeToFile:path atomically:YES]) {
                FileBrowsingController *vc = [[FileBrowsingController alloc] init];
                vc.filePath = path;
                [self.navigationController pushViewController:vc animated:YES];
            }
        } faild:^(NSString *msg) {
            [MBManager hideAlert];
            [MBManager showBriefAlert:msg];
        }];
    }
}

- (IBAction)docViewClicked:(id)sender {
    if(!_model.fileName){
        [MBManager showBriefAlert:@"还未生成文件"];
        return;
    }
    
    NSString *path = [NSString stringWithFormat:@"%@/Documents/%@.pdf", NSHomeDirectory(), _model.ID];
    if ([self checkDownload:[NSString stringWithFormat:@"%@.pdf", _model.ID]]) {
        FileBrowsingController *vc = [[FileBrowsingController alloc] init];
        vc.filePath = path;
        [self.navigationController pushViewController:vc animated:YES];
    }else {
        [MBManager showLoading];
//        @{@"dealId":self.dealID}
        [[HttpManager manager] get:[NSString stringWithFormat:@"%@%@",[UrlConfig URL:fileDfsDownload],_model.fileName]  param:nil success:^(NSData *data) {
            [MBManager hideAlert];
            if ([data writeToFile:path atomically:YES]) {
                FileBrowsingController *vc = [[FileBrowsingController alloc] init];
                vc.filePath = path;
                [self.navigationController pushViewController:vc animated:YES];
            }
        } faild:^(NSString *msg) {
            [MBManager hideAlert];
            [MBManager showBriefAlert:msg];
        }];
    }
}
- (IBAction)content3ValueChanged:(UISegmentedControl *)sender {
    __weak typeof(self) weakself = self;
    [self.commentView request:self.dealID type:sender.selectedSegmentIndex callback:^(CGFloat height) {
        weakself.content3Height.constant = height;
    }];
}

- (void)rightButtonItemClick:(Panel *)item {
    if (_model) {
        _isFlow = YES;
        if ([item.ID isEqualToString:@"button-revoke"]) {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"确认撤回？" preferredStyle:UIAlertControllerStyleAlert];
            [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
            [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [MBManager showLoading];
                [[HttpManager manager] post:[UrlConfig URL:rcvRevokeTask] param:@{@"bizPk":self.dealID} success:^(NSData *data) {
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
//            [FlowManagermentFactory factory:item bizPk:_model.memo instanceId:_model.dealId];
        }else {
//            [FlowManagermentFactory factory:item bizPk:self.bizKey instanceId:_model.dealId];
        }
    }
}
    
- (UIImage *)chooseDocImage:(NSString *)str {
    if ([str isEqualToString:@"doc"] || [str isEqualToString:@"docx"]) {
        return [UIImage imageNamed:@"doc"];
    }
    if ([str isEqualToString:@"png"]) {
        return [UIImage imageNamed:@"png"];
    }
    if ([str isEqualToString:@"jpg"]) {
        return [UIImage imageNamed:@"jpg"];
    }
    if ([str isEqualToString:@"pdf"]) {
        return [UIImage imageNamed:@"pdf"];
    }
    return [UIImage imageNamed:@"none"];
}

@end
