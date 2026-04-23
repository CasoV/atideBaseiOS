//
//  FlowPicLocation.h
//  PMPlatform_IOS
//
//  Created by 末末班车 on 2017/9/13.
//  Copyright © 2017年 com.atide. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FlowApprovalResult.h"
#import "FlowApprovalAssignees.h"

typedef NS_ENUM(NSInteger, TaskSelectScope) {
    ALL = 1,    //全部
    TOP_ORG,    //公司
    ORG,        //部门
    FLOW = 9    //流程定义
};

@interface FlowPicLocation : NSObject

@property (nonatomic, copy) NSString *status;
@property (nonatomic, copy) NSString *width;
@property (nonatomic, copy) NSString *type;
@property (nonatomic, copy) NSString *skip;
@property (nonatomic, copy) NSString *parallelMulti;
@property (nonatomic, copy) NSString *selectUser;
@property (nonatomic, copy) NSString *ID;
@property (nonatomic, copy) NSString *pointx;
@property (nonatomic, copy) NSString *pointy;
@property (nonatomic, copy) NSString *height;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *jsonTaskAssignees;
@property (nonatomic, copy) NSString *selectScope;
@property (nonatomic, assign) BOOL pointSelected;

@property (nonatomic, copy) NSArray <FlowApprovalResult *>*opinions;
@property (nonatomic, copy) NSArray <FlowApprovalAssignees *>*taskAssignees;

- (CGFloat)getPassCellHeight:(BOOL)haveLeft;

- (NSString *)getJsonTaskAssigness;

@end
