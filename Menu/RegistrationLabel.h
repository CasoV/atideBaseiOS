//
//  RegistrationLabel.h
//  YNXYJTXXPT
//
//  Created by 末末班车 on 2017/7/18.
//  Copyright © 2017年 末末班车. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RegistrationModel.h"

@interface RegistrationLabel : UILabel

@property (strong, nonatomic) RegistrationModel *model;

- (void)selected:(BOOL)isSelected;

@end
