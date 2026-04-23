//
//  MatterDetailController.m
//  ycxm
//
//  Created by 末末班车 on 2018/10/19.
//  Copyright © 2018年 末末班车. All rights reserved.
//

#import "MatterDetailController.h"
//#import "MatterBaseInfoController.h"
#import "QDOriginalRecordController.h"

@interface MatterDetailController ()

@end

@implementation MatterDetailController

- (void)viewDidLoad {
    self.title = self.model.bizTypeName;
    self.showSaveBtn = NO;
    self.bizPk = self.model.bizPk;
    self.bizKey = self.model.bizType;
    if (!self.partCode) {
        self.partCode = self.model.variables.partCode;
    }
    
    if (self.model.variables.tableUrlStr) {
        if ([self.model.variables.tableUrlStr componentsSeparatedByString:@"/"].count >= 3) {
            self.bizUrl = [self.model.variables.tableUrlStr componentsSeparatedByString:@"/"][2];
        }
    } else {
        if ([self.model.doUrl componentsSeparatedByString:@"/"].count >= 3) {
            self.bizUrl = [self.model.doUrl componentsSeparatedByString:@"/"][2];
        }
    }
    
    if ([self.bizUrl isEqualToString:ORIGINALRECORD[@"id"]]) {
        QDOriginalRecordController *vc = [[QDOriginalRecordController alloc] init];
        vc.bizPk = self.bizPk;
        vc.numId = self.numId;
        vc.bizKey = self.bizKey;
        vc.status = self.status;
        vc.formTitle = self.title;
        vc.partCode = self.partCode;
        vc.newFormFlag = self.newFormFlag;
        self.firstVC = vc;
    } else {
//        MatterBaseInfoController *fVC = [[MatterBaseInfoController alloc] init];
//        fVC.model = self.model;
//        self.firstVC = fVC;
    }
    
    [super viewDidLoad];
}

@end
