//
//  ConditionModel.h
//  ycxm
//
//  Created by 末末班车 on 2018/9/28.
//  Copyright © 2018年 末末班车. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ConditionDetail.h"

@interface ConditionModel : NSObject

@property (copy, nonatomic) NSString *ID;
@property (nonatomic, copy) NSString *headerTitle;
@property (nonatomic, copy) NSArray <ConditionDetail *>*details;

@end
