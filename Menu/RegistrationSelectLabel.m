//
//  RegistrationSelectLabel.m
//  YNXYJTXXPT
//
//  Created by 末末班车 on 2017/7/18.
//  Copyright © 2017年 末末班车. All rights reserved.
//

#import "RegistrationSelectLabel.h"

@implementation RegistrationSelectLabel

- (void)awakeFromNib {
    [super awakeFromNib];
    self.clipsToBounds = YES;
    self.layer.cornerRadius = 3.f;
    self.layer.borderColor = [UIColor hex:@"#4395E7"].CGColor;
    self.layer.borderWidth = 1.f;
}

@end
