//
//  ApplicationController.m
//  PMPlatform_IOS
//
//  Created by 末末班车 on 2017/9/5.
//  Copyright © 2017年 com.atide. All rights reserved.
//

#import "ApplicationController.h"
#import "ApplicationModel.h"
#import "ApplicationCell.h"
#import "SearchViewController.h"
#import "ProAndSectChoosePopView.h"
#import "FunctionListHeaderView.h"
#import "OAApplicationController.h"
#import "BaseWebViewController.h"
#import "FDScanViewController.h"
#import "AttenDanceViewController.h"
#import <CoreLocation/CoreLocation.h>

@interface ApplicationController ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (nonatomic, copy) NSArray <ApplicationModel *>*dataSource1;
@property (nonatomic, copy) NSArray <ApplicationModel *>*dataSource2;
@property (nonatomic, copy) NSArray <ApplicationModel *>*dataSource3;
@property (nonatomic, strong) FunctionListHeaderView *functionListHeaderView;

@end

@implementation ApplicationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupUI];
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"hasMeasure"] isEqualToString:@"1"]) {
        [self loadAuthority];
    }
    [self setProSectName];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    self.navigationController.navigationBar.hidden = YES;
    self.tabBarController.tabBar.hidden = NO;
}
#pragma mark - 设置项目/标段名称
- (void)setProSectName {
    if ([[UserAgent DefaultAgent].sectionName isEqualToString:@""]) {
        self.functionListHeaderView.nameLabel.text = [UserAgent DefaultAgent].prjName;
    } else {
        self.functionListHeaderView.nameLabel.text = [UserAgent DefaultAgent].sectionName;
    }
}

#pragma mark - 加载权限
- (void)loadAuthority {
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    [[HttpManager manager] paramsGet:[UrlConfig MeteringLogin] param:@{
                                                                       @"UserCode":[user objectForKey:@"user"],
                                                                       @"Password":[user objectForKey:@"password"],
                                                                       @"SysSet":@""
                                                                       }
                             success:^(NSData *data) {
                                 if ([ResponseUtils success:data]) {
                                     NSString *userFunc = [[ResponseUtils getData:@"data"] objectForKey:@"userFunc"];
                                     if (userFunc) {
                                         [UserInfo getInstance].userFunc = userFunc;
                                     }
                                 } else {
                                     [MBManager showBriefAlert:[ResponseUtils getMsg]];
                                 }
                             }
                               faild:^(NSString *msg) {
                                   [MBManager showBriefAlert:msg];
                               }];
}

#pragma mark - 初始化UI
- (void)setupUI {
    UICollectionViewFlowLayout *collectionViewLayout = [[UICollectionViewFlowLayout alloc] init];

    collectionViewLayout.headerReferenceSize = CGSizeMake(ScreenWidth, 35);
    collectionViewLayout.sectionInset = UIEdgeInsetsMake(0, 0, 1, 0);
    collectionViewLayout.minimumLineSpacing = 0;
    collectionViewLayout.minimumInteritemSpacing = 0;
    
    self.collectionView.collectionViewLayout = collectionViewLayout;
    self.collectionView.contentInset = UIEdgeInsetsMake(10, 0, 0, 0);
    [self.collectionView registerNib:[UINib nibWithNibName:@"ApplicationCell" bundle:nil] forCellWithReuseIdentifier:@"applicationCell"];
    [self.collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"headerView"];
    
    [self.view addSubview:self.functionListHeaderView];
}
#pragma mark - 点击事件
- (void)rightItemClicked {
    __weak typeof(self) weakSelf = self;
    ProAndSectChoosePopView *popView = [[ProAndSectChoosePopView alloc] init];
    popView.callBack = ^{
        [weakSelf setProSectName];
    };
    [popView show];
}

#pragma mark - 懒加载
- (FunctionListHeaderView *)functionListHeaderView {
    if (!_functionListHeaderView) {
        _functionListHeaderView = [[NSBundle mainBundle] loadNibNamed:@"FunctionListHeaderView" owner:nil options:nil].firstObject;
        _functionListHeaderView.frame = CGRectMake(0, kStatusBarH + kNavBarH + 103, kScreen_Width, 40);
        [_functionListHeaderView.clickView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(rightItemClicked)]];
    }
    return _functionListHeaderView;
}
- (NSArray<ApplicationModel *> *)dataSource1 {
    if (!_dataSource1) {
        ApplicationModel *model1 = [[ApplicationModel alloc] init];
        model1.title = @"收文传阅";
        model1.iconName = @"an_project_checkmng";
        ApplicationModel *model2 = [[ApplicationModel alloc] init];
        model2.title = @"收文批阅";
        model2.iconName = @"an_project_tec_knowledge";
        ApplicationModel *model3 = [[ApplicationModel alloc] init];
        model3.title = @"发文管理";
        model3.iconName = @"an_oa_send";
        ApplicationModel *model4 = [[ApplicationModel alloc] init];
        model4.title = @"收文公示";
        model4.iconName = @"an_project_checkmng";
        ApplicationModel *model5 = [[ApplicationModel alloc] init];
        model5.title = @"发文公示";
        model5.iconName = @"an_oa_send";
        ApplicationModel *model6 = [[ApplicationModel alloc] init];
        if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"hasOutline"] isEqualToString:@"1"]) {
            model6.title = @"项目概况";
            model6.iconName = @"an_project_qc";
        }
        
        _dataSource1 = @[model1, model2, model3, model4, model5, model6];
    }
    return _dataSource1;
}

- (NSArray<ApplicationModel *> *)dataSource2 {
    if (!_dataSource2) {
        ApplicationModel *model1 = [[ApplicationModel alloc] init];
        model1.title = @"公文管理";
        model1.iconName = @"an_project_checkmng";
        
        
        
        
        ApplicationModel *model2 = [[ApplicationModel alloc] init];
        if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"hasOutline"] isEqualToString:@"1"]) {
            model2.title = @"项目概况";
            model2.iconName = @"an_project_qc";
        }else if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"hasSealManagement"] isEqualToString:@"1"]) {
            model2.title = @"单位事务";
            model2.iconName = @"an_project_tec_knowledge";
        }
       
        ApplicationModel *model3 = [[ApplicationModel alloc] init];
        if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"hasOutline"] isEqualToString:@"1"] && [[[NSUserDefaults standardUserDefaults] objectForKey:@"hasSealManagement"] isEqualToString:@"1"]) {
            model3.title = @"单位事务";
            model3.iconName = @"an_project_tec_knowledge";
        }
        
        ApplicationModel *model4 = [[ApplicationModel alloc] init];
        model4.title = @"会议室管理";
        model4.iconName = @"an_project_checkmng";
        ApplicationModel *model5 = [[ApplicationModel alloc] init];
        model5.title = @"报销管理";
        model5.iconName = @"an_progress_audit";
        ApplicationModel *model6 = [[ApplicationModel alloc] init];
        model6.title = @"办公会议案材料审批";
        model6.iconName = @"an_oa_teamwork";
        ApplicationModel *model7 = [[ApplicationModel alloc] init];
        model7.title = @"考勤管理";
        model7.iconName = @"an_oa_todo";
        ApplicationModel *model8 = [[ApplicationModel alloc] init];
        model8.title = @"扫码登录";
        model8.iconName = @"an_oa_scan";
        ApplicationModel *model9 = [[ApplicationModel alloc] init];
        model9.title = @"考勤打卡";
        model9.iconName = @"an_oa_todo";
        _dataSource2 =@[model1,model4,model5,model6,model7,model8,model9];
    }
    return _dataSource2;
}

- (NSArray<ApplicationModel *> *)dataSource3 {
    if (!_dataSource3) {
        ApplicationModel *model1 = [[ApplicationModel alloc] init];
        model1.title = @"计量统计";
        model1.iconName = @"home1";
        ApplicationModel *model2 = [[ApplicationModel alloc] init];
        model2.title = @"计量审核";
        model2.iconName = @"home2";
        
        _dataSource3 = @[model1, model2];
    }
    return _dataSource3;
}

#pragma mark - UICollectionViewDelegate, UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"hasMeasure"] isEqualToString:@"1"]) {
        return 3;
    } else {
        return 2;
    }
    
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
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

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 2) {
        CGFloat width = ScreenWidth / 2;
        return CGSizeMake(width, width / 8 * 5);
    } else {
        CGFloat width = ScreenWidth / 3;
        return CGSizeMake(width, 90);
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
        case 2:
            dataArr = self.dataSource3;
            break;
        default:
            dataArr = self.dataSource1;
            break;
    }
    [cell loadDataModel:dataArr[indexPath.row] section:indexPath.section ishome:YES];
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
                label.text = @"常用功能";
                break;
            case 1:
                label.text = @"功能模块";
                break;
            case 2:
                label.text = @"计量模块";
                break;
            default:
                break;
        }
        
        return header;
    }
    return nil;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        SearchViewController *vc = [[SearchViewController alloc] initWithNibName:@"SearchViewController" bundle:nil];
        switch (indexPath.row) {
            case 0:
                vc.searchType = SearchTypeRcvCirculated;
                break;
            case 1:
                vc.searchType = SearchTypeRcvApproval;
                break;
            case 2:
                vc.searchType = SearchTypeSendManagement;
                break;
            case 3:
                vc.searchType = SearchTypeRcvPublicity;
                break;
            case 4:
                vc.searchType = SearchTypeSendPublicity;
                break;
            case 5:
                [self outline];
                return;
            default:
                return;
        }
        [self.navigationController pushViewController:vc animated:YES];
    }else if (indexPath.section == 1) {
        OAApplicationController *vc  = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"oaApplication"];
        BaseWebViewController *webvc =  [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"BaseWebViewController"];
        FDScanViewController *fdvc = [[FDScanViewController alloc] init];
        UINavigationController * nVC = [[UINavigationController alloc]initWithRootViewController:fdvc];
        nVC.navigationBar.barTintColor = [UIColor whiteColor];
        switch (indexPath.row) {
            case 0:
                [self.navigationController pushViewController:vc animated:YES];
                break;
            case 1:
                vc.ismeetingRoom = true;
                [self.navigationController pushViewController:vc animated:YES];
                break;
            case 2:
                webvc.url = [self getLoadUrl:@"summaryPage"];
                [self.navigationController pushViewController:webvc animated:YES];
                break;
            case 3:
                webvc.url = [self getLoadUrl:@"officeMeetingList"];
                [self.navigationController pushViewController:webvc animated:YES];
                break;
            case 4:
//                考勤申请
                webvc.url = [self getLoadUrl:@"attendanceManagement"];
                [self.navigationController pushViewController:webvc animated:YES];
                break;
            case 5:
//                扫一扫
                [self presentViewController:nVC animated:YES completion:nil];
                break;
            case 6: {
                AttenDanceViewController *kqVc = [[UIStoryboard storyboardWithName:@"AttenDanceMng"
                                                                            bundle:nil]instantiateViewControllerWithIdentifier:@"AttenDanceViewController"];
                [self.navigationController pushViewController:kqVc animated:YES];
            }
                break;
//            case 1:
//                if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"hasSealManagement"] isEqualToString:@"1"]) {
//                    vc = [[UIStoryboard storyboardWithName:@"sealHome" bundle:nil] instantiateViewControllerWithIdentifier:@"sealHomeVc"];
//                }else if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"hasOutline"] isEqualToString:@"1"]) {
//                    [self outline];
//                    return;
//                }
//                break;
//            case 2:
//                if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"hasSealManagement"] isEqualToString:@"1"]) {
//                    vc = [[UIStoryboard storyboardWithName:@"sealHome" bundle:nil] instantiateViewControllerWithIdentifier:@"sealHomeVc"];
//                }else if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"hasOutline"] isEqualToString:@"1"]) {
//                    [self outline];
//                    return;
//                }
                break;
            default:
                return;
        }
       
    }else {
        UIViewController *vc;
        switch (indexPath.row) {
            case 0:
                vc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"analyMain"];
                break;
            case 1:
                vc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"approvalMain"];
                break;
            default:
                return;
        }
        [self.navigationController pushViewController:vc animated:YES];
    }
}
- (void)outline{
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"hasOutline"] isEqualToString:@"1"]) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"outline" bundle:nil];
        UIViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"project_outline_main"];
        //self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
        [self.navigationController pushViewController:vc animated:YES];
    }
}
-(NSString *)getLoadUrl:(NSString *)sortUrl{
    NSString *url;
    NSString *userName = [[NSUserDefaults standardUserDefaults] objectForKey:@"user"];
    NSString *password = [[NSUserDefaults standardUserDefaults] objectForKey:@"password"];
    if ([[UserAgent DefaultAgent].sectionId isEqualToString:@""]) {
        url = [NSString stringWithFormat:@"%@%@?user=%@&pwd=%@&projectId=%@&projectCode=%@&projectName=%@", [UrlConfig URL:temMobileFina],sortUrl, [userName stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]], [password stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]], [UserAgent DefaultAgent].projectId, [UserAgent DefaultAgent].projectCode, [[UserAgent DefaultAgent].prjName stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]];
    } else {
        url = [NSString stringWithFormat:@"%@%@?user=%@&pwd=%@&projectId=%@&projectCode=%@&projectName=%@&sectionId=%@&sectionCode=%@&sectionName=%@", [UrlConfig URL:temMobileFina],sortUrl, [userName stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]], [password stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]], [UserAgent DefaultAgent].projectId, [UserAgent DefaultAgent].projectCode, [[UserAgent DefaultAgent].prjName stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]], [UserAgent DefaultAgent].sectionId, [UserAgent DefaultAgent].sectionCode, [[UserAgent DefaultAgent].sectionName stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]];
    }
    return url;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
