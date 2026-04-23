//
//  SearchFactory.m
//  PMPlatform_IOS
//
//  Created by 末末班车 on 2017/9/6.
//  Copyright © 2017年 com.atide. All rights reserved.
//

#import "SearchFactory.h"
#import "DocumentController.h"
#import "ProcessListController.h"

@implementation SearchFactory

+ (ChildBaseController *)generatorController:(SearchType)type {
    ChildBaseController *vc;
    switch (type) {
        case SearchTypeToDo:
            vc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"processList"];
            vc.url = [UrlConfig URL:getTodoList];
            break;
        case SearchTypeDoing:
            vc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"processList"];
            vc.url = [UrlConfig URL:getTodoMsgList];
            break;
        case SearchTypeDone:
            vc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"processList"];
            vc.url = [UrlConfig URL:getDoneList];
            break;
        case SearchTypeRcvCirculated:
            vc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"document"];
            vc.url = [UrlConfig URL:queryRcvList];
            break;
        case SearchTypeRcvApproval:
            vc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"document"];
            vc.url = [UrlConfig URL:queryRcvList];
            break;
        case SearchTypeRcvPublicity:
            vc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"document"];
            vc.url = [UrlConfig URL:queryRcvBookList];
            break;
        case SearchTypeSendManagement:
            vc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"document"];
            vc.url = [UrlConfig URL:queryList];
            break;
        case SearchTypeSendPublicity:
            vc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"document"];
            vc.url = [UrlConfig URL:queryList];
            break;
        case SearchTypeSealIn:
            vc = [[UIStoryboard storyboardWithName:@"InternalSeals" bundle:nil] instantiateViewControllerWithIdentifier:@"InternalSealsVc"];
            vc.url = [UrlConfig URL:sealQueryList];
            break;
        case SearchTypeSealEx:
            vc = [[UIStoryboard storyboardWithName:@"InternalSeals" bundle:nil] instantiateViewControllerWithIdentifier:@"InternalSealsVc"];
            vc.url = [UrlConfig URL:sealQueryList];
            break;
        case SearchTypeSealLoan:
            vc = [[UIStoryboard storyboardWithName:@"LoanSealList" bundle:nil] instantiateViewControllerWithIdentifier:@"LoanSealListVc"];
            vc.url = [UrlConfig URL:loanQueryList];
            break;
        default:
            break;
    }
    vc.searchType = type;
    return vc;
}

+ (NSString *)generatorTitleText:(SearchType)type {
    switch (type) {
        case SearchTypeToDo:
            return @"我的待办";
            break;
        case SearchTypeDoing:
            return @"我的消息";
            break;
        case SearchTypeDone:
            return @"我的已办";
            break;
        case SearchTypeRcvCirculated:
            return @"收文传阅";
            break;
        case SearchTypeRcvApproval:
            return @"收文批阅";
            break;
        case SearchTypeRcvPublicity:
            return @"收文公示";
            break;
        case SearchTypeSendManagement:
            return @"发文管理";
            break;
        case SearchTypeSendPublicity:
            return @"发文公示";
            break;
        case SearchTypeSealIn:
            return @"内部用印";
            break;
        case SearchTypeSealEx:
            return @"外部用印";
            break;
        case SearchTypeSealLoan:
            return @"印章外借";
            break;
        default:
            return @"未知";
            break;
    }
}

+ (NSArray<NSNumber *> *)getAllBizKeyType {
    return @[@(BizKeyTypeSend), @(BizKeyTypeDeal), @(BizKeyTypeRead)];
}

+ (NSArray <NSNumber *>*)getAllUrgencyType {
    return @[@(UrgencyTypeExtraUrgent), @(UrgencyTypeDispatch), @(UrgencyTypeUrgent), @(UrgencyTypePiece), @(UrgencyTypeUnknow)];
}

+ (NSArray <NSNumber *>*)getAllSecretLevelType {
    return @[@(SecretLevelTypeTop), @(SecretLevelTypeAsecret), @(SecretLevelTypeConfidential), @(SecretLevelTypeSecret), @(SecretLevelTypeInner), @(SecretLevelTypeAll), @(SecretLevelTypeUnknow)];
}

+ (NSArray <NSNumber *>*)getAllStatusType {
    return @[@(StatusTypeDraft), @(StatusTypeReturn), @(StatusTypeCirculation), @(StatusTypePassed)];
}
+ (NSArray <NSNumber *>*)getAllApprovalType {
    return @[@(StatusTypeIn), @(StatusTypeEx)];
}

+ (NSString *)getBizKeyTypeName:(BizKeyType)type {
    switch (type) {
        case BizKeyTypeSend:
            return @"发文";
            break;
        case BizKeyTypeDeal:
            return @"收文批阅";
            break;
        case BizKeyTypeRead:
            return @"收文传阅";
            break;
        default:
            return @"未知";
            break;
    }
}

+ (NSString *)getUrgencyTypeName:(UrgencyType)type {
    switch (type) {
        case UrgencyTypeExtraUrgent:
            return @"特急";
            break;
        case UrgencyTypeDispatch:
            return @"加急";
            break;
        case UrgencyTypeUrgent:
            return @"平急";
            break;
        case UrgencyTypePiece:
            return @"平件";
            break;
        case UrgencyTypeUnknow:
            return @"未知";
            break;
        default:
            return @"未知";
            break;
    }
}

+ (NSString *)getSecretLevelTypeName:(SecretLevelType)type {
    switch (type) {
        case SecretLevelTypeTop:
            return @"绝密";
            break;
        case SecretLevelTypeAsecret:
            return @"保密";
            break;
        case SecretLevelTypeConfidential:
            return @"机密";
            break;
        case SecretLevelTypeSecret:
            return @"秘密";
            break;
        case SecretLevelTypeInner:
            return @"内部";
            break;
        case SecretLevelTypeAll:
            return @"公开";
            break;
        case SecretLevelTypeUnknow:
            return @"未知";
            break;
        default:
            return @"未知";
            break;
    }
}

+ (NSString *)getStatusTypeName:(StatusType)type {
    switch (type) {
        case StatusTypeDraft:
            return @"草稿";
            break;
        case StatusTypeReturn:
            return @"退回";
            break;
        case StatusTypeCirculation:
            return @"流转中";
            break;
        case StatusTypePassed:
            return @"审批通过";
            break;
        default:
            return @"未知";
            break;
    }
}

+ (NSString *)getBizKeyTypeID:(BizKeyType)type {
    switch (type) {
        case BizKeyTypeSend:
            return @"doc_send";
            break;
        case BizKeyTypeDeal:
            return @"doc_rcv_deal";
            break;
        case BizKeyTypeRead:
            return @"doc_rcv_read";
            break;
        case BizKeyTypeSealIn:
            return @"use_seal_approval_inner";
            break;
        case BizKeyTypeSealEx:
            return @"use_seal_approval_outer";
            break;
        case BizKeyTypeSealLoan:
            return @"seal_loan";
            break;
        default:
            return @"未知";
            break;
    }
}

+ (NSString *)getApprovalTypeName:(StatusType)type {
    switch (type) {
        case StatusTypeIn:
            return @"内部";
            break;
        case StatusTypeEx:
            return @"外部";
            break;
        default:
            return @"未知";
            break;
    }
}
@end
