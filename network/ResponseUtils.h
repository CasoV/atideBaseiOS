//
//  ResponseUtils.h
//  YNXYJTXXPT
//
//  Created by 末末班车 on 2017/6/28.
//  Copyright © 2017年 末末班车. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ResponseUtils : NSObject

+ (BOOL)success:(NSData *)data;

+ (NSString *)getMsg;

+ (id)getData:(NSString *)key;



@end
