//
//  UIImageView+image.m
//  PMPlatform_IOS
//
//  Created by 末末班车 on 2017/9/13.
//  Copyright © 2017年 com.atide. All rights reserved.
//

#import "UIImageView+image.h"

@implementation UIImageView (image)

- (CGRect)getFrameSizeFromImage {
    UIImage *img = self.image;
    if (img) {
        CGFloat hfactor = img.size.width / self.frame.size.width;
        CGFloat vfactor = img.size.height / self.frame.size.height;
        
        CGFloat factor = fmaxf(hfactor, vfactor);
        
        // Divide the size by the greater of the vertical or horizontal shrinkage factor
        CGFloat newWidth = img.size.width / factor;
        CGFloat newHeight = img.size.height / factor;
        
        // Then figure out if you need to offset it to center vertically or horizontally
        CGFloat leftOffset = (self.frame.size.width - newWidth) / 2;
        CGFloat topOffset = (self.frame.size.height - newHeight) / 2;
        return CGRectMake(leftOffset, topOffset, newWidth, newHeight);
    }else {
        return CGRectZero;
    }
}

@end
