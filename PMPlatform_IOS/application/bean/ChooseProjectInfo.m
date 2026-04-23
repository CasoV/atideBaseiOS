//
//  ChooseProjectInfo.m
//  ycxm
//
//  Created by 末末班车 on 2022/3/9.
//  Copyright © 2022 末末班车. All rights reserved.
//

#import "ChooseProjectInfo.h"

@implementation ChooseProjectInfo

- (instancetype)initWithTitle:(NSString *)title {
    if (self = [super init]) {
        _title = title;
    }
    return self;
}

- (instancetype)initWithProjectInfo:(ProjectInfo *)projectInfo {
    if (self = [super init]) {
        _projectInfo = projectInfo;
        _title = projectInfo.label;
        _selected = projectInfo.selected;
    }
    return self;
}

- (NSMutableArray<ChooseProjectInfo *> *)children {
    if (!_children) {
        _children = [NSMutableArray array];
    }
    return _children;
}

@end
