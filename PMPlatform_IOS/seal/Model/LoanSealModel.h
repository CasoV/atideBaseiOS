//
//  LoanSealModel.h
//  PMPlatform_IOS
//
//  Created by 高小伟 on 2018/11/9.
//  Copyright © 2018 com.atide. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LoanSealModel : NSObject

@property(nonatomic,copy)NSString *fillerName;
@property(nonatomic,copy)NSString *sealId;
@property(nonatomic,copy)NSString *orgName;
@property(nonatomic,copy)NSString *accessSql;
@property(nonatomic,copy)NSString *actualReturnDate;
@property(nonatomic,copy)NSString *endDate;
@property(nonatomic,copy)NSString *estiReturnDate;
@property(nonatomic,copy)NSString *returnStatus;
@property(nonatomic,copy)NSString *returnMan;
@property(nonatomic,copy)NSString *sealType;
@property(nonatomic,copy)NSString *orgId;
@property(nonatomic,copy)NSString *appliReason;
@property(nonatomic,copy)NSString *createTime;
@property(nonatomic,copy)NSString *fillerId;
@property(nonatomic,copy)NSString *loanDate;
@property(nonatomic,copy)NSString *id;
@property(nonatomic,copy)NSString *startDate;
@property(nonatomic,copy)NSString *status;

@end

NS_ASSUME_NONNULL_END
