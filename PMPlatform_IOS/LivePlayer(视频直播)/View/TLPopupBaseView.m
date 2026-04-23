//
//  TLPopupBaseView.m
//  ZegoRoomkitDemo
//
//  Created by MrLQ  on 2018/11/1.
//  Copyright © 2018 Shenzhen Zego Technology Company Limited. All rights reserved.
//

#import "TLPopupBaseView.h"

@implementation ZegoPopupBaseView

- (instancetype)initWithFrame:(CGRect)frame showViewFrame:(CGRect)showFrame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setUIView:showFrame clickHidden:YES];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame showViewFrame:(CGRect)showFrame clickHidden:(BOOL)clickHidden {
    self = [super initWithFrame:frame];
    if (self) {
        [self setUIView:showFrame clickHidden:NO];
    }
    return self;
}

- (void)setUIView:(CGRect)showFrame clickHidden:(BOOL)clickHidden {
    self.touchView = [UIButton buttonWithType:UIButtonTypeCustom];
    self.touchView.backgroundColor = [UIColor zego_colorWithRGB:@"#000000" alpha:0.15];
    self.touchView.frame = self.bounds;
    if (clickHidden) {
        [((UIButton *) self.touchView) addTarget:self action:@selector(onhidePopupView) forControlEvents:UIControlEventTouchUpInside];
    }
    [self addSubview:self.touchView];

    self.showView = [[UIView alloc] initWithFrame:showFrame];
    [self addSubview:self.showView];
}

- (void)onhidePopupView {
    [self endEditing:YES];
    self.hidden = YES;
    
    if ([self.popDelegate respondsToSelector:@selector(onHidePopupView)]) {
        [self.popDelegate onHidePopupView];
    }
}

@end
