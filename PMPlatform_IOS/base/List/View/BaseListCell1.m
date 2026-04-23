//
//  BaseListCell1.m
//  ycxm
//
//  Created by 末末班车 on 2018/9/19.
//  Copyright © 2018年 末末班车. All rights reserved.
//

#import "BaseListCell1.h"

@implementation BaseListCell1

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (IBAction)btnClicked:(UIButton *)sender {
    if (self.callback) {
        self.callback();
    }
}

@end
