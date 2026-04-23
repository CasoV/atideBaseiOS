//
//  ApprovalCommentModel.m
//  PMPlatform_IOS
//
//  Created by 末末班车 on 2017/9/11.
//  Copyright © 2017年 com.atide. All rights reserved.
//

#import "ApprovalCommentModel.h"

@implementation ApprovalCommentModel

- (CGFloat)rowHeight {
    CGFloat width = ScreenWidth - 163.5;
    
    CGSize size = [self.message boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15.f]} context:nil].size;
    
    CGFloat height;
    
    if (size.height <= 30) {
        height = 30;
    } else {
        height = size.height + 2.5;
    }
    
    return height + 50;
}

@end
