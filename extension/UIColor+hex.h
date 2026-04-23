//
//  UIColor+hex.h
//  YNXYJTXXPT
//
//  Created by 末末班车 on 2017/6/26.
//  Copyright © 2017年 末末班车. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (hex)
    
+ (UIColor *)hex:(NSString *)hex alpha:(CGFloat) alpha;
    
+ (UIColor *)hex:(NSString *)hex;
    
+ (UIColor *)applicationColor;

+ (UIColor *)buttonBlueColor;

+ (UIColor *)navigationBgColor;

@end
