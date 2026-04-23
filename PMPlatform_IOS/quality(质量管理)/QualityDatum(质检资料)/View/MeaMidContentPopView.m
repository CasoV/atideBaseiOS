//
//  MeaMidContentPopView.m
//  ycxm
//
//  Created by 末末班车 on 2019/2/26.
//  Copyright © 2019 末末班车. All rights reserved.
//

#import "MeaMidContentPopView.h"
#import "MeaMidTableHeaderView.h"
#import "MeaMidListModel.h"
#import "UIView+STPicker.h"
#import "MeaMidListCell.h"

#define ButtonSystemHeight 30
#define DefaultFont [UIFont systemFontOfSize:14]
#define DefaultTitleColor [UIColor blackColor]
#define DefaultBorderButtonColor [UIColor colorWithRed:216.0/255 green:216.0/255 blue:216.0/255 alpha:1]
#define DefaultContentHeight [UIScreen mainScreen].bounds.size.height / 2
#define MarginBig 10
#define Margin 5

@interface MeaMidContentPopView ()<UITableViewDataSource>

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

@property (nonatomic, assign) CGRect contentViewFrame;

@property (nonatomic, strong) MeaMidTableHeaderView *tableHeaderView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, copy) NSArray <MeaMidListModel *>*dataSource;

@property (nonatomic, strong) UITextView *contentTV1;
@property (nonatomic, strong) UITextView *contentTV2;
@property (nonatomic, strong) UITextView *contentTV3;

@end

@implementation MeaMidContentPopView

- (instancetype)init {
    if (self = [super init]) {
        [self setupDefault];
    }
    return self;
}

- (void)setupDefault {
    // 1.设置数据的默认值
    _fontName              = DefaultFont;
    _borderButtonColor = DefaultBorderButtonColor;
    _heightContent     = DefaultContentHeight;
    
    // 2.设置自身的属性
    self.bounds = [UIScreen mainScreen].bounds;
    self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:102.0/255];
    self.layer.opacity = 0.0;
    self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    // 3.添加子视图
    [self addSubview:self.contentView];
    [self.contentView addSubview:self.lineView];
    [self.contentView addSubview:self.buttonLeft];
    [self.contentView addSubview:self.buttonRight];
    [self.contentView addSubview:self.labelTitle];
    [self.contentView addSubview:self.tableHeaderView];
    [self.contentView addSubview:self.tableView];
    [self.contentView addSubview:self.contentTV1];
    [self.contentView addSubview:self.contentTV2];
    [self.contentView addSubview:self.contentTV3];
    
    [self.buttonLeft mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.equalTo(self.contentView);
        make.height.equalTo(@(ButtonSystemHeight));
        make.width.equalTo(@((kScreen_Width - 10) / 2));
    }];
    [self.buttonRight mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.bottom.equalTo(self.contentView);
        make.left.equalTo(self.buttonLeft.mas_right).offset(1);
        make.height.equalTo(@(ButtonSystemHeight));
    }];
    
    CGFloat textViewWidth = (kScreen_Width - 30) / 7 * 2;
    CGFloat textViewHeight = ButtonSystemHeight * 2.5;
    [self.contentTV1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(5);
        make.bottom.equalTo(self.buttonLeft.mas_top).offset(-5);
        make.height.equalTo(@(textViewHeight));
        make.width.equalTo(@(textViewWidth));
    }];
    [self.contentTV2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentTV1.mas_right).offset(5);
        make.bottom.equalTo(self.buttonLeft.mas_top).offset(-5);
        make.height.equalTo(@(textViewHeight));
        make.width.equalTo(@(textViewWidth));
    }];
    
    [self.contentTV3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentTV2.mas_right).offset(5);
        make.right.equalTo(self.contentView).offset(-5);
        make.bottom.equalTo(self.buttonLeft.mas_top).offset(-5);
        make.height.equalTo(@(textViewHeight));
    }];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.contentView);
        make.top.equalTo(self.tableHeaderView.mas_bottom);
        make.bottom.equalTo(self.contentTV1.mas_top).offset(-5);
    }];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardFrameWillChangeNotification:)
                                                 name:UIKeyboardWillChangeFrameNotification
                                               object:nil];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - --- event response 事件相应 ---
- (void)selectedOk {
    if (self.callBack) {
        NSMutableArray <NSDictionary *>*arr = [NSMutableArray array];
        for (MeaMidListModel *model in self.dataSource) {
            [arr addObject:@{@"bid":model.ID, @"num":model.REALAMOUNT}];
        }
        
        self.callBack(self.contentTV1.text, self.contentTV2.text, self.contentTV3.text, arr);
    }
    [self remove];
}

- (void)selectedCancel {
    [self remove];
}

- (void)show {
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    [self setCenter:[UIApplication sharedApplication].keyWindow.center];
    [[UIApplication sharedApplication].keyWindow bringSubviewToFront:self];
    
    CGRect frameContent =  self.contentView.frame;
    frameContent.origin.y = (kScreen_Height - self.contentView.st_height)/2;
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        [self.layer setOpacity:1.0];
        self.contentView.frame = frameContent;
        self.contentView.autoresizingMask =  UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
    } completion:^(BOOL finished) {
    }];
}

- (void)remove {
    CGRect frameContent =  self.contentView.frame;
    frameContent.origin.y = kScreen_Height;
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        [self.layer setOpacity:0.0];
        self.contentView.frame = frameContent;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

#pragma mark - --- setters 属性 ---
- (void)setPartCode:(NSString *)partCode {
    _partCode = partCode;
    
    __weak typeof(self) weakSelf = self;
    [[HttpManager manager] post:[UrlConfig URL:getMea4mid] param:@{@"partCode":_partCode} success:^(NSData *data) {
        if ([ResponseUtils success:data]) {
            weakSelf.dataSource = [MeaMidListModel mj_objectArrayWithKeyValuesArray:[ResponseUtils getData:@"data"]];
            
            if (weakSelf.dataSource.count*30 + 175 < weakSelf.contentView.st_height) {
                CGRect frame = weakSelf.contentView.frame;
                frame.size.height = weakSelf.dataSource.count*30 + 175;
                weakSelf.contentView.frame = frame;
                weakSelf.contentViewFrame = frame;
            }
            
            for (MeaMidListModel *model in weakSelf.dataSource) {
                for (NSDictionary *dic in weakSelf.list) {
                    if ([model.ID isEqualToString:dic[@"bid"]]) {
                        model.REALAMOUNT = [NSString stringWithFormat:@"%@",dic[@"num"]];
                    }
                }
            }
            
            [weakSelf.tableView reloadData];
        } else {
            [SVProgressHUD showErrorWithStatus:[ResponseUtils getMsg]];
        }
    } faild:^(NSString *msg) {
        [SVProgressHUD showErrorWithStatus:msg];
    }];
}

- (void)setContent1:(NSString *)content1 {
    if ([content1 isKindOfClass:[NSNull class]]) {
        self.contentTV1.text = @"";
    } else {
        self.contentTV1.text = content1 ? content1 : @"";
    }
}

- (void)setContent2:(NSString *)content2 {
    if ([content2 isKindOfClass:[NSNull class]]) {
        self.contentTV2.text = @"";
    } else {
        self.contentTV2.text = content2 ? content2 : @"";
    }
}

- (void)setContent3:(NSString *)content3 {
    if ([content3 isKindOfClass:[NSNull class]]) {
        self.contentTV3.text = @"";
    } else {
        self.contentTV3.text = content3 ? content3 : @"";
    }
}

#pragma mark - --- getters 属性 ---
- (UIView *)contentView
{
    if (!_contentView) {
        CGFloat contentX = 5;
        CGFloat contentY = kScreen_Height;
        CGFloat contentW = kScreen_Width - 10;
        CGFloat contentH = self.heightContent;
        self.contentViewFrame = CGRectMake(contentX, contentY, contentW, contentH);
        _contentView = [[UIView alloc]initWithFrame:self.contentViewFrame];
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
        _buttonLeft = [[UIButton alloc]initWithFrame:CGRectZero];
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
        _buttonRight = [[UIButton alloc]initWithFrame:CGRectZero];
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
        [_labelTitle setTextColor:[UIColor blackColor]];
        [_labelTitle setText:@"中间交工内容"];
        [_labelTitle setFont:self.font];
        _labelTitle.adjustsFontSizeToFitWidth = YES;
        _labelTitle.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    }
    return _labelTitle;
}

- (MeaMidTableHeaderView *)tableHeaderView {
    if (!_tableHeaderView) {
        _tableHeaderView = [[MeaMidTableHeaderView alloc] initWithFrame:CGRectMake(0, ButtonSystemHeight, self.contentView.st_width, ButtonSystemHeight)];
    }
    return _tableHeaderView;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        [_tableView registerNib:[UINib nibWithNibName:@"MeaMidListCell" bundle:nil] forCellReuseIdentifier:@"MeaMidListCell"];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.tableFooterView = [UIView new];
        _tableView.dataSource = self;
        _tableView.rowHeight = 30;
        _tableView.bounces = NO;
    }
    return _tableView;
}

- (NSArray<MeaMidListModel *> *)dataSource {
    if (!_dataSource) {
        _dataSource = [NSArray array];
    }
    return _dataSource;
}

- (UITextView *)contentTV1 {
    if (!_contentTV1) {
        _contentTV1 = [[UITextView alloc] initWithFrame:CGRectZero];
        _contentTV1.layer.borderColor = [UIColor darkGrayColor].CGColor;
        _contentTV1.layer.borderWidth = 1.0f;
        _contentTV1.font = [UIFont systemFontOfSize:12.f];
        _contentTV1.text = @"根据设计及施工规范要求，已完成";
    }
    return _contentTV1;
}

- (UITextView *)contentTV2 {
    if (!_contentTV2) {
        _contentTV2 = [[UITextView alloc] initWithFrame:CGRectZero];
        _contentTV2.layer.borderColor = [UIColor darkGrayColor].CGColor;
        _contentTV2.layer.borderWidth = 1.0f;
        _contentTV2.font = [UIFont systemFontOfSize:12.f];
    }
    return _contentTV2;
}

- (UITextView *)contentTV3 {
    if (!_contentTV3) {
        _contentTV3 = [[UITextView alloc] initWithFrame:CGRectZero];
        _contentTV3.layer.borderColor = [UIColor darkGrayColor].CGColor;
        _contentTV3.layer.borderWidth = 1.0f;
        _contentTV3.font = [UIFont systemFontOfSize:12.f];
        _contentTV3.text = @"工作，经检验评定合格，申请中间交工。";
    }
    return _contentTV3;
}

- (NSArray<NSDictionary *> *)list {
    if (!_list) {
        _list = @[];
    }
    
    return _list;
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MeaMidListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MeaMidListCell" forIndexPath:indexPath];
    
    cell.model = self.dataSource[indexPath.row];
    
    __weak typeof(self) weakSelf = self;
    cell.callBack = ^{
        NSString *str = @"工作，经检验评定合格，申请中间交工。\n  工程数量：";
        for (MeaMidListModel *model in weakSelf.dataSource) {
            str = [str stringByAppendingString:[NSString stringWithFormat:@"\n      %@：%.02f%@", model.NAME, model.REALAMOUNT.floatValue, model.UNIT]];
        }
        weakSelf.contentTV3.text = str;
    };
    
    return cell;
}

- (void)keyboardFrameWillChangeNotification:(NSNotification *)notif {
    if (![notif.name isEqualToString:UIKeyboardWillChangeFrameNotification]) return;
    NSDictionary *info = notif.userInfo;
    if (!info) return;
    
    CGRect EndRect = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    if (EndRect.origin.y != kScreen_Height) {
        CGFloat overlapping = (self.contentView.st_y + self.contentTV1.st_y + self.contentTV1.st_height) - EndRect.origin.y;
        if (overlapping > 0) {
            CGRect frameContent =  self.contentView.frame;
            frameContent.origin.y -= overlapping;
            [UIView animateWithDuration:0.1 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                self.contentView.frame = frameContent;
            } completion:nil];
        }
    } else {
        [UIView animateWithDuration:0.1 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            self.contentView.frame = self.contentViewFrame;
        } completion:nil];
    }
}

@end
