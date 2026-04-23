//
//  FlowApprovalAssignees.h
//  PMPlatform_IOS
//
//  Created by 末末班车 on 2017/9/13.
//  Copyright © 2017年 com.atide. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FlowApprovalAssignees : NSObject

@property (nonatomic, copy) NSString *userName;
@property (nonatomic, copy) NSString *checked;
@property (nonatomic, copy) NSString *ID;
@property (nonatomic, copy) NSString *instId;
@property (nonatomic, copy) NSString *orgId;
@property (nonatomic, copy) NSString *orgName;
@property (nonatomic, copy) NSString *taskKey;
@property (nonatomic, copy) NSString *userId;

- (NSString *)getJson;

@end
