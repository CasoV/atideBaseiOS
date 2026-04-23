//
//  QualityInspectionPopView.m
//  ycxm
//
//  Created by 末末班车 on 2018/9/21.
//  Copyright © 2018年 末末班车. All rights reserved.
//

#import "QualityInspectionPopView.h"
#import <YTKNetwork/YTKNetwork.h>
#import "UIView+STPicker.h"
#import "NewFileScanView.h"
#import "ApiImageUpload.h"

#define ScreenWidth [UIScreen mainScreen].bounds.size.width
#define ScreenHeight [UIScreen mainScreen].bounds.size.height
#define ButtonSystemHeight 40
#define DefaultFont [UIFont systemFontOfSize:14]
#define DefaultTitleColor [UIColor blackColor]
#define DefaultBorderButtonColor [UIColor colorWithRed:216.0/255 green:216.0/255 blue:216.0/255 alpha:1]
#define DefaultContentHeight [UIScreen mainScreen].bounds.size.height / 2
#define MarginBig 10
#define Margin 5

@interface QualityInspectionPopView ()

/** 1.内部视图 */
@property (nonatomic, strong) UIView *contentView;
/** 2.边线,选择器和上方tool之间的边线 */
@property (nonatomic, strong)UIView *lineView;
/** 3.左边的按钮 */
@property (nonatomic, strong)UIButton *buttonLeft;
/** 4.右边的按钮 */
@property (nonatomic, strong)UIButton *buttonRight;
/** 5.标题label */
@property (nonatomic, strong)UILabel *labelTitle;
/** 6.btnView */
@property (nonatomic, strong)UIView *btnView;

@property (nonatomic, strong) UILabel *label1;
@property (nonatomic, strong) UILabel *label2;

@property (nonatomic, strong) UIButton *btn1;
@property (nonatomic, strong) UIButton *btn2;

@property (nonatomic, strong) UIButton *voiceButton;

@property (nonatomic, strong) UITextView *tv;

@property (nonatomic, strong) NewFileScanView *imagesView;

//@property (nonatomic, strong) IFlyHelper *iflyHelper;

@end

@implementation QualityInspectionPopView {
    YTKBatchRequest *_batchRequest;
    
    NSString *_ID;
}

- (instancetype)init {
    if (self = [super init]) {
        [self setupDefault];
    }
    return self;
}

- (void)dealloc {
    [_batchRequest stop];
}

- (void)setupDefault {
    // 1.设置数据的默认值
    _title             = @"审核意见";
    _fontName          = DefaultFont;
    _titleColor        = DefaultTitleColor;
    _borderButtonColor = DefaultBorderButtonColor;
    _heightContent     = DefaultContentHeight;
    
    // 2.设置自身的属性
    self.bounds = [UIScreen mainScreen].bounds;
    self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:102.0/255];
    self.layer.opacity = 0.0;
    self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self addTarget:self action:@selector(remove) forControlEvents:UIControlEventTouchUpInside];
    // 3.添加子视图
    [self addSubview:self.contentView];
    [self.contentView addSubview:self.lineView];
    [self.contentView addSubview:self.buttonLeft];
    [self.contentView addSubview:self.buttonRight];
    [self.contentView addSubview:self.labelTitle];
    [self.contentView addSubview:self.label1];
    [self.contentView addSubview:self.label2];
    [self.contentView addSubview:self.btnView];
    [self.contentView addSubview:self.tv];
    [self.contentView addSubview:self.voiceButton];
    [self.contentView addSubview:self.imagesView];
    [self.btnView addSubview:self.btn1];
    [self.btnView addSubview:self.btn2];
    
    [self getPkId];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.buttonLeft.st_y = DefaultContentHeight - ButtonSystemHeight;
    self.buttonRight.st_y = DefaultContentHeight - ButtonSystemHeight;
}

- (void)setController:(UIViewController *)controller {
    self.imagesView.controller = controller;
}

#pragma mark - 获取id
- (void)getPkId {
    __weak typeof(self) weakSelf = self;
    [[HttpManager manager] post:[UrlConfig URL:getQualityProblemId] param:nil success:^(NSData *data) {
        NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        self->_ID = [str stringByReplacingOccurrencesOfString:@"\"" withString:@""];
        weakSelf.imagesView.markId = self->_ID;
        [weakSelf.imagesView updateData];
    } faild:^(NSString *msg) {
        [weakSelf getPkId];
    }];
}

#pragma mark - --- event response 事件相应 ---
- (void)selectedOk {
    if (!self.tv || [self.tv.text isEqualToString:@""]) {
        [SVProgressHUD showInfoWithStatus:@"请先输入内容!"];
        return;
    }
    
    if (!_ID) {
        [SVProgressHUD showInfoWithStatus:@"未获取到id"];
        return;
    }
    
    [SVProgressHUD showWithStatus:@"请求中..."];
    NSMutableArray <BIMFile *>*files = [NSMutableArray array];
    [files addObjectsFromArray:[self.imagesView addFiles]];
    if (files.count == 0) {
        [self save];
    } else {
        if (_batchRequest) {
            [_batchRequest stop];
        }
        
        int x = arc4random() % 1000000;
        __weak typeof(self) weakSelf = self;
        NSMutableArray <YTKRequest *>*requests = [NSMutableArray array];
        for (BIMFile *file in files) {
            ApiImageUpload *api = [[ApiImageUpload alloc] initWithImageData:file.data fileName:[NSString stringWithFormat:@"%d.jpg", x++] markId:_ID];
            if (api) {
                [requests addObject:api];
            }
        }
        
        _batchRequest = [[YTKBatchRequest alloc] initWithRequestArray:requests];
        [_batchRequest startWithCompletionBlockWithSuccess:^(YTKBatchRequest * _Nonnull batchRequest) {
            [weakSelf save];
        } failure:^(YTKBatchRequest * _Nonnull batchRequest) {
            [weakSelf save];
        }];
    }
}

- (void)selectedCancel {
    [self remove];
}

- (void)save {
    NSString *url;
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:@{
                                                                                  @"id":_ID,
                                                                                  @"problemId":self.id,
                                                                                  @"content":self.tv.text
                                                                                  }];
    switch (self.type) {
        case FunctionTypeQualityInspectionWaitRectification:
        
            if ([self.resourceTitle isEqualToString:@"环保问题整改"]) {
                url = greeReform;
            }else if ([self.resourceTitle isEqualToString:@"水保巡查整改"]) {
                url = greeWaterReform;
            }else if ([self.resourceTitle isEqualToString:@"安全隐患"]||[self.resourceTitle isEqualToString:@"安全检查"]) {
                url = riskReform;
            }else{
                 url = qualityProblemCertReform;
            }
            
            break;
        case FunctionTypeQualityInspectionWaitReview:
            if ([self.resourceTitle isEqualToString:@"环保问题整改"]) {
                url = greeRecheck;
            }else if ([self.resourceTitle isEqualToString:@"水保巡查整改"]) {
                url = greeWaterRecheck;
            }else if ([self.resourceTitle isEqualToString:@"安全隐患"]||[self.resourceTitle isEqualToString:@"安全检查"]) {
                url = riskRecheck;
            }else{
                 url = qualityProblemRecheck;
            }
            if (self.btn1.isSelected) {
                [params setValue:@"3" forKey:@"status"];
            } else {
                [params setValue:@"2" forKey:@"status"];
            }
            break;
        default:
            if ([self.resourceTitle isEqualToString:@"环保问题整改"]) {
                url = greeSaveContent;
            }else if ([self.resourceTitle isEqualToString:@"水保巡查整改"]) {
                url = greeWaterSaveContent;
            }else if ([self.resourceTitle isEqualToString:@"安全隐患"]) {
                url = riskSaveContent;
            }else{
                url = qualityProblemSaveContent;
            }
            break;
    }
    
    __weak typeof(self) weakSelf = self;
    [[HttpManager manager] post:[UrlConfig URL:url] param:params success:^(NSData *data) {
        if ([ResponseUtils success:data]) {
            [SVProgressHUD dismiss];
            
            if (weakSelf.type == FunctionTypeQualityInspectionWaitReview) {
                if (weakSelf.block) {
                    weakSelf.block(weakSelf.btn1.isSelected);
                }
            } else {
                if (weakSelf.block) {
                    weakSelf.block(NO);
                }
            }
            
        } else {
            [SVProgressHUD showErrorWithStatus:[ResponseUtils getMsg]];
        }
        
        [weakSelf remove];
    } faild:^(NSString *msg) {
        [SVProgressHUD showErrorWithStatus:msg];
        [weakSelf remove];
    }];;
}

- (void)show {
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    [self setCenter:[UIApplication sharedApplication].keyWindow.center];
    [[UIApplication sharedApplication].keyWindow bringSubviewToFront:self];
    
    CGRect frameContent =  self.contentView.frame;
    frameContent.origin.y -= (ScreenHeight+self.contentView.st_height)/2;
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        [self.layer setOpacity:1.0];
        self.contentView.frame = frameContent;
        self.contentView.autoresizingMask =  UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
    } completion:^(BOOL finished) {
    }];
//    self.iflyHelper = [[IFlyHelper alloc] initWithView:self delegate:self];
}

- (void)remove {
    CGRect frameContent =  self.contentView.frame;
    frameContent.origin.y += (ScreenHeight+self.contentView.st_height)/2;
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        [self.layer setOpacity:0.0];
        self.contentView.frame = frameContent;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

#pragma mark - --- setters 属性 ---
- (void)setTitle:(NSString *)title {
    _title = title;
    [self.labelTitle setText:title];
}

- (void)setFont:(UIFont *)font {
    _fontName = font;
    [self.buttonLeft.titleLabel setFont:font];
    [self.buttonRight.titleLabel setFont:font];
    [self.labelTitle setFont:font];
}

- (void)setTitleColor:(UIColor *)titleColor {
    _titleColor = titleColor;
    [self.labelTitle setTextColor:titleColor];
    [self.buttonLeft setTitleColor:titleColor forState:UIControlStateNormal];
    [self.buttonRight setTitleColor:titleColor forState:UIControlStateNormal];
}

- (void)setBorderButtonColor:(UIColor *)borderButtonColor
{
    _borderButtonColor = borderButtonColor;
    [self.buttonLeft addBorderColor:borderButtonColor];
    [self.buttonRight addBorderColor:borderButtonColor];
}

- (void)setHeightContent:(CGFloat)heightContent
{
    _heightContent = heightContent;
    self.contentView.st_height = heightContent;
}

- (void)setType:(FunctionType)type {
    _type = type;
    switch (type) {
        case FunctionTypeQualityInspectionWaitRectification:
            self.labelTitle.text = @"确认整改";
            self.label2.text = @"整改说明:";
            break;
        case FunctionTypeQualityInspectionWaitReview:
            self.labelTitle.text = @"复查确认";
            self.label2.text = @"复查说明:";
            self.btnView.hidden = NO;
            self.label1.hidden = NO;
            CGRect frame = self.label2.frame;
            frame.origin.y = ButtonSystemHeight * 2 - 10;
            self.label2.frame = frame;
            frame = self.voiceButton.frame;
            frame.origin.y = ButtonSystemHeight * 2 - 10;
            self.voiceButton.frame = frame;
            frame = self.tv.frame;
            frame.origin.y = ButtonSystemHeight * 3 - 20;
            frame.size.height = DefaultContentHeight - ButtonSystemHeight * 4 + 10 - 75;
            self.tv.frame = frame;
            break;
        default:
            self.labelTitle.text = @"回复";
            self.label2.text = @"回复内容:";
            break;
    }
}

#pragma mark - --- getters 属性 ---
- (UIView *)contentView
{
    if (!_contentView) {
        CGFloat contentX = ScreenWidth * 0.05;
        CGFloat contentY = ScreenHeight;
        CGFloat contentW = ScreenWidth * 0.9;
        CGFloat contentH = self.heightContent;
        _contentView = [[UIView alloc]initWithFrame:CGRectMake(contentX, contentY, contentW, contentH)];
        [_contentView setBackgroundColor:[UIColor whiteColor]];
        _contentView.layer.cornerRadius = 5.0f;
        _contentView.clipsToBounds = YES;
        _contentView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    }
    return _contentView;
}

- (UIView *)lineView
{
    if (!_lineView) {
        CGFloat lineX = 0;
        CGFloat lineY = ButtonSystemHeight;
        CGFloat lineW = self.contentView.st_width;
        CGFloat lineH = 1;
        _lineView = [[UIView alloc]initWithFrame:CGRectMake(lineX, lineY, lineW, lineH)];
        [_lineView setBackgroundColor:self.borderButtonColor];
        _lineView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    }
    return _lineView;
}

- (UIButton *)buttonLeft
{
    if (!_buttonLeft) {
        CGFloat leftW = (self.contentView.st_width - 1) / 2;
        CGFloat leftH = ButtonSystemHeight;
        CGFloat leftX = 0;
        CGFloat leftY = DefaultContentHeight - ButtonSystemHeight;
        _buttonLeft = [[UIButton alloc]initWithFrame:CGRectMake(leftX, leftY, leftW, leftH)];
        [_buttonLeft setTitle:@"确定" forState:UIControlStateNormal];
        [_buttonLeft setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_buttonLeft setBackgroundColor:UIColorTextBlue];
        [_buttonLeft.titleLabel setFont:self.font];
        [_buttonLeft addTarget:self action:@selector(selectedOk) forControlEvents:UIControlEventTouchUpInside];
        _buttonLeft.autoresizingMask = UIViewAutoresizingFlexibleRightMargin;
    }
    return _buttonLeft;
}

- (UIButton *)buttonRight
{
    if (!_buttonRight) {
        CGFloat rightW = self.buttonLeft.st_width;
        CGFloat rightH = self.buttonLeft.st_height;
        CGFloat rightX = self.buttonLeft.st_width + 1;
        CGFloat rightY = self.buttonLeft.st_y;
        _buttonRight = [[UIButton alloc]initWithFrame:CGRectMake(rightX, rightY, rightW, rightH)];
        [_buttonRight setTitle:@"取消" forState:UIControlStateNormal];
        [_buttonRight setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_buttonRight setBackgroundColor:UIColorTextBlue];
        [_buttonRight.titleLabel setFont:self.font];
        [_buttonRight addTarget:self action:@selector(selectedCancel) forControlEvents:UIControlEventTouchUpInside];
        _buttonRight.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
    }
    return _buttonRight;
}

- (UILabel *)labelTitle
{
    if (!_labelTitle) {
        CGFloat titleX = 0;
        CGFloat titleY = 0;
        CGFloat titleW = self.contentView.st_width;
        CGFloat titleH = ButtonSystemHeight - 1;
        _labelTitle = [[UILabel alloc]initWithFrame:CGRectMake(titleX, titleY, titleW, titleH)];
        [_labelTitle setTextAlignment:NSTextAlignmentCenter];
        [_labelTitle setTextColor:self.titleColor];
        [_labelTitle setText:self.title];
        [_labelTitle setFont:self.font];
        _labelTitle.adjustsFontSizeToFitWidth = YES;
        _labelTitle.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    }
    return _labelTitle;
}

- (UILabel *)label1
{
    if (!_label1) {
        CGFloat titleX = 10;
        CGFloat titleY = ButtonSystemHeight;
        CGFloat titleW = 65;
        CGFloat titleH = ButtonSystemHeight - 10;
        _label1 = [[UILabel alloc]initWithFrame:CGRectMake(titleX, titleY, titleW, titleH)];
        [_label1 setTextAlignment:NSTextAlignmentCenter];
        [_label1 setTextColor:self.titleColor];
        [_label1 setText:@"复查结果:"];
        [_label1 setFont:self.font];
        _label1.adjustsFontSizeToFitWidth = YES;
        _label1.hidden = YES;
        _label1.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    }
    return _label1;
}

- (UILabel *)label2
{
    if (!_label2) {
        CGFloat titleX = 10;
        CGFloat titleY = ButtonSystemHeight;
        CGFloat titleW = 65;
        CGFloat titleH = ButtonSystemHeight - 10;
        _label2 = [[UILabel alloc]initWithFrame:CGRectMake(titleX, titleY, titleW, titleH)];
        [_label2 setTextAlignment:NSTextAlignmentCenter];
        [_label2 setTextColor:self.titleColor];
        [_label2 setFont:self.font];
        _label2.adjustsFontSizeToFitWidth = YES;
        _label2.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    }
    return _label2;
}

- (UIView *)btnView {
    if (!_btnView) {
        _btnView = [[UIView alloc] initWithFrame:CGRectMake(75, ButtonSystemHeight, self.contentView.st_width - 75, ButtonSystemHeight - 10)];
        _btnView.hidden = YES;
    }
    return _btnView;
}

- (UIButton *)btn1 {
    if (!_btn1) {
        _btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
        _btn1.frame = CGRectMake(0, 0, 60, ButtonSystemHeight - 10);
        _btn1.titleLabel.font = [UIFont systemFontOfSize:13.0f];
        _btn1.selected = YES;
        [_btn1 setTitle:@"通过" forState:UIControlStateNormal];
        [_btn1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_btn1 setImage:[UIImage imageNamed:@"point_off"] forState:UIControlStateNormal];
        [_btn1 setImage:[UIImage imageNamed:@"point_on"] forState:UIControlStateSelected];
        [_btn1 addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _btn1;
}

- (UIButton *)btn2 {
    if (!_btn2) {
        _btn2 = [UIButton buttonWithType:UIButtonTypeCustom];
        _btn2.frame = CGRectMake(60, 0, self.contentView.st_width - 75 - 60, ButtonSystemHeight - 10);
        _btn2.titleLabel.font = [UIFont systemFontOfSize:13.0f];
        [_btn2 setTitle:@"未通过(返回至整改确认)" forState:UIControlStateNormal];
        [_btn2 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_btn2 setImage:[UIImage imageNamed:@"point_off"] forState:UIControlStateNormal];
        [_btn2 setImage:[UIImage imageNamed:@"point_on"] forState:UIControlStateSelected];
        [_btn2 addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _btn2;
}

#pragma mark - 懒加载
- (UIButton *)voiceButton {
    if (!_voiceButton) {
        _voiceButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _voiceButton.frame = CGRectMake(self.contentView.st_width - 40, ButtonSystemHeight, 40, ButtonSystemHeight - 10);
        [_voiceButton setImage:[UIImage imageNamed:@"ico_voice"] forState:UIControlStateNormal];
        [_voiceButton addTarget:self action:@selector(voiceBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    }
    return _voiceButton;
}

- (UITextView *)tv {
    if (!_tv) {
        _tv = [[UITextView alloc] initWithFrame:CGRectMake(10, ButtonSystemHeight * 2 - 10, self.contentView.st_width - 20, DefaultContentHeight - ButtonSystemHeight * 3 - 75)];
        _tv.font = DefaultFont;
        _tv.layer.cornerRadius = 5;
        _tv.layer.borderColor = UIColorFromRGB(0xE6E6E6).CGColor;
        _tv.layer.borderWidth = 1;
    }
    return _tv;
}

- (NewFileScanView *)imagesView {
    if (!_imagesView) {
        __weak typeof(self) weakSelf = self;
        _imagesView = [[NewFileScanView alloc] initWithFrame:CGRectMake(10, self.tv.frame.size.height + self.tv.frame.origin.y + 5, self.contentView.st_width - 20, 70) type:FileScanTypeImage];
        _imagesView.block = ^(CGFloat oldHeight, CGFloat newHeight) {
            weakSelf.hidden = NO;
        };
        _imagesView.choosePhotoBlock = ^(BOOL choosePhoto) {
            weakSelf.hidden = choosePhoto;
        };
    }
    return _imagesView;
}

#pragma mark - 点击事件
//- (void)voiceBtnClicked {
//    [self.iflyHelper speech];
//}
//
//- (void)btnClicked:(UIButton *)sender {
//    self.btn1.selected = NO;
//    self.btn2.selected = NO;
//    sender.selected = YES;
//}
//
//#pragma mark - 语音协议
//- (void)onError:(IFlySpeechError *)error {
//    NSString *result = [self.iflyHelper onError:error];
//    NSString *str = self.tv.text;
//    self.tv.text = [NSString stringWithFormat:@"%@%@", str, result];
//}
//
//- (void)onResult:(NSArray *)resultArray isLast:(BOOL)isLast {
//    [self.iflyHelper onResult:resultArray isLast:isLast];
//}

@end
