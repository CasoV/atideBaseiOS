//
//  AttenDanceViewController.m
//  ycxm
//
//  Created by 高小伟 on 2020/6/9.
//  Copyright © 2020 末末班车. All rights reserved.
//

#import "AttenDanceViewController.h"
#import "YWExcelView.h"
#import "AttenTimeModel.h"
#import "AttenanceDayModel.h"
#import "AttenCollectionCell.h"
#import "UIImageView+WebCache.h"
#import "PYPhotoBrowseView.h"
#import "RecordingAttenViewController.h"
#import "NSDate+Timestamp.h"
#import "NSDate-Utilities.h"

#import <AMapFoundationKit/AMapFoundationKit.h>
#import <AMapLocationKit/AMapLocationKit.h>

@interface AttenDanceViewController ()<AMapLocationManagerDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,YWExcelViewDataSource,YWExcelViewDelegate,UICollectionViewDelegate,UICollectionViewDataSource>

typedef NS_ENUM(NSUInteger, chooseType) {
    nomal = 1,
    photo = 2,
    face = 3,
    finger = 4
};

@property (weak, nonatomic) IBOutlet UIView *footLineView;
@property (weak, nonatomic) IBOutlet UILabel *leftTitleLb;
@property (weak, nonatomic) IBOutlet UILabel *rightTitleLb;
@property (weak, nonatomic) IBOutlet UIButton *punchBtn;
@property (weak, nonatomic) IBOutlet UILabel *timeLb;
@property (weak, nonatomic) IBOutlet UILabel *titleLb;
@property (weak, nonatomic) IBOutlet UILabel *localLb;
@property (weak, nonatomic) IBOutlet UIView *listView;
//
@property (strong, nonatomic)UIView *tagView;
@property (nonatomic, weak) NSTimer *timer;
@property (nonatomic,assign) chooseType type;
@property (nonatomic,assign) BOOL haveLocation;
@property (nonatomic, strong) AMapLocationManager *locationManager;
@property (nonatomic,copy) NSString *address;
@property (nonatomic,strong) CLLocation *location;
@property (nonatomic,strong) NSData *imgData;
@property (nonatomic,strong) YWExcelView *exceView;
@property (nonatomic,strong) NSMutableArray *dataArr;
@property (nonatomic,strong) NSMutableArray *typeSourceArr;
@property(nonatomic,strong) UICollectionView *collectionView;
@property (nonatomic, strong) AttenTimeModel *timeModel;
@property (nonatomic, copy) NSString *endTime;
@property (nonatomic, copy) NSString *tempTitle;

@end

@implementation AttenDanceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.footLineView addSubview:self.tagView];
    self.type = attendanceType;

    [AMapLocationManager updatePrivacyAgree:AMapPrivacyAgreeStatusDidAgree];
    [AMapLocationManager updatePrivacyShow:AMapPrivacyShowStatusDidShow privacyInfo:AMapPrivacyInfoStatusDidContain];
    [self dealTime];
    [self loadTimeModel];
    [self setupListView];
    [self loadData];
    [self dealTypeUI];
}
//获取打卡时间
- (void)loadTimeModel {
    [[HttpManager manager] get:[UrlConfig URL:kqTimeDesignGetname] param:@{
        @"userId": [UserInfo getInstance].ID,
        @"_": [self currentTimeStr]
    } success:^(NSData *data) {
        if ([ResponseUtils success:data]) {
            NSArray <AttenTimeModel *>*tempArr = [AttenTimeModel mj_objectArrayWithKeyValuesArray:[ResponseUtils getData:@"data"]];
            if (tempArr && tempArr.count > 0) {
                self.timeModel = tempArr.firstObject;
                self.endTime = self.timeModel.endTimen;
            }
        }
        if (!self.timeModel) {
            [self checkCurrentTime];
        }
    } faild:^(NSString *msg) {
    }];
}

- (BOOL)checkCurrentTime {
    return [self checkCurrentTime:YES];
}

- (BOOL)checkCurrentTime:(BOOL)hint {
    self.titleLb.text = @"打卡";
    return YES;
    if (self.timeModel == nil) {
        if (hint) {
            [MBManager showBriefAlert:@"未设置打卡时间点！"];
        }
        return NO;
    }

    NSDate *currentDate = [NSDate date];
    NSString *currentDay = [NSDate todayDateStringYYMMdd];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    if ([currentDate isLaterThanDate:[dateFormatter dateFromString:[NSString stringWithFormat:@"%@ %@:00", currentDay, self.timeModel.startTime]]] && [currentDate isEarlierThanDate:[dateFormatter dateFromString:[NSString stringWithFormat:@"%@ %@:59", currentDay, self.timeModel.startTimen]]]) {
        self.titleLb.text = @"上班打卡";
        return YES;
    }
    if ([currentDate isLaterThanDate:[dateFormatter dateFromString:[NSString stringWithFormat:@"%@ %@:00", currentDay, self.timeModel.endTime]]] && [currentDate isEarlierThanDate:[dateFormatter dateFromString:[NSString stringWithFormat:@"%@ %@:59", currentDay, self.timeModel.endTimen]]]) {
        self.titleLb.text = @"下班打卡";
        return YES;
    }
    self.titleLb.text = self.tempTitle;
    if (hint) {
        [MBManager showBriefAlert:@"不在打卡时间范围内！"];
    }
    return NO;
}

//按类型加载UI
-(void)dealTypeUI{
    NSArray *nomalImgArr = @[@"icon_normal_punch_default",@"icon_photograph_punch_default",@"icon_faceid_punch_default",@"icon_fingerprint_punch_default"];
    NSArray *titleArr = @[@"手机打卡",@"拍照打卡",@"人脸识别",@"指纹打卡"];
    self.titleLb.text = titleArr[self.type - 1];
    self.tempTitle = titleArr[self.type - 1];
    [self.punchBtn setImage:[UIImage imageNamed:nomalImgArr[self.type - 1]] forState:UIControlStateNormal];
    [self.locationManager startUpdatingLocation];

    _exceView.hidden= self.type == photo;
    _collectionView.hidden = !_exceView.hidden;
    [self flitterData];
}

-(void)loadData{
    NSDate *currentDate = [NSDate date];
    NSDateFormatter *dataFormatter = [[NSDateFormatter alloc]init];
    [dataFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *dateString = [dataFormatter stringFromDate:currentDate];
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

            if(model.type.intValue == 2){
                [self loadImgUrl:model];
            }
        }
        [self flitterData];
    } faild:^(NSString *msg) {

    }];
}

-(void)loadImgUrl:(AttenanceDayModel *)model{
    [[HttpManager manager] get:[UrlConfig URL:searchFiles] param:@{@"metaData.formId":model.id} success:^(NSData *data) {
        NSArray *arr = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        if(arr && arr.count > 0){
            NSDictionary *fileInfo = arr[0];
            model.imgUrl = [NSString stringWithFormat:@"%@/%@",  [UrlConfig URL:downloadFile],fileInfo[@"id"]];
            [self.collectionView reloadData];
        }

    } faild:^(NSString *msg) {
    }];
}

-(void)flitterData{
    self.typeSourceArr = [NSMutableArray array];
    for (AttenanceDayModel *model in self.dataArr) {
        if (model.type.intValue == self.type) {
            [self.typeSourceArr addObject:model];
        }
    }
    [self.exceView reloadData];
    [self.collectionView reloadData];
}
-(void)setupListView{
    YWExcelViewMode *mode = [YWExcelViewMode new];
    mode.style = YWExcelViewStyleheadScrollView;
    mode.defalutHeight = 40;
    //推荐使用这样初始化
    YWExcelView *exceView = [[YWExcelView alloc] initWithFrame:CGRectMake(10, 36, self.listView.frame.size.width - 20 , kScreen_Height-472 + 42) mode:mode];
    exceView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    exceView.dataSource = self;
    exceView.showBorder = YES;
    exceView.delegate = self;
    exceView.showBorderColor = [UIColor colorWithRed:228/255.0 green:228/255.0 blue:228/255.0 alpha:1.0];
    [_listView addSubview:exceView];
    _exceView = exceView;
    [_listView addSubview:self.collectionView];
    _collectionView.hidden = true;
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationItem.title = @"考勤管理";
    self.navigationController.navigationBar.hidden = NO;
    self.tabBarController.tabBar.hidden = YES;
    [self startLocation];
}
- (void)viewWillDisappear:(BOOL)animated{
    [self.locationManager stopUpdatingLocation];
}
//开始定位
- (void)startLocation {
    self.haveLocation = NO;
    if (!self.locationManager) {
        [self configLocationManager];
    }else{
         [self.locationManager startUpdatingLocation];
    }
}

- (void)configLocationManager {
    self.locationManager = [[AMapLocationManager alloc] init];
    [self.locationManager setDelegate:self];
    [self.locationManager setLocatingWithReGeocode:YES];
    [self.locationManager startUpdatingLocation];
}

-(void)dealTime{
    //实时时间
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1 repeats:YES block:^(NSTimer * _Nonnull timer) {
        NSDate *currentDate = [NSDate date];
        NSDateFormatter *dataFormatter = [[NSDateFormatter alloc]init];
        [dataFormatter setDateFormat:@"HH:mm:ss "];
        NSString *dateString = [dataFormatter stringFromDate:currentDate];
        self.timeLb.text = dateString;
    }];

    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSUInteger unitFlags = NSCalendarUnitHour|kCFCalendarUnitWeekday;
    NSArray *weekdays = [NSArray arrayWithObjects:@"周日", @"周一", @"周二", @"周三", @"周四", @"周五", @"周六", nil];
    NSDate *nowDate = [NSDate date];
    NSDateComponents *dateComponent = [calendar components:unitFlags fromDate:nowDate];
    NSInteger hour = [dateComponent hour];
    NSString *week = weekdays[ [dateComponent weekday] - 1];

    NSDate *currentDate = [NSDate date];
    NSDateFormatter *dataFormatter = [[NSDateFormatter alloc]init];
    [dataFormatter setDateFormat:@"MM月dd日 "];
    NSString *dateString = [dataFormatter stringFromDate:currentDate];
    NSString *username = [UserInfo getInstance].name;
    NSString *hintStr = @"";
    if (hour < 12) {
        hintStr = @"早上好";
    } else if (hour > 12 && hour <= 18) {
        hintStr = @"下午好";
    } else if (hour > 18) {
        hintStr = @"晚上好";
    } else {
        hintStr = @"中午好";
    }
    _leftTitleLb.text = [NSString stringWithFormat:@"%@，%@",hintStr,username];
    _rightTitleLb.text = [NSString stringWithFormat:@"%@ %@",dateString,week];
}
- (void)dealloc {
    [self.timer invalidate];
    self.timer = nil;
}
//考勤记录
- (IBAction)recordBtnClicked:(id)sender {
    RecordingAttenViewController *reVc = [[UIStoryboard storyboardWithName:@"RecordingAtten" bundle:nil]instantiateViewControllerWithIdentifier:@"RecordingAttenViewController"];
    reVc.endTime = self.endTime;
    [self.navigationController pushViewController:reVc animated:YES];
}

//切换类型
- (IBAction)btnTouch:(id)sender {
    for (int i = 100; i<104; i++) {
         UIButton *btn0 = [self.view viewWithTag:i];
        btn0.selected = NO;
    }
    UIButton *btn = (UIButton *)sender;
    btn.selected = YES;
    [UIView animateWithDuration:0.2 animations:^{
        self.tagView.frame = CGRectMake((btn.tag - 100) * kScreen_Width/4, 0, kScreen_Width/4, 2);
           }];
    NSArray *nomalImgArr = @[@"icon_normal_punch_default",@"icon_photograph_punch_default",@"icon_faceid_punch_default",@"icon_fingerprint_punch_default"];
    NSArray *titleArr = @[@"手机打卡",@"拍照打卡",@"人脸识别",@"指纹打卡"];
    self.titleLb.text = titleArr[btn.tag - 100];
    self.tempTitle = titleArr[btn.tag - 100];
    [self.punchBtn setImage:[UIImage imageNamed:nomalImgArr[btn.tag - 100]] forState:UIControlStateNormal];
    [self.locationManager startUpdatingLocation];
    switch (btn.tag) {
        case 100:
            self.type = nomal;
            break;
        case 101:
            self.type = photo;
            break;
        case 102:
            self.type = face;
            break;
        case 103:
            self.type = finger;
            break;
        default:
            break;
    }

    _exceView.hidden= self.type == photo;
    _collectionView.hidden = !_exceView.hidden;

    [self flitterData];
}
//打卡
- (IBAction)punch:(id)sender {
    if (![self checkCurrentTime]) {
        return;
    }

    if(self.type == nomal){
        [self kqUseSaveByType:nomal];
    }else if(self.type == photo){
        [self handlePhoto];
    }
}

//打卡请求
-(void)kqUseSaveByType:(int)type{
    if(!self.address){
        [MBManager showLoading:@"正在定位..."];
        return;
    }
    
    [[HttpManager manager]post:[UrlConfig URL:kqUseSave] param:@{
        @"projectId":[UserAgent DefaultAgent].projectId,
        @"sectionId":[UserAgent DefaultAgent].sectionId.length == 0 ? [UserAgent DefaultAgent].projectId : [UserAgent DefaultAgent].sectionId,
        @"userId": [UserInfo getInstance].ID,
        @"dress":self.address,
        @"xPoint":[NSString stringWithFormat:@"%f",self.location.coordinate.longitude],
        @"yPoint":[NSString stringWithFormat:@"%f",self.location.coordinate.latitude],
        @"type":[NSString stringWithFormat:@"%d",type]
    } success:^(NSData *data) {
        if ([ResponseUtils success:data]) {
            if(type == 2){
                NSDictionary *content = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                [self fileUpload:content[@"data"][@"id"]];
            }
            [MBManager showBriefAlert:@"打卡成功"];
            [self loadData];
        } else {
            [MBManager showBriefAlert:[ResponseUtils getMsg]];
        }
    } faild:^(NSString *msg) {
        [MBManager showBriefAlert:@"打卡失败"];
    }];
}
//上传图片
-(void)fileUpload:(NSString *)formId{
    NSDictionary *params = @{@"metaData.formId":formId};
    [[HttpManager manager] uploadTask:[UrlConfig URL:filesUpload] data:self.imgData name:@"file" fileName:[NSString stringWithFormat:@"%@.png",[self currentTimeStr]] mimeType:@"image/png" param:params callback:^(NSURLResponse *response, id data, NSError *error) {
        [MBManager hideAlert];
        if (error) {
        }
    }];
}
-(UIView *)tagView{
    if(!_tagView){
        _tagView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreen_Width/4, 2)];
        _tagView.backgroundColor = [UIColor colorWithRed:108/255.0 green:175/255.0 blue:225/255.0 alpha:1.0];
    }
    return _tagView;
}
#pragma MARK LoalManagerDelegate
- (void)amapLocationManager:(AMapLocationManager *)manager didUpdateLocation:(CLLocation *)location reGeocode:(AMapLocationReGeocode *)reGeocode
{
    if (reGeocode)
      {
          self.haveLocation = YES;
          self.localLb.text = [NSString stringWithFormat:@"当前位置：%@",reGeocode.formattedAddress];
          self.address =reGeocode.formattedAddress;
          self.location = location;
          if ([self checkCurrentTime:NO]) {
              NSArray *selectArr = @[@"icon_normal_punch",@"icon_photograph_punch",@"icon_faceid_punch",@"icon_fingerprint_punch"];
              [self.punchBtn setImage:[UIImage imageNamed:selectArr[self.type - 1]] forState:UIControlStateNormal];
          }
      }
}

- (void)handlePhoto {
    BOOL isCamera = [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear];
    if (!isCamera) {
        return;
    }
    
    BOOL isCameraF = [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceFront];
    
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    imagePicker.allowsEditing = YES;
    imagePicker.delegate = self;
    if (isCameraF) {
        imagePicker.cameraDevice = UIImagePickerControllerCameraDeviceFront;
    }
    [self presentViewController:imagePicker animated:YES completion:nil];
}

#pragma MARK - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    self.imgData = UIImageJPEGRepresentation(image, 0.1);
    [self kqUseSaveByType:photo];
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

//获取当前时间戳
- (NSString *)currentTimeStr{
    NSDate* date = [NSDate dateWithTimeIntervalSinceNow:0];//获取当前时间0秒后的时间
    NSTimeInterval time=[date timeIntervalSince1970]*1000;// *1000 是精确到毫秒，不乘就是精确到秒
    NSString *timeString = [NSString stringWithFormat:@"%.0f", time];
    return timeString;
}

#pragma MARK -YWExcelViewDataSource
- (NSArray *)widthForItemOnExcelView:(YWExcelView *)excelView{
    return @[@50,@90,@(kScreen_Width - 160)];
}
- (NSInteger)numberOfSectionsInExcelView:(YWExcelView *)excelView{
    return 1;
}
//多少行
- (NSInteger)excelView:(YWExcelView *)excelView numberOfRowsInSection:(NSInteger)section{
    return _typeSourceArr.count;
}
//多少列
- (NSInteger)itemOfRow:(YWExcelView *)excelView{
    return 3;
}
- (void)excelView:(YWExcelView *)excelView label:(UILabel *)label textAtIndexPath:(YWIndexPath *)indexPath{
    AttenanceDayModel *model = _typeSourceArr[indexPath.row];

    label.numberOfLines = 0;
    label.font = [UIFont systemFontOfSize:13];
    if (indexPath.row < self.typeSourceArr.count) {
        label.backgroundColor = [UIColor whiteColor];
        switch (indexPath.item) {
            case 0:
                label.text = [NSString stringWithFormat:@"%ld",(long)indexPath.row + 1];
                break;
            case 1:
                label.text = model.time;
                break;
            case 2:
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
            label.text = @"时间";
            break;
        case 2:
            label.text = @"地点";
            break;

        default:
            break;
    }
}
#pragma MARK-LazyLoad
- (UICollectionView *)collectionView {
    if (!_collectionView) {
        CGFloat itemWidth = (kScreen_Width - 25) / 3.0;
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.minimumLineSpacing = 0;
        flowLayout.minimumInteritemSpacing = 0;
        flowLayout.itemSize = CGSizeMake(itemWidth, 190);
        flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(10, 36, self.listView.frame.size.width - 20 , kScreen_Height-472) collectionViewLayout:flowLayout];
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.alwaysBounceVertical = YES;
        _collectionView.showsVerticalScrollIndicator = NO;
        [_collectionView registerNib:[UINib nibWithNibName:@"AttenCollectionCell" bundle:nil] forCellWithReuseIdentifier:@"AttenCollectionCell"];
    }
    return _collectionView;
}

#pragma mark - UICollectionViewDelegate, UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.typeSourceArr.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    AttenanceDayModel *model = _typeSourceArr[indexPath.row];
    AttenCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"AttenCollectionCell" forIndexPath:indexPath];
    [cell.iconImgView sd_setImageWithURL:[NSURL URLWithString:model.imgUrl]];
    cell.adressLb.text = model.dress;
    cell.timeLb.text = model.time;
    cell.iconImgView.contentMode = UIViewContentModeScaleAspectFill;        // 设置图片正常填充
    cell.iconImgView.clipsToBounds = NO; // 裁剪边缘
    cell.iconImgView.layer.cornerRadius = cell.iconImgView.frame.size.width/2;
    cell.iconImgView.layer.masksToBounds=true;
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    AttenCollectionCell *cell = (AttenCollectionCell *)[collectionView cellForItemAtIndexPath:indexPath];
    PYPhotoBrowseView *photoBroseView = [[PYPhotoBrowseView alloc] init];
    NSMutableArray <UIImage *>*imgs = [NSMutableArray array];
    if(!cell.iconImgView.image){
        return;
    }
    [imgs addObject:cell.iconImgView.image];
    NSInteger index = 0;
    photoBroseView.images = imgs;
    photoBroseView.currentIndex = index;
    photoBroseView.showFromView = [collectionView cellForItemAtIndexPath:indexPath];
    photoBroseView.hiddenToView = [collectionView cellForItemAtIndexPath:indexPath];
    [photoBroseView show];
}
@end
