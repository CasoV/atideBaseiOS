//
//  SearchCoditionCell.m
//  PMPlatform_IOS
//
//  Created by 末末班车 on 2017/9/6.
//  Copyright © 2017年 com.atide. All rights reserved.
//

#import "SearchCoditionCell.h"

@implementation SearchCoditionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.parentView.layer.borderColor = [UIColor redColor].CGColor;
    self.parentView.layer.borderWidth = 1;
    self.parentView.layer.cornerRadius = 5;
}

@end
