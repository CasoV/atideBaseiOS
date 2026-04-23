//
//  NewModelInfoController.m
//  HBConstructionApp
//
//  Created by 末末班车 on 2018/5/23.
//  Copyright © 2018年 atide. All rights reserved.
//

#import "NewModelInfoController.h"
#import "UIImage+Additions.h"
#import "UnderlineButton.h"
#import "FDCalendarView.h"
#import "ModelInfoModel.h"
#import "FilesScanView.h"
#import "ApiUpload.h"
#import <YTKNetwork/YTKNetwork.h>

@interface NewModelInfoController ()

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentHeight;

@property (weak, nonatomic) IBOutlet UIView *contentView;

@property (weak, nonatomic) IBOutlet UIButton *startBtn;
@property (weak, nonatomic) IBOutlet UIButton *endBtn;
@property (weak, nonatomic) IBOutlet UITextField *placeTF;
@property (weak, nonatomic) IBOutlet UITextView *remarksTV;
@property (weak, nonatomic) IBOutlet UIButton *voiceBtn;

@property (weak, nonatomic) IBOutlet UnderlineButton *annexBtn;

@property (weak, nonatomic) IBOutlet UIView *bottomHeaderView;

@property (nonatomic, strong) FilesScanView *annexFV;

@end

@implementation NewModelInfoController {
    YTKBatchRequest *_batchRequest;
    CGFloat _midHeight1;
    CGFloat _midHeight2;
    
    ModelInfoModel *_model;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.contentView addSubview:self.annexFV];
    [self.annexFV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(5);
        make.right.equalTo(self.contentView).offset(-5);
        make.top.equalTo(self.bottomHeaderView.mas_bottom).offset(5);
        make.bottom.equalTo(self.contentView);
    }];
    
    [self.annexBtn setImage:[UIImage imageWithColor:UIColorFromRGB(0x0096FF)] forState:UIControlStateSelected];
    [self setDefaultData];
    
    if (self.canEdit) {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(save)];
    }
    
    self.startBtn.userInteractionEnabled = self.canEdit;
    self.endBtn.userInteractionEnabled = self.canEdit;
    self.placeTF.userInteractionEnabled = self.canEdit;
    
    self.remarksTV.editable = self.canEdit;
    
    self.voiceBtn.hidden = !self.canEdit;
}

- (void)dealloc {
    [_batchRequest stop];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationItem.title = @"施工工艺模型";
}

#pragma mark - 懒加载
- (FilesScanView *)annexFV {
    if (!_annexFV) {
        __weak typeof(self) weakSelf = self;
        _annexFV = [[FilesScanView alloc] initWithFrame:CGRectMake(0, 0, self.bottomHeaderView.frame.size.width, 70) isHandle:self.canEdit];
        _annexFV.fileType = self.pid;
        _annexFV.partCode = self.partCode;
        _annexFV.isUserXY = self.isUserXY;
        _annexFV.block = ^(CGFloat oldHeight, CGFloat newHeight) {
            weakSelf.contentHeight.constant -= oldHeight;
            weakSelf.contentHeight.constant += newHeight;
        };
    }
    return _annexFV;
}

#pragma mark - 初始化界面
- (void)setDefaultData {
    _midHeight1 = 100;
    _midHeight2 = 70;
    
    [self requestData];
    self.annexFV.markId = self.modelId;
    [self.annexFV updateData];
}

#pragma mark - 初始化时间
- (void)setDefaultDate:(NSDate *)date button:(UIButton *)btn{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.locale = [NSLocale currentLocale];
    formatter.timeZone = [NSTimeZone localTimeZone];
    formatter.dateFormat = @"yyyy-MM-dd HH:mm";
    [btn setTitle:[formatter stringFromDate:date] forState:UIControlStateNormal];
}

- (void)textViewDidBeginEditing:(UITextView *)textView {
    if ([textView.text isEqualToString:@"请输入说明"]) {
        textView.text = @"";
    }
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    if ([textView.text isEqualToString:@""]) {
        textView.text = @"请输入说明";
    }
}

#pragma mark - 网络请求
- (void)requestData {
    __weak typeof(self) weakSelf = self;
    NSDictionary *params = @{
                             @"modelId":self.modelId,
                             @"pid":self.pid,
                             };
    [SVProgressHUD showWithStatus:@"加载中..."];
    [[HttpManager manager] post:[UrlConfig URL:constructRegisterSingleContent] param:params success:^(NSData *data) {
        [SVProgressHUD dismiss];
        if ([ResponseUtils success:data]) {
            self->_model = [ModelInfoModel mj_objectWithKeyValues:[ResponseUtils getData:@"data"]];
            if (self->_model) {
                if (self->_model.startTime) {
                    [weakSelf setDefaultDate:[NSDate dateWithTimeIntervalSince1970:self->_model.startTime / 1000.0] button:weakSelf.startBtn];
                }
                if (self->_model.endTime) {
                    [weakSelf setDefaultDate:[NSDate dateWithTimeIntervalSince1970:self->_model.endTime / 1000.0] button:weakSelf.endBtn];
                }
                weakSelf.placeTF.text = self->_model.place;
                if (self->_model.remarks) {
                    weakSelf.remarksTV.text = self->_model.remarks;
                }
            }
        } else {
            [SVProgressHUD showErrorWithStatus:[ResponseUtils getMsg]];
            [weakSelf.navigationItem.rightBarButtonItem setEnabled:NO];
        }
    } faild:^(NSString *msg) {
        [SVProgressHUD showErrorWithStatus:msg];
        [weakSelf.navigationItem.rightBarButtonItem setEnabled:NO];
    }];
}

#pragma mark - 点击事件
- (IBAction)voiceBtnClicked:(UIButton *)sender {
    for (UIView *view in sender.superview.subviews) {
        if ([view isKindOfClass:[UITextView class]]) {
            self.textView = (UITextView *)view;
//            [self.iflyHelper speech];
            break;
        }
    }
}

- (IBAction)chooseBtnClicked:(UIButton *)sender {
    if (sender == self.startBtn) {
        [self showDate:sender minDate:nil];
    } else {
        if ([self.startBtn.currentTitle isEqualToString:@""] || [self.startBtn.currentTitle isEqualToString:@"请选择开始时间"]) {
            [SVProgressHUD showInfoWithStatus:@"请先选择开始时间"];
            return;
        }
        [self showDate:sender minDate:self.startBtn.currentTitle];
    }
}

- (void)save {
    __weak typeof(self) weakSelf = self;
    [SVProgressHUD showWithStatus:@"请求中..."];
    [[HttpManager manager] post:[UrlConfig URL:saveConstructRegisterModelContent] param:[self params] success:^(NSData *data) {
        if ([ResponseUtils success:data]) {
            [weakSelf saveFiles:weakSelf.modelId];
        }
    } faild:^(NSString *msg) {
        [SVProgressHUD showErrorWithStatus:msg];
    }];
}

- (NSDictionary *)params {
    
    NSString *startStr = [self.startBtn.currentTitle isEqualToString:@"请选择开始时间"] ? @"" : self.startBtn.currentTitle;
    NSString *endStr = [self.endBtn.currentTitle isEqualToString:@"请选择结束时间"] ? @"" : self.endBtn.currentTitle;
    NSString *remarks = [self.remarksTV.text isEqualToString:@"请输入说明"] ? @"" : self.remarksTV.text;
    
    return @{
             @"pid":self.pid,
             @"modelId":self.modelId,
             @"place":self.placeTF.text,
             @"remarks":remarks,
             @"id":_model.id ? _model.id : @"",
             @"startStr":startStr,
             @"endStr":endStr,
             };
}

#pragma mark - 保存文件
- (void)saveFiles:(NSString *)markId {
    NSMutableArray <BIMFile *>*files = [NSMutableArray array];
    [files addObjectsFromArray:[self.annexFV addFiles]];
    if (files.count == 0) {
        [SVProgressHUD dismiss];
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        if (_batchRequest) {
            [_batchRequest stop];
        }
        
        __weak typeof(self) weakSelf = self;
        NSMutableArray <YTKRequest *>*requests = [NSMutableArray array];
        for (BIMFile *file in files) {
            NSDictionary *params = @{
                                     @"file.metaData.fileType":self.pid,
                                     @"file.metaData.formId":markId,
                                     };
            
            ApiUpload *api = [[ApiUpload alloc] initWithFile:file params:params];
            api.url = zuulBatchUpload;
            [requests addObject:api];
        }
        
        _batchRequest = [[YTKBatchRequest alloc] initWithRequestArray:requests];
        [_batchRequest startWithCompletionBlockWithSuccess:^(YTKBatchRequest * _Nonnull batchRequest) {
            [SVProgressHUD dismiss];
            [weakSelf.navigationController popViewControllerAnimated:YES];
        } failure:^(YTKBatchRequest * _Nonnull batchRequest) {
            [SVProgressHUD dismiss];
            [weakSelf.navigationController popViewControllerAnimated:YES];
        }];
    }
}

#pragma mark - 显示日期选择器
- (void)showDate:(UIButton *)textUI minDate:(NSString *)minDate {
    NSDate *minimumDate = nil;
    if (minDate) {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.locale = [NSLocale currentLocale];
        formatter.timeZone = [NSTimeZone localTimeZone];
        formatter.dateFormat = @"yyyy-MM-dd HH:mm";
        minimumDate = [formatter dateFromString:minDate];
    }
    
    NSString *dateStr = [textUI currentTitle];
    
    if ([dateStr isEqualToString:@""] || [dateStr isEqualToString:@"请选择开始时间"] || [dateStr isEqualToString:@"请选择结束时间"]) {
        dateStr = nil;
    }
    
    FDCalendarView *calendarView = [[FDCalendarView alloc] initWithFrame:[UIScreen mainScreen].bounds andCurrentDateStr:dateStr minimumDate:minimumDate datePickerMode:UIDatePickerModeDateAndTime];
    [[UIApplication sharedApplication].keyWindow addSubview:calendarView];
    calendarView.block = ^(NSDate *date) {
        if (date){
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            formatter.locale = [NSLocale currentLocale];
            formatter.timeZone = [NSTimeZone localTimeZone];
            formatter.dateFormat = @"yyyy-MM-dd HH:mm";
            [textUI setTitle:[formatter stringFromDate:date] forState:UIControlStateNormal];
            if (textUI == self.startBtn) {
                [self.endBtn setTitle:@"请选择结束时间" forState:UIControlStateNormal];
            }
        }
    };
    [calendarView fadeIn];
}

@end
