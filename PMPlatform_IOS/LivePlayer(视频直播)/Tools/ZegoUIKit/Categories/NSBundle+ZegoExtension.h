//
//  NSBundle+ZegoExtension.h
//  ZegoEducation
//
//  Created by zego on 2019/12/5.
//  Copyright © 2019 Shenzhen Zego Technology Company Limited. All rights reserved.
//
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

static NSString *const ZEGOLanguageChinese = @"zh-Hans";
static NSString *const ZEGOLanguageTraditionalChinese = @"zh-Hant";
static NSString *const ZEGOLanguageEnglish = @"en";
static NSString *const ZEGOLanguageJapanese = @"ja";
static NSString *const ZEGOLanguageKorean = @"ko";

@interface NSBundle (ZegoExtension)

+ (void)zego_setLanguage:(NSString *)language;

+ (NSString *)zego_currentLanguage;

+ (BOOL)zego_isLanguageZHHans;   // 简体中文
+ (BOOL)zego_isLanguageZHHant;   // 繁体中文
+ (BOOL)zego_isLanguageJA;       // 日语
+ (BOOL)zego_isLanguageKO;       // 韩语
+ (BOOL)zego_isLanguageEN;       // 英语

@end

NS_ASSUME_NONNULL_END
