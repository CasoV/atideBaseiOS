//
//  MeViewController.m
//  PMPlatform_IOS
//
//  Created by 末末班车 on 2017/9/5.
//  Copyright © 2017年 com.atide. All rights reserved.
//

#import "MeViewController.h"
#import "HeadPhotoUtils.h"
#import "AppDelegate.h"
#import "STPickerSingle.h"
#import "UserBean.h"
#import "BaseWebViewController.h"

@interface MeViewController ()<STPickerSingleDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *sexLabel;
@property (weak, nonatomic) IBOutlet UILabel *orgLabel;
@property (weak, nonatomic) IBOutlet UILabel *occupationLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
@property (weak, nonatomic) IBOutlet UILabel *qqLabel;
@property (weak, nonatomic) IBOutlet UILabel *emailLabel;
@property (weak, nonatomic) IBOutlet UILabel *addrLabel;
@property (weak, nonatomic) IBOutlet UILabel *dutiesLabel;
@property (weak, nonatomic) IBOutlet UILabel *topOrgName;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UILabel *versionLabel;
@property (weak, nonatomic) IBOutlet UIView *changeStatusView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topOrgBtnHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topToOrgBtn;

@property(nonatomic,strong)NSMutableArray *dataArr;
@end

@implementation MeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupUI];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationItem.title = @"个人信息";
    [self getUserInfo];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationItem.title = @"";
}

- (void)getUserInfo {
    [[HttpManager manager] post:[UrlConfig URL:getUserByCode] param:@{@"userId":[UserInfo getInstance].ID} success:^(NSData *data) {
        if ([ResponseUtils success:data]) {
            UserBean * userBean = [UserBean mj_objectWithKeyValues:[ResponseUtils getData:@"data"]];
            self.nameLabel.text = userBean.name;
            self.sexLabel.text = userBean.sex == 1 ? @"男" : @"女";
            self.topOrgName.text = userBean.topOrgName;
            self.orgLabel.text = userBean.orgName;
            self.phoneLabel.text = userBean.phone;
            self.qqLabel.text = userBean.qq;
            self.emailLabel.text = userBean.eMail;
            self.addrLabel.text = userBean.address;
            self.dutiesLabel.text = userBean.position;
            
        } else {
            [MBManager showBriefAlert:[ResponseUtils getMsg]];
        }
        } faild:^(NSString *msg) {
            [MBManager showBriefAlert:msg];
        }];
}

#pragma mark - 初始化界面
- (void)setupUI {
    self.versionLabel.text = [NSString stringWithFormat:@"v-%@", [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]];
    
    UserInfo *user = [UserInfo getInstance];
    if (user) {
        self.nameLabel.text = user.name;
        self.sexLabel.text = [user.sex isEqualToString:@"1"] ? @"男" : @"女";
        self.orgLabel.text = user.orgName;
        self.occupationLabel.text = user.occupation;
        self.phoneLabel.text = user.phone;
        self.qqLabel.text = user.qq;
        self.emailLabel.text = user.email;
        self.addrLabel.text = user.addr;
        self.dutiesLabel.text = user.post;
        self.topOrgName.text = user.topOrgName;
        
        if (user.topOrgs != nil && user.topOrgs.count > 1) {
            self.topOrgBtnHeight.constant = 30;
            self.topToOrgBtn.constant = 10;
        } else {
            self.topOrgBtnHeight.constant = 0;
            self.topToOrgBtn.constant = 0;
        }
        
        [HeadPhotoUtils setHeadPhotoByUserId:self.iconImageView userId:user.ID];
    }
    [_changeStatusView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(changeStatus)]];
    [self getStatusName];
}
-(void)getStatusName{
    
    UserInfo *user = [UserInfo getInstance];
    [[HttpManager manager] post:[UrlConfig URL:getUserList] param:@{
        @"page":@"1",
        @"rows":@"999",
        @"name":user.name
    }success:^(NSData *data) {
        NSDictionary *dic = [data mj_JSONObject];
        if(!dic){
            return;
        }
        NSArray *arr = dic[@"rows"];
        if(!arr || arr.count == 0){
            return;
        }
        NSNumber *state = arr[0][@"state"];
        if(![state isKindOfClass:[NSNull class]])self.statusLabel.text = self.dataArr[state.intValue - 1];
    } faild:^(NSString *msg) {
        [MBManager showBriefAlert:msg];
    }];
}
- (void)changeStatus {
    UserInfo *user = [UserInfo getInstance];
    STPickerSingle *pickerSingle = [[STPickerSingle alloc]init];
    [pickerSingle setArrayData:self.dataArr];
    [pickerSingle setTitle:[NSString stringWithFormat:@"切换状态(%@)", user.topOrgName]];
    [pickerSingle setDelegate:self];
    pickerSingle.contentMode = STPickerContentModeCenter;
    [pickerSingle show];
}

#pragma mark - 点击事件
- (IBAction)checkOut:(id)sender {
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"确定切换账户？" preferredStyle:UIAlertControllerStyleAlert];
    [alertVC addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    [alertVC addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UIViewController *vc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"loginNav"];
        AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        delegate.window.rootViewController = vc;
    }]];
    [self presentViewController:alertVC animated:YES completion:nil];
}
- (IBAction)changeTopOrg:(id)sender {
    UserInfo *user = [UserInfo getInstance];
    NSMutableArray <NSString *>*dataArr = [NSMutableArray array];
    for (OrgModel *topOrg in user.topOrgs) {
        [dataArr addObject:topOrg.name];
    }
    STPickerSingle *pickerSingle = [[STPickerSingle alloc]init];
    [pickerSingle setArrayData:dataArr];
    [pickerSingle setTitle:[NSString stringWithFormat:@"切换组织(%@)", user.topOrgName]];
    [pickerSingle setDelegate:self];
    pickerSingle.contentMode = STPickerContentModeCenter;
    [pickerSingle show];
}

- (IBAction)changeInfo:(id)sender {
    BaseWebViewController *webvc =  [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"BaseWebViewController"];
    webvc.title = @"修改个人信息";
    NSString *userName = [[NSUserDefaults standardUserDefaults] objectForKey:@"user"];
    NSString *password = [[NSUserDefaults standardUserDefaults] objectForKey:@"password"];
    webvc.url = [NSString stringWithFormat:@"%@?user=%@&pwd=%@", [UrlConfig URL:@"/mobileView/editPersonInfo"], [userName stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]], [password stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]];
    webvc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:webvc animated:YES];
}

#pragma mark - STPickerSingleDelegate
- (void)pickerSingle:(STPickerSingle *)pickerSingle selectedTitle:(NSString *)selectedTitle {
//    UserInfo *user = [UserInfo getInstance];
//    OrgModel *selectOrg = nil;
//    for (OrgModel *topOrg in user.topOrgs) {
//        if ([topOrg.name isEqualToString:selectedTitle]) {
//            selectOrg = topOrg;
//        }
//    }
//
//    if (!selectOrg) {
//        return;
//    }
//
//
//
//    OrgModel *newOrg = nil;
//    for (OrgModel *org in user.orgs) {
//        if ([org.superId isEqualToString:selectOrg.ID]) {
//            newOrg = org;
//        }
//    }
//
//    if (!newOrg) {
//        return;
//    }
//
//
//
//    [[HttpManager manager] post:[UrlConfig URL:changeOrg] param:@{
//                                                                 @"topOrgId":newOrg.superId,
//                                                                 @"orgId":newOrg.ID
//                                                                 }
//                        success:^(NSData *data) {
//                            if ([ResponseUtils success:data]) {
//                                self.topOrgName.text = selectOrg.name;
//                                user.topOrgName = selectOrg.name;
//                                user.topOrgId = selectOrg.ID;
//                                self.orgLabel.text = newOrg.name;
//                                user.orgName = newOrg.name;
//                                user.orgId = newOrg.ID;
//                            } else {
//                                [MBManager showBriefAlert:[ResponseUtils getMsg]];
//                            }
//                        } faild:^(NSString *msg) {
//                            [MBManager showBriefAlert:msg];
//                        }];
    
    UserInfo *userInfo = [UserInfo getInstance];
    NSInteger index = [self.dataArr indexOfObject:selectedTitle];
    [[HttpManager manager] post:[UrlConfig URL:setState] param:@{
        @"state":[NSString stringWithFormat:@"%ld",index+1],
        @"userId":userInfo.ID
    }success:^(NSData *data) {
        [MBManager showBriefAlert:@"切换成功"];
        [self getStatusName];
        
    } faild:^(NSString *msg) {
        [MBManager showBriefAlert:msg];
    }];
}

- (NSMutableArray<NSString *> *)dataArr {
    if (!_dataArr) {
        _dataArr = [NSMutableArray arrayWithArray:@[@"在岗",@"外出",@"请假",@"公休"]];
    }
    return _dataArr;
}

@end
