//
//  ChooseMultiplePopView.m
//  ycxm
//
//  Created by 末末班车 on 2023/4/6.
//  Copyright © 2023 末末班车. All rights reserved.
//

#import "ChooseMultiplePopView.h"
#import "MultiplePeopleCell.h"
#import "UIView+STPicker.h"

#define ScreenWidth [UIScreen mainScreen].bounds.size.width
#define ScreenHeight [UIScreen mainScreen].bounds.size.height
#define ButtonSystemHeight 40
#define DefaultFont [UIFont systemFontOfSize:14]
#define DefaultTitleColor [UIColor blackColor]
#define DefaultBorderButtonColor [UIColor colorWithRed:216.0/255 green:216.0/255 blue:216.0/255 alpha:1]
#define DefaultContentHeight [UIScreen mainScreen].bounds.size.height / 2
#define MarginBig 10
#define Margin 5

@interface ChooseMultiplePopView ()<UITableViewDelegate,UITableViewDataSource>

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

@property (nonatomic, copy) NSArray <MultipleModel *>*datas;

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation ChooseMultiplePopView

- (instancetype)init {
    if (self = [super init]) {
        [self setupDefault];
    }
    return self;
}

- (void)setupDefault {
    // 1.设置数据的默认值
    _title             = @"选择人员";
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
    [self.contentView addSubview:self.btnView];
    [self.contentView addSubview:self.tableView];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.buttonLeft.st_y = DefaultContentHeight - ButtonSystemHeight;
    self.buttonRight.st_y = DefaultContentHeight - ButtonSystemHeight;
}

#pragma mark - --- event response 事件相应 ---
- (void)selectedOk {
    NSMutableArray <MultipleModel *>*result = [NSMutableArray array];
    for (MultipleModel *item in self.datas) {
        if (item.checked) {
            [result addObject:item];
        }
    }
    self.chooseResult([result copy]);
    [self remove];
}

- (void)selectedCancel {
    [self remove];
}

- (void)show:(NSArray <MultipleModel *>*)datas {
    self.datas = datas;
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

- (void)setFontName:(UIFont *)font {
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

- (void)setBorderButtonColor:(UIColor *)borderButtonColor {
    _borderButtonColor = borderButtonColor;
    [self.buttonLeft addBorderColor:borderButtonColor];
    [self.buttonRight addBorderColor:borderButtonColor];
}

- (void)setHeightContent:(CGFloat)heightContent {
    _heightContent = heightContent;
    self.contentView.st_height = heightContent;
}

#pragma mark - --- getters 属性 ---
- (UIView *)contentView {
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

- (UIView *)lineView {
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

- (UIButton *)buttonLeft {
    if (!_buttonLeft) {
        CGFloat leftW = (self.contentView.st_width - 1) / 2;
        CGFloat leftH = ButtonSystemHeight;
        CGFloat leftX = 0;
        CGFloat leftY = DefaultContentHeight - ButtonSystemHeight;
        _buttonLeft = [[UIButton alloc]initWithFrame:CGRectMake(leftX, leftY, leftW, leftH)];
        [_buttonLeft setTitle:@"确定" forState:UIControlStateNormal];
        [_buttonLeft setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_buttonLeft setBackgroundColor:UIColorTextBlue];
        [_buttonLeft.titleLabel setFont:self.fontName];
        [_buttonLeft addTarget:self action:@selector(selectedOk) forControlEvents:UIControlEventTouchUpInside];
        _buttonLeft.autoresizingMask = UIViewAutoresizingFlexibleRightMargin;
    }
    return _buttonLeft;
}

- (UIButton *)buttonRight {
    if (!_buttonRight) {
        CGFloat rightW = self.buttonLeft.st_width;
        CGFloat rightH = self.buttonLeft.st_height;
        CGFloat rightX = self.buttonLeft.st_width + 1;
        CGFloat rightY = self.buttonLeft.st_y;
        _buttonRight = [[UIButton alloc]initWithFrame:CGRectMake(rightX, rightY, rightW, rightH)];
        [_buttonRight setTitle:@"取消" forState:UIControlStateNormal];
        [_buttonRight setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_buttonRight setBackgroundColor:UIColorTextBlue];
        [_buttonRight.titleLabel setFont:self.fontName];
        [_buttonRight addTarget:self action:@selector(selectedCancel) forControlEvents:UIControlEventTouchUpInside];
        _buttonRight.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
    }
    return _buttonRight;
}

- (UILabel *)labelTitle {
    if (!_labelTitle) {
        CGFloat titleX = 0;
        CGFloat titleY = 0;
        CGFloat titleW = self.contentView.st_width;
        CGFloat titleH = ButtonSystemHeight - 1;
        _labelTitle = [[UILabel alloc]initWithFrame:CGRectMake(titleX, titleY, titleW, titleH)];
        [_labelTitle setTextAlignment:NSTextAlignmentCenter];
        [_labelTitle setTextColor:self.titleColor];
        [_labelTitle setText:self.title];
        [_labelTitle setFont:self.fontName];
        _labelTitle.adjustsFontSizeToFitWidth = YES;
        _labelTitle.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    }
    return _labelTitle;
}

- (UIView *)btnView {
    if (!_btnView) {
        _btnView = [[UIView alloc] initWithFrame:CGRectMake(75, ButtonSystemHeight, self.contentView.st_width - 75, ButtonSystemHeight - 10)];
        _btnView.hidden = YES;
    }
    return _btnView;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, self.lineView.st_bottom, self.contentView.st_width, self.contentView.st_height - self.lineView.st_bottom - self.buttonLeft.st_height) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerNib:[UINib nibWithNibName:@"MultiplePeopleCell" bundle:nil] forCellReuseIdentifier:@"MultiplePeopleCell"];
    }
    return _tableView;
}

- (NSArray<MultipleModel *> *)datas {
    if (!_datas) {
        _datas = [NSArray array];
    }
    return _datas;
}

#pragma mark - UITableViewDelegate,UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.datas.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MultiplePeopleCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MultiplePeopleCell" forIndexPath:indexPath];
    MultipleModel *model = self.datas[indexPath.row];
    cell.titleLb.text = model.userName;
    if (model.checked) {
        [cell.img setImage:[UIImage imageNamed:@"cbox_sele"]];
    } else {
        [cell.img setImage:[UIImage imageNamed:@"cbox_def"]];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    MultipleModel *model = self.datas[indexPath.row];
    model.checked = !model.checked;
    [tableView reloadData];
}

@end
