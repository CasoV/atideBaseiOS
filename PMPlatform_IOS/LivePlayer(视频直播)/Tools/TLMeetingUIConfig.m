//
//  TLMeetingConfig.m
//  ZegoRoomkitDemo
//
//  Created by Kael Ding on 2020/7/20.
//  Copyright © 2020 zego. All rights reserved.
//

#import "TLMeetingUIConfig.h"

@implementation TLMeetingUIConfig

- (instancetype)init {
    self = [super init];
    if (self) {
        [self configDefault];
    }
    return self;
}

- (void)configDefault {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSData *data = [userDefaults objectForKey:NSStringFromClass([TLMeetingUIConfig class])];
    TLMeetingUIConfig *setting = nil;
    if (data) {
        setting = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    }
    self.isBottomBarHidden = setting ? setting.isBottomBarHidden : NO;
    self.isChatHidden = setting ? setting.isChatHidden : NO;
    self.isAttendeesHidden = setting ? setting.isAttendeesHidden : NO;
    self.isShareHidden = setting ? setting.isShareHidden : NO;
    self.isCameraHidden = setting ? setting.isCameraHidden : NO;
    self.isMicrophoneHidden = setting ? setting.isMicrophoneHidden : NO;
    self.isMoreHidden = setting ? setting.isMoreHidden : NO;
    self.isUploadFileHidden = setting ? setting.isUploadFileHidden : NO;
    self.isMemberCountHidden = setting ? setting.isMemberCountHidden : NO;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if (self) {
        _isBottomBarHidden = [aDecoder decodeBoolForKey:@"isBottomBarHidden"];
        _isChatHidden = [aDecoder decodeBoolForKey:@"isChatHidden"];
        _isAttendeesHidden = [aDecoder decodeBoolForKey:@"isAttendeesHidden"];
        _isShareHidden = [aDecoder decodeBoolForKey:@"isShareHidden"];
        _isCameraHidden = [aDecoder decodeIntegerForKey:@"isCameraHidden"];
        _isMicrophoneHidden = [aDecoder decodeIntegerForKey:@"isMicrophoneHidden"];
        _isMoreHidden = [aDecoder decodeIntegerForKey:@"isMoreHidden"];
        _isUploadFileHidden = [aDecoder decodeIntegerForKey:@"isUploadFileHidden"];
        _isMemberCountHidden = [aDecoder decodeIntegerForKey:@"isMemberCountHidden"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeBool:self.isBottomBarHidden forKey:@"isBottomBarHidden"];
    [aCoder encodeBool:self.isChatHidden forKey:@"isChatHidden"];
    [aCoder encodeBool:self.isAttendeesHidden forKey:@"isAttendeesHidden"];
    [aCoder encodeBool:self.isShareHidden forKey:@"isShareHidden"];
    [aCoder encodeInteger:self.isCameraHidden forKey:@"isCameraHidden"];
    [aCoder encodeInteger:self.isMicrophoneHidden forKey:@"isMicrophoneHidden"];
    [aCoder encodeInteger:self.isMoreHidden forKey:@"isMoreHidden"];
    [aCoder encodeInteger:self.isUploadFileHidden forKey:@"isUploadFileHidden"];
    [aCoder encodeInteger:self.isMemberCountHidden forKey:@"isMemberCountHidden"];
}

- (void)save {
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:self];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:data forKey:NSStringFromClass([TLMeetingUIConfig class])];
}
#pragma mark - Setter
- (void)setIsBottomBarHidden:(ZegoToolBarHiddenMode)isBottomBarHidden {
    _isBottomBarHidden = isBottomBarHidden;
    [self save];
}
- (void)setIsChatHidden:(BOOL)isChatHidden {
    _isChatHidden = isChatHidden;
    [self save];
}
- (void)setIsAttendeesHidden:(BOOL)isAttendeesHidden {
    _isAttendeesHidden = isAttendeesHidden;
    [self save];
}
- (void)setIsShareHidden:(BOOL)isShareHidden {
    _isShareHidden = isShareHidden;
    [self save];
}
- (void)setIsCameraHidden:(BOOL)isCameraHidden {
    _isCameraHidden = isCameraHidden;
    [self save];
}
- (void)setIsMicrophoneHidden:(BOOL)isMicrophoneHidden {
    _isMicrophoneHidden = isMicrophoneHidden;
    [self save];
}
- (void)setIsMoreHidden:(BOOL)isMoreHidden {
    _isMoreHidden = isMoreHidden;
    [self save];
}
- (void)setIsUploadFileHidden:(BOOL)isUploadFileHidden {
    _isUploadFileHidden = isUploadFileHidden;
    [self save];
}
- (void)setIsMemberCountHidden:(BOOL)isMemberCountHidden {
    _isMemberCountHidden = isMemberCountHidden;
    [self save];
}

#pragma mark - getter
- (ZegoJoinRoomUIConfig *)joinMeetingUIConfig {
    ZegoJoinRoomUIConfig *config = [ZegoJoinRoomUIConfig new];
    config.isBottomBarHidden = self.isBottomBarHidden ? ZegoToolBarAlwaysHidden : ZegoToolBarAuto;
    config.isChatHidden = self.isChatHidden;
    config.isAttendeesHidden = self.isAttendeesHidden;
    config.isShareHidden = self.isShareHidden;
    config.isCameraHidden = self.isCameraHidden;
    config.isMicrophoneHidden = self.isMicrophoneHidden;
    config.isMoreHidden = self.isMoreHidden;
    config.isMemberCountHidden = self.isMemberCountHidden;
    config.isUploadFileHidden = NO; //默认不显示
    config.watermark = @"test watermark";
    config.language = [self language];
    config.isCompanyFilesHidden = NO;
    config.isMemberJoinRoomMessageHidden = [NSUserDefaults.standardUserDefaults boolForKey:@"joinMsg"];
    config.isMemberLeaveRoomMessageHidden = [NSUserDefaults.standardUserDefaults boolForKey:@"leaveMsg"];
    config.isFixedInOutMessage = [NSUserDefaults.standardUserDefaults boolForKey:@"fixedInOutMsg"];
    return config;
}

- (ZegoRoomUILanguage)language {
    if ([NSBundle zego_isLanguageZHHans]) {
        return ZegoRoomUILanguageZHHans;
    } else if ([NSBundle zego_isLanguageZHHant]) {
        return ZegoRoomUILanguageZHHant;
    } else if ([NSBundle zego_isLanguageJA]) {
        return ZegoRoomUILanguageJA;
    } else if ([NSBundle zego_isLanguageKO]) {
        return ZegoRoomUILanguageKO;
    } else {
        return ZegoRoomUILanguageEN;
    }
}

@end
