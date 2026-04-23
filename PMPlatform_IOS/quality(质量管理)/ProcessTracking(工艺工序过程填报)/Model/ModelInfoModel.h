//
//  ModelInfoModel.h
//  ConstructionApp
//
//  Created by 末末班车 on 2018/1/17.
//  Copyright © 2018年 atide. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ModelInfoModel : NSObject

@property (nonatomic, copy) NSString * remarks;
@property (nonatomic, copy) NSString * id;
@property (nonatomic, copy) NSString * modelId;
@property (nonatomic, copy) NSString * place;
@property (nonatomic, copy) NSString * pid;

@property (nonatomic, assign) NSInteger endTime;
@property (nonatomic, assign) NSInteger startTime;

@end
