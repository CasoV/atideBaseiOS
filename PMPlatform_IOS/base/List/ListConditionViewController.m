//
//  ListConditionViewController.m
//  ycTest
//
//  Created by 末末班车 on 2018/9/12.
//  Copyright © 2018年 末末班车. All rights reserved.
//

#import "ListConditionViewController.h"
#import "SearchCoditionCell.h"
#import "SearchHeaderCell.h"
#import "FDCalendarView.h"
//#import "PartSeleterVc.h"

static NSString *cellIdentify = @"searchviewcell";
static NSString *headerIdentify = @"headerIdentify";

@interface ListConditionViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *keywordHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *partBtnHeight;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UITextField *titleTF;
@property (weak, nonatomic) IBOutlet UIButton *startDateUI;
@property (weak, nonatomic) IBOutlet UIButton *endDateUI;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomHeight;

@property (weak, nonatomic) IBOutlet UIView *dateView;

@end

@implementation ListConditionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setupUI];
    [self initCollections];
}

#pragma mark - 初始化界面
- (void)setupUI {
    self.startDateUI.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.startDateUI.layer.borderWidth = 0.5;
    self.startDateUI.layer.cornerRadius = 5;
    [self.startDateUI sizeToFit];
    self.endDateUI.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.endDateUI.layer.borderWidth = 0.5;
    self.endDateUI.layer.cornerRadius = 5;
    [self.endDateUI sizeToFit];
    self.projectBtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.projectBtn.layer.borderWidth = 0.5;
    self.projectBtn.layer.cornerRadius = 5;
    [self.projectBtn sizeToFit];
    
    self.dateView.hidden = !self.showDate;
    
    if (self.hiddenPartBtn) {
        self.partBtnHeight.constant = 0;
    }
    
    if (self.keyword) {
        self.titleLabel.text = [NSString stringWithFormat:@"%@:", self.keyword];
        self.titleTF.placeholder = [NSString stringWithFormat:@"请输入%@", self.keyword];
    }
    
    self.keywordHeight.constant = self.showKeyword ? 40 : 0;
    
    if (IS_IPHONE_X) {
        self.bottomHeight.constant = 55;
    }
}

- (void)initCollections {
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    
    layout.itemSize = CGSizeMake(100, 30);
    layout.minimumLineSpacing = 5;
    layout.minimumInteritemSpacing = 10;
    self.collectionView.collectionViewLayout = layout;
    self.collectionView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self.collectionView registerNib:[UINib nibWithNibName:@"SearchCoditionCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:cellIdentify];
    [self.collectionView registerNib:[UINib nibWithNibName:@"SearchHeaderCell" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headerIdentify];
}

- (NSDictionary *)params {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    if (![self.titleTF.text isEqualToString:@""]) {
        [params setObject:self.titleTF.text forKey:@"title"];
    }
    
    if (self.partCode) {
        [params setObject:self.partCode forKey:@"partCode"];
    }
    
    if (![self.startDateUI.currentTitle isEqualToString:@"开始日期"]) {
        [params setObject:self.startDateUI.currentTitle forKey:@"startTime"];
    }
    if (![self.endDateUI.currentTitle isEqualToString:@"结束日期"]) {
        [params setObject:self.endDateUI.currentTitle forKey:@"endTime"];
    }
    
    for (ConditionModel *model in self.conditionModels) {
        for (ConditionDetail *detail in model.details) {
            if (detail.isSelected) {
                [params setObject:detail.ID forKey:model.ID];
            }
        }
    }
    
    return params;
}

#pragma mark - 点击事件
- (IBAction)sure:(id)sender {
    if (self.callback) {
        self.callback();
    }
}

- (IBAction)reset:(id)sender {
    [self.startDateUI setTitle:@"开始日期" forState:UIControlStateNormal];
    [self.endDateUI setTitle:@"结束日期" forState:UIControlStateNormal];
    self.titleTF.text = @"";
    [self.projectBtn setTitle:@"请选择工程部位" forState:UIControlStateNormal];
    self.partCode = nil;
    
    if (self.conditionModels) {
        for (ConditionModel *item in self.conditionModels) {
            if (item.details) {
                for (ConditionDetail *detail in item.details) {
                    detail.isSelected = NO;
                }
            }
        }
    }
    
    [self.collectionView reloadData];
}

- (IBAction)chooseSite:(UIButton *)sender {
//    __weak typeof(self) weakSelf = self;
//    PartSeleterVc *vc = [[UIStoryboard storyboardWithName:@"PartSeleter" bundle:nil] instantiateViewControllerWithIdentifier:@"PartSeleterVc"];
//    vc.type = Screening;
//    vc.block = ^(SiteModel *site) {
//        [sender setTitle:site.text forState:UIControlStateNormal];
//        weakSelf.partCode = site.id;
//    };
//    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)pickerStartDate:(id)sender {
    [self showDate:sender minDate:nil];
}

- (IBAction)pickerEndDate:(id)sender {
    if ([[self.startDateUI titleForState:UIControlStateNormal] isEqualToString:@"开始日期"]) {
        [SVProgressHUD showInfoWithStatus:@"请先选择开始日期"];
        return;
    }
    [self showDate:sender minDate:[self.startDateUI titleForState:UIControlStateNormal]];
}

#pragma mark - 显示日期选择器
- (void)showDate:(UIButton *)textUI minDate:(NSString *)minDate {
    NSDate *minimumDate = nil;
    if (minDate) {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.locale = [NSLocale currentLocale];
        formatter.timeZone = [NSTimeZone localTimeZone];
        formatter.dateFormat = @"yyyy-MM-dd";
        minimumDate = [formatter dateFromString:minDate];
    }
    
    NSString *dateStr = textUI.currentTitle;
    
    if ([dateStr isEqualToString:@"开始日期"] || [dateStr isEqualToString:@"结束日期"]) {
        dateStr = nil;
    }
    
    FDCalendarView *calendarView = [[FDCalendarView alloc] initWithFrame:[UIScreen mainScreen].bounds andCurrentDateStr:dateStr minimumDate:minimumDate datePickerMode:UIDatePickerModeDate];
    [[UIApplication sharedApplication].keyWindow addSubview:calendarView];
    calendarView.block = ^(NSDate *date) {
        if (date){
            if (textUI == self.startDateUI){
                [self.endDateUI setTitle:@"结束日期" forState:UIControlStateNormal];
            }
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            formatter.locale = [NSLocale currentLocale];
            formatter.timeZone = [NSTimeZone localTimeZone];
            formatter.dateFormat = @"yyyy-MM-dd";
            [textUI setTitle:[formatter stringFromDate:date] forState:UIControlStateNormal];
        }
    };
    [calendarView fadeIn];
}

#pragma mark - UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    if (self.conditionModels) {
        return self.conditionModels.count;
    }
    return 0;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (self.conditionModels) {
        if (self.conditionModels[section].details) {
            return self.conditionModels[section].details.count;
        }
    }
    return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    SearchCoditionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentify forIndexPath:indexPath];
    
    if (self.conditionModels) {
        if (self.conditionModels[indexPath.section].details) {
            ConditionDetail *detail = self.conditionModels[indexPath.section].details[indexPath.row];
            cell.nameLabel.text = detail.text;
            if (detail.isSelected) {
                cell.parentView.backgroundColor = UIColorFromRGB(0x0295ff);
                cell.nameLabel.textColor = [UIColor whiteColor];
            } else {
                cell.parentView.backgroundColor = [UIColor whiteColor];
                cell.nameLabel.textColor = UIColorFromRGB(0x0295ff);
            }
        }
    }
    
    cell.backgroundColor = [UIColor whiteColor];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.conditionModels) {
        if (self.conditionModels[indexPath.section].details) {
            for (ConditionDetail *detail in self.conditionModels[indexPath.section].details) {
                detail.isSelected = NO;
            }
            self.conditionModels[indexPath.section].details[indexPath.row].isSelected = YES;
            [collectionView reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section]];
        }
    }
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    UICollectionReusableView *cell = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:headerIdentify forIndexPath:indexPath];
    if (kind == UICollectionElementKindSectionHeader) {
        SearchHeaderCell *header = (SearchHeaderCell *)cell;
        header.nameLabel.text = self.conditionModels[indexPath.section].headerTitle;
    }
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    return CGSizeMake(collectionView.frame.size.width, 30);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat width;
    if (kScreen_Width < 375) {
        width = (collectionView.frame.size.width - 22) / 3;
    } else {
        width = (collectionView.frame.size.width - 33) / 4;
    }
    return CGSizeMake(width, 25);
}

@end
