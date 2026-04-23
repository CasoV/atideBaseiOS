//
//  ReviewButton.m
//  HBConstructionApp
//
//  Created by 末末班车 on 2018/4/13.
//  Copyright © 2018年 atide. All rights reserved.
//

#import "ReviewButton.h"

@implementation ReviewButton

- (CGRect)imageRectForContentRect:(CGRect)contentRect {
    return CGRectMake(0, (contentRect.size.height - 15) / 2, 15, 15);
}

@end
