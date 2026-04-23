//
//  NewModelViewController.m
//  HBConstructionApp
//
//  Created by 末末班车 on 2018/5/23.
//  Copyright © 2018年 atide. All rights reserved.
//

#import "NewModelViewController.h"
#import "NewModelInfoController.h"
#import "ModelViewModel.h"
#import "PartLayout.h"
#import "PartCell.h"
#import <objc/runtime.h>

@interface NewModelViewController ()<UICollectionViewDelegate, UICollectionViewDataSource>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) ModelViewModel *lastModel;
@property (nonatomic, strong) NSIndexPath *lastIndexPath;
@property (nonatomic, strong) NSMutableArray *chooseArr;

@end

@implementation NewModelViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    PartLayout *flowLayout = [[PartLayout alloc] init];
    flowLayout.estimatedItemSize = CGSizeMake(30, 30);
    flowLayout.headerReferenceSize = CGSizeMake(100, 50);
    self.collectionView.collectionViewLayout = flowLayout;
    [self.collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header"];
    
    [self requestData];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (self.isFromScan && ![UserAgent DefaultAgent].approvalPartModel) {
        [SVProgressHUD showInfoWithStatus:@"扫描部位已失效!"];
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }
    
    self.navigationItem.title = @"模型视图";
}

#pragma mark - 懒加载
- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

- (NSMutableArray *)chooseArr {
    if (!_chooseArr) {
        _chooseArr = [NSMutableArray array];
    }
    return _chooseArr;
}

#pragma mark - 加载数据
- (void)requestData {
    __weak typeof(self) weakSelf = self;
    [SVProgressHUD showWithStatus:@"加载中..."];
    [[HttpManager manager] post:[UrlConfig URL:constructRegisterModelChart] param:@{@"modelId":self.modelId} success:^(NSData *data) {
        [SVProgressHUD dismiss];
        [ModelViewModel mj_setupObjectClassInArray:^NSDictionary *{
            return @{@"children":@"ModelViewModel"};
        }];
        ModelViewModel *model = [ModelViewModel mj_objectWithKeyValues:data];
        if (model) {
            [weakSelf.dataSource addObject:@[model]];
            [weakSelf.collectionView reloadData];
            [weakSelf.collectionView layoutIfNeeded];
            if(weakSelf.collectionView.contentSize.height > weakSelf.collectionView.bounds.size.height){
                CGPoint bottomOffset = CGPointMake(0, weakSelf.collectionView.contentSize.height -     weakSelf.collectionView.bounds.size.height);
                [weakSelf.collectionView setContentOffset:bottomOffset animated:NO];
            }
        } else {
            [SVProgressHUD showErrorWithStatus:@"数据加载错误!"];
        }
    } faild:^(NSString *msg) {
        [SVProgressHUD showErrorWithStatus:msg];
    }];
}

#pragma mark - UICollectionViewDelegate, UICollectionViewDataSource
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return self.dataSource.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    NSArray *temps = self.dataSource[section];
    return temps.count;
}

-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    UICollectionReusableView *reusableView =nil;
    if (kind == UICollectionElementKindSectionHeader) {
        reusableView = [_collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"header" forIndexPath:indexPath];
        for (UIView *view in reusableView.subviews) {
            [view removeFromSuperview];
        }
        UILabel *titleLb = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, kScreen_Width, 50)];
        titleLb.font = [UIFont boldSystemFontOfSize:18.f];
        
        if (self.chooseArr.count && indexPath.section) {
            titleLb.text = self.chooseArr[indexPath.section - 1];
        } else {
            titleLb.text = @"模型视图";
        }
        
        [reusableView addSubview:titleLb];
    }
    return reusableView;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    NSArray *temps = self.dataSource[indexPath.section];
    ModelViewModel *model = temps[indexPath.row];
    PartCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PartCell" forIndexPath:indexPath];
    [cell.nameBtn setTitle:model.name forState:UIControlStateNormal];
    //选中效果
    if(model.checked){
        cell.nameBtn.layer.borderColor = UIColorFromRGB(0x0295FF).CGColor;
        cell.nameBtn.selected = YES;
    }else{
        cell.nameBtn.layer.borderColor = UIColor.clearColor.CGColor;
        cell.nameBtn.selected = NO;
    }
    NSDictionary *dic = @{@"model":model,@"indexPath":indexPath};
    objc_setAssociatedObject(cell.nameBtn, @"params",dic, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    return cell;
}

#pragma mark - buttonClicked
- (IBAction)confirm:(id)sender {
    if (!self.lastModel) {
        [SVProgressHUD showInfoWithStatus:@"未选中模型!"];
        return;
    }
    
    NewModelInfoController *vc = [[UIStoryboard storyboardWithName:@"Quality" bundle:nil] instantiateViewControllerWithIdentifier:@"NewModelInfo"];
    vc.canEdit = [[UserAgent DefaultAgent].resourceKeys containsObject:@"quality_constructRegisterSub_save"];
    vc.partCode = self.partCode;
    vc.modelId = self.lastModel.id;
    vc.pid = self.pid;
    if (self.isFromScan) {
        vc.isUserXY = YES;
    } else {
        for (SectionInfo *info in [UserAgent DefaultAgent].sectionInfos) {
            if ([info.sectionId isEqualToString:[UserAgent DefaultAgent].sectionId]) {
                vc.isUserXY = info.isUserXY;
                break;
            }
        }
    }
    
    [self.navigationController pushViewController:vc animated:YES];
}
- (IBAction)reset:(id)sender {
    NSArray *temp = self.dataSource.firstObject;
    
    for (ModelViewModel *model in temp) {
        model.checked = NO;
    }
    
    [self.dataSource removeAllObjects];
    [self.dataSource addObject:temp];
    [self.collectionView reloadData];
    [self.collectionView layoutIfNeeded];
    if(self.collectionView.contentSize.height > self.collectionView.bounds.size.height){
        CGPoint bottomOffset = CGPointMake(0, self.collectionView.contentSize.height - self.collectionView.bounds.size.height);
        [self.collectionView setContentOffset:bottomOffset animated:NO];
    }
    
    self.lastModel = nil;
    self.lastIndexPath = nil;
}
- (IBAction)choosePart:(id)sender {
    //数据处理
    UIButton *btn = (UIButton *)sender;
    NSDictionary *dic = objc_getAssociatedObject(btn, @"params");
    ModelViewModel *model = dic[@"model"];
    NSIndexPath *indexPath = dic[@"indexPath"];
    
    //上次选中效果消除
    if (self.lastModel && indexPath.section <= self.lastIndexPath.section) {
        NSArray *lastSeArr = self.dataSource[indexPath.section];
        for (ModelViewModel *modelSe in lastSeArr) {
            modelSe.checked = NO;
        }
    }
    self.lastModel = model;
    self.lastIndexPath = indexPath;
    model.checked = !model.checked;
    if(indexPath.section == self.dataSource.count -1){
        //Add
        [self.chooseArr addObject:model.name];
        if (model.children == nil || model.children.count == 0) {
            [SVProgressHUD showInfoWithStatus:@"无下一级模型！"];
            [self.collectionView reloadData];
            [self.collectionView layoutIfNeeded];
            if(self.collectionView.contentSize.height > self.collectionView.bounds.size.height){
                CGPoint bottomOffset = CGPointMake(0, self.collectionView.contentSize.height -     self.collectionView.bounds.size.height);
                [self.collectionView setContentOffset:bottomOffset animated:NO];
            }
            return;
        }
    }else{
        //Delete
        [self.dataSource removeObjectsInRange:NSMakeRange(indexPath.section + 1, _dataSource.count - indexPath.section - 1)];
        [self.chooseArr removeObjectsInRange:NSMakeRange(indexPath.section , _chooseArr.count - indexPath.section )];
        [self.chooseArr addObject:model.name];
    }
    for (ModelViewModel *tempModel in model.children) {
        [self uncheckModel:tempModel];
    }
    [self.dataSource addObject:model.children];
    [self.collectionView reloadData];
    [self.collectionView layoutIfNeeded];
    if(self.collectionView.contentSize.height > self.collectionView.bounds.size.height){
        CGPoint bottomOffset = CGPointMake(0, self.collectionView.contentSize.height - self.collectionView.bounds.size.height);
        [self.collectionView setContentOffset:bottomOffset animated:NO];
    }
}

#pragma mark - 循环取消选中状态
- (void)uncheckModel:(ModelViewModel *)model {
    model.checked = NO;
    if (model.children == nil || model.children.count == 0) {
        return;
    }
    for (ModelViewModel *tempModel in model.children) {
        [self uncheckModel:tempModel];
    }
}

#pragma mark - UITableViewDelegate, UITableViewDataSource
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    return self.dataSource.count;
//}
//
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    ModelViewNewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"modelViewNewCell" forIndexPath:indexPath];
//    [cell setDataModel:self.dataSource[indexPath.row] withIndex:indexPath.row + 1];
//    __weak typeof(self) weakSelf = self;
//    cell.block = ^(ModelViewModel *model) {
//        NewModelInfoController *vc = [[UIStoryboard storyboardWithName:@"Quality" bundle:nil] instantiateViewControllerWithIdentifier:@"NewModelInfo"];
//        vc.canEdit = [[UserAgent DefaultAgent].resourceKeys containsObject:@"quality_constructRegisterSub_save"];
//        vc.partCode = weakSelf.partCode;
//        vc.modelId = model.id;
//        vc.pid = weakSelf.pid;
//        if (weakSelf.isFromScan) {
//            vc.isUserXY = YES;
//        } else {
//            for (SectionInfo *info in [UserAgent DefaultAgent].sectionInfos) {
//                if ([info.sectionId isEqualToString:[UserAgent DefaultAgent].sectionId]) {
//                    vc.isUserXY = info.isUserXY;
//                    break;
//                }
//            }
//        }
//
//        [weakSelf.navigationController pushViewController:vc animated:YES];
//    };
//
//    return cell;
//}
//
//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//
//    ModelViewModel *model = self.dataSource[indexPath.row];
//
//    if (model.children == nil || model.children.count == 0) {
//        [SVProgressHUD showInfoWithStatus:@"无下一级模型！"];
//        return;
//    }
//
//    [self addBtnWith:model];
//
//    self.dataSource = model.children;
//    [self.tableView reloadData];
//}

#pragma mark - 初始化按钮
//- (void)addBtnWith:(ModelViewModel *)model {
//    CGSize size = [self calculateSize:model.name width:CGFLOAT_MAX fontSize:13];
//
//    CGFloat x;
//    if (self.scrollView.subviews.count == 0) {
//        x = 0;
//    } else {
//        x = self.scrollView.subviews.lastObject.frame.origin.x + self.scrollView.subviews.lastObject.frame.size.width;
//    }
//
//    __weak typeof(self) weakSelf = self;
//    SitesNameView *header = [[SitesNameView alloc] initWithFrame:CGRectMake(x, 0, size.width + 15, 30)];
//    header.nameLabel.text = model.name;
//    header.modelViewModel = model;
//    header.callBack = ^(ModelViewModel *model) {
//        [weakSelf deleteBtnWith:model];
//        weakSelf.dataSource = model.children;
//        [weakSelf.tableView reloadData];
//    };
//    self.scrollView.contentSize = CGSizeMake(x + size.width + 15, 0);
//    if (self.scrollView.contentSize.width > self.scrollView.frame.size.width) {
//        [self.scrollView setContentOffset:CGPointMake(self.scrollView.contentSize.width - self.scrollView.frame.size.width, 0) animated:YES];
//    }
//    [self.scrollView addSubview:header];
//}
//
//- (void)deleteBtnWith:(ModelViewModel *)model {
//    NSInteger index = 0;
//    for (int i = 0; i < self.scrollView.subviews.count; i++) {
//        SitesNameView *view = self.scrollView.subviews[i];
//        if ([view.modelViewModel.id isEqualToString:model.id]) {
//            index = i;
//            break;
//        }
//    }
//
//    for (NSInteger i = self.scrollView.subviews.count - 1; i > index; i--) {
//        UIView *view = self.scrollView.subviews[i];
//        [view removeFromSuperview];
//    }
//}
//
//
//- (CGSize)calculateSize:(NSString *)content width:(CGFloat)width fontSize:(CGFloat)fontSize {
//    return [content boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:fontSize]} context:nil].size;
//}


@end
