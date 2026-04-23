//
//  UIColor+ZegoExtension.h
//  ZegoEducation
//
//  Created by zego on 2019/12/3.
//  Copyright © 2019 Shenzhen Zego Technology Company Limited. All rights reserved.
//
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIColor (ZegoExtension)

//建议使用UIColor类别。
+ (UIColor *)zego_colorWithRGB:(NSString *)hexColor;
//建议使用UIColor类别。
+ (UIColor *)zego_colorWithRGB:(NSString *)hexColor alpha:(CGFloat)alpha;

//随机颜色
+ (UIColor*)zego_randomColor;

@end

NS_ASSUME_NONNULL_END
