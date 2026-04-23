//
//  TLMeetingCell.h
//  ZegoRoomkitDemo
//
//  Created by Larry on 2020/6/9.
//  Copyright © 2020 zego. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol TLMeetingCellDelegate <NSObject>

- (void)pressJoinButton:(NSDictionary *)meetingInfo;
- (void)pressCloseButton:(NSDictionary *)meetingInfo;

@end

@interface TLMeetingCell : UITableViewCell

@property (nonatomic, weak) id<TLMeetingCellDelegate> delegate;
@property (nonatomic, strong) NSDictionary *meetingInfo;

- (void)updateCellWithMeetingInfo:(NSDictionary *)meetingInfo;

@end

NS_ASSUME_NONNULL_END
