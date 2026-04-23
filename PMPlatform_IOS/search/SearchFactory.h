//
//  SearchFactory.h
//  PMPlatform_IOS
//
//  Created by 末末班车 on 2017/9/6.
//  Copyright © 2017年 com.atide. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ChildBaseController.h"

typedef NS_ENUM(NSInteger, SearchType) {
    SearchTypeToDo = 1,
    SearchTypeDoing,
    SearchTypeDone,
    SearchTypeRcvCirculated,
    SearchTypeRcvApproval,
    SearchTypeRcvPublicity,
    SearchTypeSendManagement,
    SearchTypeSendPublicity,
    SearchTypeSealIn,
    SearchTypeSealEx,
    SearchTypeSealLoan
};

typedef NS_ENUM(NSInteger, BizKeyType) {
    BizKeyTypeSend,
    BizKeyTypeDeal,
    BizKeyTypeRead,
    BizKeyTypeSealIn,
    BizKeyTypeSealEx,
    BizKeyTypeSealLoan
};

typedef NS_ENUM(NSInteger, UrgencyType) {
    UrgencyTypeExtraUrgent = 1,
    UrgencyTypeDispatch,
    UrgencyTypeUrgent,
    UrgencyTypePiece,
    UrgencyTypeUnknow
};

typedef NS_ENUM(NSInteger, SecretLevelType) {
    SecretLevelTypeTop = 1,
    SecretLevelTypeAsecret,
    SecretLevelTypeConfidential,
    SecretLevelTypeSecret,
    SecretLevelTypeInner,
    SecretLevelTypeAll,
    SecretLevelTypeUnknow
};

typedef NS_ENUM(NSInteger, StatusType) {
    StatusTypeDraft = 1,
    StatusTypeReturn,
    StatusTypeCirculation,
    StatusTypePassed
};

typedef NS_ENUM(NSInteger, ApprovalType) {
    StatusTypeIn = 1,
    StatusTypeEx
};

@interface SearchFactory : NSObject

+ (ChildBaseController *)generatorController:(SearchType)type;

+ (NSString *)generatorTitleText:(SearchType)type;

+ (NSString *)getBizKeyTypeName:(BizKeyType)type;

+ (NSString *)getBizKeyTypeID:(BizKeyType)type;

+ (NSString *)getUrgencyTypeName:(UrgencyType)type;

+ (NSString *)getSecretLevelTypeName:(SecretLevelType)type;

+ (NSString *)getStatusTypeName:(StatusType)type;

+ (NSArray <NSNumber *>*)getAllBizKeyType;

+ (NSArray <NSNumber *>*)getAllUrgencyType;

+ (NSArray <NSNumber *>*)getAllSecretLevelType;

+ (NSArray <NSNumber *>*)getAllStatusType;

+ (NSString *)getApprovalTypeName:(StatusType)type;

+ (NSArray <NSNumber *>*)getAllApprovalType;
@end
