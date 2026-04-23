//
//  UnderlineButton.m
//  ConstructionApp
//
//  Created by 末末班车 on 2017/12/22.
//  Copyright © 2017年 atide. All rights reserved.
//

#import "UnderlineButton.h"

#define kUnderlineH 2
#define kMargin 10

@implementation UnderlineButton

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
}

- (CGRect) titleRectForContentRect:(CGRect)contentRect {
    return CGRectMake(0, 0, CGRectGetWidth(contentRect), CGRectGetHeight(contentRect) - kUnderlineH);
}

- (CGRect) imageRectForContentRect:(CGRect)contentRect {
    return CGRectMake(kMargin / 2, CGRectGetHeight(contentRect) - kUnderlineH, CGRectGetWidth(contentRect) - kMargin, kUnderlineH);
}

@end
