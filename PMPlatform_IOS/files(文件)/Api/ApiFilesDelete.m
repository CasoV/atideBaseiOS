//
//  ApiFilesDelete.m
//  ConstructionApp
//
//  Created by mac on 2017/11/14.
//  Copyright © 2017年 atide. All rights reserved.
//

#import "ApiFilesDelete.h"

@implementation ApiFilesDelete{
    NSString *_fileId;
}

- (id)initWithFileId:(NSString *)fileId {
    self = [super init];
    if (self) {
        if (fileId == nil) {
            return nil;
        }
        _fileId = fileId;
        
    }
    return self;
}


- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodDELETE;
}

- (YTKResponseSerializerType)responseSerializerType {
    return YTKResponseSerializerTypeHTTP;
}

- (NSString *)requestUrl {
    return [@"fs/files/delete" stringByAppendingPathComponent:_fileId];
}

@end
