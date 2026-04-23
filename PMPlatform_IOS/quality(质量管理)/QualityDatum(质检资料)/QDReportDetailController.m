//
//  QDReportDetailController.m
//  HBConstructionApp
//
//  Created by vxg on 2018/04/04.
//  Copyright © 2018年 atide. All rights reserved.
//

#import "QDReportDetailController.h"
#import "QDPdfController.h"
#import "UserTaskModel.h"

@interface QDReportDetailController ()

@end

@implementation QDReportDetailController

- (void)viewDidLoad {
    [self setValue];
    [self initFirstVc];
    
    [super viewDidLoad];
    
    [self getTaskId];
}

#pragma mark - 参数传递
- (void)setValue {
    if (self.model) {
        self.bizPk = self.model.instId;
        self.title = self.model.name;
        self.numId = self.model.numId;
        self.status = self.model.testStatus;
        self.bizKey = self.model.processCode;
        self.partCode = self.model.partCode;
    }
    self.showSaveBtn = NO;
//    self.showVideoMaterial = YES;
}

#pragma mark - 初始页面
- (void)initFirstVc {
    QDPdfController *vc = [[QDPdfController alloc] init];
    vc.model = self.model;
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
        [weakSelf setTaskId:taskId];
    } faild:^(NSString *msg) {
        [SVProgressHUD showErrorWithStatus:msg];
    }];
}

- (void)updateUI {
    [super updateUI];
    [self getTaskId];
}

@end
