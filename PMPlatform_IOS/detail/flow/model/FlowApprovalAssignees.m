    //
//  FlowApprovalAssignees.m
//  PMPlatform_IOS
//
//  Created by 末末班车 on 2017/9/13.
//  Copyright © 2017年 com.atide. All rights reserved.
//

#import "FlowApprovalAssignees.h"

@implementation FlowApprovalAssignees

- (NSString *)getJson {
//    return [NSString stringWithFormat:@"{\"id\":\"%@\",\"instId\":\"%@\",\"orgId\":\"%@\",\"orgName\":\"%@\",\"taskKey\":\"%@\",\"userId\":\"%@\",\"userName\":\"%@\"}", self.ID, self.instId, self.orgId, self.orgName, self.taskKey, self.userId, self.userName];
    return [NSString stringWithFormat:@"{\"orgId\":\"%@\",\"orgName\":\"%@\",\"taskKey\":\"%@\",\"userId\":\"%@\",\"userName\":\"%@\"}", self.orgId, self.orgName, self.taskKey, self.userId, self.userName];
}

@end
