//
//  NSString+encryptionMD5.h
//  ycxm
//
//  Created by 末末班车 on 2020/3/16.
//  Copyright © 2020 末末班车. All rights reserved.
//
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (encryptionMD5)

//MARK:外部调用,用于字符串加密
+(NSMutableString *)stringMD5:(NSString *)string;

@end

NS_ASSUME_NONNULL_END
