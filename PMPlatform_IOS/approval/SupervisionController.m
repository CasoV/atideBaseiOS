//
//  SupervisionController.m
//  PMPlatform_IOS
//
//  Created by 末末班车 on 2017/10/17.
//  Copyright © 2017年 com.atide. All rights reserved.
//

#import "SupervisionController.h"
#import "SelectSectTenderController.h"
#import "MidMeasureDetilAttachment.h"
#import "AuditOpinionController.h"
#import "SupervisionModel.h"

@interface SupervisionController ()<SectDelegate>

@property (weak, nonatomic) IBOutlet UIButton *btnSectSession;
@property (weak, nonatomic) IBOutlet UIButton *supervisionBtn;
@property (weak, nonatomic) IBOutlet UIButton *flowBtn;
@property (weak, nonatomic) IBOutlet UILabel *flowLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UILabel *supPersonThings;
@property (weak, nonatomic) IBOutlet UILabel *testEquipmentThings;
@property (weak, nonatomic) IBOutlet UILabel *remarks;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *flowHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *supPersonThingsHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *testEquipmentThingsHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *remarksHeight;

@end

@implementation SupervisionController {
    UIStoryboard                *m_story;
    NSString                    *m_sect;
    NSString                    *m_session;
    SupervisionModel            *m_model;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupUI];
    [self initSectData];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.title = @"监理费用支付";
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    self.title = @"";
}

#pragma mark - 初始化界面
- (void)setupUI {
    m_story = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    self.supervisionBtn.layer.cornerRadius = 5;
    self.flowBtn.layer.cornerRadius = 5;
}

- (void)setupDataModel {
    if (!m_model) {
        return;
    }
    
    self.statusLabel.text = m_model.approvalStatus;
    self.flowLabel.text = m_model.flowName;
    self.supPersonThings.text = m_model.supPersonThings;
    self.testEquipmentThings.text = m_model.testEquipmentThings;
    self.remarks.text = m_model.remarks;

    CGFloat width = self.flowLabel.frame.size.width;
    CGSize size = [m_model.flowName boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12.f]} context:nil].size;
    if (size.height + 10 < 40) {
        self.flowHeight.constant = 40;
    } else {
        self.flowHeight.constant = size.height + 10;
    }
    
    size = [m_model.supPersonThings boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12.f]} context:nil].size;
    if (size.height + 10 < 40) {
        self.supPersonThingsHeight.constant = 40;
    } else {
        self.supPersonThingsHeight.constant = size.height + 10;
    }
    
    size = [m_model.testEquipmentThings boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12.f]} context:nil].size;
    if (size.height + 10 < 40) {
        self.testEquipmentThingsHeight.constant = 40;
    } else {
        self.testEquipmentThingsHeight.constant = size.height + 10;
    }
    
    size = [m_model.remarks boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12.f]} context:nil].size;
    if (size.height + 10 < 40) {
        self.remarksHeight.constant = 40;
    } else {
        self.remarksHeight.constant = size.height + 10;
    }
}

#pragma mark - 加载数据
- (void)initSectData {
    [[HttpManager manager] paramsGet:[UrlConfig MeteringURL:getAvaliableByUser] param:@{
                                                                                        @"BussinessFlag":@"1",
                                                                                        @"ChildBussinessFlag":@"3",
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
    [[HttpManager manager] paramsGet:[UrlConfig MeteringURL:getSuperVising] param:@{
                                                                                    @"SessionCode":m_session,
                                                                                    @"SectNo":m_sect,
                                                                                    @"UserCode":[UserInfo getInstance].code
                                                                                    }
                             success:^(NSData *data) {
                                 if ([ResponseUtils success:data]) {
                                     m_model = [SupervisionModel mj_objectWithKeyValues:[ResponseUtils getData:@"data"]];
                                     if (m_model) {
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
    nextView.childBussinessFlag = @"3";
    nextView.delegate = self;
    [self.navigationController pushViewController:nextView animated:YES];
}

- (IBAction)btnClicked:(UIButton *)sender {
    if (![self checkData]) {
        return;
    }
    if ([m_model.compId isEqualToString:@""]) {
        [MBManager showBriefAlert:@"无数据"];
        return;
    }
    
    AuditOpinionController *nextView = [m_story instantiateViewControllerWithIdentifier:@"auditOpinion"];
    MidMeasureInfo *info = [[MidMeasureInfo alloc] init];
    info.approvalGrpId = m_model.approvalGrpId;
    info.approvalUnitId = m_model.approvalUnitId;
    info.approvalUnitStep = m_model.approvalUnitStep;
    info.approvalGrpStep = m_model.approvalGrpStep;
    info.flowID = m_model.flowID;
    info.compId = m_model.compId;
    info.childBussinessFlag = @"1";
    if (sender == self.supervisionBtn) {
        info.type = JLFYZF;//监理费用支付
        info.sectNo = m_sect;
        info.sessionCode = m_session;
    }
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
