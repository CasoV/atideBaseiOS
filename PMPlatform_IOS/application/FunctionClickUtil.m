//
//  FunctionClickUtil.m
//  PMPlatform_IOS
//
//  Created by 末末班车 on 2022/6/13.
//  Copyright © 2022 com.atide. All rights reserved.
//

#import "FunctionClickUtil.h"
#import "NewFunctionListController.h"
#import "BaseWebViewController.h"
#import "LogMainViewController.h"
#import "BaseListViewController.h"

@implementation FunctionClickUtil

+(void)handleFunctionClick:(UIViewController *)controller functionData:(PermissionModel *)data {
    if (data.children && data.children.count > 0) {
        NewFunctionListController *vc = [[NewFunctionListController alloc] init];
        vc.dataSource = data.children;
        vc.model = data;
        vc.hidesBottomBarWhenPushed = YES;
        [controller.navigationController pushViewController:vc animated:YES];
        return;
    }
    
    if (data.actionType && [data.actionType isEqualToString:@"html5"]) {
        if (!data.url) {
            [MBManager showBriefAlert:@"功能地址未配置，请联系管理员配置！"];
            return;
        }
        [[UserAgent DefaultAgent] authorityChangeProAndSect:data callBack:^(Boolean isChange) {
            BaseWebViewController *webvc =  [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"BaseWebViewController"];
            webvc.title = data.resourceName;
            
            NSString *userName = [[NSUserDefaults standardUserDefaults] objectForKey:@"user"];
            NSString *password = [[NSUserDefaults standardUserDefaults] objectForKey:@"password"];
            NSString *webTag = [data.url containsString:@"?"]?@"&":@"?";
            NSString *url = [NSString stringWithFormat:@"/%@", data.url];
            if ([[UserAgent DefaultAgent].sectionId isEqualToString:@""]) {
                webvc.url = [NSString stringWithFormat:@"%@%@user=%@&pwd=%@&projectId=%@&projectCode=%@&projectName=%@&sectionId=%@", [UrlConfig URL:url],webTag, [userName stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]], [password stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]], [UserAgent DefaultAgent].projectId, [UserAgent DefaultAgent].projectCode, [[UserAgent DefaultAgent].prjName stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]], [UserAgent DefaultAgent].projectId];
            } else {
                webvc.url = [NSString stringWithFormat:@"%@%@user=%@&pwd=%@&projectId=%@&projectCode=%@&projectName=%@&sectionId=%@&sectionCode=%@&sectionName=%@", [UrlConfig URL:url],webTag, [userName stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]], [password stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]], [UserAgent DefaultAgent].projectId, [UserAgent DefaultAgent].projectCode, [[UserAgent DefaultAgent].prjName stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]], [UserAgent DefaultAgent].sectionId, [UserAgent DefaultAgent].sectionCode, [[UserAgent DefaultAgent].sectionName stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]];
            }
//            if (isChangeProSect) {
//                [self autoChangeProSectHint:vc.view];
//            }
            [controller.navigationController pushViewController:webvc animated:YES];
        }];
    } else if (data.actionType && [data.actionType isEqualToString:@"native"]) {
        if (!data.iosClassName && (!data.sbId || !data.sbName)) {
            [MBManager showBriefAlert:@"iOS配置错误，请联系管理员配置！"];
            return;
        }
        
        [[UserAgent DefaultAgent] authorityChangeProAndSect:data callBack:^(Boolean isChange) {
            UIViewController *vc;
            
            if (data.iosClassName && ![data.iosClassName isEqualToString:@""]) {
                vc = [[NSClassFromString(data.iosClassName) alloc] init];
            } else if (data.sbName && data.sbId) {
                vc = [[UIStoryboard storyboardWithName:data.sbName bundle:nil] instantiateViewControllerWithIdentifier:data.sbId];
            }
            
            if (vc) {
//                if (isChangeProSect) {
//                    [self autoChangeProSectHint:vc.view];
//                }
                if (data.description != nil && ![data.description isEqualToString:@""]) {
                    NSDictionary *dic = [data.des mj_JSONObject];
                    for (NSString *key in dic) {
                        if ([key isEqualToString:@"type"] && ([data.resourceName isEqualToString:@"施工日志"] || [data.resourceName isEqualToString:@"监理日志"])) {
                            LogMainViewController *tempVc = vc;
                            tempVc.type = [dic[key] intValue];
                        }
                        if ([key isEqualToString:@"type"] && ([data.resourceName isEqualToString:@"旁站记录"] || [data.resourceName isEqualToString:@"巡视记录"])) {
                            BaseListViewController *tempVc = vc;
                            NSString *type = dic[key];
                            tempVc.type = [type integerValue];
                        }
                    }
                }
                vc.hidesBottomBarWhenPushed = YES;
                controller.navigationController.navigationBar.hidden = NO;
                [controller.navigationController pushViewController:vc animated:YES];
            } else {
                [MBManager showBriefAlert:@"系统正在集成中...请静待开放"];
            }
        }];
    } else {
        [MBManager showBriefAlert:@"动作类型未配置，请联系管理员配置！"];
    }
}

@end
