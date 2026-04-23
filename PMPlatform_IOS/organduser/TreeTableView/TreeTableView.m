//
//  TreeTableView.m
//  circlViewText
//
//  Created by 末末班车 on 2017/9/7.
//  Copyright © 2017年 atide. All rights reserved.
//

#import "TreeTableView.h"
#import "TreeNodeTableViewCell.h"

static NSString *NODE_CELL_ID = @"nodecell";

@interface TreeTableView ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, copy) NSArray <TreeNode *>*mAllNodes; //所有的node
@property (nonatomic, strong) NSMutableArray <TreeNode *>*mNodes;    //可见的node
@property (nonatomic, assign) TreeNodePickerMode pickerMode;

@end

@implementation TreeTableView

- (instancetype)init {
    if (self = [super init]) {
        self.delegate = self;
        self.dataSource = self;
        _mAllNodes = @[];
        _mNodes = [[[TreeNodeHelper sharedInstance] filterVisibleNode:_mAllNodes] mutableCopy];
        _pickerMode = TreeNodePickerModeMULTIPLUS;
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame data:(NSArray<TreeNode *> *)data pickerMode:(TreeNodePickerMode)pickerMode {
    if (self = [super initWithFrame:frame style:UITableViewStylePlain]) {
        self.delegate = self;
        self.dataSource = self;
        _mAllNodes = data;
        _mNodes = [[[TreeNodeHelper sharedInstance] filterVisibleNode:_mAllNodes] mutableCopy];
        _pickerMode = pickerMode;
    }
    return self;
}

- (void)refresh:(NSArray<TreeNode *> *)data mode:(TreeNodePickerMode)mode {
    _mAllNodes = [[TreeNodeHelper sharedInstance] getSortedNodes:data defaultExpandLevel:0];
    _mNodes = [[[TreeNodeHelper sharedInstance] filterVisibleNode:_mAllNodes] mutableCopy];
    self.pickerMode = mode;
    [self reloadData];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    // 通过nib自定义tableviewcell
    UINib *nib = [UINib nibWithNibName:@"TreeNodeTableViewCell" bundle:[NSBundle bundleForClass:[self classForCoder]]];
    [tableView registerNib:nib forCellReuseIdentifier:NODE_CELL_ID];
    
    TreeNodeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NODE_CELL_ID];
    TreeNode *node = self.mNodes[indexPath.row];
    
    //cell缩进
    cell.leftMargin.constant = 5.0 * [node getLevel];
    
    //代码修改nodeIMG---UIImageView的显示模式.
    if (node.type == NODE_TYPE_G) {
        cell.nodeIMG.contentMode = UIViewContentModeCenter;
        cell.nodeIMG.image = [UIImage imageNamed:node.icon];
    } else {
        cell.nodeIMG.image = nil;
    }

    if (node.isNext) {
        [cell.selectBtn setImage:[UIImage imageNamed:@"next_icon"] forState:UIControlStateNormal];
        [cell.selectBtn setImage:[UIImage imageNamed:@"next_icon"] forState:UIControlStateSelected];
    }else {
        [cell.selectBtn setImage:[UIImage imageNamed:@"aunselect"] forState:UIControlStateNormal];
        [cell.selectBtn setImage:[UIImage imageNamed:@"aselected"] forState:UIControlStateSelected];
    }

    cell.selectBtn.tag = indexPath.row;
    cell.selectBtn.selected = node.isSelected;
    UITapGestureRecognizer *tapG = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(changeSelect:)];
    [cell.selectBtn addGestureRecognizer:tapG];
    cell.nodeName.text = node.name;
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.mNodes.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 40;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    TreeNode *parentNode = self.mNodes[indexPath.row];
    
    NSInteger startPosition = indexPath.row + 1;
    NSInteger endPosition = startPosition;
    
    if ([parentNode isLeaf]) {// 点击的节点为叶子节点
        // do something
    } else {
        [self expandOrCollapse:&endPosition node:parentNode];
        self.mNodes = [[[TreeNodeHelper sharedInstance] filterVisibleNode:self.mAllNodes] mutableCopy]; //更新可见节点
        
        //修正indexpath
        NSMutableArray <NSIndexPath *>*indexPathArray = [NSMutableArray array];
        NSIndexPath *tempIndexPath;
        for (NSInteger i = startPosition; i < endPosition; i++) {
            tempIndexPath = [NSIndexPath indexPathForRow:i inSection:0];
            [indexPathArray addObject:tempIndexPath];
        }
        
        // 插入和删除节点的动画
        if (parentNode.isExpand) {
            [self insertRowsAtIndexPaths:indexPathArray withRowAnimation:UITableViewRowAnimationNone];
        } else {
            [self deleteRowsAtIndexPaths:indexPathArray withRowAnimation:UITableViewRowAnimationNone];
        }
        
        //更新被选组节点
        [self reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    }
}

//MARK: 切换选中与未选中事件
- (void)changeSelect:(UITapGestureRecognizer *)gesture {
    if ([gesture.view isKindOfClass:[UIButton class]]) {
        UIButton *selectBtn = (UIButton *)gesture.view;
        selectBtn.selected = !selectBtn.selected;
        
        if (_pickerMode == TreeNodePickerModeSINGLE) {
            if (self.mAllNodes) {
                [self cancelSelected:self.mAllNodes];
            }
        }

        self.mNodes[gesture.view.tag].isSelected = selectBtn.selected;
        [self reloadData];
        
        if (self.mAllNodes) {
            NSInteger count = 0;
            
            [self calculate:&count nodes:self.mAllNodes];
            
            if (self.callback) {
                self.callback(count, self.mNodes[gesture.view.tag]);
            }
        }
    }
}

//MARK: 获取选中的数量
- (void)calculate:(NSInteger *)count nodes:(NSArray <TreeNode *>*)nodes {
    for (TreeNode *item in nodes) {
        if (item.isSelected) {
            *count += 1;
        }
    }
}

//MARK: 获取选中的nodes
- (NSArray <TreeNode *>*)getSelectedNodes {
    NSMutableArray <TreeNode *>*selected = [NSMutableArray array];
    if (self.mAllNodes) {
        for (TreeNode *item in self.mAllNodes) {
            if (item.isSelected) {
                [selected addObject:item];
            }
        }
    }
    
    return selected;
}

- (void)cancelSelected:(NSArray <TreeNode *>*)nodes {
    for (TreeNode *item in nodes) {
        item.isSelected = NO;
    }
}

//展开或者关闭某个节点
- (void)expandOrCollapse:(NSInteger *) count node:(TreeNode *)node {
    if (node.isExpand) {//如果当前节点是开着的，需要关闭节点下的所有子节点
        [self closedChildNode:count node:node];
    } else {//如果节点是关着的，打开当前节点即可
        *count += node.children.count;
        [node setExpand:YES];
    }
}

//关闭某个节点和该节点的所有子节点
- (void)closedChildNode:(NSInteger *)count node:(TreeNode *)node {
    if ([node isLeaf]) {
        return;
    }
    
    if (node.isExpand) {
        node.isExpand = NO;
        for (TreeNode *item in node.children) { //关闭子节点
            *count += 1; // 计算子节点数加一
            [self closedChildNode:count node:item];
        }
    }
}


@end
