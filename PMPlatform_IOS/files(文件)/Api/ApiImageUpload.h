//
//  ApiImageUpload.h
//  HBConstructionApp
//
//  Created by 末末班车 on 2018/6/8.
//  Copyright © 2018年 atide. All rights reserved.
//

#import <YTKNetwork/YTKNetwork.h>

@interface ApiImageUpload : YTKRequest
- (instancetype)initWithImageData:(NSData *)data fileName:(NSString *)fileName markId:(NSString *)markId;

@end
