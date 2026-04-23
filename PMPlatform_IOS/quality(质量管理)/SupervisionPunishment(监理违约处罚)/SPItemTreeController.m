//
//  SPItemTreeController.m
//  ycxm
//
//  Created by 末末班车 on 2020/3/20.
//  Copyright © 2020 末末班车. All rights reserved.
//

#import "SPItemTreeController.h"
#import "SPItemTreeCell.h"

@interface SPItemTreeController ()<RATreeViewDataSource, RATreeViewDelegate>

@property (nonatomic, copy) NSArray <PartModel *>*dataSource;
@property (nonatomic, strong) RATreeView *treeView;

@end

@implementation SPItemTreeController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _treeView = [[RATreeView alloc] initWithFrame:CGRectMake(0, kStatusBarH + kNavBarH, kScreen_Width, kScreen_Height - kStatusBarH - kNavBarH) style:RATreeViewStylePlain];
    _treeView.separatorStyle = RATreeViewCellSeparatorStyleNone;
    _treeView.treeFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    _treeView.delegate = self;
    _treeView.dataSource = self;
    [self.view addSubview:_treeView];
    
    [_treeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.equalTo(self.view);
    }];
    
    [self loadData];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.navigationItem.title = @"规定条款";
}

#pragma mark - 懒加载
- (NSArray<PartModel *> *)dataSource {
    if (!_dataSource) {
        _dataSource = [NSArray array];
    }
    return _dataSource;
}

#pragma mark - 加载数据
- (void)loadData {
    [SVProgressHUD showWithStatus:nil];
    NSDictionary *params = @{
        @"data":@"2",
        @"ruleId":self.ruleId
    };
    
    __weak typeof(self) weakSelf = self;
    [[HttpManager manager] get:[UrlConfig URL:qualityRuleItem] param:params success:^(NSData *data) {
        [SVProgressHUD dismiss];
        if ([ResponseUtils success:data]) {
            [PartModel mj_setupObjectClassInArray:^NSDictionary *{
                return @{@"children":@"PartModel"};
            }];
            weakSelf.dataSource = [PartModel mj_objectArrayWithKeyValuesArray:[ResponseUtils getData:@"data"]];
            for (PartModel *item in weakSelf.dataSource) {
                item.isExpanded = YES;
            }
            [weakSelf.treeView reloadData];
            for (PartModel *item in weakSelf.dataSource) {
                [weakSelf.treeView expandRowForItem:item expandChildren:YES withRowAnimation:RATreeViewRowAnimationNone];
            }
        } else {
            [SVProgressHUD showErrorWithStatus:[ResponseUtils getMsg]];
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
    SPItemTreeCell *cell = (SPItemTreeCell *)[treeView cellForItem:item];
    cell.expandImg.image = [UIImage imageNamed:@"ic_arrow_bottom_black"];
}
//将要收缩
- (void)treeView:(RATreeView *)treeView willCollapseRowForItem:(id)item {
    SPItemTreeCell *cell = (SPItemTreeCell *)[treeView cellForItem:item];
    cell.expandImg.image = [UIImage imageNamed:@"ic_arrow_right_black"];
}
//已经展开
- (void)treeView:(RATreeView *)treeView didExpandRowForItem:(id)item {
    PartModel *model = item;
    model.isExpanded = YES;
}
//已经收缩
- (void)treeView:(RATreeView *)treeView didCollapseRowForItem:(id)item {
    PartModel *model = item;
    model.isExpanded = NO;
}

//# dataSource方法
//返回cell
- (UITableViewCell *)treeView:(RATreeView *)treeView cellForItem:(id)item {
    //获取cell
    SPItemTreeCell *cell = [SPItemTreeCell treeViewCellWith:treeView];
    //当前item
    PartModel *modelItem = item;
    //当前层级
    NSInteger level = [treeView levelForCellForItem:item];
    //赋值
    [cell setCellBasicInfoWith:modelItem level:level children:modelItem.children.count];
    
    __weak typeof(self) weakSelf = self;
    cell.callBack = ^(PartModel * _Nonnull item) {
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
    PartModel *model = item;
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
    PartModel *model = item;
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
