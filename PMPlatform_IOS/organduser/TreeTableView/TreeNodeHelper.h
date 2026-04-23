//
//  TreeNodeHelper.h
//  circlViewText
//
//  Created by 末末班车 on 2017/9/7.
//  Copyright © 2017年 atide. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TreeNode.h"

@interface TreeNodeHelper : NSObject

+ (instancetype)sharedInstance;

//传入普通节点，转换成排序后的Node
- (NSArray <TreeNode *>*)getSortedNodes:(NSArray <TreeNode *>*)groups defaultExpandLevel:(NSInteger)defaultExpandLevel;

//过滤出所有可见节点
- (NSArray <TreeNode *>*)filterVisibleNode:(NSArray <TreeNode *>*)nodes;

@end
