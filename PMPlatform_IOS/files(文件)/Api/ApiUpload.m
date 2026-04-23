
//
//  ApiUpload.m
//  ycxm
//
//  Created by 末末班车 on 2018/10/16.
//  Copyright © 2018年 末末班车. All rights reserved.
//

#import "ApiUpload.h"

@interface ApiUpload ()


@property (nonatomic, strong) BIMFile *file;

@property (nonatomic, copy) NSDictionary *params;

@end

@implementation ApiUpload

- (instancetype)initWithFile:(BIMFile *)file params:(NSDictionary *)params; {
    if (self = [super init]) {
        self.file = file;
        self.params = params;
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
    if (self.url) {
        return self.url;
    } else {
        return @"fs/files/upload";
    }
}

- (id)requestArgument {
    return self.params;
}

- (AFConstructingBlock)constructingBodyBlock {
    __weak typeof(self) weakSelf = self;
    return ^(id<AFMultipartFormData> formData) {
        [formData appendPartWithFileData:weakSelf.file.data name:@"file" fileName:weakSelf.file.filename mimeType:weakSelf.file.contentType];
    };
}

@end
