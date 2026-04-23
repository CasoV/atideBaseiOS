//
//  SpecialUseListCell.m
//  ycxm
//
//  Created by 末末班车 on 2018/12/18.
//  Copyright © 2018 末末班车. All rights reserved.
//

#import "SpecialUseListCell.h"

@implementation SpecialUseListCell

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
