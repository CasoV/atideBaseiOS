//
//  SearchViewController.m
//  PMPlatform_IOS
//
//  Created by 末末班车 on 2017/9/6.
//  Copyright © 2017年 com.atide. All rights reserved.
//

#import "SearchViewController.h"
#import "SearchConditionController.h"
#import "SearchTypeModel.h"
#import "OrgAndUserHelper.h"

@interface SearchViewController ()<UISearchBarDelegate>

@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *headerViewTop;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *applyUserWidth;
@property (weak, nonatomic) IBOutlet UIButton *totalButton;
@property (weak, nonatomic) IBOutlet UIButton *applyButton;

@property (weak, nonatomic) IBOutlet UIView *childView;

@end

@implementation SearchViewController {
    UIView *_backColorView;
    SearchConditionController *_conditionController;
    ChildBaseController *_childController;
    
    NSMutableArray <SearchModel *>*_searchModels;
    
    NSArray <SearchTypeModel *>*_projectArr;
    NSArray <SearchTypeModel *>*_bizTypeArr;
    NSArray <SearchTypeModel *>*_natrueArr;
    
    TreeNode *_drafterNode;
    
    NSString *_dateTitle;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.edgesForExtendedLayout = UIRectEdgeBottom;
    
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, -64, ScreenWidth, 64)];
    bgView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bgView];

    _dateTitle = @"起止时间";
    
    if (self.searchType) {
        if (self.searchType == SearchTypeToDo || self.searchType == SearchTypeDoing || self.searchType == SearchTypeDone) {
//            self.applyUserWidth.constant = ScreenWidth * 0.333;
            self.headerViewTop.constant = -44;
            _searchModels = [NSMutableArray array];
            SearchModel *model = [[SearchModel alloc] init];
            model.headerTitle = @"业务类型";
            model.ID = @"bizKey";
            NSMutableArray <SearchDetail *>*details = [NSMutableArray array];
            for (NSNumber *item in [SearchFactory getAllBizKeyType]) {
                SearchDetail *detail = [[SearchDetail alloc] init];
                detail.ID = [SearchFactory getBizKeyTypeID:item.integerValue];
                detail.text = [SearchFactory getBizKeyTypeName:item.integerValue];
                [details addObject:detail];
            }
            model.details = details;
            [_searchModels addObject:model];
            _dateTitle = @"申请日期";
            [self configCondition];
        }else if (self.searchType == SearchTypeSealIn || self.searchType == SearchTypeSealEx || self.searchType == SearchTypeSealLoan){
            self.applyUserWidth.constant = 0;
            self.headerViewTop.constant = -44;
             [self loadSealOptions];
        }else {
            if (self.searchType == SearchTypeSendPublicity || self.searchType == SearchTypeSendManagement) {
                _dateTitle = @"开始时间";
            }
            self.applyUserWidth.constant = 0;
            self.headerViewTop.constant = 0;
            [self loadFilterData];
        }
        
        _childController = [SearchFactory generatorController:self.searchType];
        [self addChildViewController:_childController];
        _childController.view.frame = self.childView.bounds;
        [self.childView addSubview:_childController.view];
        self.searchBar.placeholder = @"请输入公文标题";
        self.navigationItem.title = [SearchFactory generatorTitleText:self.searchType];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    self.navigationController.navigationBar.hidden = NO;
    self.tabBarController.tabBar.hidden = YES;
    
    _conditionController.view.hidden = NO;
    [self configCondition];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    _conditionController.view.hidden = YES;
}

#pragma mark - 初始化界面
- (void)configCondition {
    /* 创建一个阴影 */
    _backColorView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    _backColorView.backgroundColor = [UIColor blackColor];
    _backColorView.alpha = 0;   //开始透明度为0,后面通过动画逐渐变黑
    UITapGestureRecognizer *tapG = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeTap)];
    [_backColorView addGestureRecognizer:tapG]; //加入触摸手势,点阴影区域时关闭右侧导航栏
    [self.view addSubview:_backColorView];
    
    /* 创建第二页对象 */
    __weak typeof(self) weakself = self;
    _conditionController = [[SearchConditionController alloc] initWithNibName:@"SearchConditionController" bundle:nil];
    _conditionController.searchModels = _searchModels;
    _conditionController.projectModels = _projectArr;
    _conditionController.searchType = self.searchType;
    _conditionController.callback = ^{
        [weakself closeTap];
        [weakself refresh];
    };
    _conditionController.view.frame = CGRectMake(ScreenWidth, 0, ScreenWidth - 50, self.view.frame.size.height);
    _conditionController.dateLabel.text = _dateTitle;
    [self addChildViewController:_conditionController];
    /* 把第二个导航栏控制器的视图加到本导航栏控制器的view上(事实上导航栏控制器的view是包含了导航栏,视图控制器的视图 */
    [self.view addSubview:_conditionController.view];
}

#pragma mark - 加载选项
- (void)loadFilterData {
    [SearchTypeModel mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
        return @{@"ID":@"id"};
    }];
    [[HttpManager manager] get:[UrlConfig URL:sendPQueryList] param:nil success:^(NSData *data) {
        _projectArr = [SearchTypeModel mj_objectArrayWithKeyValuesArray:data];
        _conditionController.projectModels = _projectArr;
        [self loadFilterConfigCondition];
    } faild:^(NSString *msg) {
        [MBManager showBriefAlert:msg];
    }];
    [[HttpManager manager] get:[UrlConfig URL:getEasyuiCombobox] param:@{@"keyId":@"docBizType"} success:^(NSData *data) {
        _bizTypeArr = [SearchTypeModel mj_objectArrayWithKeyValuesArray:data];
        [self loadFilterConfigCondition];
    } faild:^(NSString *msg) {
        [MBManager showBriefAlert:msg];
    }];
    [[HttpManager manager] get:[UrlConfig URL:getEasyuiCombobox] param:@{@"keyId":@"docNatrue"} success:^(NSData *data) {
        _natrueArr = [SearchTypeModel mj_objectArrayWithKeyValuesArray:data];
        [self loadFilterConfigCondition];
    } faild:^(NSString *msg) {
        [MBManager showBriefAlert:msg];
    }];
}
-(void)loadSealOptions{
    _searchModels = [NSMutableArray array];
    NSMutableArray <SearchDetail *>*details = [NSMutableArray array];
    if (self.searchType == SearchTypeSealIn || self.searchType == SearchTypeSealEx ) {
        SearchModel *model1 = [[SearchModel alloc] init];
        model1.headerTitle = @"内/外部用印审批";
        model1.ID = @"approvalType";
        for (NSNumber *item in [SearchFactory getAllApprovalType]) {
            SearchDetail *detail = [[SearchDetail alloc] init];
            detail.ID = [NSString stringWithFormat:@"%ld", item.integerValue];
            detail.text = [SearchFactory getApprovalTypeName:item.integerValue];
            [details addObject:detail];
        }
        model1.details = details;
        [_searchModels addObject:model1];
    }
    
    
    SearchModel *model2 = [[SearchModel alloc] init];
    model2.headerTitle = @"流程状态";
    model2.ID = @"status";
    details = [NSMutableArray array];
    for (NSNumber *item in [SearchFactory getAllStatusType]) {
        SearchDetail *detail = [[SearchDetail alloc] init];
        detail.ID = [NSString stringWithFormat:@"%ld", item.integerValue];
        detail.text = [SearchFactory getStatusTypeName:item.integerValue];
        [details addObject:detail];
    }
    model2.details = details;
    [_searchModels addObject:model2];

    [self configCondition];
}

- (void)loadFilterConfigCondition {
    if (!(_projectArr && _bizTypeArr && _natrueArr)) {
        return;
    }
    
    _searchModels = [NSMutableArray array];
    SearchModel *model1 = [[SearchModel alloc] init];
    model1.headerTitle = @"紧急程度";
    model1.ID = @"urgency";
    NSMutableArray <SearchDetail *>*details = [NSMutableArray array];
    for (NSNumber *item in [SearchFactory getAllUrgencyType]) {
        SearchDetail *detail = [[SearchDetail alloc] init];
        detail.ID = [NSString stringWithFormat:@"%ld", item.integerValue];
        detail.text = [SearchFactory getUrgencyTypeName:item.integerValue];
        [details addObject:detail];
    }
    model1.details = details;
    [_searchModels addObject:model1];
    
//    SearchModel *model2 = [[SearchModel alloc] init];
//    model2.headerTitle = @"公文密级";
//    model2.ID = @"secretLevel";
//    details = [NSMutableArray array];
//    for (NSNumber *item in [SearchFactory getAllSecretLevelType]) {
//        SearchDetail *detail = [[SearchDetail alloc] init];
//        detail.ID = [NSString stringWithFormat:@"%ld", item.integerValue];
//        detail.text = [SearchFactory getSecretLevelTypeName:item.integerValue];
//        [details addObject:detail];
//    }
//    model2.details = details;
//    [_searchModels addObject:model2];
    
    SearchModel *model3 = [[SearchModel alloc] init];
    model3.headerTitle = @"公文类型";
    model3.ID = @"itemType";
    details = [NSMutableArray array];
    for (SearchTypeModel *item in _bizTypeArr) {
        SearchDetail *detail = [[SearchDetail alloc] init];
        detail.ID = item.ID;
        detail.text = item.text;
        [details addObject:detail];
    }
    model3.details = details;
    [_searchModels addObject:model3];
    
    
    
    if (!(self.searchType == SearchTypeSendPublicity || self.searchType == SearchTypeSendManagement)) {
        SearchModel *model4 = [[SearchModel alloc] init];
        model4.headerTitle = @"流程状态";
        model4.ID = @"status";
        details = [NSMutableArray array];
        for (NSNumber *item in [SearchFactory getAllStatusType]) {
            SearchDetail *detail = [[SearchDetail alloc] init];
            detail.ID = [NSString stringWithFormat:@"%ld", item.integerValue];
            detail.text = [SearchFactory getStatusTypeName:item.integerValue];
            [details addObject:detail];
        }
        model4.details = details;
        [_searchModels addObject:model4];
    }
    
    SearchModel *model5 = [[SearchModel alloc] init];
    model5.headerTitle = @"文件性质";
    model5.ID = @"docNatrue";
    details = [NSMutableArray array];
    for (SearchTypeModel *item in _natrueArr) {
        SearchDetail *detail = [[SearchDetail alloc] init];
        detail.ID = item.ID;
        detail.text = item.text;
        [details addObject:detail];
    }
    model5.details = details;
    [_searchModels addObject:model5];
    
    [self configCondition];
}

#pragma mark - 点击事件
- (IBAction)applyUserClicked:(id)sender {
    if ([self.applyButton.currentTitle isEqualToString:@"申请人"]) {
        [OrgAndUserHelper skipController:self callback:^(NSArray<TreeNode *> *nodes) {
            _drafterNode = nodes.firstObject;
            [self.applyButton setTitle:_drafterNode.name forState:UIControlStateNormal];
            [self refresh];
        }];
    }else {
        [self.applyButton setTitle:@"申请人" forState:UIControlStateNormal];
        _drafterNode = nil;
        [self refresh];
    }
}

- (IBAction)tapCondition:(id)sender {
    /* 出现的动画 */
    [UIView animateWithDuration:0.5 animations:^{
        _backColorView.alpha = 0.3;
        _conditionController.view.frame = CGRectMake(50, 0, ScreenWidth - 50, self.view.frame.size.height);
    }];
}

- (void)closeTap {
    /* 关闭操作,先动画后移除 */
    [UIView animateWithDuration:0.5 animations:^{
        _backColorView.alpha = 0;
        _conditionController.view.frame = CGRectMake(ScreenWidth, 0, ScreenWidth - 50, self.view.frame.size.height);
    }];
}

#pragma mark - 通知界面刷新
- (void)refresh {
    SearchParam *param = [_conditionController params];
    param.title = self.searchBar.text;
    if (_drafterNode) {
        param.drafter = _drafterNode.ID;
    }
    [_childController refresh:@{@"search":param}];
}

- (void)resetTotalButton:(NSString *)total {
    [self.totalButton setTitle:[NSString stringWithFormat:@"共%@条", total] forState:UIControlStateNormal];
}

#pragma mark - UISearchBarDelegate
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {
    searchBar.showsCancelButton = YES;
    return YES;
}

- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar {
    searchBar.showsCancelButton = NO;
    return YES;
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    searchBar.text = @"";
    [searchBar resignFirstResponder];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
    [self refresh];
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    NSArray<UIView *> *views = ([[[UIDevice currentDevice] systemVersion] floatValue] < 7.0) ? searchBar.subviews : [[searchBar.subviews objectAtIndex:0] subviews];
    for (UIView *subview in views) {
        if ([subview isKindOfClass:[UITextField class]]){
            UITextField *searchBarTextField = (UITextField *)subview;
            searchBarTextField.enablesReturnKeyAutomatically = NO;
            break;
        }
    }
}

@end
