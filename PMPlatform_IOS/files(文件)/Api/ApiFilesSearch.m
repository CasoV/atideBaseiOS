//
//  ApiFilesSearch.m
//  ConstructionApp
//
//  Created by mac on 2017/11/14.
//  Copyright © 2017年 atide. All rights reserved.
//

#import "ApiFilesSearch.h"

@implementation ApiFilesSearch{
    id _requestParams;
    NSString *_formId;
}

- (id)initWithFormId:(NSString *)formId {
    self = [super init];
    if (self) {
        _formId = formId;
    }
    return self;
}

- (instancetype)initWithRequestParams:(id)requestParams {
    if (self = [super init]) {
        _requestParams = requestParams;
    }
    return self;
}


- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodGET;
}

- (YTKResponseSerializerType)responseSerializerType {
    return YTKResponseSerializerTypeHTTP;
}

- (NSString *)requestUrl {
    return @"fs/files/search";
}


- (id)requestArgument{
    if (_formId) {
        return @{@"metaData.formId":_formId};
    }
    if (_requestParams) {
        return _requestParams;
    }
    return nil;
}

@end
