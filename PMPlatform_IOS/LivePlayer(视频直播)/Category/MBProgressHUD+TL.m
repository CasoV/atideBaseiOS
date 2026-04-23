//
//  MBProgressHUD+GW.m
//  GWDefender
//
//  Created by dingguilin1 on 2019/1/5.
//  Copyright © 2019 Liu Jun. All rights reserved.
//

#import "MBProgressHUD+TL.h"

@implementation MBProgressHUD (TL)

/**
 *  =======显示信息
 *  @param text 信息内容
 *  @param icon 图标
 *  @param view 显示的视图
 */
+ (void)show:(NSString *)text icon:(NSString *)icon view:(UIView *)view withFinishBlock:(finishBlock)block afterDelay:(CGFloat)delay
{
    if (view == nil) view = [UIApplication sharedApplication].keyWindow;
    // 快速显示一个提示信息
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    
    hud.detailsLabel.text = text;
    hud.detailsLabel.font = MEDIUM_FONT(16);
    // 设置图片
    hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"MBProgressHUD.bundle/%@", icon]]];
    // 再设置模式
    hud.mode = MBProgressHUDModeCustomView;
    hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
    hud.bezelView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
    hud.contentColor = [UIColor whiteColor];
    hud.bezelView.layer.cornerRadius = 10.0;
    hud.margin = 14;
    // 隐藏时候从父控件中移除
    hud.removeFromSuperViewOnHide = YES;
    
    if (delay <= 0) {
        // 2秒之后再消失
        if (text.length<20) {
            [hud hideAnimated:YES afterDelay:1.2];
        }else{
            [hud hideAnimated:YES afterDelay:2.2];
        }
    }else{
        [hud hideAnimated:YES afterDelay:delay];
    }
    
        
    hud.completionBlock = ^{
        if (block) {
            block();
        }
    };
}

+ (void)show:(NSString *)text icon:(NSString *)icon view:(UIView *)view withFinishBlock:(finishBlock)block
{
    [self show:text icon:icon view:view withFinishBlock:block afterDelay:0];
}


/**
 *  =======显示 提示信息
 *  @param success 信息内容
 */
+ (void)showSuccess:(NSString *)success withFinishBlock:(finishBlock)block
{
    [self showSuccess:success toView:nil withFinishBlock:block];
}

/**
 *  =======显示
 *  @param success 信息内容
 */
+ (void)showSuccess:(NSString *)success toView:(UIView *)view withFinishBlock:(finishBlock)block
{
    [self show:success icon:@"success.png" view:view withFinishBlock:block];
}

/**
 *  =======显示错误信息
 */
+ (void)showError:(NSString *)error withFinishBlock:(finishBlock)block
{
    [self showError:error toView:nil withFinishBlock:block];
}
+ (void)showError:(NSString *)error toView:(UIView *)view withFinishBlock:(finishBlock)block {
    [self show:error icon:@"error.png" view:view withFinishBlock:block];
}


+ (void)showError:(NSString *)error withFinishBlock:(finishBlock)block afterDelay:(CGFloat)delay
{
    [self showError:error toView:nil withFinishBlock:block afterDelay:delay];
}
+ (void)showError:(NSString *)error toView:(UIView *)view withFinishBlock:(finishBlock)block afterDelay:(CGFloat)delay{
    [self show:error icon:@"error.png" view:view withFinishBlock:block afterDelay:delay];
}

/**
 *  显示提示 + 菊花
 *  @param message 信息内容
 *  @return 直接返回一个MBProgressHUD， 需要手动关闭(  ?
 */
+ (MBProgressHUD *)showMessage:(NSString *)message
{
    return [self showMessage:message toView:nil];
}

/**
 *  显示一些信息
 *  @param message 信息内容
 *  @param view    需要显示信息的视图
 *  @return 直接返回一个MBProgressHUD，需要手动关闭
 */
+ (MBProgressHUD *)showMessage:(NSString *)message toView:(UIView *)view {
    if (view == nil) view = [UIApplication sharedApplication].keyWindow;
    // 快速显示一个提示信息
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.label.text = message;
    hud.label.font = MEDIUM_FONT(16);
    // 隐藏时候从父控件中移除
    hud.removeFromSuperViewOnHide = YES;
    // YES代表需要蒙版效果
//    hud.dimBackground = YES;
    hud.backgroundView.backgroundColor = [[UIColor colorWithHexString:@"04040F"] colorWithAlphaComponent:0.4];
    
    return hud;
}

+ (void)showNetworkStatusWithMessage:(NSString *)message {
//    [self showStatusWithImage:@"other_img_wrong_window" message:message isAutoDismiss:NO withFinishBlock:nil];
    [self showNetworkStatusWithMessage:message toView:nil];
}
+ (void)showNetworkStatusWithMessage:(NSString *)message toView:(UIView *)view {
//    [self showStatusWithImage:@"other_img_wrong_window" message:message toView:view isAutoDismiss:NO withFinishBlock:nil];
    if (view == nil) view = [UIApplication sharedApplication].keyWindow;
    // 快速显示一个提示信息
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.label.text = message;
    hud.label.font = MEDIUM_FONT(16);
    hud.contentColor = [UIColor whiteColor];
    hud.bezelView.backgroundColor = [UIColor blackColor];
    // 隐藏时候从父控件中移除
    hud.removeFromSuperViewOnHide = YES;
}

/**
 *  手动关闭MBProgressHUD
 */
+ (void)hideHUD
{
    [self hideHUDForView:nil];
}
/**
 *  @param view    显示MBProgressHUD的视图
 */
+ (void)hideHUDForView:(UIView *)view {
    __block UIView *blockView = view;
    if (blockView == nil){
        blockView = [UIApplication sharedApplication].keyWindow;
    }
    if ([[NSThread currentThread] isMainThread]) {
        [self hideHUDForView:blockView animated:NO];
    } else {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self hideHUDForView:blockView animated:NO];
        });
    }
    
}

@end
