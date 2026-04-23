//
//  TLMeetingCell.m
//  ZegoRoomkitDemo
//
//  Created by Larry on 2020/6/9.
//  Copyright © 2020 zego. All rights reserved.
//

#import "TLMeetingCell.h"
#import "UIButton+TLButton.h"
#import "UIButton+Edge.h"
#import "TLManager.h"

@interface TLMeetingCell()

@property (nonatomic, strong) UIView *backContentView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *meetingNumberLabel;
@property (nonatomic, strong) UILabel *startTimeLabel;
@property (nonatomic, strong) UILabel *endTimeLabel;
@property (nonatomic, strong) UIButton *joinButton;
@property (nonatomic, strong) UIButton *closeButton;
@property (nonatomic, strong) UIView *lineView;

@end

@implementation TLMeetingCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.backgroundColor = [UIColor colorWithHexString:@"f5f5f5"];
    
    [self.contentView addSubview:self.backContentView];
    [self.backContentView addSubview:self.titleLabel];
    [self.backContentView addSubview:self.meetingNumberLabel];
    [self.backContentView addSubview:self.joinButton];
    [self.backContentView addSubview:self.closeButton];
    [self.backContentView addSubview:self.startTimeLabel];
    [self.backContentView addSubview:self.endTimeLabel];
    [self.backContentView addSubview:self.lineView];
   
    self.closeButton.hidden = ![[TLManager sharedInstance] isLogin];;
    
    [self.backContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(16);
        make.right.equalTo(self.contentView).offset(-16);
        make.top.equalTo(self.contentView).offset(8);
        make.bottom.equalTo(self.contentView).offset(-8);
    }];
    [self.startTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.backContentView).offset(16);
        make.bottom.equalTo(self.backContentView.mas_centerY).offset(-7.5);
        make.height.mas_equalTo(14);
        make.width.mas_equalTo(40);
    }];
    [self.endTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.backContentView).offset(16);
        make.top.equalTo(self.backContentView.mas_centerY).offset(7.5);
        make.height.mas_equalTo(14);
        make.width.mas_equalTo(40);
    }];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.startTimeLabel.mas_right).offset(14);
        make.centerY.equalTo(self.backContentView);
        make.height.mas_equalTo(40);
        make.width.mas_equalTo(1);
    }];
    [self.joinButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.backContentView).offset(-16);
        make.bottom.equalTo(self.backContentView).offset(-20);
        make.width.mas_equalTo(60);
        make.height.mas_equalTo(27);
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.lineView.mas_right).offset(14);
        make.right.equalTo(self.joinButton.mas_left).offset(-16);
        make.centerY.equalTo(self.startTimeLabel);
        make.height.mas_equalTo(17);
    }];
    [self.meetingNumberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.lineView.mas_right).offset(14);
        make.top.equalTo(self.titleLabel.mas_bottom).offset(13);
        make.height.mas_equalTo(14);
    }];
    [self.closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.backContentView).offset(-7);
        make.top.equalTo(self.backContentView).offset(7);
        make.width.height.mas_equalTo(15);
    }];
}


#pragma mark - Public
/*
- (void)updateCellWithMeetingInfo:(ZegoRoomDetailInfo *)meetingInfo {
    self.meetingInfo = meetingInfo;
    self.titleLabel.text = meetingInfo.baseInfo.subject;
    self.titleLabel.lineBreakMode = NSLineBreakByTruncatingMiddle;
    self.meetingNumberLabel.text = [NSString stringWithFormat:@"%@ %@", TLLocalizedString(room_id),meetingInfo.roomID];
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDate *startDate = [NSDate dateWithTimeIntervalSince1970:meetingInfo.baseInfo.scheduleBeginTimestamp / 1000];
    NSDateComponents *startComponents = [calendar components:NSCalendarUnitHour|NSCalendarUnitMinute fromDate:startDate];
    
    NSDate *endDate = [NSDate dateWithTimeIntervalSince1970:(meetingInfo.baseInfo.scheduleBeginTimestamp + meetingInfo.baseInfo.scheduleDuration * 60000) / 1000];
    NSDateComponents *endComponents = [calendar components:NSCalendarUnitHour|NSCalendarUnitMinute fromDate:endDate];
    
    self.startTimeLabel.text = [NSString stringWithFormat:@"%.2ld:%.2ld", (long)startComponents.hour, (long)startComponents.minute];
    self.endTimeLabel.text = [NSString stringWithFormat:@"%.2ld:%.2ld", (long)endComponents.hour, (long)endComponents.minute];
}
 */

- (void)updateCellWithMeetingInfo:(NSDictionary *)meetingInfo {
    self.meetingInfo = meetingInfo;
    self.titleLabel.text = meetingInfo[@"subject"];
    self.titleLabel.lineBreakMode = NSLineBreakByTruncatingMiddle;
    
    if([[TLManager sharedInstance] isLogin]){
        self.meetingNumberLabel.text = [NSString stringWithFormat:@"%@ %@", TLLocalizedString(room_id), meetingInfo[@"room_id"]];
    }else{
        self.meetingNumberLabel.text = [NSString stringWithFormat:@"创建人: %@", meetingInfo[@"host_name"]];
    }
    
    
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDate *startDate = [NSDate dateWithTimeIntervalSince1970:[meetingInfo[@"begin_timestamp"] integerValue] / 1000];
    NSDateComponents *startComponents = [calendar components:NSCalendarUnitHour|NSCalendarUnitMinute fromDate:startDate];
    
    NSDate *endDate = [NSDate dateWithTimeIntervalSince1970:([meetingInfo[@"begin_timestamp"] integerValue]+ [meetingInfo[@"duration"] integerValue] * 60000) / 1000];
    NSDateComponents *endComponents = [calendar components:NSCalendarUnitHour|NSCalendarUnitMinute fromDate:endDate];
    
    self.startTimeLabel.text = [NSString stringWithFormat:@"%.2ld:%.2ld", (long)startComponents.hour, (long)startComponents.minute];
   
    if([[TLManager sharedInstance] isLogin]){
        self.endTimeLabel.text = [NSString stringWithFormat:@"%.2ld:%.2ld", (long)endComponents.hour, (long)endComponents.minute];
    }else{
        self.endTimeLabel.text = @"--:--";
    }
}

#pragma mark - action
- (void)joinButtonClick:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(pressJoinButton:)]) {
        [self.delegate pressJoinButton:self.meetingInfo];
    }
}
- (void)closeButtonClick:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(pressCloseButton:)]) {
        [self.delegate pressCloseButton:self.meetingInfo];
    }
}

#pragma mark - getter
- (UIView *)backContentView {
    if (!_backContentView) {
        _backContentView = [UIView new];
        _backContentView.backgroundColor = [UIColor whiteColor];
        _backContentView.layer.cornerRadius = 8;
    }
    return _backContentView;
}
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        _titleLabel.textColor = [UIColor colorWithHexString:@"040404"];
        _titleLabel.font = REGULAR_FONT(17);
    }
    return _titleLabel;
}
- (UILabel *)meetingNumberLabel {
    if (!_meetingNumberLabel) {
        _meetingNumberLabel = [UILabel new];
        _meetingNumberLabel.textAlignment = NSTextAlignmentLeft;
        _meetingNumberLabel.textColor = [UIColor colorWithHexString:@"868ca0"];
        _meetingNumberLabel.font = REGULAR_FONT(14);
    }
    return _meetingNumberLabel;
}
- (UILabel *)startTimeLabel {
    if (!_startTimeLabel) {
        _startTimeLabel = [UILabel new];
        _startTimeLabel.textAlignment = NSTextAlignmentCenter;
        _startTimeLabel.textColor = [UIColor colorWithHexString:@"303030"];
        _startTimeLabel.font = MEDIUM_FONT(14);
    }
    return _startTimeLabel;
}
- (UILabel *)endTimeLabel {
    if (!_endTimeLabel) {
        _endTimeLabel = [UILabel new];
        _endTimeLabel.textAlignment = NSTextAlignmentCenter;
        _endTimeLabel.textColor = [UIColor colorWithHexString:@"303030"];
        _endTimeLabel.font = MEDIUM_FONT(14);
    }
    return _endTimeLabel;
}
- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [UIView new];
        _lineView.backgroundColor = [UIColor colorWithHexString:@"f1f1f1"];
    }
    return _lineView;
}
- (UIButton *)joinButton {
    if (!_joinButton) {
        _joinButton = [UIButton actionButtonWithTitle:TLLocalizedString(room_join)];
        _joinButton.titleLabel.font = MEDIUM_FONT(13);
        _joinButton.layer.cornerRadius = 4;
        [_joinButton addTarget:self action:@selector(joinButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _joinButton;
}
- (UIButton *)closeButton {
    if (!_closeButton) {
        _closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_closeButton setImage:[UIImage imageNamed:@"shutdown"] forState:UIControlStateNormal];
        [_closeButton addTarget:self action:@selector(closeButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [_closeButton setEnlargeEdge:20];
    }
    return _closeButton;
}

@end
