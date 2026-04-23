//
//  ImageClusterModel.h
//  HBConstructionApp
//
//  Created by 末末班车 on 2018/6/13.
//  Copyright © 2018年 atide. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ImageClusterModel : NSObject

@property (nonatomic, copy) NSString *dateStr;

@property (nonatomic, copy) NSString *address;

@property (nonatomic, strong) NSMutableArray <UIImage *>*images;

@end
