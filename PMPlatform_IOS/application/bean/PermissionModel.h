//
//  PermissionModel.h
//  ycxm
//
//  Created by 末末班车 on 2018/9/29.
//  Copyright © 2018年 末末班车. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PermissionModel : NSObject

@property (nonatomic, copy) NSString * url;
@property (nonatomic, copy) NSString * resourceName;
@property (nonatomic, copy) NSString * proType;
@property (nonatomic, copy) NSString * linkType;
@property (nonatomic, copy) NSString * actionType;
@property (nonatomic, copy) NSString * iosClassName;
@property (nonatomic, copy) NSString * sbName;
@property (nonatomic, copy) NSString * sbId;
@property (nonatomic, copy) NSString * des;
@property (nonatomic, copy) NSArray<PermissionModel *> * children;

@end
