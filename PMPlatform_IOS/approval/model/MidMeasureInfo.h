//
//  MidMeasureInfo.h
//  TrafficMs
//
//  Created by apple on 2015/11/14.
//  Copyright © 2015年 com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CommCfg.h"

@interface MidMeasureInfo : NSObject

@property (nonatomic, copy) NSString *compId;
@property (nonatomic, copy) NSString *codeNo;
@property (nonatomic, copy) NSString *flowID;
@property (nonatomic, copy) NSString *flowName;
@property (nonatomic, copy) NSString *approvalStatus;
@property (nonatomic, copy) NSString *approvalStatusDesc;
@property (nonatomic, copy) NSString *approvalUnitId;
@property (nonatomic, copy) NSString *approvalUnitStep;
@property (nonatomic, copy) NSString *approvalGrpId;
@property (nonatomic, copy) NSString *approvalGrpStep;
@property (nonatomic, copy) NSString *listCode;
@property (nonatomic, copy) NSString *listName;
@property (nonatomic, copy) NSString *monitPicket;
@property (nonatomic, copy) NSString *compPile;
@property (nonatomic, copy) NSString *partName;
@property (nonatomic, copy) NSString *itemUnit;
@property (nonatomic, copy) NSString *compDate;
@property (nonatomic, copy) NSString *confirmQuantity;
@property (nonatomic, copy) NSString *bargainQuantity;
@property (nonatomic, copy) NSString *altQuantity;
@property (nonatomic, copy) NSString *abandonQuantity;
@property (nonatomic, copy) NSString *waterDestroyQuantity;
@property (nonatomic, copy) NSString *totalQuantity;
@property (nonatomic, copy) NSString *compQuantity;
@property (nonatomic, copy) NSString *totalCompQuantity;
@property (nonatomic, copy) NSString *remainQuantity;
@property (nonatomic, copy) NSString *formula;

@property (nonatomic, copy) NSString *type;
@property (nonatomic, copy) NSString *sectNo;
@property (nonatomic, copy) NSString *sessionCode;
@property (nonatomic, copy) NSString *childBussinessFlag;

-(void)setData:(NSDictionary *)nsd;
@end
