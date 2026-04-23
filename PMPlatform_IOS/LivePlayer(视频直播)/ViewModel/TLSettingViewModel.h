//
//  TLSettingViewModel.h
//  ZegoRoomkitDemo
//
//  Created by Kael Ding on 2020/7/17.
//  Copyright © 2020 zego. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TLSettingCellConfig.h"

NS_ASSUME_NONNULL_BEGIN

@interface TLSettingViewModel : NSObject

@property (nonatomic, strong) NSArray<NSArray<TLSettingCellConfig *> *> *dataSource;

@property (nonatomic, copy) void (^meetingSettingBlock)(void);
@property (nonatomic, copy) void (^uiSettingBlock)(void);
@property (nonatomic, copy) void (^testSettingBlock)(void);
@property (nonatomic, copy) void (^uploadLogBlock)(void);
@property (nonatomic, copy) void (^loginoutBlock)(void);
@property (nonatomic, copy) void (^clearCacheBlock)(void);
@property (nonatomic, copy) void (^feedbackBlock)(void);
@property (nonatomic, copy) void (^accessEnvBlock)(void);

- (void)updateEnvSubtitle:(NSString *)subtitle;

@end

NS_ASSUME_NONNULL_END
