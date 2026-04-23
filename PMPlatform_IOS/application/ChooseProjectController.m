//
//  ChooseProjectController.m
//  PMPlatform_IOS
//
//  Created by 末末班车 on 2022/6/13.
//  Copyright © 2022 com.atide. All rights reserved.
//

#import "ChooseProjectController.h"
#import "ChooseProjectCell.h"

@interface ChooseProjectController ()<RATreeViewDataSource, RATreeViewDelegate>

@property (nonatomic, copy) NSArray <ProjectInfo *>*dataSource;
@property (nonatomic, strong) RATreeView *treeView;

@end

@implementation ChooseProjectController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, kStatusBarH, kScreen_Width, kNavBarH)];
    view.backgroundColor = [UIColor navigationBgColor];
    [self.view addSubview:view];
    
    _treeView = [[RATreeView alloc] initWithFrame:CGRectMake(0, kStatusBarH + kNavBarH, kScreen_Width, kScreen_Height - kStatusBarH - kNavBarH) style:RATreeViewStylePlain];
    _treeView.separatorStyle = RATreeViewCellSeparatorStyleNone;
    _treeView.treeFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    _treeView.delegate = self;
    _treeView.dataSource = self;
    _treeView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_treeView];
}

- (NSArray<ProjectInfo *> *)dataSource {
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.navigationItem.title = @"单位选择";
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    self.dataSource = [UserAgent DefaultAgent].projectInfos;
    [self expandDatas:self.dataSource];
    [self.treeView reloadData];
    for (ProjectInfo *item in self.dataSource) {
        [self.treeView expandRowForItem:item expandChildren:YES withRowAnimation:RATreeViewRowAnimationNone];
    }
}

- (void)expandDatas:(NSArray <ProjectInfo *>*)datas {
    for (ProjectInfo *info in datas) {
        info.isExpanded = YES;
        if (info.children && info.children.count > 0) {
            [self expandDatas:info.children];
        }
    }
}

#pragma mark - RATreeViewDataSource, RATreeViewDelegate
//返回行高
- (CGFloat)treeView:(RATreeView *)treeView heightForRowForItem:(id)item {
    return 40;
}

//将要展开
- (void)treeView:(RATreeView *)treeView willExpandRowForItem:(id)item {
    ChooseProjectCell *cell = (ChooseProjectCell *)[treeView cellForItem:item];
    cell.expandImg.image = [UIImage imageNamed:@"ic_arrow_bottom_black"];
}
//将要收缩
- (void)treeView:(RATreeView *)treeView willCollapseRowForItem:(id)item {
    ChooseProjectCell *cell = (ChooseProjectCell *)[treeView cellForItem:item];
    cell.expandImg.image = [UIImage imageNamed:@"ic_arrow_right_black"];
}
//已经展开
- (void)treeView:(RATreeView *)treeView didExpandRowForItem:(id)item {
    ProjectInfo *model = item;
    model.isExpanded = YES;
}
//已经收缩
- (void)treeView:(RATreeView *)treeView didCollapseRowForItem:(id)item {
    ProjectInfo *model = item;
    model.isExpanded = NO;
}

//# dataSource方法
//返回cell
- (UITableViewCell *)treeView:(RATreeView *)treeView cellForItem:(id)item {
    //获取cell
    ChooseProjectCell *cell = [ChooseProjectCell treeViewCellWith:treeView];
    //当前item
    ProjectInfo *modelItem = item;
    //当前层级
    NSInteger level = [treeView levelForCellForItem:item];
    //赋值
    [cell setCellBasicInfoWith:modelItem level:level children:modelItem.children.count];
    __weak typeof(self) weakSelf = self;
    cell.callBack = ^(ProjectInfo * _Nonnull item) {
        [weakSelf chooseProOrSect:item];
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
    ProjectInfo *model = item;
    if (item == nil) {
        return self.dataSource.count;
    } else if (!model.children || model.children.count == 0) {
        return 0;
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
    ProjectInfo *model = item;
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

- (void)chooseProOrSect:(ProjectInfo *)info {
    ProjectInfo *projectInfo = nil;
    ProjectInfo *sectionInfo = nil;
    
    NSString *key = info.attributes[@"key"];
    if ([key containsString:@"project"]) {
        projectInfo = info;
    } else if ([key containsString:@"section"]) {
        sectionInfo = info;
        for (ProjectInfo *parent in [UserAgent DefaultAgent].projectInfos) {
            if ([parent.id isEqualToString:info.attributes[@"topId"]]) {
                projectInfo = parent;
                break;
            }
        }
    } else {
        [MBManager showBriefAlert:@"数据错误！"];
        return;
    }
    
    [[NSUserDefaults standardUserDefaults]setObject:projectInfo.id forKey:@"projectId"];
    [UserAgent DefaultAgent].projectId = projectInfo.id;
    [UserAgent DefaultAgent].typeKey =  projectInfo.attributes[@"key"];
    
    if (sectionInfo) {
        [[NSUserDefaults standardUserDefaults]setObject:sectionInfo.id forKey:@"sectId"];
        [UserAgent DefaultAgent].sectionId = sectionInfo.id;
        [UserAgent DefaultAgent].sectionName = sectionInfo.text;
        [UserAgent DefaultAgent].stdVersion = sectionInfo.otherInfo[@"stdVersion"];
        [UserAgent DefaultAgent].sectionMajor = sectionInfo.otherInfo[@"sectMajor"];
    } else {
        [[NSUserDefaults standardUserDefaults]setObject:@"" forKey:@"sectId"];
        [UserAgent DefaultAgent].sectionId = @"";
        [UserAgent DefaultAgent].sectionName = @"";
        [UserAgent DefaultAgent].stdVersion = @"";
        [UserAgent DefaultAgent].sectionMajor = @"";
    }
    [UserAgent DefaultAgent].sectionInfos = projectInfo.tempChildren;
    [[UserAgent DefaultAgent] saveValuesToCache];
    
    //切换服务器项目
    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithDictionary:@{
        @"typeKey": projectInfo.attributes[@"key"],
        @"projectId": projectInfo.id,
        @"mainPrjName": projectInfo.text,
        @"mainPrjCode": projectInfo.otherInfo[@"projectCode"],
        @"projectPlanSn": projectInfo.otherInfo[@"projectPlanSn"]
    }];
    if (sectionInfo) {
        [param setObject:sectionInfo.id forKey:@"mainSectionId"];
        [param setObject:sectionInfo.text forKey:@"mainSectionName"];
        [param setObject:sectionInfo.otherInfo[@"sectCode"] forKey:@"mainSectionCode"];
        [param setObject:sectionInfo.otherInfo[@"stdVersion"] forKey:@"stdVersion"];
        [param setObject:sectionInfo.otherInfo[@"sectMajor"] forKey:@"sectionMajor"];
    }
    __weak typeof(self) weakSelf = self;
    [[HttpManager manager] post:[UrlConfig URL:setPrjInfo] param:param success:^(NSData *data) {
        [weakSelf.navigationController popViewControllerAnimated:YES];
    } faild:^(NSString *msg) {}];
}

@end
