//
//  QualityInspectionView.m
//  ycxm
//
//  Created by 末末班车 on 2018/9/20.
//  Copyright © 2018年 末末班车. All rights reserved.
//

#import "QualityInspectionView.h"
//#import "NewChoosePersonController.h"
#import "UIImage+Additions.h"
#import "UnderlineButton.h"
#import "FDCalendarView.h"
#import "STPickerSingle.h"

@interface QualityInspectionView ()<UITextViewDelegate, STPickerSingleDelegate>

@property (weak, nonatomic) IBOutlet UITextField *nameTF;
@property (weak, nonatomic) IBOutlet UITextField *partNameTF;
@property (weak, nonatomic) IBOutlet UITextView *describeTV;
@property (weak, nonatomic) IBOutlet UITextView *measureTV;
@property (weak, nonatomic) IBOutlet UIButton *levelBtn;
@property (weak, nonatomic) IBOutlet UIButton *reformUserBtn;
@property (weak, nonatomic) IBOutlet UIButton *limitDateBtn;

//@property (weak, nonatomic) IBOutlet UISwitch *isReform;

@property (weak, nonatomic) IBOutlet UIButton *describeBtn;
@property (weak, nonatomic) IBOutlet UIButton *measureBtn;

@property (weak, nonatomic) IBOutlet UnderlineButton *annexBtn;

@property (nonatomic, copy) NSArray <NSString *>*levelArray;

@end

@implementation QualityInspectionView {
    NSString *_reformUser;
    NSString *_level;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
//    self.isReform.transform = CGAffineTransformMakeScale(0.8, 0.8);
    self.describeTV.delegate = self;
    self.measureTV.delegate = self;
    
    [self.annexBtn setImage:[UIImage imageWithColor:UIColorFromRGB(0x0096FF)] forState:UIControlStateSelected];
    
    [self addSubview:self.imagesView];
    [self.imagesView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(5);
        make.right.equalTo(self).offset(-5);
        make.top.equalTo(self).offset(460);
        make.bottom.equalTo(self);
    }];
}

- (void)setResourceTitle:(NSString *)resourceTitle {
    _resourceTitle = resourceTitle;
    
    if (_resourceTitle) {
        if ([resourceTitle isEqualToString:@"安全隐患"] || [resourceTitle isEqualToString:@"环保问题整改"] || [resourceTitle isEqualToString:@"水保巡查整改"]) {
            [self.imagesView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self).offset(5);
                make.right.equalTo(self).offset(-5);
                make.top.equalTo(self).offset(425);
                make.bottom.equalTo(self);
            }];
        } else {
            [self.imagesView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self).offset(5);
                make.right.equalTo(self).offset(-5);
                make.top.equalTo(self).offset(460);
                make.bottom.equalTo(self);
            }];
        }
    }
}

- (NewFileScanView *)imagesView {
    if (!_imagesView) {
        _imagesView = [[NewFileScanView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, 70) type:FileScanTypeImage];
    }
    return _imagesView;
}

- (void)setModel:(QualityInspectionModel *)model {
    if (model) {
        self.nameTF.text = model.name;
        self.partNameTF.text = model.partName;
        _level = model.level;
        if ([model.level integerValue] > 0 && [model.level integerValue] <= self.levelArray.count) {
            [self.levelBtn setTitle:self.levelArray[[model.level integerValue] - 1] forState:UIControlStateNormal];
        }
        
//        self.isReform.on = [model.isReform isEqualToString:@"1"];
        [self.reformUserBtn setTitle:model.reformUserName forState:UIControlStateNormal];
        _reformUser = model.reformUser;
        
        if (model.limitDate) {
            [self.limitDateBtn setTitle:model.limitDate forState:UIControlStateNormal];
        }
        if(model.createTime){
            [self.rwcordingTimeBtn setTitle:model.limitDate forState:UIControlStateNormal];
        }
        if (model.describe) {
            self.describeTV.text = model.describe;
        }
        if (model.measure && ![model.measure isEqualToString:@""]) {
            self.measureTV.text = model.measure;
        }
    }
}

- (void)setCanEdit:(BOOL)canEdit {
    self.nameTF.userInteractionEnabled = canEdit;
    self.partNameTF.userInteractionEnabled = canEdit;
    
    self.levelBtn.userInteractionEnabled = canEdit;
    self.reformUserBtn.userInteractionEnabled = canEdit;
    self.limitDateBtn.userInteractionEnabled = canEdit;
    
    self.rwcordingTimeBtn.userInteractionEnabled = canEdit;
    
//    self.isReform.userInteractionEnabled = canEdit;
    
    self.describeTV.editable = canEdit;
    self.measureTV.editable = canEdit;
    
    self.describeBtn.hidden = !canEdit;
    self.measureBtn.hidden = !canEdit;
    
    self.imagesView.isHandle = canEdit;
    [self.imagesView updateData];
}

- (NSArray<NSString *> *)levelArray {
    if (!_levelArray) {
        _levelArray = @[@"一般", @"较大", @"重大", @"特大"];
    }
    return _levelArray;
}

#pragma mark - UITextViewDelegate
- (void)textViewDidBeginEditing:(UITextView *)textView {
    NSString *str;
    if (textView == self.describeTV) {
        str = @"请输入问题描述";
    } else {
        str = @"请输入整改建议";
    }
    if ([textView.text isEqualToString:str]) {
        textView.text = @"";
    }
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    NSString *str;
    if (textView == self.describeTV) {
        str = @"请输入问题描述";
    } else {
        str = @"请输入整改建议";
    }
    if ([textView.text isEqualToString:@""]) {
        textView.text = str;
    }
}

#pragma mark - 点击事件
- (IBAction)voiceBtnClicked:(UIButton *)sender {
    if (self.voiceClicked) {
        self.voiceClicked(sender);
    }
}
- (IBAction)rwcordingTimeClick:(id)sender {
    [self showDate:sender];
}

- (IBAction)btnClicked:(UIButton *)sender {
    if (sender == self.levelBtn) {
        [self showTypePicker];
    } else if (sender == self.reformUserBtn) {
//        NewChoosePersonController *vc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"NewChoosePerson"];
//        if (_reformUser) {
//            vc.userIds = [NSMutableArray arrayWithObject:_reformUser];
//        }
//        vc.block = ^(PersonModel * _Nonnull person) {
//            if (person) {
//                [sender setTitle:person.name forState:UIControlStateNormal];
//                self->_reformUser = person.userId;
//            } else {
//                [sender setTitle:@"请选择整改负责人" forState:UIControlStateNormal];
//                self->_reformUser = nil;
//            }
//        };
//        [[self findViewController].navigationController pushViewController:vc animated:YES];
    } else if (sender == self.limitDateBtn) {
        [self showDate:sender];
    }
}

#pragma mark - 显示日期选择器
- (void)showDate:(UIButton *)textUI {
    NSString *dateStr = [textUI currentTitle];
    
    if ([dateStr isEqualToString:@""] || [dateStr isEqualToString:@"请选择整改完成期限"]) {
        dateStr = nil;
    }
    
    FDCalendarView *calendarView = [[FDCalendarView alloc] initWithFrame:[UIScreen mainScreen].bounds andCurrentDateStr:dateStr minimumDate:nil datePickerMode:UIDatePickerModeDate];
    [[UIApplication sharedApplication].keyWindow addSubview:calendarView];
    calendarView.block = ^(NSDate *date) {
        if (date){
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            formatter.locale = [NSLocale currentLocale];
            formatter.timeZone = [NSTimeZone localTimeZone];
            formatter.dateFormat = @"yyyy-MM-dd";
            [textUI setTitle:[formatter stringFromDate:date] forState:UIControlStateNormal];
        }
    };
    [calendarView fadeIn];
}

#pragma mark - 选择级别
- (void)showTypePicker {
    STPickerSingle *pickerSingle = [[STPickerSingle alloc]init];
    [pickerSingle setArrayData:[self.levelArray copy]];
    [pickerSingle setTitle:@"请选择级别"];
    [pickerSingle setDelegate:self];
    pickerSingle.contentMode = STPickerContentModeCenter;
    [pickerSingle show];
}

#pragma mark - STPickerSingleDelegate
- (void)pickerSingle:(STPickerSingle *)pickerSingle selectedTitle:(NSString *)selectedTitle {
    [self.levelBtn setTitle:selectedTitle forState:UIControlStateNormal];
    _level = [NSString stringWithFormat:@"%ld", [self.levelArray indexOfObject:selectedTitle] + 1];
}

#pragma mark - 获取数据
- (NSDictionary *)params {
    if ([self FD_validate]) {
        NSString *measure = [self.measureTV.text isEqualToString:@"请输入整改建议"] ? @"" : self.measureTV.text;

        //                 @"isReform":self.isReform.isOn ? @"1" : @"0",
        return @{
                 @"name":self.nameTF.text,
                 @"partName":self.partNameTF.text,
                 @"level":_level,
                 @"reformUser":_reformUser,
                 @"reformUserName":self.reformUserBtn.currentTitle,
                 @"limitDate":self.limitDateBtn.currentTitle,
                 @"describe":self.describeTV.text,
                 @"measure":measure,
                 @"createTime":self.limitDateBtn.currentTitle,
                 };
    }
    
    return nil;
}

#pragma mark - 数据验证
- (BOOL)FD_validate {
    if ([self.nameTF.text isEqualToString:@""] && self.partViewTop.constant > 5) {
        [SVProgressHUD showInfoWithStatus:self.nameTF.placeholder];
        return NO;
    }
    if ([self.partNameTF.text isEqualToString:@""]) {
        [SVProgressHUD showInfoWithStatus:self.partNameTF.placeholder];
        return NO;
    }
    if ([self.levelBtn.currentTitle isEqualToString:@"请选择级别"]) {
        [SVProgressHUD showInfoWithStatus:@"请选择级别"];
        return NO;
    }
    if ([self.reformUserBtn.currentTitle isEqualToString:@"请选择整改负责人"]) {
        [SVProgressHUD showInfoWithStatus:@"请选择整改负责人"];
        return NO;
    }
    if ([self.limitDateBtn.currentTitle isEqualToString:@"请选择整改完成期限"]) {
        [SVProgressHUD showInfoWithStatus:@"请选择整改完成期限"];
        return NO;
    }
    if ([self.describeTV.text isEqualToString:@""] || [self.describeTV.text isEqualToString:@"请输入问题描述"]) {
        [SVProgressHUD showInfoWithStatus:@"请输入问题描述"];
        return NO;
    }
    
    return YES;
}

@end
