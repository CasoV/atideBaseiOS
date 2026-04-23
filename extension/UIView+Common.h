//
//  UIView+Common.h
//  ycTest
//
//  Created by 末末班车 on 2018/9/12.
//  Copyright © 2018年 末末班车. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Common)

- (UIViewController *)findViewController;

- (void)doBorderWidth:(CGFloat)width color:(UIColor *)color cornerRadius:(CGFloat)cornerRadius;

+ (UIView *)lineViewWithPointYY:(CGFloat)pointY;
+ (UIView *)lineViewWithPointYY:(CGFloat)pointY andColor:(UIColor *)color;
+ (UIView *)lineViewWithPointYY:(CGFloat)pointY andColor:(UIColor *)color andLeftSpace:(CGFloat)leftSpace;

@end
