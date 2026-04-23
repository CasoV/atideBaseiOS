//
//  TLPopupBaseView.h
//  ZegoRoomkitDemo
//
//  Created by MrLQ  on 2018/11/1.
//  Copyright © 2018 Shenzhen Zego Technology Company Limited. All rights reserved.
//


NS_ASSUME_NONNULL_BEGIN

@protocol ZegoPopupBaseViewDelegate <NSObject>
@optional
- (void)onHidePopupView;
@end

@interface ZegoPopupBaseView : UIView

@property (nonatomic, strong) UIView *touchView;  //点击视图
@property (nonatomic, strong) UIView *showView;   //显示视图
@property (nonatomic, weak) id<ZegoPopupBaseViewDelegate> popDelegate;

- (instancetype)initWithFrame:(CGRect)frame showViewFrame:(CGRect)showFrame;
- (instancetype)initWithFrame:(CGRect)frame showViewFrame:(CGRect)showFrame clickHidden:(BOOL)clickHidden;

- (void)onhidePopupView;

@end

NS_ASSUME_NONNULL_END
