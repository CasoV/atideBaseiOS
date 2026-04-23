//
//  MBProgressHUD+GW.h
//  GWDefender
//
//  Created by dingguilin1 on 2019/1/5.
//  Copyright © 2019 Liu Jun. All rights reserved.
//

#import <MBProgressHUD/MBProgressHUD.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^finishBlock)(void);

@interface MBProgressHUD (TL)


/**
 展示成功界面

 @param success 消息内容
 @param block 销毁block
 */
+ (void)showSuccess:(NSString *)success withFinishBlock:(nullable finishBlock)block;

/**
 展示成功消息

 @param success 内容
 @param view view
 @param block 销毁block
 */
+ (void)showSuccess:(NSString *)success toView:(nullable UIView *)view withFinishBlock:(nullable finishBlock)block;


/**
 展示错误消息

 @param error 消息内容
 @param block 销毁回调
 */
+ (void)showError:(NSString *)error withFinishBlock:(nullable finishBlock)block;
+ (void)showError:(NSString *)error withFinishBlock:(nullable finishBlock)block afterDelay:(CGFloat)delay;


/**
 展示错误消息

 @param error 内容
 @param view view
 @param block 销毁回调
 */
+ (void)showError:(NSString *)error toView:(nullable UIView *)view withFinishBlock:(nullable finishBlock)block;


/**
 展示消息:需要手动dismiss

 @param message 内容
 @return hud
 */
+ (MBProgressHUD *)showMessage:(NSString *)message;
+ (MBProgressHUD *)showMessage:(NSString *)message toView:(nullable UIView *)view;


/**
 网络请求加载过程

 @param message 消息内容
 */
+ (void)showNetworkStatusWithMessage:(NSString *)message;

/**
 网络请求加载过程

 @param message 消息内容
 @param view 展示view
 */
+ (void)showNetworkStatusWithMessage:(NSString *)message toView:(nullable UIView *)view;


/**
 隐藏hud
 */
+ (void)hideHUD;


/**
 隐藏hud

 @param view view
 */
+ (void)hideHUDForView:(nullable UIView *)view;


@end

NS_ASSUME_NONNULL_END
