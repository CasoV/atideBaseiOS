//
//  RegistrationModel.h
//  YNXYJTXXPT
//
//  Created by 末末班车 on 2017/7/18.
//  Copyright © 2017年 末末班车. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RegistrationModel : NSObject

@property (copy, nonatomic) NSString *ID;
@property (copy, nonatomic) NSString *name;
@property (copy, nonatomic) NSString *code;

- (CGFloat)getLabelWidth;

@end
