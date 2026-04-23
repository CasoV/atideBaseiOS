//
//  QualityProblemReplyModel.m
//  ycxm
//
//  Created by 末末班车 on 2018/9/30.
//  Copyright © 2018年 末末班车. All rights reserved.
//

#import "QualityProblemReplyModel.h"

@implementation QualityProblemReplyModel

- (CGFloat)rowHeight {
    CGFloat width = self.fileIds.count == 0 ? kScreen_Width - 30: kScreen_Width - 30 - 38;
    
    CGSize size = [self.content boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12.f]} context:nil].size;
    
    CGFloat height;
    
    if (size.height + 5 < 40) {
        height = 40;
    } else {
        height = size.height + 5;
    }
    
    return height + 40;
}

@end
