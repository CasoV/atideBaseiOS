//
//  SupervisionPunishmentDetailController.m
//  ycxm
//
//  Created by 末末班车 on 2020/3/19.
//  Copyright © 2020 末末班车. All rights reserved.
//

#import "SupervisionPunishmentDetailController.h"
//#import "ChoosePersonController.h"
#import "SPItemTreeController.h"
#import "STPickerSingle.h"
#import "FDCalendarView.h"
#import "EnumModel.h"
#import "PartModel.h"

@interface SupervisionPunishmentDetailController ()<STPickerSingleDelegate>

@property (weak, nonatomic) IBOutlet UITextField *tfSectName;
@property (weak, nonatomic) IBOutlet UITextField *tfCode;
@property (weak, nonatomic) IBOutlet UITextField *tfPosition;
@property (weak, nonatomic) IBOutlet UITextField *tfWork;
@property (weak, nonatomic) IBOutlet UITextField *tfReason;
@property (weak, nonatomic) IBOutlet UITextField *tfScore;
@property (weak, nonatomic) IBOutlet UITextField *tfFine;

@property (weak, nonatomic) IBOutlet UIButton *btnUser;
@property (weak, nonatomic) IBOutlet UIButton *btnRule;
@property (weak, nonatomic) IBOutlet UIButton *btnItem;
@property (weak, nonatomic) IBOutlet UIButton *btnRegisterDate;
@property (weak, nonatomic) IBOutlet UIButton *voiceBtn;

@property (weak, nonatomic) IBOutlet UITextView *tvMemo;

@property (nonatomic, copy) NSArray <EnumModel *>*rules;
@property (nonatomic, strong) NSMutableArray <NSString *>*ruleTitles;

@property (nonatomic, copy) NSString *dictId;
@property (nonatomic, copy) NSString *userId;
@property (nonatomic, copy) NSString *ruleId;
@property (nonatomic, copy) NSString *itemId;

@end

@implementation SupervisionPunishmentDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.tfSectName.text = [UserAgent DefaultAgent].sectionName;
    self.line.hidden = YES;
    
    [self reqDictId];
}

- (void)setModel:(SupervisionPunishmentModel *)model {
    _model = model;
    
    if (_model) {
        self.tfCode.text = _model.code;
        self.tfPosition.text = _model.position;
        self.tfWork.text = _model.work;
        self.tfReason.text = _model.reason;
        self.tfScore.text = [NSString stringWithFormat:@"%ld", _model.score];
        self.tfFine.text = [NSString stringWithFormat:@"%ld", _model.fine];;
        
        self.userId = _model.userId;
        [self.btnUser setTitle:_model.userName forState:UIControlStateNormal];
        self.ruleId = _model.ruleId;
        [self.btnRule setTitle:_model.ruleName forState:UIControlStateNormal];
        self.itemId = _model.itemId;
        [self.btnItem setTitle:_model.itemName forState:UIControlStateNormal];
        [self.btnRegisterDate setTitle:_model.registerDate forState:UIControlStateNormal];
        
        if (_model.memo) {
            self.tvMemo.text = _model.memo;
        }
    }
}

#pragma mark - 懒加载
- (NSArray<EnumModel *> *)rules {
    if (!_rules) {
        _rules = [NSArray array];
    }
    return _rules;
}

- (NSMutableArray<NSString *> *)ruleTitles {
    if (!_ruleTitles) {
        _ruleTitles = [NSMutableArray array];
        for (EnumModel *item in self.rules) {
            [_ruleTitles addObject:item.name];
        }
    }
    return _ruleTitles;
}

#pragma mark - 请求DictId
- (void)reqDictId {
//    [SVProgressHUD showWithStatus:nil];
//    __weak typeof(self) weakSelf = self;
//    [[HttpManager manager] post:[UrlConfig URL:getCategoryList] param:@{@"value":@"pm_rule"} success:^(NSData *data) {
//        if ([ResponseUtils success:data]) {
//            NSArray <EnumModel *>*datas = [EnumModel mj_objectArrayWithKeyValuesArray:[ResponseUtils getData:@"data"]];
//            for (EnumModel *item in datas) {
//                if ([item.key isEqualToString:weakSelf.bizKey]) {
//                    weakSelf.dictId = item.id;
//                    [weakSelf reqRules];
//                    break;
//                }
//            }
//        } else {
//            [SVProgressHUD showErrorWithStatus:[ResponseUtils getMsg]];
//        }
//    } faild:^(NSString *msg) {
//        [SVProgressHUD showErrorWithStatus:msg];
//    }];
}

#pragma mark - 请求管理办法
- (void)reqRules {
    [SVProgressHUD showWithStatus:nil];
    __weak typeof(self) weakSelf = self;
    NSDictionary *params = @{
        @"dictId": self.dictId,
        @"data": @"1"
    };
    [[HttpManager manager] get:[UrlConfig URL:qualityRule] param:params success:^(NSData *data) {
        if ([ResponseUtils success:data]) {
            [SVProgressHUD dismiss];
            weakSelf.rules = [EnumModel mj_objectArrayWithKeyValuesArray:[ResponseUtils getData:@"data"]];
        } else {
            [SVProgressHUD showErrorWithStatus:[ResponseUtils getMsg]];
        }
    } faild:^(NSString *msg) {
        [SVProgressHUD showErrorWithStatus:msg];
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

- (IBAction)chooseUser:(UIButton *)sender {
//    __weak typeof(self) weakSelf = self;
//    ChoosePersonController *vc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"choosePerson"];
//    vc.useGet = YES;
//    vc.url = qualityRecordUser;
//    vc.key = @"jianli_";
//    vc.block = ^(PersonModel *person) {
//        [sender setTitle:person.userName forState:UIControlStateNormal];
//        weakSelf.userId = person.userId;
//    };
//    if (self.pushBlock) {
//        self.pushBlock();
//    }
//    [self.navigationController pushViewController:vc animated:YES];
    
}
- (IBAction)chooseRule:(id)sender {
    [self showRulesPicker];
}
- (IBAction)chooseItem:(UIButton *)sender {
    if (!self.ruleId || [self.ruleId isEqualToString:@""]) {
        [SVProgressHUD showInfoWithStatus:@"请先选择管理办法!"];
        return;
    }
    
    __weak typeof(self) weakSelf = self;
    SPItemTreeController *vc = [[SPItemTreeController alloc] init];
    vc.ruleId = self.ruleId;
    vc.callBack = ^(PartModel * _Nonnull item) {
        weakSelf.itemId = item.id;
        [sender setTitle:item.text forState:UIControlStateNormal];
        weakSelf.tfReason.text = item.text;
    
        NSString *score = item.otherInfo[@"score"] ? item.otherInfo[@"score"] : @"";
        NSString *fine = item.otherInfo[@"fine"] ? item.otherInfo[@"fine"] : @"";
        weakSelf.tfScore.text = score;
        weakSelf.tfFine.text = fine;
    };
    
    if (self.pushBlock) {
        self.pushBlock();
    }
    
    [self.navigationController pushViewController:vc animated:YES];
}
- (IBAction)chooseDate:(UIButton *)sender {
    [self showDate:sender];
}

#pragma mark - UITextViewDelegate
- (void)textViewDidBeginEditing:(UITextView *)textView {
    if ([textView.text isEqualToString:@"请输入备注"]) {
        textView.text = @"";
    }
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    if ([textView.text isEqualToString:@""]) {
        textView.text = @"请输入备注";
    }
}

- (void)setCanEdit:(BOOL)canEdit {
    _canEdit = canEdit;

    self.tfCode.userInteractionEnabled = canEdit;
    self.tfPosition.userInteractionEnabled = canEdit;
    self.tfWork.userInteractionEnabled = canEdit;
    self.tfReason.userInteractionEnabled = canEdit;
    self.tfScore.userInteractionEnabled = canEdit;
    self.tfFine.userInteractionEnabled = canEdit;
    self.btnUser.userInteractionEnabled = canEdit;
    self.btnRule.userInteractionEnabled = canEdit;
    self.btnItem.userInteractionEnabled = canEdit;
    self.btnRegisterDate.userInteractionEnabled = canEdit;

    self.tvMemo.editable = canEdit;
    
    self.voiceBtn.hidden = !canEdit;
}

#pragma mark - 验证数据
- (BOOL)verify {
    if (!self.userId || [self.userId isEqualToString:@""]) {
        [SVProgressHUD showErrorWithStatus:@"请选择人员!"];
        return NO;
    } else if (!self.ruleId || [self.ruleId isEqualToString:@""]) {
        [SVProgressHUD showErrorWithStatus:@"请选择管理办法!"];
        return NO;
    } else if (!self.itemId || [self.itemId isEqualToString:@""]) {
        [SVProgressHUD showErrorWithStatus:@"请选择规定条款!"];
        return NO;
    } else if ([self.tfWork.text isEqualToString:@""]) {
        [SVProgressHUD showErrorWithStatus:self.tfWork.placeholder];
        return NO;
    } else if ([self.tfReason.text isEqualToString:@""]) {
        [SVProgressHUD showErrorWithStatus:self.tfReason.placeholder];
        return NO;
    } else if ([self.tfPosition.text isEqualToString:@""]) {
        [SVProgressHUD showErrorWithStatus:self.tfPosition.placeholder];
        return NO;
    } else if ([[self.btnRegisterDate currentTitle] isEqualToString:@"请选择日期"]) {
        [SVProgressHUD showErrorWithStatus:@"请选择日期"];
        return NO;
    } else if ([self.tfFine.text isEqualToString:@""]) {
        [SVProgressHUD showErrorWithStatus:self.tfFine.placeholder];
        return NO;
    } else if ([self.tfScore.text isEqualToString:@""]) {
        [SVProgressHUD showErrorWithStatus:self.tfScore.placeholder];
        return NO;
    }
    
    return YES;
}

- (NSDictionary *)params {    
    NSString *memo = [self.tvMemo.text isEqualToString:@"请输入备注"] ? @"" : self.tvMemo.text;;
    
    return @{
        @"projectId":[UserAgent DefaultAgent].projectId,
        @"sectId":[UserAgent DefaultAgent].sectionId,
        @"dictId":self.dictId,
        @"code":self.tfCode.text,
        @"userId":self.userId,
        @"position":self.tfPosition.text,
        @"ruleId":self.ruleId,
        @"itemId":self.itemId,
        @"work":self.tfWork.text,
        @"reason":self.tfReason.text,
        @"score":self.tfScore.text,
        @"fine":self.tfFine.text,
        @"memo":memo,
        @"registerDate":[self.btnRegisterDate currentTitle],
    };
}

#pragma mark - 选择管理办法
- (void)showRulesPicker {
    STPickerSingle *pickerSingle = [[STPickerSingle alloc]init];
    [pickerSingle setArrayData:self.ruleTitles];
    [pickerSingle setTitle:@"请选择管理办法"];
    [pickerSingle setDelegate:self];
    pickerSingle.contentMode = STPickerContentModeCenter;
    [pickerSingle show];
}

#pragma mark - STPickerSingleDelegate
- (void)pickerSingle:(STPickerSingle *)pickerSingle selectedTitle:(NSString *)selectedTitle {
    NSInteger index = [self.ruleTitles indexOfObject:selectedTitle];
    
    EnumModel *item = self.rules[index];
    self.ruleId = item.id;
    [self.btnRule setTitle:item.name forState:UIControlStateNormal];
}

#pragma mark - 显示日期选择器
- (void)showDate:(UIButton *)textUI {
    
    NSString *dateStr = [textUI currentTitle];
    
    if ([dateStr isEqualToString:@""] || [dateStr isEqualToString:@"请选择日期"]) {
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

@end
