//
//  MinimizeTipView.h
//  ZegoRoomkitDemo
//
//  Created by zego on 2021/3/22.
//  Copyright © 2021 zego. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MinimizeTipView : UIView

@property (strong, nonatomic) UILabel *labelRoom;
@property (strong, nonatomic) UIButton *buttonJoin;
@property (strong, nonatomic) UIImageView *imageRoom;
@property (copy, nonatomic) dispatch_block_t joinRoomBlock;

- (void)setMinimizeTipTitle;

@end

NS_ASSUME_NONNULL_END
