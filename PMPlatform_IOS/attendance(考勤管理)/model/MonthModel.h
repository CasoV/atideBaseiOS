//
//  MonthModel.h
//  ycxm
//
//  Created by 高小伟 on 2020/6/11.
//  Copyright © 2020 末末班车. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MonthModel : NSObject
@property (assign, nonatomic) NSInteger dayValue;
@property (strong, nonatomic) NSDate *dateValue;
@property (assign, nonatomic) BOOL isSelectedDay;
@property (assign, nonatomic) BOOL isWorkDay;
@property (copy, nonatomic) NSString *standard1;
@property (copy, nonatomic) NSString *standard2;
@end

NS_ASSUME_NONNULL_END
