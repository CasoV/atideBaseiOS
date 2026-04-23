//
//  AuditController.m
//  PMPlatform_IOS
//
//  Created by 末末班车 on 2017/10/18.
//  Copyright © 2017年 com.atide. All rights reserved.
//

#import "AuditController.h"
#import "STPickerSingle.h"
#import "ApprovalGroupModel.h"
#import "WebserviceManager.h"
#import "WebServiceConfig.h"
#import "NSObject+GetIP.h"
#import "XMLParser.h"

@interface AuditController ()<UITextViewDelegate, STPickerSingleDelegate>

@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UIButton *defualtBtn;
@property (weak, nonatomic) IBOutlet UIButton *returnBtn;
@property (weak, nonatomic) IBOutlet UIButton *passBtn;

@property (nonatomic, copy) NSArray <ApprovalGroupModel *>*groups;

@end

@implementation AuditController {
    STPickerSingle *_pickerSingle;
    NSString *_ip;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupUI];
}

#pragma mark - 初始化界面
- (void)setupUI {
    self.textView.layer.cornerRadius = 5;
    self.textView.layer.borderColor = [UIColor navigationBgColor].CGColor;
    self.textView.layer.borderWidth = 1;
    
    self.returnBtn.layer.cornerRadius = 5;
    self.passBtn.layer.cornerRadius = 5;
    
    _ip = [NSObject deviceIPAdress];
    if ([_ip isEqualToString:@"an error occurred when obtaining ip address"]) {
        _ip = @"";
    }
}

#pragma mark - UITextViewDelegate
- (void)textViewDidEndEditing:(UITextView *)textView {
    if ([textView.text isEqualToString:@""]) {
        textView.text = @"请填写意见:";
    }
}

- (void)textViewDidBeginEditing:(UITextView *)textView {
    if ([textView.text isEqualToString:@"请填写意见:"]) {
        textView.text = @"";
    }
}

#pragma mark - STPickerSingleDelegate
- (void)pickerSingle:(STPickerSingle *)pickerSingle selectedTitle:(NSString *)selectedTitle {
    if (pickerSingle == _pickerSingle) {
        ApprovalGroupModel *group = nil;
        for (ApprovalGroupModel *item in self.groups) {
            if ([item.stepname isEqualToString:selectedTitle]) {
                group = item;
            }
        }
        
        if (!group) {
            return;
        }
        
        [MBManager showLoading];
        __weak typeof(self) weakSelf = self;
        NSDictionary *config = [WebServiceConfig config:WebServiceConfig.PayWebService];
        [WebserviceManager dataTaskWithSoapRequest:[@{@"userKey":[UserInfo getInstance].ID, @"returnUnitOrder":group.unitstepserialno, @"returnGrpOrder":group.grpstepserialno, @"interimKey":self.model.interimPayId, @"ideas":self.textView.text} mutableCopy] header:[@{@"InnerToken":[UserInfo getInstance].ID, @"UserHost":_ip} mutableCopy] url:config[@"url"] method:config[@"ReturnPayCert"] nameSpace:config[@"nameSpace"] completed:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            if (error) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [MBManager hideAlert];
                    [MBManager showBriefAlert:[NSString stringWithFormat:@"%@", error]];
                });
            }else {
                
                [[[XMLParser alloc] init] analysisXMLData:data handleBlock:^(NSData *jsonData) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [MBManager hideAlert];
                        if ([ResponseUtils success:jsonData]) {
                            [MBManager showBriefAlert:@"退回成功！"];
                            [weakSelf.navigationController popViewControllerAnimated:YES];
                        } else {
                            [MBManager showBriefAlert:[ResponseUtils getMsg]];
                        }
                    });
                }];
            }
        }];
    }else {
        self.textView.text = selectedTitle;
        [self.defualtBtn setTitle:selectedTitle forState:UIControlStateNormal];
    }
}


#pragma mark - 点击事件
- (IBAction)defualtClicked:(id)sender {
    [self.textView resignFirstResponder];
    NSMutableArray <NSString *>*dataArr = [NSMutableArray arrayWithObjects:@"同意计量", @"退回", nil];

    STPickerSingle *pickerSingle = [[STPickerSingle alloc]init];
    [pickerSingle setArrayData:dataArr];
    [pickerSingle setTitle:@"请选择默认意见"];
    [pickerSingle setDelegate:self];
    pickerSingle.contentMode = STPickerContentModeCenter;
    [pickerSingle show];
}

- (IBAction)returnClicked:(id)sender {
    [self.textView resignFirstResponder];
    if ([self.textView.text isEqualToString:@"请填写意见:"]) {
        [MBManager showBriefAlert:@"意见不能为空"];
        return;
    }
    
    if (self.groups) {
        [self showApprovalGroups];
        return;
    }
    
    [MBManager showLoading];
    __weak typeof(self) weakSelf = self;
    NSDictionary *config = [WebServiceConfig config:WebServiceConfig.PayWebService];
    [WebserviceManager dataTaskWithSoapRequest:[@{@"userKey":[UserInfo getInstance].ID, @"flowID":self.model.flowID, @"approvalUnitStep":self.model.approvalUnitStep} mutableCopy] header:[@{@"InnerToken":[UserInfo getInstance].ID, @"UserHost":_ip} mutableCopy] url:config[@"url"] method:config[@"GetApprovalGroups"] nameSpace:config[@"nameSpace"] completed:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [MBManager hideAlert];
                [MBManager showBriefAlert:[NSString stringWithFormat:@"%@", error]];
            });
        }else {
            
            [[[XMLParser alloc] init] analysisXMLData:data handleBlock:^(NSData *jsonData) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [MBManager hideAlert];
                    if ([ResponseUtils success:jsonData]) {
                        NSArray <ApprovalGroupModel *>*arr = [ApprovalGroupModel mj_objectArrayWithKeyValuesArray:[ResponseUtils getData:@"data"]];
                        if (arr) {
                            weakSelf.groups = arr;
                            [weakSelf showApprovalGroups];
                        }
                    } else {
                        [MBManager showBriefAlert:[ResponseUtils getMsg]];
                    }
                });
            }];
        }
    }];
}

- (IBAction)passClicked:(id)sender {
    [self.textView resignFirstResponder];
    if ([self.textView.text isEqualToString:@"请填写意见:"]) {
        [MBManager showBriefAlert:@"意见不能为空"];
        return;
    }
    
    [MBManager showLoading];
    
    __weak typeof(self) weakSelf = self;
    NSDictionary *config = [WebServiceConfig config:WebServiceConfig.PayWebService];
    [WebserviceManager dataTaskWithSoapRequest:[@{@"userKey":[UserInfo getInstance].ID, @"interimKey":self.model.interimPayId, @"ideas":self.textView.text} mutableCopy] header:[@{@"InnerToken":[UserInfo getInstance].ID, @"UserHost":_ip} mutableCopy] url:config[@"url"] method:config[@"ApprovalPayCert"] nameSpace:config[@"nameSpace"] completed:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [MBManager hideAlert];
                [MBManager showBriefAlert:[NSString stringWithFormat:@"%@", error]];
            });
        }else {
            
            [[[XMLParser alloc] init] analysisXMLData:data handleBlock:^(NSData *jsonData) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [MBManager hideAlert];
                    if ([ResponseUtils success:jsonData]) {
                        [MBManager showBriefAlert:@"提交成功！"];
                        [weakSelf.navigationController popViewControllerAnimated:YES];
                    } else {
                        [MBManager showBriefAlert:[ResponseUtils getMsg]];
                    }
                });
            }];
        }
    }];
}

#pragma mark - 选择审核组
- (void)showApprovalGroups {
    NSMutableArray <NSString *>*dataArr = [NSMutableArray array];
    
    for (ApprovalGroupModel *model in self.groups) {
        [dataArr addObject:model.stepname];
    }
    
    _pickerSingle = [[STPickerSingle alloc]init];
    [_pickerSingle setArrayData:dataArr];
    [_pickerSingle setTitle:@"退回到:"];
    [_pickerSingle setDelegate:self];
    _pickerSingle.contentMode = STPickerContentModeCenter;
    [_pickerSingle show];
}

@end
