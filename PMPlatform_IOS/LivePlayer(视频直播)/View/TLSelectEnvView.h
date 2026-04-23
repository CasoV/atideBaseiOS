//
//  TLSelectEnvView.h
//  ZegoRoomkitDemo
//
//  Created by xia on 2021/6/7.
//  Copyright © 2021 zego. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TLSelectEnvView : UIView

@property (nonatomic, copy) void(^selectEnvBlock)(NSInteger env);

- (instancetype)initWithSelectedEnv:(NSInteger)env;

- (void)selectEnv:(NSInteger)env;

@end

NS_ASSUME_NONNULL_END
