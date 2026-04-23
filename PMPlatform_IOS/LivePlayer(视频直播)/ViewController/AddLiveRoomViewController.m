//
//  AddLiveRoomViewController.m
//  ycxm
//
//  Created by 高小伟 on 2021/7/15.
//  Copyright © 2021 末末班车. All rights reserved.
//

#import "AddLiveRoomViewController.h"

@interface AddLiveRoomViewController (){
    NSArray *times;
    UIDatePicker *datePicker;
    NSLocale *datelocale;
}
@property (weak, nonatomic) IBOutlet UITextField *subTitleTf;
@property (weak, nonatomic) IBOutlet UITextField *dateTf;
@property (weak, nonatomic) IBOutlet UIButton *continuedTimeBtn;

@end

@implementation AddLiveRoomViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    

    times = @[
        @"30分钟",@"1小时",@"2小时",@"3小时",@"5小时",@"10小时"];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm"];
    NSDate *datenow = [NSDate date];
    NSString *currentTimeString = [formatter stringFromDate:datenow];
    self.dateTf.text = currentTimeString;
    
    datePicker= [[UIDatePicker alloc]init];
    datePicker.preferredDatePickerStyle = UIDatePickerStyleWheels;
    datelocale = [[NSLocale alloc]initWithLocaleIdentifier:@"zh_zn"];//设置时区
    datePicker.locale = datelocale;
    datePicker.timeZone= [NSTimeZone timeZoneWithName:@"GMT"];
    datePicker.datePickerMode=UIDatePickerModeDateAndTime;
    _dateTf.inputView=datePicker;
    NSCalendar*calendar = [[NSCalendar alloc]initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents*components = [[NSDateComponents alloc]init];
    [components setYear:-100];
    [components setMonth:12];
    [components setDay:30];
    NSDate*minDate = [calendar dateByAddingComponents:components toDate:datenow options:0];
    datePicker.minimumDate= minDate;
    [datePicker addTarget:self action:@selector(selectDate:)forControlEvents:UIControlEventValueChanged];
    [self.continuedTimeBtn setTitle:@"1小时" forState:UIControlStateNormal];

    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"创建" style:UIBarButtonItemStylePlain target:self action:@selector(save)];
}
-(void)save{
    
       NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
       [formatter setDateStyle:NSDateFormatterMediumStyle];
       [formatter setTimeStyle:NSDateFormatterShortStyle];
       [formatter setDateFormat:@"YYYY-MM-dd HH:mm"];
       NSDate* dateTodo = [formatter dateFromString:_dateTf.text];
       NSNumber *beginTimestamp = [NSNumber numberWithLong:(long)[dateTodo timeIntervalSince1970]];

    
    NSInteger index = [times indexOfObject:_continuedTimeBtn.currentTitle];
    NSInteger time = 30;
    switch (index) {
        case 1:
            time = 60 * 1;
            break;
        case 2:
            time = 60 * 2;
            break;
        case 3:
            time = 60 * 3;
            break;
        case 4:
            time = 60 * 5;
            break;
        case 5:
            time = 60 * 10;
            break;
        default:
            time = 30;
            break;
    }
    
    if(!self.subTitleTf.text || self.subTitleTf.text.length <1){
        [SVProgressHUD showErrorWithStatus:@"请输入直播主题"];
        return;
    }
    NSDictionary *param =@{
        @"defaultTitle" :@"%@创建的直播间",
        @"failMsg" : @"创建直播间失败",
        @"maxOnStageCount":@(2),
        @"name" : @"安排课程",
        @"succeedMsg" : @"创建直播间成功",
        @"type" :@(5),
        @"subject":self.subTitleTf.text,
        @"beginTimestamp":beginTimestamp,
        @"duration": [NSNumber numberWithInteger:time]
    };
    [SVProgressHUD showWithStatus:@"创建中..."];
    [self.viewModel createMeetingWithData:param showHUD:YES success:^(NSString * _Nonnull message) {
       
        [SVProgressHUD showSuccessWithStatus:@"创建成功"];
        [self.navigationController popViewControllerAnimated:YES];
    } failure:^(NSError * _Nonnull error) {
        NSString *message = error.userInfo[@"message"];
        [SVProgressHUD showErrorWithStatus:message];
        if (error.code == 4000007) {
            return;
        }
      
    }];
    
    
}
-(void)selectDate:(UIDatePicker *)datePicker

{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"YYYY-MM-dd HH:mm"];
    [dateFormatter setLocale:datelocale];
    NSDate *date = [datePicker date];
    NSString *str = [NSString stringWithFormat:@"%@",date];
    self.dateTf.text = [str substringToIndex:16];
    
}
- (IBAction)chooseTime:(id)sender {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"请选择持续时长" preferredStyle:UIAlertControllerStyleActionSheet];
    
    for (NSString *time in times) {
        [alertController addAction:[UIAlertAction actionWithTitle:time style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self.continuedTimeBtn setTitle:time forState:UIControlStateNormal];
        }]];
    }
    [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }]];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

-(void)viewWillAppear:(BOOL)animated{
    self.navigationItem.title = @"创建直播间";
}

@end
