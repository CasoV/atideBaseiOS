//
//  TLRadioButton.h
//  ZegoRoomkitDemo
//
//  Created by xia on 2021/6/8.
//  Copyright © 2021 zego. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TLRadioButton : UIView

@property (nonatomic, copy) void(^actionBlock)(NSInteger tag);

- (instancetype)initWithTitle:(NSString *)title
                   isSelected:(BOOL)isSelected;

- (void)setSelected:(BOOL)selected;

@end

NS_ASSUME_NONNULL_END
