//
//  ApprovalPopView.m
//  HBConstructionApp
//
//  Created by 末末班车 on 2018/4/14.
//  Copyright © 2018年 atide. All rights reserved.
//

#import "ApprovalPopView.h"
#import "UnderlineButton.h"
#import "UIView+STPicker.h"
#import "UIImage+Additions.h"
#import "EasySignatureView.h"

#define ScreenWidth [UIScreen mainScreen].bounds.size.width
#define ScreenHeight [UIScreen mainScreen].bounds.size.height
#define ButtonSystemHeight 40
#define DefaultFont [UIFont systemFontOfSize:14]
#define DefaultTitleColor [UIColor blackColor]
#define DefaultBorderButtonColor [UIColor colorWithRed:216.0/255 green:216.0/255 blue:216.0/255 alpha:1]
#define DefaultContentHeight [UIScreen mainScreen].bounds.size.height / 2
#define MarginBig 10
#define Margin 5

@interface ApprovalPopView ()<UITextViewDelegate, SignatureViewDelegate>

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

@property (nonatomic, strong) UnderlineButton *frontBtn;
@property (nonatomic, strong) UnderlineButton *opinionBtn;

@property (nonatomic, strong) UIButton *voiceButton;
@property (nonatomic, strong) UIButton *button1;
@property (nonatomic, strong) UIButton *button2;

@property (nonatomic, strong) EasySignatureView *signatureView;
@property (nonatomic, strong) UITextView *tv;

//@property (nonatomic, strong) IFlyHelper *iflyHelper;

@end

@implementation ApprovalPopView {
    BOOL _signature;
}

- (instancetype)init {
    if (self = [super init]) {
        [self setupDefault];
    }
    return self;
}

- (void)setupDefault {
    // 1.设置数据的默认值
    _title             = @"审核意见";
    _fontName              = DefaultFont;
    _titleColor        = DefaultTitleColor;
    _borderButtonColor = DefaultBorderButtonColor;
    _heightContent     = DefaultContentHeight;
    _signature         = NO;
    
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
    [self.contentView addSubview:self.btnView];
    [self.contentView addSubview:self.button1];
    [self.contentView addSubview:self.button2];
    [self.contentView addSubview:self.signatureView];
    [self.contentView addSubview:self.tv];
    [self.btnView addSubview:self.frontBtn];
    [self.btnView addSubview:self.opinionBtn];
    [self.btnView addSubview:self.voiceButton];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.buttonLeft.st_y = DefaultContentHeight - ButtonSystemHeight;
    self.buttonRight.st_y = DefaultContentHeight - ButtonSystemHeight;
}

#pragma mark - --- event response 事件相应 ---
- (void)selectedOk {
//    if (!_signature) {
//        [SVProgressHUD showInfoWithStatus:@"请签名后再通过！"];
//        return;
//    }

    __weak typeof(self) weakSelf = self;
    NSString *comment = [self.tv.text isEqualToString:@"填写意见"] ? @"" : self.tv.text;
    NSString *encodedImageStr = [self getSignatureImgStr];
    [SVProgressHUD showWithStatus:@""];

    NSMutableArray *params = [NSMutableArray array];
    for (WaitCheckBean *item in self.beans) {
        NSString *taskKey = @"";
        if (item.taskKey) {
            taskKey = item.taskKey;
        }
        
        NSDictionary *body = @{
            @"bizKey":item.bizType,
            @"bizPk":item.bizPk,
            @"comment":comment,
            @"taskKey":taskKey,
            @"jsonTaskAssignees":@"",
            @"seal":@"",
            @"signature":encodedImageStr,
            @"userId":[AppUser sharedInstance].userId
        };
        
        NSDictionary *param = @{
            @"bizPk":item.bizPk,
            @"bizKey":@"quality_test",
            @"methodKey":@"flowOperator",
            @"taskHttpInstParams":@[
                    @{@"type": @"REQUEST_HEADER", @"name":@"flow-token", @"value":@"COMPLETE"},
                    @{@"type": @"REQUEST_HEADER", @"name":@"Content-Type", @"value":@"application/json"},
                    @{@"type": @"REQUEST_PATH", @"name":@"bizPk", @"value":item.bizPk},
                    @{@"type": @"REQUEST_BODY", @"name":@"", @"value":[body mj_JSONString]},
            ]
        };
        [params addObject:param];
    }

    [[HttpManager manager] jsonPost:[UrlConfig URL:saveTaskHttpInst] arrayParam:params success:^(NSData *data) {
        [SVProgressHUD dismiss];
        id ids = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
        if (ids) {
            [SVProgressHUD showInfoWithStatus:@"审核成功"];
            if (weakSelf.block) {
                weakSelf.block();
            }
            [weakSelf remove];
        }else{
            [SVProgressHUD showInfoWithStatus:@"审核失败"];
        }
    } faild:^(NSString *msg) {
        [SVProgressHUD dismiss];
        [SVProgressHUD showInfoWithStatus:@"审核失败"];
    }];
}

- (void)selectedCancel {
    [self remove];
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

- (UIView *)btnView {
    if (!_btnView) {
        _btnView = [[UIView alloc] initWithFrame:CGRectMake(0, ButtonSystemHeight, self.contentView.st_width, ButtonSystemHeight - 10)];
    }
    return _btnView;
}

#pragma mark - 懒加载
- (UnderlineButton *)frontBtn {
    if (!_frontBtn) {
        _frontBtn = [UnderlineButton buttonWithType:UIButtonTypeCustom];
        _frontBtn.frame = CGRectMake(5, 0, 70, 30);
        _frontBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        [_frontBtn setTitle:@"签名" forState:UIControlStateNormal];
        [_frontBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_frontBtn setImage:[UIImage imageWithColor:UIColorFromRGB(0x0096FF)] forState:UIControlStateSelected];
        [_frontBtn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
        _frontBtn.selected = YES;
    }
    return _frontBtn;
}

- (UnderlineButton *)opinionBtn {
    if (!_opinionBtn) {
        _opinionBtn = [UnderlineButton buttonWithType:UIButtonTypeCustom];
        _opinionBtn.frame = CGRectMake(85, 0, 70, 30);
        _opinionBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        [_opinionBtn setTitle:@"意见填写" forState:UIControlStateNormal];
        [_opinionBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_opinionBtn setImage:[UIImage imageWithColor:UIColorFromRGB(0x0096FF)] forState:UIControlStateSelected];
        [_opinionBtn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
        _opinionBtn.selected = NO;
    }
    return _opinionBtn;
}

- (UIButton *)voiceButton {
    if (!_voiceButton) {
        _voiceButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _voiceButton.frame = CGRectMake(self.contentView.st_width - 26, 0, 26, ButtonSystemHeight - 10);
        [_voiceButton setImage:[UIImage imageNamed:@"ico_voice"] forState:UIControlStateNormal];
        [_voiceButton addTarget:self action:@selector(voiceBtnClicked) forControlEvents:UIControlEventTouchUpInside];
        _voiceButton.hidden = YES;
    }
    return _voiceButton;
}

- (UIButton *)button1 {
    if (!_button1) {
        _button1 = [UIButton buttonWithType:UIButtonTypeCustom];
        _button1.frame = CGRectMake(self.contentView.st_width - 50 - 45, DefaultContentHeight - ButtonSystemHeight - 30, 45, 30);
        _button1.titleLabel.font = [UIFont systemFontOfSize:13];
        [_button1 setTitleColor:UIColorTextBlue forState:UIControlStateNormal];
        _button1.hidden = YES;
        [_button1 addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _button1;
}

- (UIButton *)button2 {
    if (!_button2) {
        _button2 = [UIButton buttonWithType:UIButtonTypeCustom];
        _button2.frame = CGRectMake(self.contentView.st_width - 50, DefaultContentHeight - ButtonSystemHeight - 30, 45, 30);
        _button2.titleLabel.font = [UIFont systemFontOfSize:13];
        [_button2 setTitleColor:UIColorTextBlue forState:UIControlStateNormal];
        [_button2 setTitle:@"重写" forState:UIControlStateNormal];
        [_button2 addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _button2;
}

- (EasySignatureView *)signatureView {
    if (!_signatureView) {
        _signatureView = [[EasySignatureView alloc] initWithFrame:CGRectMake(-1, 70, self.contentView.st_width + 2, DefaultContentHeight - 140)];
        _signatureView.delegate = self;
        _signatureView.layer.borderColor = UIColorFromRGB(0xE6E6E6).CGColor;
        _signatureView.layer.borderWidth = 1;
        _signatureView.backgroundColor = [UIColor whiteColor];
    }
    return _signatureView;
}

- (UITextView *)tv {
    if (!_tv) {
        _tv = [[UITextView alloc] initWithFrame:CGRectMake(5, 75, self.contentView.st_width - 10, DefaultContentHeight - 150)];
        _tv.delegate = self;
        _tv.text = @"填写意见";
        _tv.font = DefaultFont;
        _tv.layer.cornerRadius = 5;
        _tv.layer.borderColor = UIColorFromRGB(0xE6E6E6).CGColor;
        _tv.layer.borderWidth = 1;
        _tv.hidden = YES;
    }
    return _tv;
}

#pragma mark - 点击事件
- (void)btnClicked:(UnderlineButton *)sender {
    sender.selected = YES;
    
    if (sender == self.frontBtn) {
        self.opinionBtn.selected = NO;
        self.signatureView.hidden = NO;
        self.tv.hidden = YES;
    
        self.button1.hidden = YES;
        self.voiceButton.hidden = YES;
        [self.button2 setTitle:@"重写" forState:UIControlStateNormal];
    } else {
        self.frontBtn.selected = NO;
        self.signatureView.hidden = YES;
        self.tv.hidden = NO;
        
        self.button1.hidden = NO;
        self.voiceButton.hidden = NO;
        [self.button1 setTitle:@"同意" forState:UIControlStateNormal];
        [self.button2 setTitle:@"已阅" forState:UIControlStateNormal];
    }
}

- (void)buttonClicked:(UIButton *)sender {
    if (self.frontBtn.isSelected) {
        [self.signatureView clear];
        _signature = NO;
    } else {
        self.tv.text = sender.currentTitle;
    }
}

- (void)voiceBtnClicked {
//    [self.iflyHelper speech];
}

#pragma mark - UITextViewDelegate
- (void)textViewDidBeginEditing:(UITextView *)textView {
    if ([textView.text isEqualToString:@"填写意见"]) {
        textView.text = @"";
    }
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    if ([textView.text isEqualToString:@""]) {
        textView.text = @"填写意见";
    }
}

#pragma mark - SignatureViewDelegate
- (void)onSignatureWriteAction {
    _signature = YES;
}

- (NSString *) getSignatureImgStr {
    if (_signature) {
        [_signatureView sure];
    } else {
        return @"";
    }
    if(_signatureView.SignatureImg) {
        return [UIImagePNGRepresentation(_signatureView.SignatureImg) base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    } else {
        
        return @"";
    }
}

#pragma mark - 语音协议
//- (void)onError:(IFlySpeechError *)error {
//    NSString *result = [self.iflyHelper onError:error];
//    NSString *str = self.tv.text;
//    if ([str isEqualToString:@"填写意见"]) {
//        str = @"";
//    }
//    self.tv.text = [NSString stringWithFormat:@"%@%@", str, result];
//}
//
//- (void)onResult:(NSArray *)resultArray isLast:(BOOL)isLast {
//    [self.iflyHelper onResult:resultArray isLast:isLast];
//}

@end
