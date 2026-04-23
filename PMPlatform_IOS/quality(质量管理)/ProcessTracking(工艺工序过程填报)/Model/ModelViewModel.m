//
//  ModelViewModel.m
//  ConstructionApp
//
//  Created by 末末班车 on 2018/1/17.
//  Copyright © 2018年 atide. All rights reserved.
//

#import "ModelViewModel.h"

@implementation ModelViewModel

- (NSMutableArray<ModelViewModel *> *)children {
    if (!_children) {
        _children = [NSMutableArray array];
    }
    return _children;
}

@end
