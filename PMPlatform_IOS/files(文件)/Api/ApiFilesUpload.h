//
//  ApiFilesUpload.h
//  ConstructionApp
//
//  Created by mac on 2017/11/14.
//  Copyright © 2017年 atide. All rights reserved.
//

#import <YTKNetwork/YTKNetwork.h>

@interface ApiFilesUpload : YTKRequest
@property (nonatomic, assign) BOOL isBackground;
@property (nonatomic, copy) NSString *url;
@property (nonatomic, copy) NSDictionary *param;
- (id)initWithImageData:(NSData *)data fileName:(NSString *)fileName markId:(NSString *)markId;

- (id)initWithImage:(UIImage *)image fileName:(NSString *)fileName markId:(NSString *)markId;

- (id)initWithImage:(UIImage *)image fileName:(NSString *)fileName markId:(NSString *)markId actionId:(NSString *)actionId taskId:(NSString *)taskId;

- (id)initWithImage:(UIImage *)image;

@end
