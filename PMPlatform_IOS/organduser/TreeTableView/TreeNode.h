//
//  TreeNode.h
//  circlViewText
//
//  Created by 末末班车 on 2017/9/7.
//  Copyright © 2017年 atide. All rights reserved.
//

#import <Foundation/Foundation.h>

static NSInteger NODE_TYPE_G = 0; //表示该节点不是叶子节点
static NSInteger NODE_TYPE_N = 1; //表示节点为叶子节点

@interface TreeNode : NSObject

@property (nonatomic, assign) NSInteger type;
@property (nonatomic, copy) NSString *desc; // 对于多种类型的内容，需要确定其内容
@property (nonatomic, copy) NSString *ID;
@property (nonatomic, copy) NSString *pId;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, assign) NSInteger level;
@property (nonatomic, assign) BOOL isExpand;
@property (nonatomic, copy) NSString *icon;
@property (nonatomic, strong) NSMutableArray <TreeNode *>*children;
@property (nonatomic, assign) BOOL isNext;
@property (nonatomic, strong) TreeNode *parent;
@property (nonatomic, assign) BOOL isSelected;

- (instancetype)initWith:(NSString *)desc ID:(NSString *)ID pId:(NSString *)pId name:(NSString *)name;

//是否为根节点
- (BOOL)isRoot;

//判断父节点是否打开
- (BOOL)isParentExpand;


//是否是叶子节点
- (BOOL)isLeaf;

//获取level,用于设置节点内容偏左的距离
- (NSInteger)getLevel;

//设置展开
- (void)setExpand:(BOOL)isExpand;

@end
