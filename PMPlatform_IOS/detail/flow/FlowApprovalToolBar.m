//
//  FlowApprovalToolBar.m
//  PMPlatform_IOS
//
//  Created by 末末班车 on 2017/9/12.
//  Copyright © 2017年 com.atide. All rights reserved.
//

#import "FlowApprovalToolBar.h"
#import "FlowOperator.h"


@implementation FlowApprovalToolBar

- (void)request:(NSString *)instanceId bizKey:(NSString *)bizKey callback:(void (^)(NSArray <Panel *>*))callback {
    NSDictionary *param = @{@"bizKey":bizKey,
                            @"bizPk":instanceId,
                            @"sectId":[UserAgent DefaultAgent].sectionId,
                            @"projectId":[UserAgent DefaultAgent].projectId};
    [[HttpManager manager] post:[UrlConfig URL:getFlowToolbar] param:param success:^(NSData *data) {
        if ([ResponseUtils success:data]) {
            NSArray <ToolBar *>*result = [ToolBar mj_objectArrayWithKeyValuesArray:[ResponseUtils getData:@"data"]];
            if (result) {
                NSMutableArray <Panel *>*items = [NSMutableArray array];
                for (ToolBar *item in result) {
                    if ([item.name isEqualToString:@"删除"]) {
                        if (!self.isMatter) {
                            [items addObject:[FlowOperator generatorInfo:item]];
                        }
                    } else if ([item.name isEqualToString:@"打印"] || [item.name isEqualToString:@"关联记录表"]) {
                        break;
                    } else {
                        [items addObject:[FlowOperator generatorInfo:item]];
                    }
                }
                if (callback) {
                    callback(items);
                }
            }
        }else {
            if (callback) {
                callback(nil);
            }
        }
    } faild:^(NSString *msg) {
        if (callback) {
            callback(nil);
        }
    }];
}

- (void)request:(NSString *)bizPk bizKey:(NSString *)bizKey callbackAll:(void (^)(NSArray <ToolBar *>*))callbackAll {
    NSDictionary *param = @{@"bizKey":bizKey,
                            @"bizPk":bizPk};
    [[HttpManager manager] post:[UrlConfig URL:getFlowToolbar] param:param success:^(NSData *data) {
        if ([ResponseUtils success:data]) {
            NSArray <ToolBar *>*result = [ToolBar mj_objectArrayWithKeyValuesArray:[ResponseUtils getData:@"data"]];
            if (result && callbackAll) {
                NSMutableArray <ToolBar *>*items = [NSMutableArray array];
                for (ToolBar *item in result) {
                    if (![item.name isEqualToString:@"打印"] ||
                        ![item.name isEqualToString:@"返回"] ||
                        ![item.name isEqualToString:@"办理过程"]) {
                        [items addObject:item];
                    }
                }
                callbackAll(items);
            }
        }else {
            if (callbackAll) {
                callbackAll(nil);
            }
        }
    } faild:^(NSString *msg) {
        if (callbackAll) {
            callbackAll(nil);
        }
    }];
}

@end
