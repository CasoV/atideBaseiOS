//
//  ProjectInfo.m
//  PMPlatform_IOS
//
//  Created by vxg on 2017/09/06.
//  Copyright © 2017年 com.atide. All rights reserved.
//

#import "ProjectInfo.h"

@implementation ProjectInfo

- (NSString *)id {
    if (!_id) {
        _id = @"";
    }
    return _id;
}

- (NSMutableArray<ProjectInfo *> *)tempChildren {
    if (!_tempChildren) {
        _tempChildren = [NSMutableArray array];
    }
    return _tempChildren;
}

@end
