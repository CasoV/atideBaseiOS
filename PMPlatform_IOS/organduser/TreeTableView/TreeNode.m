//
//  TreeNode.m
//  circlViewText
//
//  Created by 末末班车 on 2017/9/7.
//  Copyright © 2017年 atide. All rights reserved.
//

#import "TreeNode.h"

@implementation TreeNode

- (instancetype)initWith:(NSString *)desc ID:(NSString *)ID pId:(NSString *)pId name:(NSString *)name {
    if (self = [super init]) {
        _desc = desc;
        _ID = ID;
        _pId = pId;
        _name = name;
    }
    return self;
}

- (BOOL)isRoot {
    return self.parent == nil;
}

- (BOOL)isParentExpand {
    if (self.parent == nil) {
        return NO;
    }
    return self.parent.isExpand;
}

- (BOOL)isLeaf {
    return self.children.count == 0;
}

- (NSInteger)getLevel {
    return self.parent == nil ? 0 : [self.parent getLevel] + 1;
}
- (NSMutableArray<TreeNode *> *)children {
    if (!_children) {
        _children = [NSMutableArray array];
    }
    return _children;
}

- (void)setExpand:(BOOL)isExpand {
    self.isExpand = isExpand;
    if (!isExpand) {
        for (int i = 0; i < self.children.count; i++) {
            [self.children[i] setExpand:isExpand];
        }
    }
}

- (BOOL)isEqual:(id)object {
    if (object) {
        if ([object isKindOfClass:[TreeNode class]]) {
            TreeNode *ano = (TreeNode *)object;
            if ([ano.ID isEqualToString:self.ID]) {
                return YES;
            }
        }
    }
    return NO;
}

@end
