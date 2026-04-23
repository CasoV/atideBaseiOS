//
//  NewFileBackgroundUploadManager.h
//  HBConstructionApp
//
//  Created by 末末班车 on 2018/6/12.
//  Copyright © 2018年 atide. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UnUploadFile.h"

@interface NewFileBackgroundUploadManager : NSObject

@property (nonatomic, copy) void (^block)(void);

+ (instancetype)shareInstance;

- (void)startUpload:(NSArray <UnUploadFile *>*)files;

@end
