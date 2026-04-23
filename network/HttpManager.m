//
//  HttpManager.m
//  YNXYJTXXPT
//
//  Created by 末末班车 on 2017/6/26.
//  Copyright © 2017年 末末班车. All rights reserved.
//

#import "HttpManager.h"

@implementation HttpManager {
    NSTimer *_autoLoginTimer;
}

//MARK: 创建单例
static HttpManager * manager;

+ (instancetype)manager {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSURLSessionConfiguration * configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        configuration.HTTPShouldSetCookies = YES;
        configuration.timeoutIntervalForRequest = 30;
        configuration.requestCachePolicy = NSURLRequestReloadIgnoringLocalAndRemoteCacheData;
        
        manager = [[self alloc] initWithSessionConfiguration:configuration];
        manager.responseSerializer = [[AFCompoundResponseSerializer alloc] init];
    });
    return manager;
}

//MARK: POST方法
- (void)post:(NSString *)url param:(NSDictionary *)param success: (void (^)(NSData *data)) success faild: (void (^)(NSString *msg)) faild {
    [self request:url method:@"post" param:param success:success faild:faild];
}

- (void)post:(NSString *)url data:(NSData *)data success: (void (^)(NSData *data)) success faild: (void (^)(NSString *msg)) faild{
    NSMutableURLRequest *request = [[[AFHTTPRequestSerializer alloc] init] requestWithMethod:@"post" URLString:url parameters:nil error:nil];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:data];
    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request uploadProgress:nil downloadProgress:nil completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        if (error) {
            if (faild) {
                if ([[error localizedDescription] isEqualToString:@"The Internet connection appears to be offline."]) {
                    faild(@"当前无网络!");
                } else {
                    faild([error localizedDescription]);
                }
            }
            return;
        }
        if (responseObject) {
            if ([responseObject isKindOfClass:[NSNull class]]) {
                faild(@"登陆失效，请退出重新登陆");
            } else {
                [[NSNotificationCenter defaultCenter] postNotificationName:NotifacationName_ResetAutoLogin object:nil];
                success(responseObject);
            }
        }else {
            faild(@"服务器错误");
        }
    }];
    
    [dataTask resume];
}

//MARK: GET方法
- (void)get:(NSString *)url param:(NSDictionary *)param success: (void (^)(NSData *data)) success faild: (void (^)(NSString *msg)) faild {
    [self request:url method:@"get" param:param success:success faild:faild];
}

//MARK: PUT方法
- (void)put:(NSString *)url param:(NSDictionary *)param success: (void (^)(NSData *data)) success faild: (void (^)(NSString *msg)) faild {
    [self jsonRequest:url method:@"put" param:param success:success faild:faild headers:nil];
}
- (void)jsonPut:(NSString *)url data:(NSData *)data success: (void (^)(NSData *data)) success faild: (void (^)(NSString *msg)) faild {
    NSMutableURLRequest *request = [[[AFHTTPRequestSerializer alloc] init] requestWithMethod:@"put" URLString:url parameters:nil error:nil];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:data];
    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request uploadProgress:nil downloadProgress:nil completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        if (error) {
            if (faild) {
                if ([[error localizedDescription] isEqualToString:@"The Internet connection appears to be offline."]) {
                    faild(@"当前无网络!");
                } else {
                    faild([error localizedDescription]);
                }
            }
            return;
        }
        if (responseObject) {
            if ([responseObject isKindOfClass:[NSNull class]]) {
                faild(@"登陆失效，请退出重新登陆");
            } else {
                [[NSNotificationCenter defaultCenter] postNotificationName:NotifacationName_ResetAutoLogin object:nil];
                success(responseObject);
            }
        }else {
            faild(@"服务器错误");
        }
    }];
    
    [dataTask resume];
}

//MARK: DELETE方法
- (void)del:(NSString *)url param:(NSDictionary *)param success: (void (^)(NSData *data)) success faild: (void (^)(NSString *msg)) faild {
    [self request:url method:@"delete" param:param success:success faild:faild];
}
- (void)jsonArrDel:(NSString *)url param:(NSArray *)param success: (void (^)(NSData *data)) success faild: (void (^)(NSString *msg)) faild{
    [self jsonRequest:url method:@"delete" param:param success:success faild:faild headers:nil];
}

//MARK: GET方法(封装params)
- (void)paramsGet:(NSString *)url param:(NSDictionary *)param success: (void (^)(NSData *data)) success faild: (void (^)(NSString *msg)) faild {
    NSString *jsonParam = nil;
    if (param != nil && param.count != 0) {
        jsonParam = @"{";
        for (NSString *key in [param allKeys]) {
            jsonParam = [NSString stringWithFormat:@"%@\"%@\":\"%@\",", jsonParam, key, param[key]];
            if ([param[key] isKindOfClass:[NSMutableArray class]]) {
                NSMutableString *str = [jsonParam mutableCopy];
                str = [[str stringByReplacingOccurrencesOfString:@"\"(" withString:@"["] mutableCopy];
                str = [[str stringByReplacingOccurrencesOfString:@"sectNos" withString:@"sectnos"] mutableCopy];
                str = [[str stringByReplacingOccurrencesOfString:@"sectNo" withString:@"\"sectNo\""] mutableCopy];
                str = [[str stringByReplacingOccurrencesOfString:@"sessionCode" withString:@"\"sessionCode\""] mutableCopy];
                str = [[str stringByReplacingOccurrencesOfString:@"sectnos" withString:@"sectNos"] mutableCopy];
                str = [[str stringByReplacingOccurrencesOfString:@"=" withString:@":"] mutableCopy];
                jsonParam = [str stringByReplacingOccurrencesOfString:@")\"" withString:@"]"];
            }
        }
        jsonParam = [NSString stringWithFormat:@"%@}", [jsonParam substringToIndex:jsonParam.length - 1]];
    }
    
    NSDictionary *params = @{@"params":@""};
    if (jsonParam) {
        params = @{@"params":jsonParam};
    }
    
    [self request:url method:@"get" param:params success:success faild:faild];
}

- (void)request:(NSString *)url method:(NSString *)method param:(id)param success: (void (^)(NSData *data)) success faild: (void (^)(NSString *msg)) faild {
    NSMutableURLRequest *request = [[[AFHTTPRequestSerializer alloc] init] requestWithMethod:method URLString:url parameters:param error:nil];
    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request uploadProgress:nil downloadProgress:nil completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        if (error) {
            if (faild) {
                if ([[error localizedDescription] isEqualToString:@"The Internet connection appears to be offline."]) {
                    faild(@"当前无网络!");
                } else {
                    faild([error localizedDescription]);
                }
            }
            return;
        }
        if (responseObject) {
            if ([responseObject isKindOfClass:[NSNull class]]) {
                faild(@"登陆失效，请退出重新登陆");
            } else {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"ResetAutoLoginNotifacation" object:nil];
                success(responseObject);
            }
        }else {
            faild(@"服务器错误");
        }
    }];
    
    [dataTask resume];
}

- (void)post:(NSString *)url param:(NSDictionary *)param success: (void (^)(NSData *data)) success faild: (void (^)(NSString *msg)) faild headers:(NSDictionary *)headers {
    [self request:url method:@"post" param:param success:success faild:faild headers:headers];
}


- (void)request:(NSString *)url method:(NSString *)method param:(id)param success: (void (^)(NSData *data)) success faild: (void (^)(NSString *msg)) faild headers:(NSDictionary *)headers {
    NSMutableURLRequest *request = [[[AFHTTPRequestSerializer alloc] init] requestWithMethod:method URLString:url parameters:param error:nil];
    if (headers) {
        for (NSString *key in [headers allKeys]) {
            [request setValue:[headers objectForKey:key] forHTTPHeaderField:key];
        }
    }
    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request uploadProgress:nil downloadProgress:nil completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        if (error) {
            if (faild) {
                if ([[error localizedDescription] isEqualToString:@"The Internet connection appears to be offline."]) {
                    faild(@"当前无网络!");
                } else {
                    faild([error localizedDescription]);
                }
            }
            return;
        }
        if (responseObject) {
            if ([responseObject isKindOfClass:[NSNull class]]) {
                faild(@"登陆失效，请退出重新登陆");
            } else {
                [self setupTimer];
                success(responseObject);
            }
        }else {
            faild(@"服务器错误");
        }
    }];
    
    [dataTask resume];
}


//MARK: upload方法
- (void)uploadTask:(NSString *)url data:(NSData *)data name:(NSString *)name fileName:(NSString *)fileName mimeType:(NSString *)mimeType param:(NSDictionary *)param callback:(void(^)(NSURLResponse *response, id data, NSError *error))callback {
    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] multipartFormRequestWithMethod:@"POST" URLString:url parameters:param constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        [formData appendPartWithFileData:data name:name fileName:fileName.lowercaseString mimeType:mimeType];
    } error:nil];
    //@"https://dxgsbim.yciccloud.com:9009/"
    [request setValue:[UrlConfig URL:@"/"]  forHTTPHeaderField:@"Referer"];

    NSURLSessionUploadTask *uploadTask = [manager uploadTaskWithStreamedRequest:request progress:nil completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        callback(response, responseObject, error);
    }];
    [uploadTask resume];
}

//MARK: download方法
- (void)downloadWithFileid:(NSString *)fileId fileName:(NSString *)fileName progress:(void (^)(NSProgress *downloadProgress)) downloadProgressBlock completionHandler:(void (^)(NSURLResponse *response, NSURL *filePath, NSError *error))completionHandler {
    NSString *url = [NSString stringWithFormat:@"%@/%@", [UrlConfig URL:downloadFile], fileId];
    NSMutableURLRequest *request = [[[AFHTTPRequestSerializer alloc] init] requestWithMethod:@"get" URLString:url parameters:@{
                                                                                                                               @"id":fileId,
                                                                                                                               @"projectId":[UserAgent DefaultAgent].projectId,
                                                                                                                               @"sectionId":[UserAgent DefaultAgent].sectionId,
                                                                                                                               @"sectId":[UserAgent DefaultAgent].sectionId
                                                                                                                               } error:nil];
    
    NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
//        downloadProgressBlock(downloadProgress);
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        NSURL *documentsDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
        return [documentsDirectoryURL URLByAppendingPathComponent:fileName ? fileName : [response suggestedFilename]];
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        completionHandler(response, filePath, error);
    }];
    [downloadTask resume];
}

- (void)downloadWithUrl:(NSString *)url params:(NSDictionary *)params fileName:(NSString *)fileName progress:(void (^)(NSProgress *downloadProgress)) downloadProgressBlock completionHandler:(void (^)(NSURLResponse *response, NSURL *filePath, NSError *error))completionHandler {
    NSMutableURLRequest *request = [[[AFHTTPRequestSerializer alloc] init] requestWithMethod:@"post" URLString:url parameters:params error:nil];
    
    NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
//        downloadProgressBlock(downloadProgress);
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        NSURL *documentsDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
        return [documentsDirectoryURL URLByAppendingPathComponent:fileName ? fileName : [response suggestedFilename]];
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        completionHandler(response, filePath, error);
    }];
    [downloadTask resume];
}

- (void)downloadVideoWithFileid:(NSString *)filePath fileName:(NSString *)fileName progress:(void (^)(NSProgress *downloadProgress)) downloadProgressBlock completionHandler:(void (^)(NSURLResponse *response, NSURL *filePath, NSError *error))completionHandler{
    NSString *url = [NSString stringWithFormat:@"%@/%@", [UrlConfig URL:downloadFile], filePath];
    NSMutableURLRequest *request = [[[AFHTTPRequestSerializer alloc] init] requestWithMethod:@"get" URLString:url parameters:@{
                                                                                                                               @"asAttachment":@"true"
                                                                                                                               } error:nil];
    
    NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        NSURL *documentsDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
        return [documentsDirectoryURL URLByAppendingPathComponent:fileName];
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        completionHandler(response, filePath, error);
    }];
    [downloadTask resume];
}

//MARK: 定时自动登录
- (void)setupTimer {
    if (_autoLoginTimer) {
        [_autoLoginTimer invalidate];
    }
    _autoLoginTimer = [NSTimer scheduledTimerWithTimeInterval:1800 target:self selector:@selector(autoLogin) userInfo:nil repeats:YES];
}

- (void)autoLogin {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    if ([userDefaults objectForKey:@"user"] == nil) {
        return;
    }
    [self request:[UrlConfig login] method:@"post" param:@{@"userId":@"", @"user":[userDefaults objectForKey:@"user"], @"pwd":[userDefaults objectForKey:@"pwd"]} success:^(NSData *data) {

    } faild:^(NSString *msg) {
        
    }];
}

- (void)jsonPost:(NSString *)url param:(NSDictionary *)param success: (void (^)(NSData *data)) success faild: (void (^)(NSString *msg)) faild headers:(NSDictionary *)headers {
    [self jsonRequest:url method:@"post" param:param success:success faild:faild headers:headers];
}

- (void)jsonPost:(NSString *)url arrayParam:(NSArray *)param success: (void (^)(NSData *data)) success faild: (void (^)(NSString *msg)) faild {
    [self jsonRequest:url method:@"post" param:param success:success faild:faild headers:nil];
}

- (void)jsonPost:(NSString *)url param:(NSDictionary *)param success: (void (^)(NSData *data)) success faild: (void (^)(NSString *msg)) faild {
    [self jsonRequest:url method:@"post" param:param success:success faild:faild headers:nil];
}

- (void)jsonRequest:(NSString *)url method:(NSString *)method param:(id)param success: (void (^)(NSData *data)) success faild: (void (^)(NSString *msg)) faild headers:(NSDictionary *)headers{
    
    AFJSONRequestSerializer *serializer = [AFJSONRequestSerializer serializer];
    serializer.HTTPMethodsEncodingParametersInURI = [NSSet setWithObjects:@"GET", @"HEAD", nil];
    
    NSMutableURLRequest *request = [serializer requestWithMethod:method URLString:url parameters:param error:nil];
    
    if (headers) {
        for (NSString *key in [headers allKeys]) {
            [request setValue:[headers objectForKey:key] forHTTPHeaderField:key];
        }
    }
    
    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request uploadProgress:nil downloadProgress:nil completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        if (error) {
            if (faild) {
                faild([error localizedDescription]);
            }
            return;
        }
        if (responseObject) {
            if ([responseObject isKindOfClass:[NSNull class]]) {
                faild(@"登陆失效，请退出重新登陆");
            } else {
                [[NSNotificationCenter defaultCenter] postNotificationName:NotifacationName_ResetAutoLogin object:nil];
                success(responseObject);
            }
        }else {
            faild(@"服务器错误");
        }
    }];
    
    [dataTask resume];
}
@end
