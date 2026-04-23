//
//  WebServiceConfig.h
//  PMPlatform_IOS
//
//  Created by vxg on 2017/09/05.
//  Copyright © 2017年 com.atide. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WebServiceConfig : NSObject
@property (class, nonatomic, copy, readonly) NSString *SecurityService;
@property (class, nonatomic, copy, readonly) NSString *PrjectOverViewService;
@property (class, nonatomic, copy, readonly) NSString *PayWebService;
@property (class, nonatomic, copy, readonly) NSString *ProgressService;
@property (class, nonatomic, copy, readonly) NSString *SingleProjectService;
+ (NSDictionary *)config:(NSString *)category;
@end
