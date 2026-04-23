//
//  TreeNodeHelper.m
//  circlViewText
//
//  Created by 末末班车 on 2017/9/7.
//  Copyright © 2017年 atide. All rights reserved.
//

#import "TreeNodeHelper.h"

@implementation TreeNodeHelper

//MARK: 创建单例
static TreeNodeHelper * helper;

+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        helper = [[self alloc] init];
    });
    return helper;
}

- (NSArray<TreeNode *> *)getSortedNodes:(NSArray<TreeNode *> *)groups defaultExpandLevel:(NSInteger)defaultExpandLevel {
    NSMutableArray <TreeNode *>*result = [NSMutableArray array];
    NSArray <TreeNode *>*nodes = [self convetData2Node:groups];
    NSArray <TreeNode *>*rootNodes = [self getRootNodes:nodes];

    for (TreeNode *item in rootNodes) {
        [self addNode:result node:item defaultExpandLeval:defaultExpandLevel currentLevel:1];
    }
    
    return result;
}

- (NSArray<TreeNode *> *)filterVisibleNode:(NSArray<TreeNode *> *)nodes {
    NSMutableArray <TreeNode *>*result = [NSMutableArray array];
    for (TreeNode *item in nodes) {
        if ([item isRoot] || [item isParentExpand]) {
            [self setNodeIcon:item];
            [result addObject:item];
        }
    }
    return [result copy];
}

// 设置节点图标
- (void)setNodeIcon:(TreeNode *)node {
    if (node.children.count > 0) {
        node.type = NODE_TYPE_G;
        if (node.isExpand) {
            // 设置icon为向下的箭头
            node.icon = @"tree_ex.png";
        }else if (!node.isExpand) {
            // 设置icon为向右的箭头
            node.icon = @"tree_ec.png";
        }
    }else {
        node.type = NODE_TYPE_N;
    }
}

//将数据转换成书节点
- (NSArray <TreeNode *>*)convetData2Node:(NSArray <TreeNode *>*)groups {
    NSMutableArray <TreeNode *>*nodes = [NSMutableArray array];
    
    TreeNode *node;
    
    for (TreeNode *item1 in groups) {
        node = [[TreeNode alloc] initWith:item1.desc ID:item1.ID pId:item1.pId name:item1.name];
        node.isNext = item1.isNext;
        node.isSelected = item1.isSelected;
        [nodes addObject:node];
    }
    
    /**
     * 设置Node间，父子关系;让每两个节点都比较一次，即可设置其中的关系
     */
    TreeNode *Nnn;
    TreeNode *Mmm;

    for (int i = 0; i < nodes.count; i++) {
        Nnn = nodes[i];
        
        for (int j = i + 1; j < nodes.count; j++) {
            Mmm = nodes[j];
            if ([Mmm.pId isEqualToString:Nnn.ID]) {
                [Nnn.children addObject:Mmm];
                Mmm.parent = Nnn;
            } else if ([Nnn.pId isEqualToString:Mmm.ID]) {
                [Mmm.children addObject:Nnn];
                Nnn.parent = Mmm;
            }
        }
    }
    
    for (TreeNode *item in nodes) {
        [self setNodeIcon:item];
    }
    
    return nodes;
}

// 获取根节点集
- (NSArray <TreeNode *>*)getRootNodes:(NSArray <TreeNode *>*)nodes {
    NSMutableArray <TreeNode *>*root = [NSMutableArray array];
    for (TreeNode *item in nodes) {
        if (item.isRoot) {
            [root addObject:item];
        }
    }

    return root;
}
//把一个节点的所有子节点都挂上去
- (void)addNode:(NSMutableArray <TreeNode *>*)nodes node:(TreeNode *)node defaultExpandLeval:(NSInteger)defaultExpandLeval currentLevel:(NSInteger)currentLevel {
    [nodes addObject:node];
    if (defaultExpandLeval >= currentLevel) {
        [node setExpand:YES];
    }
    if ([node isLeaf]) {
        return;
    }
    
    for (int i = 0; i < node.children.count; i++) {
        [self addNode:nodes node:node.children[i] defaultExpandLeval:defaultExpandLeval currentLevel:currentLevel + 1];
    }
}

@end
