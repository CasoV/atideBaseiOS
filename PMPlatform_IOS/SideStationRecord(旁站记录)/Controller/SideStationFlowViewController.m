//
//  SideStationFlowViewController.m
//  ycxm
//
//  Created by 高小伟 on 2021/4/19.
//  Copyright © 2021 末末班车. All rights reserved.
//
#import "SideStationFlowViewController.h"
#import "QDPdfController.h"
#import "UserTaskModel.h"

@interface SideStationFlowViewController ()

@end

@implementation SideStationFlowViewController

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
    self.showVideoMaterial = NO;
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
        if (datas.count >= 2) {
            taskId = datas[0].id;
            if (datas[0].endTime == nil) {
                taskId = datas[1].id;
            }
        } else if (datas.count == 1) {
            taskId = datas[0].id;
        }
        [weakSelf setTaskId:taskId];
        [(QDPdfController *)weakSelf.firstVC setTaskId:taskId];
    } faild:^(NSString *msg) {
        [SVProgressHUD showErrorWithStatus:msg];
    }];
}

- (void)updateUI {
    [super updateUI];
    [self getTaskId];
}

@end
