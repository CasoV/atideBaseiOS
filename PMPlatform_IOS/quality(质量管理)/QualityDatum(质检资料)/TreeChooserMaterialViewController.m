//
//  TypeTreeViewController.m
//  ycxm
//
//  Created by 高小伟 on 2020/3/23.
//  Copyright © 2020 末末班车. All rights reserved.
//

#import "TreeChooserMaterialViewController.h"
#import "DirectorySelectionCell.h"
#import "DatumModel.h"

@interface TreeChooserMaterialViewController ()<RATreeViewDataSource, RATreeViewDelegate>

@property (nonatomic, copy) NSArray <DatumModel *>*dataSource;
@property (nonatomic, strong) RATreeView *treeView;

@end

@implementation TreeChooserMaterialViewController

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
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.line.hidden = YES;
    self.navigationItem.title = @"请选择类别";
}

#pragma mark - 懒加载
- (NSArray<DatumModel *> *)dataSource {
    if (!_dataSource) {
        _dataSource = [NSArray array];
    }
    return _dataSource;
}
- (void)setPartModel:(PartModel *)partModel {
    _partModel = partModel;
    [self loadData];
}
#pragma mark - 加载数据
- (void)loadData {
    NSString *projectId = [UserAgent DefaultAgent].projectId;
    NSString *sectId = [UserAgent DefaultAgent].sectionId;
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:@{
        @"projectId": projectId ? projectId : @"",
        @"sectId": sectId ? sectId : @"",
        @"partType": self.partModel.type ? self.partModel.type : @"",
        @"partTypeCode": self.partModel.projectTypeCode ? self.partModel.projectTypeCode : @"",
        @"partCode": self.partModel.id ? self.partModel.id : @""
    }];
    if (self.code) {
        [params setValue:self.code forKey:@"useCompany"];
    }
    __weak typeof(self) weakSelf = self;
    [[HttpManager manager] post:[UrlConfig URL:getQualityDatumList] param:params success:^(NSData *data) {
        [DatumModel mj_setupObjectClassInArray:^NSDictionary *{
               return @{@"children":@"DatumModel"};
           }];
           
        NSArray <DatumModel *>*datas = [DatumModel mj_objectArrayWithKeyValuesArray:[data mj_JSONObject][@"data"]];
        if (datas.count > 0) {
            weakSelf.dataSource = datas;
            for (DatumModel *item in weakSelf.dataSource) {
                item.isExpanded = YES;
            }
            [weakSelf.treeView reloadData];
            for (DatumModel *item in weakSelf.dataSource) {
                [weakSelf.treeView expandRowForItem:item expandChildren:YES withRowAnimation:RATreeViewRowAnimationNone];
            }
        }else{
            weakSelf.dataSource = [NSArray array];
            [weakSelf.treeView reloadData];
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

