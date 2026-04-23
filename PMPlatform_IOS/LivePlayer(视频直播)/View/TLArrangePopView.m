//
//  TLArrangePopView.m
//  ZegoRoomkitDemo
//
//  Created by MrLQ  on 2020/5/28.
//  Copyright © 2020 Shenzhen Zego Technology Company Limited. All rights reserved.
//

#import "TLArrangePopView.h"

@interface TLArrangePopView () <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation TLArrangePopView

#pragma mark - Init
- (instancetype)initWithFrame:(CGRect)frame
                showViewFrame:(CGRect)showFrame
                  clickHidden:(BOOL)clickHidden {
    self = [super initWithFrame:frame showViewFrame:showFrame clickHidden:clickHidden];
    if (self) {
        [self setupUI];
        [self.tableView reloadData];
    }
    return self;
}

- (void)onhidePopupView {
    [super onhidePopupView];
}

- (void)setupUI {
    self.touchView.backgroundColor = UIColor.clearColor;
    self.showView.layer.cornerRadius = 3;
    //增加阴影块
    CALayer *shadowLayer0 = [[CALayer alloc] init];
    shadowLayer0.frame = self.showView.bounds;
    shadowLayer0.shadowColor = [UIColor colorWithRed:101.0f/255.0f green:102.0f/255.0f blue:110.0f/255.0f alpha:0.3f].CGColor;
    shadowLayer0.shadowOpacity = 1;
    shadowLayer0.shadowOffset = CGSizeMake(0, 0);
    shadowLayer0.shadowRadius = 4;
    CGFloat shadowSize0 = 0;
    CGRect shadowSpreadRect0 = CGRectMake(-shadowSize0, -shadowSize0, self.showView.bounds.size.width+shadowSize0*2, self.showView.bounds.size.height+shadowSize0*2);
    UIBezierPath *shadowPath0 = [UIBezierPath bezierPathWithRoundedRect:shadowSpreadRect0 cornerRadius:3];
    shadowLayer0.shadowPath = shadowPath0.CGPath;
    [self.showView.layer addSublayer:shadowLayer0];

}

#pragma mark - TableViewDelegate & DataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TLArrangePopViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TLArrangePopViewCell"];
    NSDictionary *dict = self.arrangeData[indexPath.row];
    cell.textLabel.text = dict[@"name"];
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.arrangeData.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *selectedData = self.arrangeData[indexPath.row];
    if(self.arrangeblock)
        self.arrangeblock(selectedData);
    [self onhidePopupView];
}

#pragma mark - Public
- (CGFloat)caculateTheBestWidth {
    CGFloat maxWidth = 0;
    NSArray *data = self.arrangeData;
    for (NSDictionary *dic in data) {
        NSString *name = dic[@"name"];
        CGSize size = [name sizeForFont:[UIFont boldSystemFontOfSize:15]
                                   size:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX)
                                   mode:NSLineBreakByWordWrapping];
        CGFloat width = size.width + (36 + 40 + 12 + 72) * 0.5;
        if (width > maxWidth) {
            maxWidth = width;
        }
    }
    return maxWidth;
}

#pragma mark - Private
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    CGPoint maskPoint = [self convertPoint:point toView:self.tableView];
    if ([self.tableView pointInside:maskPoint withEvent:event] && self.hidden == NO) {
        return self.tableView;
    }else {
        [self onhidePopupView];
        return [super hitTest:point withEvent:event];
    }
}

#pragma mark - Getter
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.showView.bounds];
        _tableView.layer.cornerRadius = 3;
        _tableView.layer.masksToBounds = YES;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.scrollEnabled = NO;
        _tableView.rowHeight = 81 * 0.5;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        _tableView.separatorColor = UIColorHex(#f1f1f1);
        _tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.showView.width, 5)];
        _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.showView.width, 5)];
        [_tableView registerClass:[TLArrangePopViewCell class] forCellReuseIdentifier:@"TLArrangePopViewCell"];
        [self.showView addSubview:_tableView];
    }
    return _tableView;
}

@end

@interface TLArrangePopViewCell ()
@property (nonatomic, copy) NSDictionary *dict;
@end

@implementation TLArrangePopViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    [self setSeparatorInset:UIEdgeInsetsMake(0, 15, 0, 15)];
    
    self.textLabel.font = REGULAR_FONT(15);
    self.textLabel.textColor = UIColorHex(000000);
    self.textLabel.textAlignment = NSTextAlignmentCenter;
    [self setSelectionStyle:UITableViewCellSelectionStyleNone];
    [self.textLabel sizeToFit];

    [self.textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mas_centerY);
        make.width.equalTo(self.mas_width);
    }];
}

@end

