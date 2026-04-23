//
//  NSObject+NSURLRequest_IgnoreSSL.h
//  PMPlatform_IOS
//
//  Created by 高小伟 on 2024/3/11.
//  Copyright © 2024 com.atide. All rights reserved.
//


#import <Foundation/Foundation.h>
 

@interface NSURLRequest (IgnoreSSL)
+ (BOOL)allowsAnyHTTPSCertificateForHost:(NSString *)host;
+ (void)setAllowsAnyHTTPSCertificate:(BOOL)allow forHost:(NSString *)host;
@end
 
