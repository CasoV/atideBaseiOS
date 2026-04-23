//
//  TLToken.h
//  ZegoRoomkitDemo
//
//  Created by Kael Ding on 2020/7/17.
//  Copyright © 2020 zego. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TLToken : NSObject

+ (void)getAccessTokenWithCompletion:(void(^)(NSString * _Nullable token))completion;

+ (NSString *)getToken;
+ (void)saveToken:(nullable NSString *)token;



@end

NS_ASSUME_NONNULL_END
