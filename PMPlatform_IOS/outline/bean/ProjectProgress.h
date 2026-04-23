//
//  ProjectProgress.h
//  PMPlatform_IOS
//
//  Created by vxg on 2017/09/06.
//  Copyright © 2017年 com.atide. All rights reserved.
//

#import <Foundation/Foundation.h>
/**
 "dsiid":"1",
 "dsiname":"100章 总则",
 "dsiuid":"27",
 "dsiuname":"万元",
 "ismainunit":"",
 "unitprecision":"",
 "contractquantity":"",
 "designquantity":"9594.6822",
 "changequantity":"",
 "finishedquantity":"8022.4972",
 "accountquantity":"9594.6822",
 "unfinishedquantity":"1572.1850"
 **/
@interface ProjectProgress : NSObject
@property (nonatomic, copy) NSString *dsiid;
@property (nonatomic, copy) NSString *dsiname;
@property (nonatomic, copy) NSString *dsiuid;
@property (nonatomic, copy) NSString *dsiuname;
@property (nonatomic, copy) NSString *ismainunit;
@property (nonatomic, copy) NSString *unitprecision;
@property (nonatomic, copy) NSString *contractquantity;
@property (nonatomic, copy) NSString *designquantity;
@property (nonatomic, copy) NSString *changequantity;
@property (nonatomic, copy) NSString *finishedquantity;
@property (nonatomic, copy) NSString *accountquantity;
@property (nonatomic, copy) NSString *unfinishedquantity;
@end
