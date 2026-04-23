//
//  ZIMAppCenter.m
//  VoiceAndChatRoom
//
//  Created by zego on 2021/10/9.
//

#import "KeyCenter.h"

static unsigned int _appID =  46572736;//190177013;

static NSString *_appSign =@"cccd5864e26e1e30e75d4cefa4b196ae0e3d72d5c6e9729bf388cb5014f7123f"; //@"5c6592dcd7ca40772be824a5fafc9d0e8efed77ddb482a7a089c78b063bcf9e6";

static bool _isUseToken = false;

static NSString *_resourceID = @"";

@interface KeyCenter()


@end


@implementation KeyCenter

+ (unsigned int)appID {
    return  _appID;
}

+(NSString *)appSign{
    return _appSign;
}

+(bool)isUseToken{
    return _isUseToken;
}

+(void)setAppID:(unsigned int)appID{
    _appID = appID;
}

+(void)setAppSign:(NSString *)appSign{
    _appSign = appSign;
}

+(void)setIsUseToken:(bool)isUseToken{
    _isUseToken = isUseToken;
}

+(void)setResourceID:(NSString *)resourceID{
    _resourceID = resourceID;
}

+ (NSString *)resourceID{
    return _resourceID;
}

@end
