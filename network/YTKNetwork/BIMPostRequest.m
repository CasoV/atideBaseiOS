//
//  ERMPostRequest.m
//  erm
//
//  Created by mac on 2017/10/23.
//  Copyright © 2017年 atide. All rights reserved.
//

#import "BIMPostRequest.h"
#import <SVProgressHUD/SVProgressHUD.h>
#import "YTKNetworkConfig.h"
#import "AppUser.h"
#import "DDLog.h"

#ifdef DEBUG
static const int ddLogLevel = LOG_LEVEL_OFF;//LOG_LEVEL_VERBOSE;
#else
static const int ddLogLevel = LOG_LEVEL_OFF;
#endif
@interface BIMPostRequest ()

@end

@implementation BIMPostRequest

- (id)initWithRequestParams:(id)requestParams{
    self = [super init];
    if (self) {
        self.requestParams = requestParams;
    }
    return self;
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodPOST;
}

- (YTKResponseSerializerType)responseSerializerType {
    return YTKResponseSerializerTypeHTTP;
}

- (id)requestArgument {
    if (self.requestParams) {
        return self.requestParams;
    }
    return nil;
}

- (void)requestCompleteFilter {

    [[NSNotificationCenter defaultCenter] postNotificationName:NotifacationName_ResetAutoLogin object:nil];
}

- (void)requestFailedFilter{
    DDLogDebug(@"description:%@",[self description]);
    DDLogInfo(@"API-DEBUG:\n API-NAME = %@\n REQUEST-URL = %@%@\n POST-ARGUMENT = \n%@ \n\n  ",NSStringFromClass([self class]),[YTKNetworkConfig sharedConfig].baseUrl,[self requestUrl],[self.requestArgument description]);
    
    DDLogDebug(@"[DEBUG]responseStatusCode:%zd",[self responseStatusCode]);
    DDLogDebug(@"%@",[self.currentRequest.allHTTPHeaderFields description]);
    DDLogDebug(@"[DEBUG]RESPONSE-headers:\n%@",[[self responseHeaders] description]);
    DDLogDebug(@"[error:\n%@",[[self error] localizedDescription]);
    [SVProgressHUD showInfoWithStatus:[self.error localizedDescription]];
}

@end
