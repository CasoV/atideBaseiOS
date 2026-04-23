//
//  LogFlowController.m
//  PMPlatform_IOS
//
//  Created by 末末班车 on 2025/3/5.
//  Copyright © 2025 com.atide. All rights reserved.
//

#import "LogFlowController.h"
#import "PassViewController.h"
#import "QDPdfController.h"
#import "UserTaskModel.h"

@interface LogFlowController ()

@property (nonatomic, copy) NSString *mTaskId;

@end

@implementation LogFlowController

- (void)viewDidLoad {
    self.bizKey = @"";
    self.showSaveBtn = NO;
    [self initFirstVc];
    
    [super viewDidLoad];
    
    [self getTaskId];
    
    __weak typeof(self) weakSelf = self;
    self.toolView.completeBlock = ^(NSString *btnTitle) {
        PassViewController *vc = [[UIStoryboard storyboardWithName:@"Flow" bundle:nil] instantiateViewControllerWithIdentifier:@"pass"];
        vc.useJsonParams = YES;
        vc.taskId = weakSelf.mTaskId;
        vc.instanceId = weakSelf.bizPk;
        vc.bizKey =  weakSelf.bizKey;
        vc.url = pass;
        vc.title = @"通过";
        vc.callBack = ^(BOOL success) {
            [weakSelf getStatus:weakSelf.bizPk];
        };
        [weakSelf.navigationController pushViewController:vc animated:YES];
    };
    self.toolView.rejectBlock = ^(BOOL isReject) {
        PassViewController *vc = [[UIStoryboard storyboardWithName:@"Flow" bundle:nil] instantiateViewControllerWithIdentifier:@"pass"];
        vc.useJsonParams = YES;
        vc.taskId = weakSelf.mTaskId;
        vc.instanceId = weakSelf.bizPk;
        vc.bizKey =  weakSelf.bizKey;
        vc.url = reject;
        vc.title = @"退回";
        vc.callBack = ^(BOOL success) {
            [weakSelf getStatus:weakSelf.bizPk];
        };
        [weakSelf.navigationController pushViewController:vc animated:YES];
    };
}

#pragma mark - 初始页面
- (void)initFirstVc {
    QDPdfController *vc = [[QDPdfController alloc] init];
    vc.bizPk = self.bizPk;
    self.firstVC = vc;
}

#pragma mark - 获取taskId
- (void)getTaskId {
    NSString *url = [UrlConfig URL:queryUserTask];
    NSDictionary *params = @{
        @"bizPk": self.bizPk,
        @"userId": [AppUser sharedInstance].userId,
        @"forward": @"0"
    };
    __weak typeof(self) weakSelf = self;
    [[HttpManager manager] get:url param:params success:^(NSData *data) {
        NSArray <UserTaskModel *>*datas = [UserTaskModel mj_objectArrayWithKeyValuesArray:data];
        NSString *taskId = @"";
        for (UserTaskModel *item in datas) {
            if ([taskId isEqualToString:@""]) {
                taskId = item.id;
            }
            if (item.endTime != nil) {
                [(QDPdfController *)weakSelf.firstVC setTaskId:item.id];
                break;
            }
        }
        weakSelf.mTaskId = taskId;
        [weakSelf setTaskId:taskId];
    } faild:^(NSString *msg) {
        [SVProgressHUD showErrorWithStatus:msg];
    }];
}

- (void)updateUI {
    [super updateUI];
    [self getTaskId];
}

#pragma mark - 获取状态
- (void)getStatus:(NSString *)bizPk {
    [[HttpManager manager] get:[UrlConfig URL:getInstBizByBizPk] param:@{@"bizPk":bizPk} success:^(NSData *data) {
        if ([ResponseUtils success:data]) {
            NSDictionary *dic  = [data mj_JSONObject];
            [self updateStatus:dic[@"data"][@"status"]];
        }
    } faild:^(NSString *msg) {
        [SVProgressHUD showErrorWithStatus:msg];
    }];
}

#pragma mark - 同步更新状态
- (void)updateStatus:(NSString *)status {
    NSString *url = [UrlConfig URL:@"/api/quality/qualityOther/sgrz/save"];
    if ([self.flowType isEqualToString:@"2"]) {
        url = [UrlConfig URL:@"/api/quality/qualityOther/jlrz/save"];
    }
    
    [[HttpManager manager] post:url param:@{
        @"id": self.numId,
        @"statu": status
    } success:^(NSData *data) {
    } faild:^(NSString *msg) {
    }];
}

@end
