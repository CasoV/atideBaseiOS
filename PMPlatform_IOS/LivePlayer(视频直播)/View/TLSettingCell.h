//
//  TLSettingCell.h
//  ZegoRoomkitDemo
//
//  Created by Kael Ding on 2020/7/19.
//  Copyright © 2020 zego. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TLSettingCellConfig.h"

NS_ASSUME_NONNULL_BEGIN

@protocol TLMeetingSettingCellDelegate <NSObject>

- (void)switchButtonClickWithConfig:(TLSettingCellConfig *)config isSwitchOn:(BOOL)isSwitchOn;

@end

@interface TLSettingCell : UITableViewCell

@property (nonatomic, strong) TLSettingCellConfig *config;
@property (nonatomic, weak) id<TLMeetingSettingCellDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
