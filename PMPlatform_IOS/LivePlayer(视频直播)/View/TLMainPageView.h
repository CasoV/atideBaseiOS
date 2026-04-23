//
//  TLMainPageView.h
//  ZegoRoomkitDemo
//
//  Created by Kael Ding on 2020/7/16.
//  Copyright © 2020 zego. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TLMainPageView : UIView

@property (nonatomic, strong) NSArray<NSDictionary *> *meetings;
@property (nonatomic, copy) void (^joinMeetingBlock)(NSDictionary* meetingInfo);
@property (nonatomic, copy) void (^closeMeetingBlock)(NSDictionary* meetingInfo);
@property (nonatomic, copy) void (^refreshMeetingsBlock)(void);
@property (copy, nonatomic) dispatch_block_t joinRoomBlock;

/// 停止下拉刷新
- (void)endRefresh;

/// 滚动到底部
- (void)scrollToBottom;

/// 最小化提示
- (void)showMinimizeTip:(BOOL)isShow;

@end

NS_ASSUME_NONNULL_END
