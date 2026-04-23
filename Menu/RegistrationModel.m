//
//  RegistrationModel.m
//  YNXYJTXXPT
//
//  Created by 末末班车 on 2017/7/18.
//  Copyright © 2017年 末末班车. All rights reserved.
//

#import "RegistrationModel.h"

@implementation RegistrationModel

- (CGFloat)getLabelWidth {
    CGSize size = [self.name sizeWithAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:12]}];
    return size.width + 25;
}

@end
