//
//  TunnelPileFoundationController.m
//  PMPlatform_IOS
//
//  Created by 末末班车 on 2017/10/17.
//  Copyright © 2017年 com.atide. All rights reserved.
//

#import "TunnelPileFoundationController.h"
#import "MediumPaymentVoucherController.h"
#import "SelectSectTenderController.h"
#import "TunnelPileFoundationModel.h"
#import "AuditOpinionController.h"
#import "MidMeasureInfo.h"
#import "SectModel.h"

@interface TunnelPileFoundationController ()<SectDelegate>

@property (weak, nonatomic) IBOutlet UIButton *btnSectSession;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UILabel *flowLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *flowViewHeight;
@property (weak, nonatomic) IBOutlet UIButton *zqzfBtn;
@property (weak, nonatomic) IBOutlet UIButton *flowBtn;

@end

@implementation TunnelPileFoundationController {
    NSInteger                   m_type;
    UIStoryboard                *m_story;
    NSString                    *m_sect;
    NSString                    *m_session;
    NSString                    *m_childBussinessFlag;
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
    
    if (m_type == 0) {
        self.title = @"第三方试验检测费用支付";
    } else if (m_type == 1){
        self.title = @"隧道检测费用支付";
    } else if (m_type == 2) {
        self.title = @"桩基检测费用支付";
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    self.title = @"";
}

#pragma mark - 初始化界面
- (void)setupUI {
    m_story = [UIStoryboard storyboardWithName:@"Main" bundle:nil];

    self.zqzfBtn.layer.cornerRadius = 5;
    self.flowBtn.layer.cornerRadius = 5;
}

- (void)setupDataModel {
    if (!m_model) {
        return;
    }
    
    self.statusLabel.text = m_model.approvalStatus;
    self.flowLabel.text = m_model.flowName;
    
    CGFloat width = self.flowLabel.frame.size.width;
    CGSize size = [m_model.flowName boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12.f]} context:nil].size;
    if (size.height + 10 < 40) {
        self.flowViewHeight.constant = 40;
    } else {
        self.flowViewHeight.constant = size.height + 10;
    }
}

#pragma mark - 加载数据
- (void)initSectData {
    [[HttpManager manager] paramsGet:[UrlConfig MeteringURL:getAvaliableByUser] param:@{
                                                                                        @"BussinessFlag":@"1",
                                                                                        @"ChildBussinessFlag":m_childBussinessFlag,
                                                                                        @"UserCode":[UserInfo getInstance].code
                                                                                       }
                             success:^(NSData *data) {
                                 if ([ResponseUtils success:data]) {
                                     NSMutableArray *arr = [SectModel mj_objectArrayWithKeyValuesArray:[[ResponseUtils getData:@"data"] objectForKey:@"rows"]];
                                     if (arr != nil && arr.count != 0) {
                                         SectModel *model = arr.firstObject;
                                         m_sect = model.sectNo;
                                         m_session = model.sessionCode;
                                         [self.btnSectSession setTitle:[NSString stringWithFormat:@"%@第%@期",model.sectName,m_session] forState:UIControlStateNormal];
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

#pragma mark - params
- (void)setTunnelPileFoundationParams:(NSDictionary *)dic {
    if (dic[@"type"]) {
        m_type = [dic[@"type"] integerValue];
        
        if (m_type == 0) {
            m_childBussinessFlag = @"4";
        } else if (m_type == 1) {
            m_childBussinessFlag = @"5";
        } else if (m_type == 2) {
            m_childBussinessFlag = @"6";
        }
    }
}

#pragma mark - 点击事件
- (IBAction)selectSectSession:(id)sender {
    if (![self checkData]) {
        return;
    }
    
    SelectSectTenderController *nextView = [m_story instantiateViewControllerWithIdentifier:@"selectSectTender"];
    if (m_type == 0) {
        nextView.childBussinessFlag = @"4";
    } else if (m_type == 1) {
        nextView.childBussinessFlag = @"5";
    } else if (m_type == 2) {
        nextView.childBussinessFlag = @"6";
    }
    nextView.delegate = self;
    [self.navigationController pushViewController:nextView animated:YES];
}
- (IBAction)zqzfClicked:(id)sender {
    if (![self checkData]) {
        return;
    }
    
    MediumPaymentVoucherController *vc = [m_story instantiateViewControllerWithIdentifier:@"mediumPaymentVoucher"];
    vc.model = m_model;
    if (m_type == 0) {
        vc.specialtyCode = @"13";
    } else if (m_type == 1) {
        vc.specialtyCode = @"8";
    } else if (m_type == 2) {
        vc.specialtyCode = @"9";
    }
    [self.navigationController pushViewController:vc animated:YES];
}
- (IBAction)flowClicked:(id)sender {
    if (![self checkData]) {
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
    [nextView setParams:info];
    [self.navigationController pushViewController:nextView animated:YES];
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
