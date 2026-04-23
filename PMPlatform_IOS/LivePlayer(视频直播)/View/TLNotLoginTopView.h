//
//  TLNotLoginTopView.h
//  ZegoRoomkitDemo
//
//  Created by KaelDing on 2020/7/15.
//  Copyright © 2020 zego. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, TLTopButtonType) {
    TLTopButtonTypeQuickJoin = 0,
    TLTopButtonTypeTestLogin,
};

@protocol TLNotLoginTopViewDelegate <NSObject>

@optional
- (void)notLoginTopViewDidClickWithActionButton:(UIButton *)sender;

@end

@interface TLNotLoginTopView : UIView

@property (nonatomic, weak) id<TLNotLoginTopViewDelegate> delegate;

- (void)selectTopViewActionButtonWithType:(TLTopButtonType)type;

@end

NS_ASSUME_NONNULL_END
