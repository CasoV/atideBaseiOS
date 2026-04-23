//
//  NSBundle+ZegoExtension.m
//  ZegoEducation
//
//  Created by zego on 2019/12/5.
//  Copyright © 2019 Shenzhen Zego Technology Company Limited. All rights reserved.
//

#import "NSBundle+ZegoExtension.h"

#import <objc/runtime.h>

#pragma mark - 语言设置

static const char _bundle = 0;

@interface ZegoBundle : NSBundle

@end

@implementation ZegoBundle

- (NSString *)localizedStringForKey:(NSString *)key value:(NSString *)value table:(NSString *)tableName
{
    NSBundle *bundle = objc_getAssociatedObject(self, &_bundle);
    return bundle ? [bundle localizedStringForKey:key value:value table:tableName] : [super localizedStringForKey:key value:value table:tableName];
}

@end


@implementation NSBundle (ZegoExtension)

+ (void)zego_setLanguage:(NSString *)language
{
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        object_setClass([NSBundle mainBundle], [ZegoBundle class]);
//    });
//
//    objc_setAssociatedObject([NSBundle mainBundle], &_bundle, language ? [NSBundle bundleWithPath:[[NSBundle mainBundle] pathForResource:language ofType:@"lproj"]] : nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [NSBundle zego_setUserLanguage:language];
}

+ (NSString *)zego_currentLanguage
{
    NSArray *languages = [[NSUserDefaults standardUserDefaults]objectForKey:@"AppleLanguages"];
    return [languages firstObject];
}

// 简体中文
+ (BOOL)zego_isLanguageZHHans
{
    NSString *language = [NSBundle zego_currentLanguage];
    if ([language hasPrefix:ZEGOLanguageChinese]) {
        return YES;
    }
    return NO;
}

+ (void)zego_setUserLanguage:(NSString *)userLanguage
{
    [[NSUserDefaults standardUserDefaults] setValue:userLanguage forKey:@"UWUserLanguageKey"];
    [[NSUserDefaults standardUserDefaults] setValue:@[userLanguage] forKey:@"AppleLanguages"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

// 繁体中文
+ (BOOL)zego_isLanguageZHHant
{
    NSString *language = [NSBundle zego_currentLanguage];
    if ([language hasPrefix:ZEGOLanguageTraditionalChinese]) {
        return YES;
    }
    return NO;
}

// 日文
+ (BOOL)zego_isLanguageJA
{
    NSString *language = [NSBundle zego_currentLanguage];
    if ([language isEqualToString:ZEGOLanguageJapanese] || [language hasPrefix:[NSString stringWithFormat:@"%@-", ZEGOLanguageJapanese]]) {
        return YES;
    }
    return NO;
}

// 韩语
+ (BOOL)zego_isLanguageKO
{
    NSString *language = [NSBundle zego_currentLanguage];
    if ([language isEqualToString:ZEGOLanguageKorean] || [language hasPrefix:[NSString stringWithFormat:@"%@-", ZEGOLanguageKorean]]) {
        return YES;
    }
    return NO;
}

// 英语
+ (BOOL)zego_isLanguageEN
{
    NSString *language = [NSBundle zego_currentLanguage];
    if ([language isEqualToString:ZEGOLanguageEnglish] || [language hasPrefix:[NSString stringWithFormat:@"%@-", ZEGOLanguageEnglish]]) {
        return YES;
    }
    return NO;
}

@end

