//
//  WebServiceConfig.m
//  PMPlatform_IOS
//
//  Created by vxg on 2017/09/05.
//  Copyright © 2017年 com.atide. All rights reserved.
//

#import "WebServiceConfig.h"

@implementation WebServiceConfig
static NSString *SecurityService = @"SecurityService";
static NSString *PrjectOverViewService = @"PrjectOverViewService";
static NSString *PayWebService = @"PayWebService";
static NSString *ProgressService = @"ProgressService";
static NSString *SingleProjectService = @"SingleProjectService";
+ (NSString *)SecurityService{
    return SecurityService;
}
+ (NSString *)PrjectOverViewService{
    return PrjectOverViewService;
}
+ (NSString *)PayWebService {
    return PayWebService;
}
+ (NSString *)ProgressService{
    return ProgressService;
}
+ (NSString *)SingleProjectService{
    return SingleProjectService;
}
+ (NSDictionary *)config:(NSString *)category{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    if ([category isEqualToString:SecurityService]) {
        [dict setObject:@"http://220.165.247.79:9004/SecurityService.asmx" forKey:@"url"];
        [dict setObject:@"http://www.atidesoft.com/SecurityService/" forKey:@"nameSpace"];
        [dict setObject:@"GetProjectsByUserKeys" forKey:@"GetProjectsByUserKeys"];
        
    }else if([category isEqualToString:PrjectOverViewService]){
        [dict setObject:@"http://220.165.247.79:9004/PrjectOverViewService.asmx" forKey:@"url"];
        [dict setObject:@"http://www.atidesoft.com/PrjectOverViewService/" forKey:@"nameSpace"];
        
        [dict setObject:@"StatProjectInvestFinished" forKey:@"StatProjectInvestFinished"];
        [dict setObject:@"StatProgressFinished" forKey:@"StatProgressFinished"];
        [dict setObject:@"GetSectDatas" forKey:@"GetSectDatas"];
    }else if([category isEqualToString:PayWebService]){
        [dict setObject:@"http://220.165.247.79:6808/PayWebService.asmx" forKey:@"url"];
        [dict setObject:@"http://www.atidesoft.com/PayWebService/" forKey:@"nameSpace"];
        
        [dict setObject:@"GetApprovalGroups" forKey:@"GetApprovalGroups"];
        [dict setObject:@"ApprovalPayCert" forKey:@"ApprovalPayCert"];
        [dict setObject:@"ReturnPayCert" forKey:@"ReturnPayCert"];
    }else if([category isEqualToString:ProgressService]){
        [dict setObject:@"http://220.165.247.79:9004/ProgressService.asmx" forKey:@"url"];
        [dict setObject:@"http://www.atidesoft.com/ProgressService/" forKey:@"nameSpace"];
        [dict setObject:@"GetPrjQuantity" forKey:@"GetPrjQuantity"];
    }else if([category isEqualToString:SingleProjectService]){
        [dict setObject:@"http://119.62.44.163:8687/SingleProjectService.asmx" forKey:@"url"];
        [dict setObject:@"http://www.atidesoft.com/SingleProjectService/" forKey:@"nameSpace"];
        [dict setObject:@"GetProjectInfoDatasByPrjCode" forKey:@"GetProjectInfoDatasByPrjCode"];
    }
    return dict;
}

@end
