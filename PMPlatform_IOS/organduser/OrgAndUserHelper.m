//
//  OrgAndUserHelper.m
//  circlViewText
//
//  Created by 末末班车 on 2017/9/7.
//  Copyright © 2017年 atide. All rights reserved.
//

#import "OrgAndUserHelper.h"
#import "OrgAndUserChoiceController.h"
#import "OrgAndUserMainController.h"
#import "OrgAndUserLeftController.h"
#import "FlowApprovalAssignees.h"

@implementation OrgAndUserHelper

+ (void)skipController:(UIViewController *)controller callback:(void (^)(NSArray<TreeNode *> *))callback {
    OrgAndUserMainController *mainViewController = [[OrgAndUserMainController alloc] init];
    mainViewController.callback = callback;
    OrgAndUserLeftController *rightVC = [[OrgAndUserLeftController alloc] initWithNibName:@"OrgAndUserLeftController" bundle:nil];
    
    OrgAndUserChoiceController *vc = [[OrgAndUserChoiceController alloc] initWithMainViewController:mainViewController rightMenuViewController:rightVC];
    vc.automaticallyAdjustsScrollViewInsets = NO;
    vc.delegate = mainViewController;
    [controller.navigationController pushViewController:vc animated:YES];
}

+ (void)skipController:(UIViewController *)controller flowPicLocation:(FlowPicLocation *)flowPicLocation callback:(void (^)(NSArray<TreeNode *> *))callback {
    NSString *orgId = @"";
    if ([flowPicLocation.selectScope isEqualToString:@"2"]) {
        orgId = [UserInfo getInstance].topOrgId;
    } else if ([flowPicLocation.selectScope isEqualToString:@"3"]) {
        orgId = [UserInfo getInstance].orgId;
    } else if ([flowPicLocation.selectScope isEqualToString:@"9"]) {
        OrgAndUserLeftController *vc = [[OrgAndUserLeftController alloc] initWithNibName:@"OrgAndUserLeftController" bundle:nil];
        vc.title = @"人员选择";
        
        NSMutableArray <TreeNode *>*arr = [NSMutableArray array];
        for (FlowApprovalAssignees *assignees in flowPicLocation.taskAssignees) {
            [arr addObject:[[TreeNode alloc] initWith:@"" ID:assignees.userId pId:@"0" name:assignees.userName]];
        }
        [vc loadNodes:arr callback:callback];
        [controller.navigationController pushViewController:vc animated:YES];
        
        return;
    }
    
    OrgAndUserMainController *mainViewController = [[OrgAndUserMainController alloc] init];
    mainViewController.callback = callback;
    mainViewController.orgId = orgId;
    OrgAndUserLeftController *rightVC = [[OrgAndUserLeftController alloc] initWithNibName:@"OrgAndUserLeftController" bundle:nil];
    
    OrgAndUserChoiceController *vc = [[OrgAndUserChoiceController alloc] initWithMainViewController:mainViewController rightMenuViewController:rightVC];
    vc.automaticallyAdjustsScrollViewInsets = NO;
    vc.delegate = mainViewController;
    vc.title = @"人员选择";
    [controller.navigationController pushViewController:vc animated:YES];
}
@end
