//
//  ApiFilesUpload.m
//  ConstructionApp
//
//  Created by mac on 2017/11/14.
//  Copyright © 2017年 atide. All rights reserved.
//

#import "ApiFilesUpload.h"

//#import <AFNetworking/AFNetworking.h>
//#import "DBManager.h"

@implementation ApiFilesUpload {
    NSData *_data;
    UIImage *_image;
    
    NSString *_filename;
    NSString *_formId;
    NSString *_actionId;
    NSString *_taskId;
}

- (id)initWithImageData:(NSData *)data fileName:(NSString *)fileName markId:(NSString *)markId {
    if (self = [super init]) {
        _data = data;
        _filename = fileName;
        _formId = markId;
    }
    return self;
}

- (id)initWithImage:(UIImage *)image {
    return [self initWithImage:image fileName:@"" markId:@""];
}

- (id)initWithImage:(UIImage *)image fileName:(NSString *)fileName markId:(NSString *)markId {
    self = [super init];
    if (self) {
        _image = image;
        _filename = fileName;
        _formId = markId;
    }
    return self;
}

- (id)initWithImage:(UIImage *)image fileName:(NSString *)fileName markId:(NSString *)markId actionId:(NSString *)actionId taskId:(NSString *)taskId {
    self = [super init];
    if (self) {
        _image = image;
        _filename = fileName;
        _formId = markId;
        _actionId = actionId;
        _taskId = taskId;
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
    if (_url) {
        return _url;
    } else {
        UserAgent *userAgent = [UserAgent DefaultAgent];
        return [NSString stringWithFormat:@"fs/files/upload?sectId=%@&sectionId=%@&projectId=%@", userAgent.sectionId, userAgent.sectionId, userAgent.projectId];
    }
}

- (id)requestArgument {
    if (_param) {
        return _param;
    } else {
        NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:@{
                                                                                      @"filename":_filename,
                                                                                      @"metaData.formId":_formId,
                                                                                      }];
        if (_actionId) {
            [params setObject:_actionId forKey:@"metaData.actionId"];
        }
        if (_taskId) {
            [params setObject:_taskId forKey:@"metaData.taskId"];
        }
        
        return params;
    }
}

- (AFConstructingBlock)constructingBodyBlock {
    return ^(id<AFMultipartFormData> formData) {
        NSData *data;
        if (self->_data) {
            data = self->_data;
        } else {
            data = UIImageJPEGRepresentation(self->_image, 0.9);
        }
        NSString *formKey = @"file";
        NSString *type = @"image/jpeg";
        [formData appendPartWithFileData:data name:formKey fileName:self->_filename mimeType:type];
    };
}


- (void)start{
    AFNetworkReachabilityStatus status = [AFNetworkReachabilityManager sharedManager].networkReachabilityStatus;
    if (status == AFNetworkReachabilityStatusReachableViaWiFi) {
        [super start];
        return;
    }
    if (_isBackground) {
        return;
    }
    
//    BOOL wifiAuto = [[NSUserDefaults standardUserDefaults] boolForKey:@"wifi-auto"];
//    if (wifiAuto) {
//        BOOL isSuccess = [DBManager save:_image ? _image : [UIImage imageWithData:_data] fileName:_filename formId:_formId actionId:_actionId taskId:_taskId];
//        if (isSuccess) {
//            if ( self.delegate && [self.delegate respondsToSelector:@selector(requestFinished:)]) {
//                [self.delegate requestFinished:self];
//            }
//        }else{
//            if ( self.delegate && [self.delegate respondsToSelector:@selector(requestFailed:)]) {
//                [self.delegate requestFailed:self];
//            }
//        }
//    }else{
//        [super start];
//    }
    
    [super start];
}


@end
