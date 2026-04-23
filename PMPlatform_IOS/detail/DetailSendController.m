//
//  DetailSendController.m
//  PMPlatform_IOS
//
//  Created by 末末班车 on 2017/9/8.
//  Copyright © 2017年 com.atide. All rights reserved.
//

#import "DetailSendController.h"
#import "FlowApprovalCommentView.h"
#import "DocumentModel.h"
#import "OrgListModel.h"
#import "AnnexModel.h"
#import "AnnexView.h"
#import "FileBrowsingController.h"
#import "FlowApprovalToolBar.h"
#import "FlowManagermentFactory.h"

@interface DetailSendController ()

@property (weak, nonatomic) IBOutlet UIScrollView *firstScrollView;
@property (weak, nonatomic) IBOutlet UIScrollView *secondScrollView;
@property (weak, nonatomic) IBOutlet UIView *thirdView;

@property (nonatomic, strong) UISegmentedControl *segmentedControl;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *content2Height;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *content3Height;

@property (weak, nonatomic) IBOutlet UILabel *sendCode;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *fileTypeLabel;
@property (weak, nonatomic) IBOutlet UILabel *itemTypeName;
@property (weak, nonatomic) IBOutlet UILabel *urgency;
@property (weak, nonatomic) IBOutlet UILabel *secretLevel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *originOrg;
@property (weak, nonatomic) IBOutlet UILabel *numLabel;
@property (weak, nonatomic) IBOutlet UILabel *sendOrg;
@property (weak, nonatomic) IBOutlet UILabel *CopyOrg;
@property (weak, nonatomic) IBOutlet UILabel *reason;
@property (weak, nonatomic) IBOutlet UILabel *sendTime;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *reasonHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleHeight;

@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet UILabel *label1;
@property (weak, nonatomic) IBOutlet UILabel *label2;

@property (weak, nonatomic) IBOutlet UILabel *tipLabel;
@property (weak, nonatomic) IBOutlet UIImageView *docImageView;
@property (weak, nonatomic) IBOutlet UILabel *docLabel;
@property (weak, nonatomic) IBOutlet UIView *annexViews;

@property (weak, nonatomic) IBOutlet FlowApprovalCommentView *commentView;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedControl3;

@end

@implementation DetailSendController {
    DocumentModel *_model;
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

#pragma mark - 初始化界面
- (void)setupUI {
    _orgModels = @[];
    _bottomViewHeight = 50;
    
    NSArray *strArr;
    if ([_model.originType isEqualToString:@"3"]) {
        strArr = @[@"基本信息", @"公文及附件"];
    } else {
        strArr = @[@"基本信息", @"公文及附件", @"审核信息"];
        self.segmentedControl3.selectedSegmentIndex = 0;
        [self content3ValueChanged:self.segmentedControl3];
    }
    
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
}

#pragma mark - 加载数据
- (void)loadData:(BOOL)loadOther {
    NSString *url = [UrlConfig URL:queryObject];
    
    //加载基本信息数据
    [[HttpManager manager] post:url param:@{@"id":self.ID} success:^(NSData *data) {
        [MBManager hideAlert];
        if ([ResponseUtils success:data]) {
            [DocumentModel mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
                return @{@"ID":@"id", @"COPYORG":@"copyOrg"};
            }];
            _model = [DocumentModel mj_objectWithKeyValues:[ResponseUtils getData:@"data"]];
            if (_model) {
                [FlowManagermentFactory config:self.navigationController symbol:@"" update:nil];
                if (self.bizKey) {
                    [self loadToolBar];
                } else {
                    if (self.searchType == SearchTypeSendPublicity) {
                        if ([_model.originType isEqualToString:@"3"]) {
                            [self showRightButton:@[]];
                        } else {
                            [self showRightButton:@[[[Panel alloc] init:@"button-process" text:@"办理过程" icon:@""]]];
                        }
                        
                    } else {
                        self.bizKey = @"doc_send";
                        [self loadToolBar];
                    }
                }
                
                [self setupUI];
                [self setupModel];
            }
        } else {
            [MBManager showBriefAlert:[ResponseUtils getMsg]];
        }
    } faild:^(NSString *msg) {
        [MBManager hideAlert];
        [MBManager showBriefAlert:msg];
    }];
    
    if (loadOther) {
        //加载项目单位数组
        [[HttpManager manager] post:[UrlConfig URL:sendOrgQueryList] param:@{@"docSendId":self.ID} success:^(NSData *data) {
            _orgModels = [OrgListModel mj_objectArrayWithKeyValuesArray:data];
            if (_orgModels != nil) {
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
}

#pragma mark - 获取工具栏
- (void)loadToolBar {
    FlowApprovalToolBar *toolBar = [[FlowApprovalToolBar alloc] init];
    
    [toolBar request:self.ID bizKey:self.bizKey callback:^(NSArray<Panel *> *items) {
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

- (void)setupModel {
    self.sendCode.text = [NSString stringWithFormat:@"%@%@", _model.tempName, _model.code];
    self.titleLabel.text = _model.title;
    self.fileTypeLabel.text = _model.itemName;
    self.itemTypeName.text = _model.docNatrueName;
    self.urgency.text = [SearchFactory getUrgencyTypeName:_model.urgency.integerValue];
    self.secretLevel.text = [SearchFactory getSecretLevelTypeName:_model.secretLevel.integerValue];
    self.nameLabel.text = _model.userName;
    self.originOrg.text = _model.orgName;
    self.numLabel.text = _model.num;
    self.sendOrg.text = _model.sendOrg;
    self.CopyOrg.text = _model.COPYORG;
    self.reason.text = _model.reason;
    self.sendTime.text = _model.sendTime;
    
    CGFloat width = ScreenWidth - 96;
    CGSize size = [_model.title boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12.f]} context:nil].size;
    if (size.height + 10 < 30) {
        self.titleHeight.constant = 30;
    }else {
        self.titleHeight.constant = size.height + 10;
    }
    
    size = [_model.reason boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12.f]} context:nil].size;
    if (size.height + 10 < 30) {
        self.reasonHeight.constant = 30;
    }else {
        self.reasonHeight.constant = size.height + 10;
    }
    
    [self updateConstraint1];
    
    self.docLabel.text = _model.title;
    self.docImageView.image = [self chooseDocImage:[_model.fileName componentsSeparatedByString:@"."].lastObject];
}

- (void)setupOrgModel {
    CGRect frame1 = self.label1.frame;
    CGRect frame2 = self.label2.frame;
    
    for (OrgListModel *model in _orgModels) {
        CGFloat rowHeight;
        CGSize size = [model.proName boundingRectWithSize:CGSizeMake(frame2.size.width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:11.f]} context:nil].size;
        if (size.height + 10 < 25) {
            rowHeight = 25;
        }else {
            rowHeight = size.height + 10;
        }
        
        frame1 = CGRectMake(frame1.origin.x, frame1.origin.y + frame1.size.height, frame1.size.width, rowHeight);
        frame2 = CGRectMake(frame2.origin.x, frame2.origin.y + frame2.size.height, frame2.size.width, rowHeight);
        
        UILabel *label1 = [[UILabel alloc] initWithFrame:frame1];
        label1.font = [UIFont systemFontOfSize:11];
        label1.numberOfLines = 0;
        label1.textAlignment = NSTextAlignmentCenter;
        label1.layer.borderWidth = 0.5;
        label1.layer.borderColor = [UIColor hex:@"999999"].CGColor;
        label1.text = model.orderNo;
        [self.bottomView addSubview:label1];
        UILabel *label2 = [[UILabel alloc] initWithFrame:frame2];
        label2.font = [UIFont systemFontOfSize:11];
        label2.textAlignment = NSTextAlignmentCenter;
        label2.layer.borderWidth = 0.5;
        label2.layer.borderColor = [UIColor hex:@"999999"].CGColor;
        label2.text = model.proName;
        [self.bottomView addSubview:label2];
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

#pragma mark - 更新约束
- (void)updateConstraint1 {
    self.contentHeight.constant = self.titleHeight.constant + self.reasonHeight.constant + 330 + _bottomViewHeight;
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
    NSString *path = [NSString stringWithFormat:@"%@/Documents/%@%@.doc", NSHomeDirectory(), _model.title, _model.ID];
    if ([self checkDownload:[NSString stringWithFormat:@"%@%@.doc", _model.title, _model.ID]]) {
        FileBrowsingController *vc = [[FileBrowsingController alloc] init];
        vc.filePath = path;
        [self.navigationController pushViewController:vc animated:YES];
    }else {
        [MBManager showLoading];
        [[HttpManager manager] get:[NSString stringWithFormat:@"%@%@", [UrlConfig URL:fileDfsDownload], _model.fileName] param:nil success:^(NSData *data) {
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
                [[HttpManager manager] post:[UrlConfig URL:sendRevokeTask] param:@{@"bizPk":self.ID} success:^(NSData *data) {
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
        }else {
//            [FlowManagermentFactory factory:item bizPk:self.bizKey instanceId:_model.ID];
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
