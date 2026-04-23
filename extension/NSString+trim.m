//
//  NSString+trim.m
//  PMPlatform_IOS
//
//  Created by vxg on 2017/09/06.
//  Copyright © 2017年 com.atide. All rights reserved.
//

#import "NSString+trim.h"
#import <CommonCrypto/CommonCryptor.h>

@implementation NSString (trim)
- (NSString *)trim{
    return [NSString stringWithFormat:@"%.0f",self.floatValue];
}

- (NSString *)aesEncrypt {
    NSString *key = @"ATIDEABCDEF12134";
    NSString *iv = @"12134ABCDEFATIDE";
 
    char keyPtr[kCCKeySizeAES128 + 1];
    char ivPtr[kCCKeySizeAES128];
    
    memset(keyPtr, 0, sizeof(keyPtr));
    memset(keyPtr, 0, sizeof(ivPtr));

    [key getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];
    [iv getCString:ivPtr maxLength:sizeof(ivPtr) encoding:NSUTF8StringEncoding];
 
    NSData* data = [self dataUsingEncoding:NSUTF8StringEncoding];
    
    NSUInteger dataLength = [data length];
    
    size_t bufferSize = dataLength + kCCBlockSizeAES128;
    
    void *buffer = malloc(bufferSize);

    size_t numBytesEncrypted = 0;
    
    CCCryptorStatus cryptStatus = CCCrypt(kCCEncrypt,
                                          kCCAlgorithmAES128,
                                          kCCOptionPKCS7Padding|kCCOptionECBMode,
                                          keyPtr,
                                          kCCBlockSizeAES128,
                                          NULL,
                                          [data bytes],
                                          dataLength,
                                          buffer,
                                          bufferSize,
                                          &numBytesEncrypted);
    
    if (cryptStatus == kCCSuccess) {
        NSData *resultData = [NSData dataWithBytesNoCopy:buffer length:numBytesEncrypted];

        NSString *base64String = [resultData base64EncodedStringWithOptions:0];

        return base64String;
    }
    
    free(buffer);
    
    return nil;
}

@end
