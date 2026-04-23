//
//  OAApplicationController.m
//  PMPlatform_IOS
//
//  Created by 末末班车 on 2017/9/8.
//  Copyright © 2017年 com.atide. All rights reserved.
//

#import "OAApplicationController.h"
#import "ApplicationModel.h"
#import "ApplicationCell.h"
#import "SearchViewController.h"
#import "BaseWebViewController.h"
#import "UrlConfig.h"

@interface OAApplicationController ()<UICollectionViewDelegate, UICollectionViewDataSource>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (nonatomic, copy) NSArray <ApplicationModel *>*dataSource1;
@property (nonatomic, copy) NSArray <ApplicationModel *>*dataSource2;
@property (nonatomic, copy) NSArray <ApplicationModel *>*dataSource3;
@property (nonatomic, copy) NSArray <ApplicationModel *>*dataSource4;

@end

@implementation OAApplicationController

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
    
    if(_ismeetingRoom)self.navigationItem.title = @"会议室管理";
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
        model1.title = @"收文传阅";
        model1.iconName = @"an_project_checkmng";
        ApplicationModel *model2 = [[ApplicationModel alloc] init];
        model2.title = @"收文批阅";
        model2.iconName = @"an_project_tec_knowledge";
        ApplicationModel *model3 = [[ApplicationModel alloc] init];
        
        _dataSource1 = @[model1, model2, model3];
    }
    return _dataSource1;
}

- (NSArray<ApplicationModel *> *)dataSource2 {
    if (!_dataSource2) {
        ApplicationModel *model1 = [[ApplicationModel alloc] init];
        model1.title = @"发文";
        model1.iconName = @"an_oa_send";
        ApplicationModel *model2 = [[ApplicationModel alloc] init];
        ApplicationModel *model3 = [[ApplicationModel alloc] init];
        
        _dataSource2 = @[model1, model2, model3];
    }
    return _dataSource2;
}
- (NSArray<ApplicationModel *> *)dataSource3 {
    if (!_dataSource3) {
        ApplicationModel *model1 = [[ApplicationModel alloc] init];
        model1.title = @"收文";
        model1.iconName = @"an_project_checkmng";
        ApplicationModel *model2 = [[ApplicationModel alloc] init];
        model2.title = @"发文";
        model2.iconName = @"an_oa_send";
        ApplicationModel *model3 = [[ApplicationModel alloc] init];
        
        _dataSource3 = @[model1, model2, model3];
    }
    return _dataSource3;
}

- (NSArray<ApplicationModel *> *)dataSource4 {
    if (!_dataSource4) {
        ApplicationModel *model1 = [[ApplicationModel alloc] init];
        model1.title = @"会议室预约";
        model1.iconName = @"an_project_checkmng";
        ApplicationModel *model2 = [[ApplicationModel alloc] init];
        model2.title = @"我的会议室";
        model2.iconName = @"an_project_tec_knowledge";
        ApplicationModel *model3 = [[ApplicationModel alloc] init];
        model3.title = @"部门参会回执";
        model3.iconName = @"an_project_tec_knowledge";
        _dataSource4 = @[model1, model2, model3];
    }
    return _dataSource4;
}

#pragma mark - UICollectionViewDelegate, UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    return _ismeetingRoom?1:3;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    if(_ismeetingRoom){
        return self.dataSource4.count;
    }
    switch (section) {
        case 0:
            return self.dataSource1.count;
            break;
        case 1:
            return self.dataSource2.count;
            break;
        case 2:
            return self.dataSource3.count;
            break;
        default:
            return 0;
            break;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ApplicationCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"applicationCell" forIndexPath:indexPath];
    NSArray <ApplicationModel *>*dataArr;
    if(_ismeetingRoom){
        dataArr = self.dataSource4;
    }else{
        switch (indexPath.section) {
            case 0:
                dataArr = self.dataSource1;
                break;
            case 1:
                dataArr = self.dataSource2;
                break;
            case 2:
                dataArr = self.dataSource3;
                break;
            default:
                dataArr = self.dataSource1;
                break;
        }
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
        
        if(_ismeetingRoom){
            label.text = @"会议室预约管理";
        }else{
            switch (indexPath.section) {
                case 0:
                    label.text = @"收文承办";
                    break;
                case 1:
                    label.text = @"发文管理";
                    break;
                case 2:
                    label.text = @"公示公文";
                    break;
                default:
                    break;
            }
        }

        
        return header;
    }
    return nil;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    
    if(_ismeetingRoom){
        BaseWebViewController *vc =  [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"BaseWebViewController"];
        switch (indexPath.row) {
            case 0:
                vc.url = [self getLoadUrl:@"meetingReserve"];
                break;
            case 1:
                vc.url = [NSString stringWithFormat:@"%@&isMy=1", [self getLoadUrl:@"myMeeting"]];
                break;
            case 2:
                vc.url = [NSString stringWithFormat:@"%@&isMy=0", [self getLoadUrl:@"myMeeting"]];
                break;
            default:
                return;
        }
        [self.navigationController pushViewController:vc animated:YES];
        return;
    }
    SearchViewController *vc = [[SearchViewController alloc] initWithNibName:@"SearchViewController" bundle:nil];
    if (indexPath.section == 0) {
        switch (indexPath.row) {
            case 0:
                vc.searchType = SearchTypeRcvCirculated;
                break;
            case 1:
                vc.searchType = SearchTypeRcvApproval;
                break;
            default:
                return;
        }
    } else if (indexPath.section == 1) {
        switch (indexPath.row) {
            case 0:
                vc.searchType = SearchTypeSendManagement;
                break;
            default:
                return;
        }
    } else {
        switch (indexPath.row) {
            case 0:
                vc.searchType = SearchTypeRcvPublicity;
                break;
            case 1:
                vc.searchType = SearchTypeSendPublicity;
                break;
            default:
                return;
        }
    }
    [self.navigationController pushViewController:vc animated:YES];
}

-(NSString *)getLoadUrl:(NSString *)sortUrl{
    NSString *url;
    NSString *userName = [[NSUserDefaults standardUserDefaults] objectForKey:@"user"];
    NSString *password = [[NSUserDefaults standardUserDefaults] objectForKey:@"password"];
    if ([[UserAgent DefaultAgent].sectionId isEqualToString:@""]) {
        url = [NSString stringWithFormat:@"%@%@?user=%@&pwd=%@&projectId=%@&projectCode=%@&projectName=%@", [UrlConfig URL:temMobile],sortUrl, [userName stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]], [password stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]], [UserAgent DefaultAgent].projectId, [UserAgent DefaultAgent].projectCode, [[UserAgent DefaultAgent].prjName stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]];
    } else {
        url = [NSString stringWithFormat:@"%@%@?user=%@&pwd=%@&projectId=%@&projectCode=%@&projectName=%@&sectionId=%@&sectionCode=%@&sectionName=%@", [UrlConfig URL:temMobile],sortUrl, [userName stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]], [password stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]], [UserAgent DefaultAgent].projectId, [UserAgent DefaultAgent].projectCode, [[UserAgent DefaultAgent].prjName stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]], [UserAgent DefaultAgent].sectionId, [UserAgent DefaultAgent].sectionCode, [[UserAgent DefaultAgent].sectionName stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]];
    }
    return url;
}
@end
