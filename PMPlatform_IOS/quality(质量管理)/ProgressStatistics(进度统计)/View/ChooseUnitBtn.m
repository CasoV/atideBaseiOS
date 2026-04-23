//
//  ChooseUnitBtn.m
//  ConstructionApp
//
//  Created by 末末班车 on 2017/12/21.
//  Copyright © 2017年 atide. All rights reserved.
//

#import "ChooseUnitBtn.h"

@interface ChooseUnitBtn()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end

@implementation ChooseUnitBtn

- (void)setTitle:(NSString *)title {
    self.titleLabel.text = title;
}

@end
