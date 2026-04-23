//
//  SearchConditionController.m
//  PMPlatform_IOS
//
//  Created by 末末班车 on 2017/9/6.
//  Copyright © 2017年 com.atide. All rights reserved.
//

#import "SearchConditionController.h"
#import "SearchCoditionCell.h"
#import "SearchHeaderCell.h"
#import "FDCalendarView.h"
#import "STPickerSingle.h"

static NSString *cellIdentify = @"searchviewcell";
static NSString *headerIdentify = @"headerIdentify";

@interface SearchConditionController ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, STPickerSingleDelegate>

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *projectViewHeight;
@property (weak, nonatomic) IBOutlet UIButton *startDateUI;
@property (weak, nonatomic) IBOutlet UIButton *endDateUI;
@property (weak, nonatomic) IBOutlet UIButton *projectButton;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *dateChooseHeight;

@property (nonatomic, strong) SearchTypeModel *projectNode;

@end

@implementation SearchConditionController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setupUI];
    [self initCollections];
    if (self.searchType) {
        if (self.searchType == SearchTypeToDo || self.searchType == SearchTypeDoing || self.searchType == SearchTypeDone || self.searchType == SearchTypeSealIn || self.searchType == SearchTypeSealEx || self.searchType == SearchTypeSealLoan) {
            self.projectViewHeight.constant = 0;
            if (self.searchType == SearchTypeSealLoan) {
               self.dateChooseHeight.constant = 0;
            }
            
        }else {
            self.projectViewHeight.constant = 70;
        }
    }
}

#pragma mark - 初始化界面
- (void)setupUI {
    self.startDateUI.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.startDateUI.layer.borderWidth = 1;
    self.startDateUI.layer.cornerRadius = 5;
    [self.startDateUI sizeToFit];
    self.endDateUI.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.endDateUI.layer.borderWidth = 1;
    self.endDateUI.layer.cornerRadius = 5;
    [self.endDateUI sizeToFit];
    self.projectButton.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.projectButton.layer.borderWidth = 1;
    self.projectButton.layer.cornerRadius = 5;
    [self.projectButton sizeToFit];
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

#pragma mark - 点击事件
- (IBAction)sure:(id)sender {
    if (self.callback) {
        self.callback();
    }
}

- (IBAction)reset:(id)sender {
    [self.startDateUI setTitle:@"开始日期" forState:UIControlStateNormal];
    [self.endDateUI setTitle:@"结束日期" forState:UIControlStateNormal];
    [self.projectButton setTitle:@"请选择" forState:UIControlStateNormal];
    self.projectNode = nil;
    if (self.searchModels) {
        for (SearchModel *item in self.searchModels) {
            if (item.details) {
                for (SearchDetail *detail in item.details) {
                    detail.isSelected = NO;
                }
            }
        }
    }

    [self.collectionView reloadData];
}

- (IBAction)projectClicked:(id)sender {
    if (self.projectModels) {
        NSMutableArray <NSString *>*dataArr = [NSMutableArray array];
        for (SearchTypeModel *model in self.projectModels) {
            [dataArr addObject:model.name];
        }
        STPickerSingle *pickerSingle = [[STPickerSingle alloc]init];
        [pickerSingle setArrayData:dataArr];
        [pickerSingle setTitle:@"请选择单位"];
        [pickerSingle setDelegate:self];
        [pickerSingle show];
    }
}

- (IBAction)pickerStartDate:(id)sender {
    [self showDate:sender minDate:nil];
}

- (IBAction)pickerEndDate:(id)sender {
    if ([[self.startDateUI titleForState:UIControlStateNormal] isEqualToString:@"开始日期"]) {
        [MBManager showBriefAlert:@"请先选择开始日期"];
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

- (SearchParam *)params {
    NSMutableArray <SearchModel *>*models = [NSMutableArray array];
    
    if (self.searchModels) {
        for (SearchModel *item in self.searchModels) {
            if (item.details) {
                for (SearchDetail *detail in item.details) {
                    if (detail.isSelected) {
                        [models addObject:item];
                        break;
                    }
                }
            }
        }
    }
    
    NSString *startDate = [self.startDateUI titleForState:UIControlStateNormal];
    startDate = [startDate isEqualToString:@"开始日期"] ? @"" : startDate;
    NSString *endDate = [self.endDateUI titleForState:UIControlStateNormal];
    endDate = [endDate isEqualToString:@"结束日期"] ? @"" : endDate;

    SearchParam *param = [[SearchParam alloc] init];
    param.startDate = startDate;
    param.endDate = endDate;
    if (self.projectNode) {
        param.proId = self.projectNode.ID;
    }
    if (models.count > 0) {
        param.models = models;
    }
    return param;
}

#pragma mark - UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    if (self.searchModels) {
        return self.searchModels.count;
    }
    return 0;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (self.searchModels) {
        if (self.searchModels[section].details) {
            return self.searchModels[section].details.count;
        }
    }
    return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    SearchCoditionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentify forIndexPath:indexPath];
    
    if (self.searchModels) {
        if (self.searchModels[indexPath.section].details) {
            SearchDetail *detail = self.searchModels[indexPath.section].details[indexPath.row];
            cell.nameLabel.text = detail.text;
            if (detail.isSelected) {
                cell.parentView.backgroundColor = [UIColor redColor];
                cell.nameLabel.textColor = [UIColor whiteColor];
            } else {
                cell.parentView.backgroundColor = [UIColor whiteColor];
                cell.nameLabel.textColor = [UIColor darkGrayColor];
            }
        }
    }
    
    cell.backgroundColor = [UIColor whiteColor];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.searchModels) {
        if (self.searchModels[indexPath.section].details) {
            for (SearchDetail *detail in self.searchModels[indexPath.section].details) {
                detail.isSelected = NO;
            }
            self.searchModels[indexPath.section].details[indexPath.row].isSelected = YES;
            [collectionView reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section]];
        }
    }
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    UICollectionReusableView *cell = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:headerIdentify forIndexPath:indexPath];
    if (kind == UICollectionElementKindSectionHeader) {
        SearchHeaderCell *header = (SearchHeaderCell *)cell;
        header.nameLabel.text = self.searchModels[indexPath.section].headerTitle;
    }

    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    return CGSizeMake(collectionView.frame.size.width, 30);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSString *value = self.searchModels[indexPath.section].details[indexPath.row].text;
    CGSize size = [value boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]} context:nil].size;
    CGFloat width = MAX(size.width + 10, 40);
    return CGSizeMake(width, 25);
}

#pragma mark - STPickerSingleDelegate
- (void)pickerSingle:(STPickerSingle *)pickerSingle selectedTitle:(NSString *)selectedTitle {
    for (SearchTypeModel *model in self.projectModels) {
        if ([model.name isEqualToString:selectedTitle]) {
            self.projectNode = model;
            [self.projectButton setTitle:selectedTitle forState:UIControlStateNormal];
        }
    }
}

@end
