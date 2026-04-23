//
//  NSObject+NSURLRequest_IgnoreSSL.m
//  PMPlatform_IOS
//
//  Created by 高小伟 on 2024/3/11.
//  Copyright © 2024 com.atide. All rights reserved.
//

#import "NSObject+NSURLRequest_IgnoreSSL.h"

@implementation NSURLRequest (IgnoreSSL)


+ (BOOL)allowsAnyHTTPSCertificateForHost:(NSString *)host {
    return YES;
}

+ (void)setAllowsAnyHTTPSCertificate:(BOOL)allow forHost:(NSString *)host {
    
}
@end
