//
//  LineScheduleModel.h
//  ycxm
//
//  Created by 末末班车 on 2019/1/15.
//  Copyright © 2019 末末班车. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LineScheduleModel : NSObject

@property (nonatomic, copy) NSString * status;
@property (nonatomic, copy) NSString * sectId;
@property (nonatomic, copy) NSString * projectId;
@property (nonatomic, copy) NSString * id;
@property (nonatomic, copy) NSString * code;
@property (nonatomic, copy) NSString * typeName;
@property (nonatomic, copy) NSString * partCode;
@property (nonatomic, copy) NSString * name;
@property (nonatomic, copy) NSString * parentCode;
@property (nonatomic, assign) BOOL isSelected;

@end

NS_ASSUME_NONNULL_END
