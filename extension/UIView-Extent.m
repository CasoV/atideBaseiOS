//
//  UIView-Extent.m
//  YNXYJTXXPT
//
//  Created by vxg on 2017/07/21.
//  Copyright © 2017年 末末班车. All rights reserved.
//

#import "UIView-Extent.h"

@implementation UIView (Extent)

- (UIViewController*)viewController {
    for (UIView* next = [self superview]; next; next = next.superview) {
        UIResponder* nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController*)nextResponder;
        }
    }
    return nil;
}
@end
