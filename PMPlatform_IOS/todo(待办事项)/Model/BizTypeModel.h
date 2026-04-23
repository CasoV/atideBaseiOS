//
//  BizTypeModel.h
//  ycxm
//
//  Created by 末末班车 on 2018/10/19.
//  Copyright © 2018年 末末班车. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BizTypeModel : NSObject

@property (nonatomic, copy) NSString * bizKey;
@property (nonatomic, copy) NSString * remark;
@property (nonatomic, copy) NSString * todoneUrl;
@property (nonatomic, copy) NSString * id;
@property (nonatomic, copy) NSString * flowKey;
@property (nonatomic, copy) NSString * bizUrlPrefix;
@property (nonatomic, copy) NSString * name;
@property (nonatomic, copy) NSString * bizName;
@property (nonatomic, assign) int count;

@end
