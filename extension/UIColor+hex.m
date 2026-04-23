//
//  UIColor+hex.m
//  YNXYJTXXPT
//
//  Created by 末末班车 on 2017/6/26.
//  Copyright © 2017年 末末班车. All rights reserved.
//

#import "UIColor+hex.h"

@implementation UIColor (hex)
    
+ (UIColor *)applicationColor {
    return [UIColor hex:@"f2f2f2"];
}

+ (UIColor *)buttonBlueColor {
    return [UIColor hex:@"007AFF"];
}

+ (UIColor *)navigationBgColor {
    return [UIColor hex:@"1A4EB4"];
}
    
+ (UIColor *)hex:(NSString *)hex {
    return  [UIColor hex:hex alpha:1.0];
}
    
+ (UIColor *)hex:(NSString *)hex alpha:(CGFloat)alpha {
    NSString * cString = [[hex stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] uppercaseString];
    // String should be 6 or 8 characters
    if (cString.length < 6) {
        return [UIColor clearColor];
    }
    
    // strip 0X if it appears
    //如果是0x开头的，那么截取字符串，字符串从索引为2的位置开始，一直到末尾
    if ([cString hasPrefix:@"0X"]) {
        cString = [cString substringFromIndex:2];
    }
    
    //如果是#开头的，那么截取字符串，字符串从索引为1的位置开始，一直到末尾
    if ([cString hasPrefix:@"#"]) {
        cString = [cString substringFromIndex:1];
    }

    if (cString.length != 6) {
        return [UIColor clearColor];
    }
    
    // Separate into r, g, b substrings
    NSString *rString = [cString substringWithRange:NSMakeRange(0, 2)];
    NSString *gString = [cString substringWithRange:NSMakeRange(2, 2)];
    NSString *bString = [cString substringWithRange:NSMakeRange(4, 2)];
    unsigned int r = 0;
    unsigned int g = 0;
    unsigned int b = 0;
    [[[NSScanner alloc] initWithString:rString] scanHexInt:&r];
    [[[NSScanner alloc] initWithString:gString] scanHexInt:&g];
    [[[NSScanner alloc] initWithString:bString] scanHexInt:&b];
    return [[UIColor alloc] initWithRed:r / 255.0 green:g / 255.0 blue:b / 255.0 alpha:alpha];
}

@end
