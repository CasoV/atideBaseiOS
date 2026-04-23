//
//  WebserviceManager.h
//  PMPlatform_IOS
//
//  Created by vxg on 2017/09/05.
//  Copyright © 2017年 com.atide. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WebserviceManager : NSObject
+(NSMutableURLRequest *)getUrlRequest:(NSMutableDictionary *)params
                               header:(NSMutableDictionary *)header
                                  url:(NSString *)url
                               method:(NSString *)method
                            nameSpace:(NSString *)nameSpace;
+(NSMutableURLRequest *)getUrlRequest:(NSMutableDictionary *)params
                                  url:(NSString *)url
                               method:(NSString *)method
                            nameSpace:(NSString *)nameSpace;

+(NSString *)getSoapMsg:(NSMutableDictionary *)tokenDict
                   body:(NSMutableDictionary *)bodyDict
                 method:(NSString *)method
              namespace:(NSString *)nameSpace;

+(NSString *)getPaySoapMsg:(NSMutableDictionary *)tokenDict
                   body:(NSMutableDictionary *)bodyDict
                 method:(NSString *)method
              namespace:(NSString *)nameSpace;

+(void)dataTaskWithSoapRequest:(NSMutableDictionary *)params
                           url:(NSString *)url
                        method:(NSString *)method
                     nameSpace:(NSString *)nameSpace
                     completed:(void (^)(NSData * __nullable data, NSURLResponse * __nullable response, NSError * __nullable error))completionHandler;

+(void)dataTaskWithSoapRequest:(NSMutableDictionary *)params
                        header:(NSMutableDictionary *)header
                           url:(NSString *)url
                        method:(NSString *)method
                     nameSpace:(NSString *)nameSpace
                     completed:(void (^)(NSData * __nullable data, NSURLResponse * __nullable response, NSError * __nullable error))completionHandler;
@end
