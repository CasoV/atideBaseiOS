//
//  NewFileBackgroundUploadManager.m
//  HBConstructionApp
//
//  Created by 末末班车 on 2018/6/12.
//  Copyright © 2018年 atide. All rights reserved.
//

#import "NewFileBackgroundUploadManager.h"
#import <YTKNetwork/YTKNetwork.h>
#import "ApiUnUploadFileUpload.h"

@interface NewFileBackgroundUploadManager()

@property (nonatomic, assign) BOOL isStart;

@end

@implementation NewFileBackgroundUploadManager

static NewFileBackgroundUploadManager * _instance = nil;

+ (instancetype)shareInstance{
    return [[self alloc] init];
}

////alloc会调用allocWithZone:
+(instancetype)allocWithZone:(struct _NSZone *)zone{
    //只进行一次
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [super allocWithZone:zone];
    });
    return _instance;
}
//初始化方法
- (instancetype)init{
    // 只进行一次
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [super init];
    });
    return _instance;
}
//copy在底层 会调用copyWithZone:
- (id)copyWithZone:(NSZone *)zone{
    return  _instance;
}
+ (id)copyWithZone:(struct _NSZone *)zone{
    return  _instance;
}
+ (id)mutableCopyWithZone:(struct _NSZone *)zone{
    return _instance;
}
- (id)mutableCopyWithZone:(NSZone *)zone{
    return _instance;
}

- (void)startUpload:(NSArray<UnUploadFile *> *)files {
    if (self.isStart) {
        [SVProgressHUD showInfoWithStatus:@"文件上传中！"];
        return;
    }
    
    NSMutableArray <YTKRequest *>*requests = [NSMutableArray array];
    for (UnUploadFile *file in files) {
        ApiUnUploadFileUpload *api = [[ApiUnUploadFileUpload alloc] initWithUnUploadFileAllNetworks:file];
        [requests addObject:api];
    }
    
    __weak typeof(self) weakSelf = self;
    self.isStart = YES;
    [SVProgressHUD showInfoWithStatus:@"文件开始上传..."];
    YTKBatchRequest *batchRequest = [[YTKBatchRequest alloc] initWithRequestArray:requests];
    [batchRequest startWithCompletionBlockWithSuccess:^(YTKBatchRequest * _Nonnull batchRequest) {
        _isStart = NO;
        for (ApiUnUploadFileUpload *api in batchRequest.requestArray) {
            [api deleteUnUploadFile];
        }
        [SVProgressHUD showSuccessWithStatus:@"文件上传完成！"];
        if (weakSelf.block) {
            weakSelf.block();
        }
    } failure:^(YTKBatchRequest * _Nonnull batchRequest) {
        _isStart = NO;
        [SVProgressHUD showErrorWithStatus:@"文件上传失败！"];
    }];
}

@end
