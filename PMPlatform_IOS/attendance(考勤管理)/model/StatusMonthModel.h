//
//  StatusMonthModel.h
//  ycxm
//
//  Created by 高小伟 on 2020/6/11.
//  Copyright © 2020 末末班车. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface StatusMonthModel : NSObject

@property(nonatomic,copy)NSString *date;
@property(nonatomic,strong)NSArray *data;
@property(nonatomic,copy)NSString *useId;

@end

NS_ASSUME_NONNULL_END
