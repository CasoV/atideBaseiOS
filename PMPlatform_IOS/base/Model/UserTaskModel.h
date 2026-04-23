//
//  UserTaskModel.h
//  ycxm
//
//  Created by 末末班车 on 2020/3/17.
//  Copyright © 2020 末末班车. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface UserTaskModel : NSObject

@property (nonatomic, copy) NSString * userId;
@property (nonatomic, copy) NSString * instanceId;
@property (nonatomic, copy) NSString * id;
@property (nonatomic, copy) NSString * procdefId;
@property (nonatomic, copy) NSString * endTime;
@property (nonatomic, copy) NSString * key;
@property (nonatomic, copy) NSString * startTime;
@property (nonatomic, copy) NSString * name;

@end

NS_ASSUME_NONNULL_END
