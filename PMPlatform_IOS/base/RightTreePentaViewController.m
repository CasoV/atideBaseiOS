//
//  RightTreePentaViewController.m
//  ycxm
//
//  Created by 高小伟 on 2021/8/18.
//  Copyright © 2021 末末班车. All rights reserved.
//

#import "RightTreePentaViewController.h"
#import "DirectorySelectionCell.h"

@interface RightTreePentaViewController ()<RATreeViewDataSource, RATreeViewDelegate>

@property (nonatomic, strong) RATreeView *treeView;

@end

@implementation RightTreePentaViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _treeView = [[RATreeView alloc] initWithFrame:CGRectMake(0, kStatusBarH + kNavBarH, kScreen_Width, kScreen_Height - kStatusBarH - kNavBarH) style:RATreeViewStylePlain];
    _treeView.separatorStyle = RATreeViewCellSeparatorStyleNone;
    _treeView.treeFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    _treeView.delegate = self;
    _treeView.dataSource = self;
    [self.view addSubview:_treeView];
    self.view.backgroundColor = UIColor.whiteColor;
    [_treeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.equalTo(self.view);
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationItem.title = @"请选择目录";
}

#pragma mark - 懒加载
- (void)setDataSource:(NSArray<DatumModel *>  *)dataSource {
    _dataSource = dataSource;
    [self.treeView reloadData];
    for (DatumModel *item in self.dataSource) {
        [self.treeView expandRowForItem:item expandChildren:YES withRowAnimation:RATreeViewRowAnimationNone];
    }
    
}

#pragma mark - RATreeViewDataSource, RATreeViewDelegate
//返回行高
- (CGFloat)treeView:(RATreeView *)treeView heightForRowForItem:(id)item {
    return 40;
}

//将要展开
- (void)treeView:(RATreeView *)treeView willExpandRowForItem:(id)item {
    DirectorySelectionCell *cell = (DirectorySelectionCell *)[treeView cellForItem:item];
    cell.expandImg.image = [UIImage imageNamed:@"ic_arrow_bottom_black"];
}
//将要收缩
- (void)treeView:(RATreeView *)treeView willCollapseRowForItem:(id)item {
    DirectorySelectionCell *cell = (DirectorySelectionCell *)[treeView cellForItem:item];
    cell.expandImg.image = [UIImage imageNamed:@"ic_arrow_right_black"];
}
//已经展开
- (void)treeView:(RATreeView *)treeView didExpandRowForItem:(id)item {
    DatumModel *model = item;
    model.isExpanded = YES;
}
//已经收缩
- (void)treeView:(RATreeView *)treeView didCollapseRowForItem:(id)item {
    DatumModel *model = item;
    model.isExpanded = NO;
}

//# dataSource方法
//返回cell
- (UITableViewCell *)treeView:(RATreeView *)treeView cellForItem:(id)item {
    //获取cell
    DirectorySelectionCell *cell = [DirectorySelectionCell treeViewCellWith:treeView];
    //当前item
    DatumModel *modelItem = item;
    //当前层级
    NSInteger level = [treeView levelForCellForItem:item];
    //赋值
    [cell setCellBasicInfoWith:modelItem level:level children:modelItem.children.count];
    __weak typeof(self) weakSelf = self;
    cell.callBack = ^(DatumModel * _Nonnull item) {
        if (weakSelf.callBack) {
            weakSelf.callBack(item);
        }
    };
    
    return cell;
}

/**
 *  必须实现
 *
 *  @param treeView treeView
 *  @param item    节点对应的item
 *
 *  @return  每一节点对应的个数
 */
- (NSInteger)treeView:(RATreeView *)treeView numberOfChildrenOfItem:(id)item {
    DatumModel *model = item;
    if (item == nil) {
        return self.dataSource.count;
    }
    return model.children.count;
}


/**
 *必须实现的dataSource方法
 *
 *  @param treeView treeView
 *  @param index    子节点的索引
 *  @param item     子节点索引对应的item
 *
 *  @return 返回 节点对应的item
 */
- (id)treeView:(RATreeView *)treeView child:(NSInteger)index ofItem:(id)item {
    DatumModel *model = item;
    if (item == nil) {
        return self.dataSource[index];
    }
    return model.children[index];
}

//cell的点击方法
- (void)treeView:(RATreeView *)treeView didSelectRowForItem:(id)item {
}
//单元格是否可以编辑 默认是YES
- (BOOL)treeView:(RATreeView *)treeView canEditRowForItem:(id)item {
    return NO;
}
//编辑要实现的方法
- (void)treeView:(RATreeView *)treeView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowForItem:(id)item {
 
}

@end
