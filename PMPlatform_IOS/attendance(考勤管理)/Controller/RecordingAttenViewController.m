//
//  RecordingAttenViewController.m
//  ycxm
//
//  Created by 高小伟 on 2020/6/11.
//  Copyright © 2020 末末班车. All rights reserved.
//

#import "RecordingAttenViewController.h"
#import "MonthModel.h"
#import "CalendarHeaderView.h"
#import "CalendarCell.h"
//#import "StatusMonthModel.h"
#import "AttenanceDayModel.h"
#import "YWExcelView.h"
#import "MouthUserStatisModel.h"
#import "UIImage+Additions.h"
#import "NSDate-Utilities.h"
#import "NSDate+Timestamp.h"
#import "NSDate+Formatter.h"

#define LL_SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define LL_SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)
#define Iphone6Scale(x) ((x) * LL_SCREEN_WIDTH / 375.0f)

#define HeaderViewHeight 30
#define WeekViewHeight 40

@interface RecordingAttenViewController ()

@end

@interface RecordingAttenViewController () <UICollectionViewDelegate, UICollectionViewDataSource,YWExcelViewDataSource,YWExcelViewDelegate>
@property (strong, nonatomic) UICollectionView *collectionView;
@property (strong, nonatomic) NSMutableArray *dayModelArray;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (strong, nonatomic) NSDate *tempDate;
// 上一次选择index ，初始值为今天的index
@property (assign, nonatomic) NSInteger lastSelectIndex;
@property (weak, nonatomic) IBOutlet UILabel *titleLb;

@property (weak, nonatomic) IBOutlet UIView *listView;
@property(strong, nonatomic) NSMutableArray *dataArr;
@property (nonatomic,strong) YWExcelView *exceView;

@property (weak, nonatomic) IBOutlet UIImageView *tagImg1;
@property (weak, nonatomic) IBOutlet UILabel *tagLabel1;
@property (weak, nonatomic) IBOutlet UIImageView *tagImg2;
@property (weak, nonatomic) IBOutlet UILabel *tagLabel2;
@property (weak, nonatomic) IBOutlet UIImageView *tagImg3;
@property (weak, nonatomic) IBOutlet UILabel *tagLabel3;

@property (nonatomic, assign) NSInteger currentYear;
@property (nonatomic, assign) NSInteger currentMonth;
@property (nonatomic, assign) NSInteger currentDay;
@property (nonatomic, assign) BOOL todayFinish;

@end

@implementation RecordingAttenViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationItem.title = @"考勤记录";
}
- (IBAction)left:(id)sender {
    self.tempDate = [self getLastMonth:self.tempDate];
    self.dateLabel.text = self.tempDate.yyyyMMByLineWithDate;
    [self getDataDayModel:self.tempDate];
    [self getWorkDays];
}

- (IBAction)right:(id)sender {
    self.tempDate = [self getNextMonth:self.tempDate];
    self.dateLabel.text = self.tempDate.yyyyMMByLineWithDate;
    [self getDataDayModel:self.tempDate];
    [self getWorkDays];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.view addSubview:self.collectionView];

    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    if (self.endTime && self.endTime.length > 0 && [[NSDate date] isLaterThanDate:[dateFormatter dateFromString:[NSString stringWithFormat:@"%@ %@:59", [NSDate todayDateStringYYMMdd], self.endTime]]]) {
        self.todayFinish = YES;
    }

    NSArray <NSString *>*tempArr = [[NSDate todayDateStringYYMMdd] componentsSeparatedByString:@"-"];
    if (tempArr.count == 3) {
        self.currentYear = tempArr[0].integerValue;
        self.currentMonth = tempArr[1].integerValue;
        self.currentDay = tempArr[2].integerValue;
    }

    self.tempDate = [NSDate date];
    self.dateLabel.text = self.tempDate.yyyyMMByLineWithDate;
    [self getDataDayModel:self.tempDate];
    [self getWorkDays];

    [self setupListView];
    [self loadData:self.tempDate];

    _tagImg1.image = [UIImage imageWithColor:[UIColor hex:@"3AC674"]];
    _tagImg1.layer.masksToBounds = YES;
    _tagImg1.layer.cornerRadius = 7.5f;
    _tagImg2.image = [UIImage imageWithColor:[UIColor hex:@"78A3EC"]];
    _tagImg2.layer.masksToBounds = YES;
    _tagImg2.layer.cornerRadius = 7.5f;
    _tagImg3.image = [UIImage imageWithColor:[UIColor hex:@"FF6A42"]];
    _tagImg3.layer.masksToBounds = YES;
    _tagImg3.layer.cornerRadius = 7.5f;
}

-(void)loadData:(NSDate *)date{
    NSString *dateString = date.yyyyMMddByLineWithDate;
    self.titleLb.text = [NSString stringWithFormat:@"%@ %@ 打卡记录",dateString,[self dealWeek:date]];
    [[HttpManager manager]post:[UrlConfig URL:selectByDay] param:@{
        @"date":dateString,
        @"useId":[UserInfo getInstance].ID
    } success:^(NSData *data) {
        self.dataArr =  [AttenanceDayModel mj_objectArrayWithKeyValuesArray:data];
        for (AttenanceDayModel *model in self.dataArr) {
            NSDate * myDate=[NSDate dateWithTimeIntervalSince1970:model.date.doubleValue/1000];
            NSDateFormatter * formatter=[[NSDateFormatter alloc]init];
            [formatter setDateFormat:@"HH:mm:ss"];
            NSString *timeStr=[formatter stringFromDate:myDate];
            model.time = timeStr;
            NSArray *typeArr = @[@"普通",@"拍照",@"人脸",@"指纹"];
            model.typeStr = typeArr[model.type.intValue - 1];

        };
        [self.exceView reloadData];
    } faild:^(NSString *msg) {

    }];
}

-(void)setupListView{
    YWExcelViewMode *mode = [YWExcelViewMode new];
    mode.style = YWExcelViewStyleheadScrollView;
    mode.defalutHeight = 40;
    //推荐使用这样初始化
    YWExcelView *exceView = [[YWExcelView alloc] initWithFrame:CGRectMake(10, 36, self.listView.frame.size.width - 20 , kScreen_Height - 530) mode:mode];
    exceView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    exceView.dataSource = self;
    exceView.showBorder = YES;
    exceView.delegate = self;
    exceView.showBorderColor = [UIColor colorWithRed:228/255.0 green:228/255.0 blue:228/255.0 alpha:1.0];
    [_listView addSubview:exceView];
    _exceView = exceView;
}

-(void)getWorkDays{
    NSString *dateStr = self.tempDate.yyyyMMByLineWithDate;
        [[HttpManager manager] get:[UrlConfig URL:kqStatisDayUserStatis] param:@{
            @"projectId":[UserAgent DefaultAgent].projectId,
            @"sectionId":[UserAgent DefaultAgent].sectionId.length == 0 ? [UserAgent DefaultAgent].projectId : [UserAgent DefaultAgent].sectionId,
            @"currentDate":dateStr,
            @"userId":[UserInfo getInstance].ID
        } success:^(NSData *data) {
            NSArray *arr = [MouthUserStatisModel mj_objectArrayWithKeyValuesArray :data];

                for (MouthUserStatisModel *modelSever in arr) {
                    for (MonthModel *model in self.dayModelArray) {
                        NSArray <NSString *>*dateStrs = [modelSever.workDay componentsSeparatedByString:@"-"];
                        if (dateStrs.count == 3 && ![model isEqual:@""]) {
                            NSInteger year = dateStrs[0].integerValue;
                            NSInteger month = dateStrs[1].integerValue;
                            NSInteger day = dateStrs[2].integerValue;
                            if (day == model.dayValue) {
                                if (year < self.currentYear || (year == self.currentYear && month < self.currentMonth) || (year == self.currentYear && month == self.currentMonth && (self.todayFinish ? day <= self.currentDay : day < self.currentDay))) {
                                    model.isWorkDay = YES;
                                    model.standard1 = modelSever.kqStatus;
                                }
                                break;
                            }
                        }
                    }
                }
            [self.collectionView reloadData];
            int normalCount = 0;
            int omissionCount = 0;
            int aberrantCount = 0;
            for (MonthModel *item in self.dayModelArray) {
                if([item isEqual:@""] || !item.isWorkDay){
                    continue;;
                }
                if ([item.standard1 isEqualToString: @"0"]) {
                    aberrantCount++;
                } else if ([item.standard1 isEqualToString: @"1"]) {
                    normalCount++;
                } else if ([item.standard1 isEqualToString: @"2"]) {
                    omissionCount++;
                }
            }
            self->_tagLabel1.text = [NSString stringWithFormat:@"出勤:%d天",normalCount];
            self->_tagLabel2.text = [NSString stringWithFormat:@"请假:%d天",omissionCount];
            self->_tagLabel3.text = [NSString stringWithFormat:@"缺勤:%d天",aberrantCount];


        } faild:^(NSString *msg) {

        }];
}

- (void)getDataDayModel:(NSDate *)date{
    NSUInteger days = [self numberOfDaysInMonth:date];
    NSInteger week = [self startDayOfWeek:date];
    self.dayModelArray = [[NSMutableArray alloc] initWithCapacity:42];
    int day = 1;
    for (int i= 1; i<days+week; i++) {
        if (i<week) {
            [self.dayModelArray addObject:@""];
        }else{
            MonthModel *mon = [MonthModel new];
            mon.dayValue = day;
            NSDate *dayDate = [self dateOfDay:day];
            mon.dateValue = dayDate;
            if ([dayDate.yyyyMMddByLineWithDate isEqualToString:[NSDate date].yyyyMMddByLineWithDate]) {
                mon.isSelectedDay = YES;
                self.lastSelectIndex = i - 1;
            }
            [self.dayModelArray addObject:mon];
            day++;
        }
    }
    [self.collectionView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dayModelArray.count;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CalendarCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CalendarCell" forIndexPath:indexPath];

    id mon = self.dayModelArray[indexPath.row];
    if ([mon isKindOfClass:[MonthModel class]]) {
        cell.monthModel = (MonthModel *)mon;
    }else{
        cell.dayLabel.text = @"";
        cell.dayLabel.textColor = [UIColor blackColor];
        cell.image1.image = nil;
        cell.image2.image = nil;
    }

    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    CalendarHeaderView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"CalendarHeaderView" forIndexPath:indexPath];
    return headerView;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{

    if (indexPath.row == _lastSelectIndex) return;
    id mon = self.dayModelArray[indexPath.row];
    id lastMon = self.dayModelArray[self.lastSelectIndex];

    if ([lastMon isKindOfClass:[MonthModel class]] && [mon isKindOfClass:[MonthModel class]]) {
        MonthModel *lastMonthModel = (MonthModel *)lastMon;
        lastMonthModel.isSelectedDay = NO;

        MonthModel *monthModel = (MonthModel *)mon;
        monthModel.isSelectedDay = YES;
        self.dateLabel.text = [monthModel dateValue].yyyyMMddByLineWithDate;

        NSIndexPath *lastSelectPath = [NSIndexPath indexPathForItem:self.lastSelectIndex inSection:0];
        [self.collectionView reloadItemsAtIndexPaths:@[lastSelectPath, indexPath]];
        self.lastSelectIndex = indexPath.row;

        [self loadData:monthModel.dateValue];
    }


}

- (UICollectionView *)collectionView{
    if (!_collectionView) {
        NSInteger width = Iphone6Scale(54);
        NSInteger height = Iphone6Scale(54);

        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
        flowLayout.itemSize = CGSizeMake(width, height);
        flowLayout.headerReferenceSize = CGSizeMake(LL_SCREEN_WIDTH, HeaderViewHeight);
        flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
        flowLayout.minimumInteritemSpacing = 0;
        flowLayout.minimumLineSpacing = 0;

        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 64 + WeekViewHeight + 30, width * 7, 350) collectionViewLayout:flowLayout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = [UIColor whiteColor];

        [_collectionView registerClass:[CalendarCell class] forCellWithReuseIdentifier:@"CalendarCell"];
        [_collectionView registerClass:[CalendarHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"CalendarHeaderView"];

    }
    return _collectionView;
}


#pragma mark -Private
- (NSUInteger)numberOfDaysInMonth:(NSDate *)date{
    NSCalendar *greCalendar = [[NSCalendar alloc]initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    [greCalendar setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
    return [greCalendar rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:date].length;

}

- (NSDate *)firstDateOfMonth:(NSDate *)date{
    NSCalendar *greCalendar = [[NSCalendar alloc]initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    [greCalendar setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
    NSDateComponents *comps = [greCalendar
                               components:NSCalendarUnitYear | NSCalendarUnitMonth |NSCalendarUnitWeekday | NSCalendarUnitDay
                               fromDate:date];
    comps.day = 1;
    return [greCalendar dateFromComponents:comps];
}

- (NSUInteger)startDayOfWeek:(NSDate *)date
{
    NSCalendar *greCalendar = [[NSCalendar alloc]initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    [greCalendar setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];//Asia/Shanghai
    NSDateComponents *comps = [greCalendar
                               components:NSCalendarUnitYear | NSCalendarUnitMonth |NSCalendarUnitWeekday | NSCalendarUnitDay
                               fromDate:[self firstDateOfMonth:date]];
    return comps.weekday;
}

- (NSDate *)getLastMonth:(NSDate *)date{
    NSCalendar *greCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    [greCalendar setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
    NSDateComponents *comps = [greCalendar
                               components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay
                               fromDate:date];
    comps.month -= 1;
    return [greCalendar dateFromComponents:comps];
}

- (NSDate *)getNextMonth:(NSDate *)date{
    NSCalendar *greCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    [greCalendar setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
    NSDateComponents *comps = [greCalendar
                               components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay
                               fromDate:date];
    comps.month += 1;
    return [greCalendar dateFromComponents:comps];
}

- (NSDate *)dateOfDay:(NSInteger)day{
    NSCalendar *greCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    [greCalendar setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
    NSDateComponents *comps = [greCalendar
                               components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay
                               fromDate:self.tempDate];
    comps.day = day;
    return [greCalendar dateFromComponents:comps];
}
#pragma MARK -YWExcelViewDataSource
- (NSArray *)widthForItemOnExcelView:(YWExcelView *)excelView{
    return @[@50,@50,@70,@(kScreen_Width - 190)];
}
- (NSInteger)numberOfSectionsInExcelView:(YWExcelView *)excelView{
    return 1;
}
//多少行
- (NSInteger)excelView:(YWExcelView *)excelView numberOfRowsInSection:(NSInteger)section{
    return _dataArr.count;
}
//多少列
- (NSInteger)itemOfRow:(YWExcelView *)excelView{
    return 4;
}
- (void)excelView:(YWExcelView *)excelView label:(UILabel *)label textAtIndexPath:(YWIndexPath *)indexPath{
    AttenanceDayModel *model = _dataArr[indexPath.row];

    label.numberOfLines = 0;
    label.font = [UIFont systemFontOfSize:13];
    if (indexPath.row < self.dataArr.count) {
        label.backgroundColor = [UIColor whiteColor];
        switch (indexPath.item) {
            case 0:
                label.text = [NSString stringWithFormat:@"%ld",(long)indexPath.row + 1];
                break;
            case 1:
                label.text = model.typeStr;
                break;
            case 2:
                label.text = model.time;
                break;
            case 3:
                label.text = model.dress;
                break;
            default:
                break;
        }
    }
}
- (void)excelView:(YWExcelView *)excelView headView:(UILabel *)label textAtIndexPath:(YWIndexPath *)indexPath{
    label.backgroundColor = [UIColor whiteColor];
    switch (indexPath.item) {
        case 0:
            label.text = @"序号";
            break;
        case 1:
            label.text = @"类型";
            break;
        case 2:
            label.text = @"时间";
            break;
        case 3:
            label.text = @"地点";
            break;

        default:
            break;
    }
}
-(NSString *)dealWeek:(NSDate *)date{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSUInteger unitFlags = NSCalendarUnitHour|kCFCalendarUnitWeekday;
    NSArray *weekdays = [NSArray arrayWithObjects:@"周日", @"周一", @"周二", @"周三", @"周四", @"周五", @"周六", nil];
    NSDateComponents *dateComponent = [calendar components:unitFlags fromDate:date];
    NSString *week = weekdays[ [dateComponent weekday] - 1];
    return week;
}
@end
