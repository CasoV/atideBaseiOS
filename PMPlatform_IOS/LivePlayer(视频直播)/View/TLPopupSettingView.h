//
//  TLPopupSettingView.h
//  ZegoRoomkitDemo
//
//  Created by xia on 2021/6/7.
//  Copyright © 2021 zego. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TLPopupBaseView.h"

NS_ASSUME_NONNULL_BEGIN

@interface TLPopupSettingView : ZegoPopupBaseView

@property (nonatomic, copy) void(^actionBlock)(NSInteger index);

//- (instancetype)initWithTitle:(NSString *)title options:(NSArray<NSDictionary *> *)options;

+ (TLPopupSettingView *)addPopupSettingViewWithTitle:(NSString *)title
                                             options:(NSArray *)options
                                              onView:(UIView *)view;

@end

NS_ASSUME_NONNULL_END
