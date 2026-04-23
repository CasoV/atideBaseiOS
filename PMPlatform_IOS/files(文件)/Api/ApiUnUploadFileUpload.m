//
//  ApiUnUploadFileUpload.m
//  HBConstructionApp
//
//  Created by 末末班车 on 2018/6/12.
//  Copyright © 2018年 atide. All rights reserved.
//

#import "ApiUnUploadFileUpload.h"
//#import <AFNetworking/AFNetworking.h>
#import "DBManager.h"

@implementation ApiUnUploadFileUpload {
    UnUploadFile *_file;
}

- (instancetype)initWithUnUploadFile:(UnUploadFile *)unUploadFile {
//    AFNetworkReachabilityStatus status = [AFNetworkReachabilityManager sharedManager].networkReachabilityStatus;
//    if (status == AFNetworkReachabilityStatusReachableViaWiFi) {
//        if (self = [super init]) {
//            _file = unUploadFile;
//        }
//        return self;
//    } else {
//        return nil;
//    }
    if (self = [super init]) {
        _file = unUploadFile;
    }
    return self;
}

- (instancetype)initWithUnUploadFileAllNetworks:(UnUploadFile *)unUploadFile {
    if (self = [super init]) {
        _file = unUploadFile;
    }
    return self;
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodPOST;
}

- (YTKResponseSerializerType)responseSerializerType {
    return YTKResponseSerializerTypeHTTP;
}

- (NSString *)requestUrl {
    return @"fs/files/upload";
}

- (id)requestArgument {
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:@{
                                                                                  @"filename":_file.name,
                                                                                  @"metaData.formId":_file.formId,
                                                                                  }];
    return params;
}

- (AFConstructingBlock)constructingBodyBlock {
    return ^(id<AFMultipartFormData> formData) {
        NSString *formKey = @"file";
        NSString *type;
        if ([self->_file.type isEqualToString:@"video"]) {
            type = @"video/mp4";
        } else {
            type = @"image/jpeg";
        }

        NSString *doc = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject;
        NSData *data = [NSData dataWithContentsOfFile:[doc stringByAppendingPathComponent:self->_file.path]];
        
        [formData appendPartWithFileData:data ? data : [NSData data] name:formKey fileName:self->_file.name mimeType:type];
    };
}

- (void)deleteUnUploadFile {
    [DBManager deleteUploadFiles:@[_file]];
}

@end
