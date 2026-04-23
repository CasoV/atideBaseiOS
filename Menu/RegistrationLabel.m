//
//  RegistrationLabel.m
//  YNXYJTXXPT
//
//  Created by 末末班车 on 2017/7/18.
//  Copyright © 2017年 末末班车. All rights reserved.
//

#import "RegistrationLabel.h"

@implementation RegistrationLabel

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame: frame]) {
        self.userInteractionEnabled = YES;
        self.numberOfLines = 0;
        self.clipsToBounds = YES;
        self.layer.cornerRadius = 3.f;
        self.layer.borderColor = [UIColor hex:@"#F0F0F0"].CGColor;
        self.layer.borderWidth = 1.f;
        self.textColor = [UIColor blackColor];
        self.textAlignment = NSTextAlignmentCenter;
        self.font = [UIFont systemFontOfSize:11];
    }
    
    return self;
}

- (instancetype)init {
    if (self = [super init]) {
        self.userInteractionEnabled = YES;
        self.backgroundColor = [UIColor hex:@"#F0F0F0"];
        self.layer.cornerRadius = 4.0;
        self.clipsToBounds = YES;
        self.textColor = [UIColor hex:@"#5A5A5A"];
        self.font = [UIFont systemFontOfSize:12];
        self.textAlignment = NSTextAlignmentCenter;
    }
    return self;
}

- (void)setModel:(RegistrationModel *)model {
    _model = model;
    self.text = model.name;
}

- (void)selected:(BOOL)isSelected {
    if (isSelected) {
        self.layer.borderWidth = 0;
        self.backgroundColor = [UIColor hex:@"#4395E7"];
        self.textColor = [UIColor whiteColor];
    } else {
        self.layer.borderWidth = 1.f;
        self.backgroundColor = [UIColor whiteColor];
        self.textColor = [UIColor blackColor];
    }
}

@end
