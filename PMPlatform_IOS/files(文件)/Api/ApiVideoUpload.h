//
//  ApiVideoUpload.h
//  HBConstructionApp
//
//  Created by 末末班车 on 2018/6/7.
//  Copyright © 2018年 atide. All rights reserved.
//

#import <YTKNetwork/YTKNetwork.h>

@interface ApiVideoUpload : YTKRequest

@property (nonatomic, assign) BOOL isBackground;
- (instancetype)initWithVideoData:(NSData *)data fileName:(NSString *)fileName markId:(NSString *)markId;

@end
