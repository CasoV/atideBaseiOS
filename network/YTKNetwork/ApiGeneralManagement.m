//
//  GeneralManagementApi.m
//  ConstructionApp
//
//  Created by RedLi on 2018/1/19.
//  Copyright © 2018年 atide. All rights reserved.
//

#import "ApiGeneralManagement.h"

static NSDictionary *keyDic;

@implementation ApiGeneralManagement {
    GeneralManagementType _flag;
    NSString *_bizKey;
    NSString *_finalStr;
}

- (instancetype)initWithRequestParams:(id)requestParams flag:(NSInteger)flag bizKey:(NSString*) bizKey {
    if (self = [super initWithRequestParams:requestParams]) {
        _flag = flag;
        _bizKey = bizKey;
        keyDic = @{
                   @"staff_travel":@"staffTravel",
                   @"construction_process":@"constructionProcess",
                   @"approval_plan":@"mouthPlan",
                   };
    }
    return self;
}

- (void) initFinalStr:(NSString *)finalStr {
    _finalStr = finalStr;
}

- (NSString *)requestUrl {
    NSString *str = @"";
    NSString *midStr = @"";
    switch (_flag) {
        case FlowToolbar:
            return @"/workflow/commonFlow/getFlowToolbar";
        case BaseInfo:
            return @"";
        case Comments:
            return @"/workflow/commonFlow/getComments";
        case HandleHis:
            return @"/workflow/mobileFlow/queryHandleHis";
        case AddSave:
            midStr = keyDic[_bizKey];
            str = @"save"; //newFormFlag 参数为1
            break;
        case EditSave:
            midStr = keyDic[_bizKey];
            str = @"save"; //newFormFlag 参数为0
            break;
        case DELETE:
            midStr = keyDic[_bizKey];
            str = _finalStr == nil ? @"delete" : _finalStr;
            break;
        case SUBMIT:
            return @"/workflow/mobileFlow/pass";
        case REVOKE:
            midStr = keyDic[_bizKey];
            str = @"revokeTask";
            break;
        case REJECT:
            return @"/workflow/mobileFlow/reject";
        case PASS:
            return @"/workflow/mobileFlow/pass";
        case SUBMIT_SAVE:
            midStr = keyDic[_bizKey];
            str = @"completeTask";
            break;
        case REJECT_SAVE:
            midStr = keyDic[_bizKey];
            str = @"rejectTask";
            break;
        case PASS_SAVE:
            midStr = keyDic[_bizKey];
            str = @"completeTask";
            break;
        default:
            return @"";
    }
    return [NSString stringWithFormat:@"/processapproval/%@/%@", midStr, str];
}

- (NSString *)baseUrl {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *protocol = [userDefaults objectForKey:@"protocol"];
    NSString *ip = [userDefaults objectForKey:@"ip"];
    NSString *port = [userDefaults objectForKey:@"port"];
    NSString *temp = @":";
    if ([port isEqualToString:@""]) {
        temp = @"";
    }
    return [NSString stringWithFormat:@"%@://%@%@%@/api", protocol, ip, temp, port];
}

@end
