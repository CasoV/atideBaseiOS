//
//  BIMFile.h
//  ConstructionApp
//
//  Created by mac on 2017/11/14.
//  Copyright © 2017年 atide. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Photos/PHAsset.h>
#import "UnUploadFile.h"

@interface BIMFile : NSObject
@property (nonatomic, assign) NSInteger length;
@property (nonatomic, copy) NSString *md5;
@property (nonatomic, copy) NSString *uid;
@property (nonatomic, copy) NSString *id;
@property (nonatomic, copy) NSString *contentType;
@property (nonatomic, copy) NSString *extName;
@property (nonatomic, copy) NSString *filename;
@property (nonatomic, assign) NSInteger uploadDate;
@property (nonatomic, assign) NSInteger updateTime;

@property (nonatomic, copy) NSString *filePath;
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) NSData *data;
@property (nonatomic, strong) PHAsset *asset;

@property (nonatomic, strong) UnUploadFile *unUploadFile;

@property (nonatomic, assign) BOOL isImageOrVideo;

@property (nonatomic, assign) BOOL isImage;

//经纬度 时间信息
@property (nonatomic, copy) NSString *latitude;
@property (nonatomic, copy) NSString *longitude;
@property (nonatomic, copy) NSString *dateTimeOriginal;
@property (nonatomic, strong) NSDate *date;

// 国家
@property (nonatomic, copy) NSString *country;
// 省份名称
@property (nonatomic, copy) NSString *province;
// 城市名称
@property (nonatomic, copy) NSString *city;
// 区县名称
@property (nonatomic, copy) NSString *district;

@property (nonatomic, copy) NSString *fileType;

- (BOOL)isDownload;

@end
