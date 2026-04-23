//
//  TLOutRoomService.h
//  ZegoRoomkitDemo
//
//  Created by xia on 2021/6/9.
//  Copyright © 2021 zego. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TLOutRoomService : NSObject

+ (void)createRoomWithDict:(NSDictionary *)dict
                completion:(void(^)(NSInteger errorCode, NSDictionary * _Nullable data))completion;

+ (void)deleteRoomWithDict:(NSDictionary *)dict
                completion:(void(^)(NSInteger errorCode, NSDictionary * _Nullable data))completion;

+ (void)listRoomWithDict:(NSDictionary *)dict
              completion:(void(^)(NSInteger errorCode, NSDictionary * _Nullable data))completion;

+ (void)queryRoomWithDict:(NSDictionary *)dict
               completion:(void(^)(NSInteger errorCode, NSDictionary * _Nullable data))completion;

@end

NS_ASSUME_NONNULL_END
