//
//  ProjectInvest.h
//  PMPlatform_IOS
//
//  Created by vxg on 2017/09/06.
//  Copyright © 2017年 com.atide. All rights reserved.
//

#import <Foundation/Foundation.h>
/**
 "sectno":"1",
 "designamt":"448526904.000000",
 "bargainamt":"0.000000",
 "changeamt":"2975405.000000",
 "compamt":"238682122.000000",
 "finishedamt":"256412377.000000",
 "camt":"441975326.0000",
 "otheramt":"39000000.0000",
 "contractamt":"480975326.0000",
 "payamt":"231758659.00",
 "accountamt":"451502309.000000",
 "sectname":"第SG-1合同段",
 "sectcode":"SG-1",
 "orderno":"4"
 **/
@interface ProjectInvest : NSObject
@property (nonatomic,copy) NSString *sectno;
@property (nonatomic,copy) NSString *designamt;
@property (nonatomic,copy) NSString *bargainamt;
@property (nonatomic,copy) NSString *changeamt;
@property (nonatomic,copy) NSString *compamt;
@property (nonatomic,copy) NSString *finishedamt;
@property (nonatomic,copy) NSString *camt;
@property (nonatomic,copy) NSString *otheramt;
@property (nonatomic,copy) NSString *contractamt;
@property (nonatomic,copy) NSString *payamt;
@property (nonatomic,copy) NSString *accountamt;
@property (nonatomic,copy) NSString *sectname;
@property (nonatomic,copy) NSString *sectcode;
@property (nonatomic,copy) NSString *orderno;

- (instancetype)trim;

@end
