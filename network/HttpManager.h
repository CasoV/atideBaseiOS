//
//  HttpManager.h
//  YNXYJTXXPT
//
//  Created by 末末班车 on 2017/6/26.
//  Copyright © 2017年 末末班车. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import <AFNetworking/AFNetworking.h>
#import "AFURLSessionManager.h"

@interface HttpManager : AFURLSessionManager

+ (instancetype)manager;

//MARK: POST方法
- (void)post:(NSString *)url param:(NSDictionary *)param success: (void (^)(NSData *data)) success faild: (void (^)(NSString *msg)) faild;
- (void)post:(NSString *)url data:(NSData *)data success: (void (^)(NSData *data)) success faild: (void (^)(NSString *msg)) faild;

//MARK: GET方法
- (void)get:(NSString *)url param:(NSDictionary *)param success: (void (^)(NSData *data)) success faild: (void (^)(NSString *msg)) faild;

//MARK: GET方法(封装params)
- (void)paramsGet:(NSString *)url param:(NSDictionary *)param success: (void (^)(NSData *data)) success faild: (void (^)(NSString *msg)) faild;

//MARK: PUT方法
- (void)put:(NSString *)url param:(NSDictionary *)param success: (void (^)(NSData *data)) success faild: (void (^)(NSString *msg)) faild;
- (void)jsonPut:(NSString *)url data:(NSData *)data success: (void (^)(NSData *data)) success faild: (void (^)(NSString *msg)) faild;

//MARK: DELETE方法
- (void)del:(NSString *)url param:(NSDictionary *)param success: (void (^)(NSData *data)) success faild: (void (^)(NSString *msg)) faild;
- (void)jsonArrDel:(NSString *)url param:(NSArray *)param success: (void (^)(NSData *data)) success faild: (void (^)(NSString *msg)) faild;

//MARK: upload方法
- (void)uploadTask:(NSString *)url data:(NSData *)data name:(NSString *)name fileName:(NSString *)fileName mimeType:(NSString *)mimeType param:(NSDictionary *)param callback:(void(^)(NSURLResponse *response, id data, NSError *error))callback;

//MARK: download方法
- (void)downloadWithFileid:(NSString *)fileId fileName:(NSString *)fileName progress:(void (^)(NSProgress *downloadProgress)) downloadProgressBlock completionHandler:(void (^)(NSURLResponse *response, NSURL *filePath, NSError *error))completionHandler;
- (void)downloadVideoWithFileid:(NSString *)filePath fileName:(NSString *)fileName progress:(void (^)(NSProgress *downloadProgress)) downloadProgressBlock completionHandler:(void (^)(NSURLResponse *response, NSURL *filePath, NSError *error))completionHandler;
- (void)downloadWithUrl:(NSString *)url params:(NSDictionary *)params fileName:(NSString *)fileName progress:(void (^)(NSProgress *downloadProgress)) downloadProgressBlock completionHandler:(void (^)(NSURLResponse *response, NSURL *filePath, NSError *error))completionHandler;

- (void)post:(NSString *)url param:(NSDictionary *)param success: (void (^)(NSData *data)) success faild: (void (^)(NSString *msg)) faild headers:(NSDictionary *)headers;
- (void)jsonPost:(NSString *)url arrayParam:(NSArray *)param success: (void (^)(NSData *data)) success faild: (void (^)(NSString *msg)) faild;
- (void)jsonPost:(NSString *)url param:(NSDictionary *)param success: (void (^)(NSData *data)) success faild: (void (^)(NSString *msg)) faild;
- (void)jsonPost:(NSString *)url param:(NSDictionary *)param success: (void (^)(NSData *data)) success faild: (void (^)(NSString *msg)) faild headers:(NSDictionary *)headers;
@end
