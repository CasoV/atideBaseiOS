//
//  TLMainPageView.m
//  ZegoRoomkitDemo
//
//  Created by Kael Ding on 2020/7/16.
//  Copyright © 2020 zego. All rights reserved.
//

#import "TLMainPageView.h"
#import "UIButton+TLButton.h"
#import "TLMeetingCell.h"
#import "ZegoRefreshHeader.h"
#import "MinimizeTipView.h"

@interface TLMainPageView ()<UITableViewDataSource, UITableViewDelegate, TLMeetingCellDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIImageView *noMeetingImageView;
@property (nonatomic, strong) UILabel *noMeetingLabel;
@property (nonatomic, strong) MinimizeTipView *minimizeTipView;
@property (nonatomic, strong) UIView *topLine;

@end

static NSString *reuseIdentifier = @"TLMeetingCellIdentifier";

@implementation TLMainPageView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
        [self registerCell];
    }
    return self;
}

- (void)setupUI {
    [self addSubview:self.tableView];
    [self addSubview:self.noMeetingImageView];
    [self addSubview:self.noMeetingLabel];
    [self addSubview:self.topLine];
    [self addSubview:self.minimizeTipView];
    
    [self.topLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.height.mas_equalTo(0.5);
        make.top.equalTo(self).offset(TOP_BAR_HEIGHT);
    }];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self);
        make.top.equalTo(self.topLine.mas_bottom);
    }];
    [self.noMeetingImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
        make.width.height.mas_equalTo(120);
    }];
    [self.noMeetingLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.noMeetingImageView);
        make.top.equalTo(self.noMeetingImageView.mas_bottom).offset(20);
        make.height.mas_equalTo(16);
    }];
}

- (void)registerCell {
    [self.tableView registerClass:[TLMeetingCell class] forCellReuseIdentifier:reuseIdentifier];
}

#pragma mark - Public
- (void)setMeetings:(NSArray *)meetings {
    if ([meetings isKindOfClass:[NSNull class]]) {
        meetings = @[];
    }
    _meetings = meetings;
    BOOL haveData = meetings.count;
    self.noMeetingImageView.hidden = haveData;
    self.noMeetingLabel.hidden = haveData;
    [self.tableView reloadData];
}

- (void)endRefresh {
    [self.tableView.mj_header endRefreshing];
}

- (void)scrollToBottom {
    //增加一个判断 当contentSize.height > tableView高度时
    if (self.tableView.contentSize.height > self.tableView.bounds.size.height) {
        [self.tableView scrollToBottom];
    }
}

- (void)showMinimizeTip:(BOOL)isShow{
    self.minimizeTipView.hidden = !isShow;
    [self.minimizeTipView setMinimizeTipTitle];
    
    [self.minimizeTipView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.top.equalTo(self.topLine.mas_bottom);
        make.height.mas_equalTo(isShow ? 40 : 0);
    }];
    
    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self);
        make.top.equalTo(self.minimizeTipView.mas_bottom);
    }];

}

#pragma mark - action
- (void)handleRefresh:(MJRefreshHeader *)sender {
    if(self.refreshMeetingsBlock)
        self.refreshMeetingsBlock();
}

#pragma mark - UITableViewDataSource & UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.meetings.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TLMeetingCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    cell.delegate = self;
    NSDictionary *room = self.meetings[indexPath.row];
    [cell updateCellWithMeetingInfo:room];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 104;
}

#pragma mark - TLMeetingCellDelegate
- (void)pressJoinButton:(NSDictionary *)meetingInfo {
    if(self.joinMeetingBlock)
        self.joinMeetingBlock(meetingInfo);
}
- (void)pressCloseButton:(NSDictionary *)meetingInfo {
    if(self.closeMeetingBlock)
        self.closeMeetingBlock(meetingInfo);
}

#pragma mark - getter
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.estimatedRowHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.tableFooterView = [UIView new];
        _tableView.backgroundColor = [UIColor colorWithHexString:@"f5f5f5"];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.contentInset = UIEdgeInsetsMake(8, 0, 8, 0);
        ZegoRefreshHeader *refreshHeader = [ZegoRefreshHeader headerWithRefreshingTarget:self refreshingAction:@selector(handleRefresh:)];
        refreshHeader.ignoredScrollViewContentInsetTop = 8;
        _tableView.mj_header = refreshHeader;
    }
    return _tableView;
}
- (UIImageView *)noMeetingImageView {
    if (!_noMeetingImageView) {
        _noMeetingImageView = [UIImageView new];
        _noMeetingImageView.image = [UIImage imageNamed:@"nomeeting"];
    }
    return _noMeetingImageView;
}
- (UILabel *)noMeetingLabel {
    if (!_noMeetingLabel) {
        _noMeetingLabel = [UILabel new];
        _noMeetingLabel.textColor = [UIColor colorWithHexString:@"868ca0"];
        _noMeetingLabel.textAlignment = NSTextAlignmentCenter;
        _noMeetingLabel.font = MEDIUM_FONT(16);
        _noMeetingLabel.text = TLLocalizedString(room_schedule_empty);
    }
    return _noMeetingLabel;
}
- (UIView *)topLine {
    if (!_topLine) {
        _topLine = [UIView new];
        _topLine.backgroundColor = [UIColor colorWithHexString:@"f1f1f1"];
    }
    return _topLine;
}
- (MinimizeTipView *)minimizeTipView {
    if (!_minimizeTipView) {
        _minimizeTipView = [MinimizeTipView new];
    }
    return _minimizeTipView;
}

- (void)setJoinRoomBlock:(dispatch_block_t)block{
    _minimizeTipView.joinRoomBlock = block;
}
@end
