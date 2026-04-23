//
//  OpinionsModel.h
//  HBConstructionApp
//
//  Created by 末末班车 on 2018/5/30.
//  Copyright © 2018年 atide. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OpinionsModel : NSObject

@property (nonatomic, copy) NSString * superId;
@property (nonatomic, copy) NSString * id;
@property (nonatomic, copy) NSString * code;
@property (nonatomic, copy) NSString * childNum;
@property (nonatomic, copy) NSString * extProp;
@property (nonatomic, copy) NSString * key;
@property (nonatomic, copy) NSString * page;
@property (nonatomic, copy) NSString * name;
@property (nonatomic, copy) NSString * activeId;
@property (nonatomic, copy) NSString * message;
@property (nonatomic, copy) NSString * time;

@property (nonatomic, assign) BOOL isSelected;
@property (nonatomic, assign) NSInteger orderNo;

@end
