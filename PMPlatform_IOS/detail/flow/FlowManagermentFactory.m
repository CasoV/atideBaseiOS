//
//  FlowManagermentFactory.m
//  PMPlatform_IOS
//
//  Created by 末末班车 on 2017/9/13.
//  Copyright © 2017年 com.atide. All rights reserved.
//

#import "FlowManagermentFactory.h"
#import "UpdateCommentController.h"
#import "PassViewController.h"
#import "TransferController.h"
#import "ResultController.h"
#import "FlowOperator.h"

@implementation FlowManagermentFactory

static UINavigationController *navigator;
static NSString *SYMBOL;
static void (^updateMethod)(void);

+ (void)config:(UINavigationController *)navigatorController symbol:(NSString *)symbol update:(void (^)(void))update {
    navigator = navigatorController;
    SYMBOL = symbol;
    updateMethod = update;
}

+ (void)factory:(Panel *)item bizPk:(NSString *)bizPk instanceId:(NSString *)instanceId bizUrl:(NSString *)bizUrl{
    FlowOperatorType type = [FlowOperator generator:item.ID];
    
    switch (type) {
        case FlowOperatorTypeREVOKE:
            break;
        case FlowOperatorTypePASS:
            [FlowManagermentFactory pass:bizPk instanceId:instanceId bizUrl:bizUrl title:item.iconName];
            break;
        case FlowOperatorTypeSeal:
            [FlowManagermentFactory pass:bizPk instanceId:instanceId bizUrl:bizUrl title:item.iconName];
            break;
        case FlowOperatorTypeSUBMIT:
            [FlowManagermentFactory submit:bizPk instanceId:instanceId bizUrl:bizUrl];
            break;
        case FlowOperatorTypeREJECT:
            [FlowManagermentFactory reject:bizPk instanceId:instanceId bizUrl:bizUrl title:item.iconName];
            break;
        case FlowOperatorTypeUPDATECOMMENT:
            [FlowManagermentFactory updateComment:bizPk instanceId:instanceId bizUrl:bizUrl];
            break;
        case FlowOperatorTypeREPLACEPAAS:
            [FlowManagermentFactory replacePass:bizPk instanceId:instanceId bizUrl:bizUrl];
            break;
        case FlowOperatorTypeTRANSFER:
            [FlowManagermentFactory transfer:bizPk instanceId:instanceId bizUrl:bizUrl];
            break;
        case FlowOperatorTypePROCESS:
            [FlowManagermentFactory process:instanceId];
            break;
        case FlowOperatorTypeRESULT:
            [FlowManagermentFactory result:bizPk instanceId:instanceId bizUrl:bizUrl];
            break;
        default:
            break;
    }
}

+ (void)process:(NSString *)instanceId {
    
}

+ (void)pass:(NSString *)bizKey instanceId:(NSString *)instanceId bizUrl:(NSString *)bizUrl{
    [FlowManagermentFactory pass:bizKey instanceId:instanceId bizUrl:bizUrl title:@"审核"];
}

+ (void)pass:(NSString *)bizKey instanceId:(NSString *)instanceId bizUrl:(NSString *)bizUrl title:(NSString *)title{
    PassViewController *vc = [[UIStoryboard storyboardWithName:@"Flow" bundle:nil] instantiateViewControllerWithIdentifier:@"pass"];
    vc.instanceId = instanceId;
    vc.bizKey = bizKey;
    vc.bizUrl = bizUrl;
    vc.url = pass;
    vc.title = title;
    
    if (![SYMBOL isEqualToString:@""]) {
        NSArray <NSString *>*items = [SYMBOL componentsSeparatedByString:@",usertask"];
        if (items.count > 1) {
            vc.taskId = [NSString stringWithFormat:@"usertask%@", items[1]];
            vc.completeInfo = items[0];
        } else {
            vc.taskId = items[0];
        }
    }
    
    [navigator pushViewController:vc animated:YES];
}

+ (void)submit:(NSString *)bizKey instanceId:(NSString *)instanceId bizUrl:(NSString *)bizUrl{
    PassViewController *vc = [[UIStoryboard storyboardWithName:@"Flow" bundle:nil] instantiateViewControllerWithIdentifier:@"pass"];
    vc.instanceId = instanceId;
    vc.bizKey = bizKey;
    vc.bizUrl = bizUrl;
    vc.url = pass;
    vc.title = @"提交";
    
    if (![SYMBOL isEqualToString:@""]) {
        vc.taskId = [NSString stringWithFormat:@"usertask%@",[SYMBOL componentsSeparatedByString:@",usertask"][1]];
        vc.completeInfo = [SYMBOL componentsSeparatedByString:@",usertask"][0];
    }
    
    [navigator pushViewController:vc animated:YES];
}

+ (void)reject:(NSString *)bizKey instanceId:(NSString *)instanceId bizUrl:(NSString *)bizUrl title:(NSString *)title{
    PassViewController *vc = [[UIStoryboard storyboardWithName:@"Flow" bundle:nil] instantiateViewControllerWithIdentifier:@"pass"];
    vc.instanceId = instanceId;
    vc.bizKey = bizKey;
    vc.bizUrl = bizUrl;
    vc.url = reject;
    vc.title = title;
    if (![SYMBOL isEqualToString:@""]) {
        NSArray <NSString *>*items = [SYMBOL componentsSeparatedByString:@",usertask"];
        if (items.count > 1) {
            vc.taskId = [NSString stringWithFormat:@"usertask%@", items[1]];
            vc.completeInfo = items[0];
        } else {
            vc.taskId = items[0];
        }
    }
    [navigator pushViewController:vc animated:YES];
}

+ (void)updateComment:(NSString *)bizKey instanceId:(NSString *)instanceId bizUrl:(NSString *)bizUrl{
    UpdateCommentController *vc = [[UIStoryboard storyboardWithName:@"Flow" bundle:nil] instantiateViewControllerWithIdentifier:@"updateComment"];
    vc.instanceId = instanceId;
    vc.bizKey = bizKey;
    vc.url = updateComment;
    vc.title = @"补签";
    [navigator pushViewController:vc animated:YES];
}

+ (void)replacePass:(NSString *)bizKey instanceId:(NSString *)instanceId bizUrl:(NSString *)bizUrl{
    PassViewController *vc = [[UIStoryboard storyboardWithName:@"Flow" bundle:nil] instantiateViewControllerWithIdentifier:@"pass"];
    vc.instanceId = instanceId;
    vc.bizKey = bizKey;
    vc.bizUrl = bizUrl;
    vc.url = replacePass;
    vc.title = @"代签";
    [navigator pushViewController:vc animated:YES];
}

+ (void)transfer:(NSString *)bizKey instanceId:(NSString *)instanceId bizUrl:(NSString *)bizUrl{
    TransferController *vc = [[UIStoryboard storyboardWithName:@"Flow" bundle:nil] instantiateViewControllerWithIdentifier:@"transfer"];
    vc.instanceId = instanceId;
    vc.bizKey = bizKey;
    vc.title = @"转办";
    [navigator pushViewController:vc animated:YES];
}

+ (void)result:(NSString *)bizKey instanceId:(NSString *)instanceId bizUrl:(NSString *)bizUrl{
    ResultController *vc = [[UIStoryboard storyboardWithName:@"Flow" bundle:nil] instantiateViewControllerWithIdentifier:@"result"];
    vc.memo = bizKey;
    vc.ID = instanceId;
    [navigator pushViewController:vc animated:YES];
}

@end
