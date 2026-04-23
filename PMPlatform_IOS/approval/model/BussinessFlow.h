//
//  BussinessFlow.h
//  TrafficMs
//
//  Created by apple on 2015/11/19.
//  Copyright © 2015年 com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BussinessFlow : NSObject

@property (nonatomic, copy) NSString *flowID;
@property (nonatomic, copy) NSString *approvalUnitId;
@property (nonatomic, copy) NSString *unitName;
@property (nonatomic, copy) NSString *unitStepSerialNo;
@property (nonatomic, copy) NSString *approvalGrpId;
@property (nonatomic, copy) NSString *cnname;
@property (nonatomic, copy) NSString *grpStepSerialNo;
@property (nonatomic, copy) NSString *sequenceNo;
@property (nonatomic, copy) NSString *defaultApprovalIdea;
@property (nonatomic, copy) NSString *defaultReturnIdea;
@property (nonatomic, nonatomic) BOOL isCurrStatus;

-(void)setData:(NSDictionary *)nsd;

@end
