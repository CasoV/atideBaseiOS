//
//  ImageClusterModel.m
//  HBConstructionApp
//
//  Created by 末末班车 on 2018/6/13.
//  Copyright © 2018年 atide. All rights reserved.
//

#import "ImageClusterModel.h"

@implementation ImageClusterModel

- (NSMutableArray<UIImage *> *)images {
    if (!_images) {
        _images = [NSMutableArray array];
    }
    return _images;
}

@end
