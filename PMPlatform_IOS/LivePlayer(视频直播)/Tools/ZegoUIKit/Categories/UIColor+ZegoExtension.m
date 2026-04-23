//
//  UIColor+ZegoExtension.m
//  ZegoEducation
//
//  Created by zego on 2019/12/3.
//  Copyright © 2019 Shenzhen Zego Technology Company Limited. All rights reserved.
//

#import "UIColor+ZegoExtension.h"

@implementation UIColor (ZegoExtension)

+ (UIColor *)zego_colorWithRGB:(NSString *)hexColor {
    return [UIColor zego_colorWithRGB:hexColor alpha:1];
}

+ (UIColor *)zego_colorWithRGB:(NSString *)hexColor alpha:(CGFloat)alpha {
    NSString *str = nil;
    if ([hexColor rangeOfString:@"#"].length > 0) {
        str = [hexColor substringFromIndex:1];
    } else {
        str = hexColor;
    }
    if (str.length <= 0) return [UIColor clearColor];

    unsigned int red, green, blue;
    NSRange range;
    range.length = 2;
    range.location = 0;
    [[NSScanner scannerWithString:[str substringWithRange:range]] scanHexInt:&red];
    range.location = 2;
    [[NSScanner scannerWithString:[str substringWithRange:range]] scanHexInt:&green];
    range.location = 4;
    [[NSScanner scannerWithString:[str substringWithRange:range]] scanHexInt:&blue];

    return [UIColor colorWithRed:(float) (red / 255.0f) green:(float) (green / 255.0f) blue:(float) (blue / 255.0f) alpha:alpha];
}

+ (UIColor*)zego_randomColor
{
    NSInteger aRedValue = arc4random() % 255;
    NSInteger aGreenValue = arc4random() % 255;
    NSInteger aBlueValue = arc4random() % 255;
    UIColor *randColor = [UIColor colorWithRed:aRedValue / 255.0f green:aGreenValue / 255.0f blue:aBlueValue / 255.0f alpha:1.0f];
    return randColor;
}

@end
