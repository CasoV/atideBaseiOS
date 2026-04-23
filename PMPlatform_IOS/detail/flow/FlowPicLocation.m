//
//  FlowPicLocation.m
//  PMPlatform_IOS
//
//  Created by 末末班车 on 2017/9/13.
//  Copyright © 2017年 com.atide. All rights reserved.
//

#import "FlowPicLocation.h"

#define BUTTONW 60
#define BUTTONH 25

@implementation FlowPicLocation

- (CGFloat)getPassCellHeight:(BOOL)haveLeft {
    if ([self.selectUser isEqualToString:@"1"]) {
        return 60;
    }
    CGFloat width;
    if (haveLeft) {
        width = kScreen_Width - 70;
    } else {
        width = kScreen_Width - 40;
    }
    
    if (self.taskAssignees != nil && self.taskAssignees.count != 0) {
        CGFloat x = 0;
        CGFloat y = 0;
        for (int i = 0; i < self.taskAssignees.count; i++) {
            if (x + BUTTONW > width) {
                x = 0;
                y += BUTTONH;
            }
            x += BUTTONW;
        }
        return y + BUTTONH + 30;
    }else {
        return 30;
    }
}

- (NSString *)getJsonTaskAssigness {
    if (self.taskAssignees == nil && self.taskAssignees.count == 0) {
        return @"";
    }
    
    NSString *result = @"";
    
    BOOL isFirst = YES;
    for (FlowApprovalAssignees *item in self.taskAssignees) {
        item.taskKey = self.ID;
        if ([item.checked isEqualToString:@"1"]) {
            if (isFirst) {
                isFirst = NO;
                result = [item getJson];
            } else {
                result = [NSString stringWithFormat:@"%@,%@", result, [item getJson]];
            }
        }
    }
    
    return result;
}

@end
