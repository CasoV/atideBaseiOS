//
//  TLQuickJoinView.h
//  ZegoRoomkitDemo
//
//  Created by KaelDing on 2020/7/15.
//  Copyright © 2020 zego. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TLQuickJoinView : UIView

@property (nonatomic, copy) NSString *quickJoinRoomID;
@property (nonatomic, copy) NSString *quickJoinName;
@property (nonatomic, assign) NSInteger roomType;
@property (nonatomic, assign) NSInteger role;
@property (nonatomic, assign) CGFloat bottomPoint;

@property (nonatomic, copy) void(^quickJoinBlock)(void);
@property (nonatomic, copy) void(^createBlock)(void);
@property (nonatomic, copy) void(^selectTypeBlock)(void);
@property (nonatomic, copy) void(^selectRoleBlock)(void);

- (void)setRoomTypeTitle:(NSString *)title;
- (void)setRoleTitle:(NSString *)title;

- (void)resignFirstResponder;

- (void)updateJoinButtonToEnable:(BOOL)enabled;

@end

NS_ASSUME_NONNULL_END
