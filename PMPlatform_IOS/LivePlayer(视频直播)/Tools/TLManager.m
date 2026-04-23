//
//  TLManager.m
//  ZegoRoomkitDemo
//
//  Created by Larry on 2020/6/19.
//  Copyright © 2020 zego. All rights reserved.
//

#import "TLManager.h"

static TLManager *_singleton = nil;

@implementation TLManager

+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _singleton = [[TLManager alloc] initWithPrivate];
    });
    return _singleton;
}

- (instancetype)init {
    return nil;
}

- (instancetype)initWithPrivate {
    if (self = [super init]) {
        _isLogin =  [[NSUserDefaults standardUserDefaults] boolForKey:@"isLogin"];
    }
    return self;
}

- (void)logout {
    self.isLogin = NO;
    self.userID = 0;
    self.userName = nil;
    ZegoLeaveRoomCommand *command = [ZegoLeaveRoomCommand new];
    command.type = ZegoLeaveRoomTypeLeave;
    [[ZegoRoomKit sharedInstance].inRoomService leaveRoomWithCommand:command completion:^(ZegoRoomKitError error) {
        NSLog(@"退出登录----离开房间");
    }];
}

- (void)setIsLogin:(BOOL)isLogin {
    _isLogin = isLogin;
    [[NSUserDefaults standardUserDefaults] setBool:_isLogin forKey:@"isLogin"];
}

- (NSInteger)userID {
    if ([TLManager sharedInstance].isLogin) {
        if (_userID == 0) {
            NSString *md5Str = [ZegoRoomKit deviceID].md5String;
            _userID = [TLManager numberWithHexString:[md5Str substringFromIndex:md5Str.length - 6]];
            NSLog(@"logined userID generated: %ld", (long)_userID);
        }
    } else {
        // 每次快速加入都要根据 name 重新生成，因为 name 可能会在两次加入之间变更
        NSString *md5Str = TLManager.sharedInstance.userName.md5String;
        _userID = [TLManager numberWithHexString:[md5Str substringFromIndex:md5Str.length - 6]];
        NSLog(@"unlogined userID generated: %ld", (long)_userID);
    }
    return _userID;
}

+ (NSInteger)numberWithHexString:(NSString *)hexString {
    const char *hexChar = [hexString cStringUsingEncoding:NSUTF8StringEncoding];
    int hexNumber;
//    sscanf(hexChar, "%x", &hexNumber);
    return (NSInteger)hexNumber;
}


@end
