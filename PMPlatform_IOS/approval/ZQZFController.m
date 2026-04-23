//
//  ZQZFController.m
//  PMPlatform_IOS
//
//  Created by 末末班车 on 2017/10/18.
//  Copyright © 2017年 com.atide. All rights reserved.
//

#import "ZQZFController.h"
#import "SelectSectTenderController.h"
#import "TunnelPileFoundationModel.h"
#import "ZQZFCertificateController.h"
#import "AuditOpinionController.h"
#import "AuditController.h"

@interface ZQZFController ()<SectDelegate>

@property (weak, nonatomic) IBOutlet UIButton *btnSectSession;
@property (weak, nonatomic) IBOutlet UILabel *status;
@property (weak, nonatomic) IBOutlet UILabel *flow;
@property (weak, nonatomic) IBOutlet UILabel *datumStatus;
@property (weak, nonatomic) IBOutlet UILabel *amt;

@property (weak, nonatomic) IBOutlet UIButton *topBtn;
@property (weak, nonatomic) IBOutlet UIButton *midBtn;
@property (weak, nonatomic) IBOutlet UIButton *botBtn;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *flowHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *statusHeight;

@end

@implementation ZQZFController {
    UIStoryboard                *m_story;
    NSString                    *m_sect;
    NSString                    *m_session;
    TunnelPileFoundationModel   *m_model;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupUI];
    [self initSectData];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.title = @"中期支付报表";
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    self.title = @"";
}

#pragma mark - 初始化界面
- (void)setupUI {
    m_story = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    self.topBtn.layer.cornerRadius = 5;
    self.midBtn.layer.cornerRadius = 5;
    self.botBtn.layer.cornerRadius = 5;
}

- (void)setupDataModel {
    if (!m_model) {
        return;
    }
    
    [self.btnSectSession setTitle:m_model.datumName forState:UIControlStateNormal];
    self.status.text = m_model.approvalStatus;
    self.flow.text = m_model.flowName;
    self.datumStatus.text = m_model.datumStatus;
    if ([m_model.applyAmt isEqualToString:@""]) {
        m_model.applyAmt = @"0";
    }
    self.amt.text = [NSString stringWithFormat:@"%.02f", [m_model.applyAmt floatValue]];
    
    CGFloat width = self.flow.frame.size.width;
    CGSize size = [m_model.flowName boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12.f]} context:nil].size;
    if (size.height + 10 < 40) {
        self.flowHeight.constant = 40;
    } else {
        self.flowHeight.constant = size.height + 10;
    }
    
    size = [m_model.datumStatus boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12.f]} context:nil].size;
    if (size.height + 10 < 40) {
        self.statusHeight.constant = 40;
    } else {
        self.statusHeight.constant = size.height + 10;
    }

    if ([m_model.interimPayId isEqualToString:@"-1"]) {
        self.topBtn.backgroundColor = [UIColor lightGrayColor];
    } else {
        self.topBtn.backgroundColor = [UIColor hex:@"007AFF"];
    }
}

#pragma mark - 加载数据
- (void)initSectData {
    [[HttpManager manager] paramsGet:[UrlConfig MeteringURL:getAvaliableByUser] param:@{
                                                                                        @"BussinessFlag":@"1",
                                                                                        @"ChildBussinessFlag":@"1",
                                                                                        @"UserCode":[UserInfo getInstance].code
                                                                                        }
                             success:^(NSData *data) {
                                 if ([ResponseUtils success:data]) {
                                     NSMutableArray *arr = [SectModel mj_objectArrayWithKeyValuesArray:[[ResponseUtils getData:@"data"] objectForKey:@"rows"]];
                                     if (arr != nil && arr.count != 0) {
                                         SectModel *model = arr.firstObject;
                                         m_sect = model.sectNo;
                                         m_session = model.sessionCode;
                                         [self loadData];
                                     } else {
                                         [MBManager showBriefAlert:@"无数据"];
                                     }
                                 } else {
                                     [MBManager showBriefAlert:[ResponseUtils getMsg]];
                                 }
                             } faild:^(NSString *msg) {
                                 [MBManager showBriefAlert:msg];
                             }];
}

- (void)loadData {
    [[HttpManager manager] paramsGet:[UrlConfig MeteringURL:getInterReportBasic] param:@{
                                                                                         @"SessionCode":m_session,
                                                                                         @"SectNo":m_sect,
                                                                                         @"UserCode":[UserInfo getInstance].code
                                                                                         }
                             success:^(NSData *data) {
                                 if ([ResponseUtils success:data]) {
                                     NSMutableArray *arr = [TunnelPileFoundationModel mj_objectArrayWithKeyValuesArray:[[ResponseUtils getData:@"data"] objectForKey:@"rows"]];
                                     if (arr != nil && arr.count != 0) {
                                         m_model = arr.firstObject;
                                         [self setupDataModel];
                                     }
                                 } else {
                                     [MBManager showBriefAlert:[ResponseUtils getMsg]];
                                 }
                             } faild:^(NSString *msg) {
                                 [MBManager showBriefAlert:msg];
                             }];
}

#pragma mark - 点击事件
- (IBAction)selectSectSession:(id)sender {
    if (![self checkData]) {
        return;
    }
    
    SelectSectTenderController *nextView = [m_story instantiateViewControllerWithIdentifier:@"selectSectTender"];
    nextView.delegate = self;
    [self.navigationController pushViewController:nextView animated:YES];
}
- (IBAction)topClicked:(id)sender {
    if (![self checkData]) {
        return;
    }
    
    if ([m_model.interimPayId isEqualToString:@"-1"]) {
        [MBManager showBriefAlert:@"本期中期支付报表尚未流转！"];
        return;
    }
    
    AuditOpinionController *nextView = [m_story instantiateViewControllerWithIdentifier:@"auditOpinion"];
    MidMeasureInfo *info = [[MidMeasureInfo alloc] init];
    info.approvalGrpId = m_model.approvalGrpId;
    info.approvalUnitId = m_model.approvalUnitId;
    info.approvalUnitStep = m_model.approvalUnitStep;
    info.approvalGrpStep = m_model.approvalGrpStep;
    info.flowID = m_model.flowID;
    info.compId = m_model.interimPayId;
    info.childBussinessFlag = @"1";
    info.type = ZQZF;//中期支付
    [nextView setParams:info];
    [self.navigationController pushViewController:nextView animated:YES];
}
- (IBAction)midClicked:(id)sender {
    if (![self checkData]) {
        return;
    }
    
    ZQZFCertificateController *vc = [m_story instantiateViewControllerWithIdentifier:@"ZQZFCertificate"];
    vc.sectNo = m_sect;
    vc.sessionCode = m_session;
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)botClicked:(id)sender {
    if (![self checkData]) {
        return;
    }
    
    AuditController *vc = [m_story instantiateViewControllerWithIdentifier:@"audit"];
    vc.model = m_model;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - SectDelegate
-(void)getSect:(SectModel *)data {
    m_sect = data.sectNo ;
    m_session = data.sessionCode;
    
    [self.btnSectSession setTitle:[NSString stringWithFormat:@"%@第%@期",data.sectName,m_session] forState:UIControlStateNormal];
    [self loadData];
}

#pragma mark - 判断是否有数据
- (BOOL)checkData {
    if (m_sect == nil || m_session == nil || m_model == nil) {
        [MBManager showBriefAlert:@"无数据"];
        return NO;
    } else {
        return YES;
    }
}

@end
