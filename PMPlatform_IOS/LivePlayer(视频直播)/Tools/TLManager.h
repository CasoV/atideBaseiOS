//
//  TLManager.h
//  ZegoRoomkitDemo
//
//  Created by Larry on 2020/6/19.
//  Copyright © 2020 zego. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TLManager : NSObject

@property (nonatomic, assign) NSInteger userID;
@property (nonatomic, copy) NSString *userName;
@property (nonatomic, copy, readonly) NSString *token;
@property (nonatomic, assign) BOOL isLogin;

+ (instancetype)sharedInstance;

- (void)logout;

@end

NS_ASSUME_NONNULL_END
