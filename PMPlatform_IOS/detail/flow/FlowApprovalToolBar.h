//
//  FlowApprovalToolBar.h
//  PMPlatform_IOS
//
//  Created by 末末班车 on 2017/9/12.
//  Copyright © 2017年 com.atide. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ToolBar.h"
#import "Panel.h"

@interface FlowApprovalToolBar : NSObject

@property (nonatomic, assign) BOOL isMatter;

- (void)request:(NSString *)instanceId bizKey:(NSString *)bizKey callback:(void (^)(NSArray <Panel *>*))callback;

- (void)request:(NSString *)bizPk bizKey:(NSString *)bizKey callbackAll:(void (^)(NSArray <ToolBar *>*))callbackAll;

@end
