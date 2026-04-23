//
//  sealHomeVc.m
//  PMPlatform_IOS
//
//  Created by 高小伟 on 2018/11/7.
//  Copyright © 2018 com.atide. All rights reserved.
//

#import "sealHomeVc.h"
#import "ApplicationModel.h"
#import "ApplicationCell.h"
#import "SearchViewController.h"
@interface sealHomeVc ()<UICollectionViewDelegate, UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (nonatomic, copy) NSArray <ApplicationModel *>*dataSource1;
@property (nonatomic, copy) NSArray <ApplicationModel *>*dataSource2;
@property (nonatomic, copy) NSArray <ApplicationModel *>*dataSource3;
@end

@implementation sealHomeVc

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupUI];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    self.navigationController.navigationBar.hidden = NO;
    self.tabBarController.tabBar.hidden = YES;
}

#pragma mark - 初始化UI
- (void)setupUI {
    UICollectionViewFlowLayout *collectionViewLayout = [[UICollectionViewFlowLayout alloc] init];
    CGFloat width = ScreenWidth / 3;
    collectionViewLayout.itemSize = CGSizeMake(width, 90);
    collectionViewLayout.headerReferenceSize = CGSizeMake(ScreenWidth, 35);
    collectionViewLayout.sectionInset = UIEdgeInsetsMake(0, 0, 1, 0);
    collectionViewLayout.minimumLineSpacing = 0;
    collectionViewLayout.minimumInteritemSpacing = 0;
    
    self.collectionView.collectionViewLayout = collectionViewLayout;
    self.collectionView.contentInset = UIEdgeInsetsMake(10, 0, 0, 0);
    [self.collectionView registerNib:[UINib nibWithNibName:@"ApplicationCell" bundle:nil] forCellWithReuseIdentifier:@"applicationCell"];
    [self.collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"headerView"];
}

#pragma mark - 懒加载
- (NSArray<ApplicationModel *> *)dataSource1 {
    if (!_dataSource1) {
        ApplicationModel *model1 = [[ApplicationModel alloc] init];
        model1.title = @"内部用印";
        model1.iconName = @"an_project_checkmng";
        ApplicationModel *model2 = [[ApplicationModel alloc] init];
        model2.title = @"外部用印";
        model2.iconName = @"an_project_tec_knowledge";
        ApplicationModel *model3 = [[ApplicationModel alloc] init];
        
        _dataSource1 = @[model1, model2, model3];
    }
    return _dataSource1;
}

- (NSArray<ApplicationModel *> *)dataSource2 {
    if (!_dataSource2) {
        ApplicationModel *model1 = [[ApplicationModel alloc] init];
        model1.title = @"印章外借";
        model1.iconName = @"an_oa_send";
        ApplicationModel *model2 = [[ApplicationModel alloc] init];
        ApplicationModel *model3 = [[ApplicationModel alloc] init];
        
        _dataSource2 = @[model1, model2, model3];
    }
    return _dataSource2;
}

#pragma mark - UICollectionViewDelegate, UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 2;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return self.dataSource1.count;
            break;
        case 1:
            return self.dataSource2.count;
            break;
        default:
            return 0;
            break;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ApplicationCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"applicationCell" forIndexPath:indexPath];
    NSArray <ApplicationModel *>*dataArr;
    switch (indexPath.section) {
        case 0:
            dataArr = self.dataSource1;
            break;
        case 1:
            dataArr = self.dataSource2;
            break;
        default:
            dataArr = self.dataSource1;
            break;
    }
    [cell loadDataModel:dataArr[indexPath.row] section:indexPath.section ishome:NO];
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        UICollectionReusableView *header = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"headerView" forIndexPath:indexPath];
        header.backgroundColor = [UIColor whiteColor];
        [header.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(10, 10, 5, 20)];
        view.backgroundColor = [UIColor hex:@"1976D2"];
        [header addSubview:view];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, 5, ScreenWidth - 20, 30)];
        label.font = [UIFont systemFontOfSize:15];
        label.textColor = [UIColor grayColor];
        [header addSubview:label];
        
        switch (indexPath.section) {
            case 0:
                label.text = @"用印审批";
                break;
            case 1:
                label.text = @"印章外接";
                break;
            default:
                break;
        }
        
        return header;
    }
    return nil;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    SearchViewController *vc = [[SearchViewController alloc] initWithNibName:@"SearchViewController" bundle:nil];
    if (indexPath.section == 0) {
        switch (indexPath.row) {
            case 0:
                vc.searchType = SearchTypeSealIn;
                break;
            case 1:
                vc.searchType = SearchTypeSealEx;
                break;
            default:
                return;
        }
    } else {
        switch (indexPath.row) {
            case 0:
                vc.searchType = SearchTypeSealLoan;
                break;
            default:
                return;
        }
    }
    [self.navigationController pushViewController:vc animated:YES];
}


@end
