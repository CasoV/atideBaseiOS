//
//  WebserviceManager.m
//  PMPlatform_IOS
//
//  Created by vxg on 2017/09/05.
//  Copyright © 2017年 com.atide. All rights reserved.
//

#import "WebserviceManager.h"

@implementation WebserviceManager
+(NSMutableURLRequest *)getUrlRequest:(NSMutableDictionary *)params
                                  url:(NSString *)url
                               method:(NSString *)method
                            nameSpace:(NSString *)nameSpace{
    NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    NSString *soapMsg = [WebserviceManager getSoapMsg:nil
                                           body:params method:method
                                      namespace:nameSpace];
    
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:[soapMsg dataUsingEncoding:NSUTF8StringEncoding]];
    [request addValue:@"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    
    return request;
}

+(NSMutableURLRequest *)getUrlRequest:(NSMutableDictionary *)params
                               header:(NSMutableDictionary *)header
                                  url:(NSString *)url
                               method:(NSString *)method
                            nameSpace:(NSString *)nameSpace{
    NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    NSString *soapMsg = [WebserviceManager getPaySoapMsg:header
                                                 body:params method:method
                                            namespace:nameSpace];
    
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:[soapMsg dataUsingEncoding:NSUTF8StringEncoding]];
    [request addValue:@"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    return request;
}

+(NSString *)getSoapMsg:(NSMutableDictionary *)tokenDict
                   body:(NSMutableDictionary *)bodyDict
                 method:(NSString *)method
              namespace:(NSString *)nameSpace{
    
    NSString *nameSpaceHttp = [NSString stringWithFormat:@"\"%@\"",nameSpace];
    NSString *soapMsg = [NSString stringWithFormat:
                         @"<?xml version=\"1.0\" encoding=\"utf-8\"?>"
                         "<soap:Envelope "
                         "xmlns:soap=\"http://www.w3.org/2003/05/soap-envelope\">"];
    
    NSString *soap12Header = nil;
    if(tokenDict!=nil && [tokenDict count]>0 ){
        soap12Header = [NSString stringWithFormat:
                        @"\r\n<soap:Header>"
                        "\r\n\r\n<TokenHeader xmlns=%@>\r\n\r\n\r\n",nameSpaceHttp];
        NSArray *keys = [tokenDict allKeys];
        for (NSString *key  in  keys) {
            NSString *value = [tokenDict objectForKey:key];
            soap12Header = [soap12Header stringByAppendingFormat:@"<%@>%@</%@>\n",
                            key,value,key];
        }
        soap12Header = [soap12Header stringByAppendingFormat:@"\r\n\r\n</TokenHeader>\r\n</soap:Header>"];
    }
    
    NSString *soapBody = [NSString stringWithFormat:
                          @"\r\n<soap:Body>"
                          "\r\n\r\n<%@ xmlns=%@>",
                          method,nameSpaceHttp];
    if (bodyDict !=nil && [bodyDict count] > 0) {
        NSArray *bodyKeys = [bodyDict allKeys];
        for (NSString *body in bodyKeys) {
            NSObject *bodyVa = [bodyDict objectForKey:body];
            if ([bodyVa isKindOfClass:[NSArray class]]) {
                NSArray *arrVa = bodyVa;
                soapBody = [soapBody stringByAppendingFormat:@"<%@>\n",
                            body];
                for (NSString *key in arrVa) {
                    soapBody = [soapBody stringByAppendingFormat:@"<string>%@</string>\n",
                                key];
                }
                soapBody = [soapBody stringByAppendingFormat:@"</%@>\n",
                            body];

            } else {
                soapBody = [soapBody stringByAppendingFormat:@"<%@>%@</%@>\n",
                            body,bodyVa,body];
            }
            
        }
        soapBody = [soapBody stringByAppendingFormat:@"</%@>\n",method];
    }else {
        soapBody = [soapBody stringByAppendingFormat:@"</%@>\n",method];
    }
    soapBody = [soapBody stringByAppendingFormat:@"</soap:Body>"];
    if (soap12Header != nil) {
        soapMsg = [soapMsg stringByAppendingFormat:@"%@%@\n</soap:Envelope>",soap12Header,soapBody];
    }else{
        soapMsg = [soapMsg stringByAppendingFormat:@"%@\n</soap:Envelope>",soapBody];
    }
    
    
    return soapMsg;
}

+(NSString *)getPaySoapMsg:(NSMutableDictionary *)tokenDict
                   body:(NSMutableDictionary *)bodyDict
                 method:(NSString *)method
              namespace:(NSString *)nameSpace{
    
    NSString *nameSpaceHttp = [NSString stringWithFormat:@"\"%@\"",nameSpace];
    NSString *soapMsg = [NSString stringWithFormat:
                         @"<v:Envelope xmlns:i=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:d=\"http://www.w3.org/2001/XMLSchema\" xmlns:c=\"http://schemas.xmlsoap.org/soap/encoding/\" xmlns:v=\"http://schemas.xmlsoap.org/soap/envelope/\">"];
    
    NSString *soap12Header = nil;
    if(tokenDict!=nil && [tokenDict count]>0 ){
        soap12Header = [NSString stringWithFormat:
                        @"\r\n<v:Header>"
                        "\r\n\r\n<TokenHeader xmlns=%@>\r\n\r\n\r\n",nameSpaceHttp];
        NSArray *keys = [tokenDict allKeys];
        for (NSString *key  in  keys) {
            NSString *value = [tokenDict objectForKey:key];
            soap12Header = [soap12Header stringByAppendingFormat:@"<%@>%@</%@>\n",
                            key,value,key];
        }
        soap12Header = [soap12Header stringByAppendingFormat:@"\r\n\r\n</TokenHeader>\r\n</v:Header>"];
    }
    
    NSString *soapBody = [NSString stringWithFormat:
                          @"\r\n<v:Body>"
                          "\r\n\r\n<%@ xmlns=%@>",
                          method,nameSpaceHttp];
    if (bodyDict !=nil && [bodyDict count] > 0) {
        NSArray *bodyKeys = [bodyDict allKeys];
        for (NSString *body in bodyKeys) {
            NSObject *bodyVa = [bodyDict objectForKey:body];
            if ([bodyVa isKindOfClass:[NSArray class]]) {
                NSArray *arrVa = bodyVa;
                soapBody = [soapBody stringByAppendingFormat:@"<%@>\n",
                            body];
                for (NSString *key in arrVa) {
                    soapBody = [soapBody stringByAppendingFormat:@"<string>%@</string>\n",
                                key];
                }
                soapBody = [soapBody stringByAppendingFormat:@"</%@>\n",
                            body];
                
            } else {
                soapBody = [soapBody stringByAppendingFormat:@"<%@>%@</%@>\n",
                            body,bodyVa,body];
            }
            
        }
        soapBody = [soapBody stringByAppendingFormat:@"</%@>\n",method];
    }else {
        soapBody = [soapBody stringByAppendingFormat:@"</%@>\n",method];
    }
    soapBody = [soapBody stringByAppendingFormat:@"</v:Body>"];
    if (soap12Header != nil) {
        soapMsg = [soapMsg stringByAppendingFormat:@"%@%@\n</v:Envelope>",soap12Header,soapBody];
    }else{
        soapMsg = [soapMsg stringByAppendingFormat:@"%@\n</v:Envelope>",soapBody];
    }
    
    
    return soapMsg;
}

+(void)dataTaskWithSoapRequest:(NSMutableDictionary *)params
                           url:(NSString *)url
                        method:(NSString *)method
                     nameSpace:(NSString *)nameSpace
                     completed:(void (^)(NSData * __nullable data, NSURLResponse * __nullable response, NSError * __nullable error))completionHandler{
    NSURLSession *session = [NSURLSession sharedSession];
    NSMutableURLRequest *request = [WebserviceManager getUrlRequest:params
                                                          url:url
                                                       method:method
                                                    nameSpace:nameSpace];
    
    NSURLSessionDataTask *task =
    [session dataTaskWithRequest:request
               completionHandler:completionHandler];
    [task resume];
}

+(void)dataTaskWithSoapRequest:(NSMutableDictionary *)params
                        header:(NSMutableDictionary *)header
                           url:(NSString *)url
                        method:(NSString *)method
                     nameSpace:(NSString *)nameSpace
                     completed:(void (^)(NSData * __nullable data, NSURLResponse * __nullable response, NSError * __nullable error))completionHandler{
    NSURLSession *session = [NSURLSession sharedSession];
    NSMutableURLRequest *request = [WebserviceManager getUrlRequest:params
                                                             header:header
                                                                url:url
                                                             method:method
                                                          nameSpace:nameSpace];
    
    NSURLSessionDataTask *task =
    [session dataTaskWithRequest:request
               completionHandler:completionHandler];
    [task resume];
}
@end
