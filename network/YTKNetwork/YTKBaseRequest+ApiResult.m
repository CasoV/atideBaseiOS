//
//  YTKBaseRequest+ApiResult.m
//  Community
//
//  Created by Arthur Wang on 15/2/11.
//  Copyright (c) 2015年 speed. All rights reserved.
//

#import "YTKBaseRequest+ApiResult.h"
#import "YTKNetworkConfig.h"
#import "DDLog.h"

#ifdef DEBUG
static const int ddLogLevel = LOG_LEVEL_INFO;//LOG_LEVEL_VERBOSE;
#else
static const int ddLogLevel = LOG_LEVEL_OFF;
#endif


@implementation YTKBaseRequest (ApiResult)

- (BOOL)resultIsSuccess{
    DDLogInfo(@"API-DEBUG:\n API-NAME = %@\n REQUEST-URL = %@/%@\n POST-ARGUMENT = \n%@ \n RESPONSE-JSON =\n%@\n\n  ",NSStringFromClass([self class]),[YTKNetworkConfig sharedConfig].baseUrl,[self requestUrl],[self.requestArgument description],[self responsePrintJsonString]);
    
    DDLogDebug(@"[DEBUG]RESPONSE-headers:\n%@",[[self responseHeaders] description]);
    DDLogDebug(@"[DEBUG]RESPONSE-raw-string:\n%@",[self responseString]);
    if ([[self responseJSON] objectForKey:@"succeed"]) {
        return [[[self responseJSON] objectForKey:@"succeed"] boolValue];
    }
    else if ([[self responseJSON] objectForKey:@"success"]) {
        return [[[self responseJSON] objectForKey:@"success"] boolValue];
    }
    else{
        return NO;
    }
    
}
- (id)responseJSON{

    NSData *data = [[self responseString] dataUsingEncoding:NSUTF8StringEncoding];
    if (data) {
        NSError *dataError = nil;
        id jsonObject = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&dataError];
        return jsonObject;
    }
    else{
        return nil;
    }
    
}


- (NSString *)responsePrintJsonString{
    NSError *errorj;
    // 创造一个json从Data, NSJSONWritingPrettyPrinted指定的JSON数据产的空白，使输出更具可读性。
    
    if ([[self responseString] length] == 0) {
        return nil;
    }
    NSData *data = [[self responseString] dataUsingEncoding:NSUTF8StringEncoding];
    NSError *dataError = nil;
    id jsonObject = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&dataError];
    if (jsonObject == nil) {
        return nil;
    }
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:jsonObject options:NSJSONWritingPrettyPrinted error:&errorj];
    NSString *json =[[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    return json;
}

- (NSDictionary *)resultData{
    id jsonObject = [[self responseJSON] objectForKey:@"data"];
    if ([jsonObject isKindOfClass:[NSDictionary class]]) {
        return (NSDictionary *)jsonObject;
    }
    else{
        return nil;
    }
    
}

- (NSArray *)resultDataArray{
    id jsonObject = [[self responseJSON] objectForKey:@"data"];
    if ([jsonObject isKindOfClass:[NSArray class]]) {
        return (NSArray *)jsonObject;
    }
    else{
        return nil;
    }
}

- (NSArray *)resultRows{
    DDLogInfo(@"API-DEBUG:\n API-NAME = %@\n REQUEST-URL = %@/%@\n POST-ARGUMENT = \n%@ \n RESPONSE-JSON =\n%@\n\n  ",NSStringFromClass([self class]),[YTKNetworkConfig sharedConfig].baseUrl,[self requestUrl],[self.requestArgument description],[self responsePrintJsonString]);
    id jsonObject = [[self responseJSON] objectForKey:@"rows"];
    if ([jsonObject isKindOfClass:[NSArray class]]) {
        return (NSArray *)jsonObject;
    }
    else{
        return nil;
    }
    
}


- (NSString *)resultMsg{
    if ([[self responseJSON] objectForKey:@"msg"]) {
        return [[self responseJSON] objectForKey:@"msg"];
    }
    else if ([[self responseJSON] objectForKey:@"message"]){
        return [[self responseJSON] objectForKey:@"message"];
    }
    else return nil;
    
}

@end
