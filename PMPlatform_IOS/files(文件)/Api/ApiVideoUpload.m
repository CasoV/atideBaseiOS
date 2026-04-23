//
//  ApiVideoUpload.m
//  HBConstructionApp
//
//  Created by 末末班车 on 2018/6/7.
//  Copyright © 2018年 atide. All rights reserved.
//

#import "ApiVideoUpload.h"

//#import <AFNetworking/AFNetworking.h>
//#import "DBManager.h"

@implementation ApiVideoUpload {
    NSData *_data;
    
    NSString *_filename;
    NSString *_formId;
}

- (instancetype)initWithVideoData:(NSData *)data fileName:(NSString *)fileName markId:(NSString *)markId {
//    AFNetworkReachabilityStatus status = [AFNetworkReachabilityManager sharedManager].networkReachabilityStatus;
//    if (status == AFNetworkReachabilityStatusReachableViaWiFi) {
//        if (self = [super init]) {
//            _data = data;
//            _filename = fileName;
//            _formId = markId;
//        }
//        return self;
//    } else {
//        [DBManager saveVideo:data fileName:fileName formId:markId];
//        return nil;
//    }
    if (self = [super init]) {
        _data = data;
        _filename = fileName;
        _formId = markId;
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
                                                                                  @"filename":_filename,
                                                                                  @"metaData.formId":_formId,
                                                                                  }];
    return params;
}

- (AFConstructingBlock)constructingBodyBlock {
    return ^(id<AFMultipartFormData> formData) {
        NSString *formKey = @"file";
        NSString *type = @"video/mp4";
        [formData appendPartWithFileData:self->_data name:formKey fileName:self->_filename mimeType:type];
    };
}

@end
