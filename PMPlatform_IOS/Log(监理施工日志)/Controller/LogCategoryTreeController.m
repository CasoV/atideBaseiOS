//
//  LogCategoryTreeController.m
//  ycxm
//
//  Created by 高小伟 on 2021/7/5.
//  Copyright © 2021 末末班车. All rights reserved.
//

#import "LogCategoryTreeController.h"
#import "LogCategoryTreeCell.h"

@interface LogCategoryTreeController ()<RATreeViewDataSource, RATreeViewDelegate>

@property (nonatomic, copy) NSArray <LogTreeModel *>*dataSource;
@property (nonatomic, strong) RATreeView *treeView;

@end

@implementation LogCategoryTreeController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _treeView = [[RATreeView alloc] initWithFrame:CGRectMake(0, kStatusBarH + kNavBarH, kScreen_Width, kScreen_Height - kStatusBarH - kNavBarH) style:RATreeViewStylePlain];
    _treeView.separatorStyle = RATreeViewCellSeparatorStyleNone;
    _treeView.treeFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    _treeView.delegate = self;
    _treeView.dataSource = self;
    [self.view addSubview:_treeView];
    
    [_treeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.equalTo(self.view);
    }];
    
    [self loadData:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.navigationItem.title = @"目录";
}

#pragma mark - 懒加载
- (NSArray<LogTreeModel *> *)dataSource {
    if (!_dataSource) {
        _dataSource = [NSArray array];
    }
    return _dataSource;
}

#pragma mark - 加载数据
- (void)loadData:(LogTreeModel *)model {
    NSString *url = [UrlConfig URL:listTree];
    NSDictionary *params = @{
        @"projectId": self.projectId,
        @"sectionId": self.sectionId,
        @"pid":model?model.id:@"-1"
    };
    [SVProgressHUD showWithStatus:nil];
    [[HttpManager manager]post:url param:params success:^(NSData *data) {
        
        [SVProgressHUD dismiss];
        NSArray <LogTreeModel *>*datas = [LogTreeModel mj_objectArrayWithKeyValuesArray:[data mj_JSONObject]];
        if(!model){
            self.dataSource = datas;
            [self.treeView reloadData];
        }else{
            model.loaded = YES;
            if(!datas || datas.count == 0){
                return;
            }
            model.children = datas;
            [self.treeView collapseRowForItem:model collapseChildren:NO withRowAnimation:RATreeViewRowAnimationNone];
            [self.treeView expandRowForItem:model expandChildren:NO withRowAnimation:RATreeViewRowAnimationNone];
        }
    } faild:^(NSString *msg) {
        [SVProgressHUD showErrorWithStatus:msg];
    }];
}


#pragma mark - RATreeViewDataSource, RATreeViewDelegate
//返回行高
- (CGFloat)treeView:(RATreeView *)treeView heightForRowForItem:(id)item {
    return 40;
}

//将要展开
- (void)treeView:(RATreeView *)treeView willExpandRowForItem:(id)item {
    LogCategoryTreeCell *cell = (LogCategoryTreeCell *)[treeView cellForItem:item];
    cell.expandImg.image = [UIImage imageNamed:@"ic_arrow_bottom_black"];
}
//将要收缩
- (void)treeView:(RATreeView *)treeView willCollapseRowForItem:(id)item {
    LogCategoryTreeCell *cell = (LogCategoryTreeCell *)[treeView cellForItem:item];
    cell.expandImg.image = [UIImage imageNamed:@"ic_arrow_right_black"];
}
//已经展开
- (void)treeView:(RATreeView *)treeView didExpandRowForItem:(id)item {
    LogTreeModel *model = item;
    model.isExpanded = YES;
    if (!model.loaded) {
        [self loadData:(LogTreeModel *)item];
    }
}
//已经收缩
- (void)treeView:(RATreeView *)treeView didCollapseRowForItem:(id)item {
    LogTreeModel *model = item;
    model.isExpanded = NO;
}

//# dataSource方法
//返回cell
- (UITableViewCell *)treeView:(RATreeView *)treeView cellForItem:(id)item {
    //获取cell
    LogCategoryTreeCell *cell = [LogCategoryTreeCell treeViewCellWith:treeView];
    //当前item
    LogTreeModel *modelItem = item;
    //当前层级
    NSInteger level = [treeView levelForCellForItem:item];
    //赋值
    [cell setCellBasicInfoWith:modelItem level:level children:modelItem.children.count];
    
    __weak typeof(self) weakSelf = self;
    cell.callBack = ^(LogTreeModel * _Nonnull item) {
        if (weakSelf.callBack) {
            weakSelf.callBack(item);
        }
        [weakSelf.navigationController popViewControllerAnimated:YES];
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
    LogTreeModel *model = item;
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
    LogTreeModel *model = item;
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
