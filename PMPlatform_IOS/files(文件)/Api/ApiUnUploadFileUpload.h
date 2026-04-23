//
//  ApiUnUploadFileUpload.h
//  HBConstructionApp
//
//  Created by 末末班车 on 2018/6/12.
//  Copyright © 2018年 atide. All rights reserved.
//

#import <YTKNetwork/YTKNetwork.h>
#import "UnUploadFile.h"

@interface ApiUnUploadFileUpload : YTKRequest

- (instancetype)initWithUnUploadFile:(UnUploadFile *)unUploadFile;

- (instancetype)initWithUnUploadFileAllNetworks:(UnUploadFile *)unUploadFile;

- (void)deleteUnUploadFile;

@end
