//
//  ApprovalIdeal.h
//  TrafficMs
//
//  Created by apple on 2015/11/19.
//  Copyright © 2015年 com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ApprovalIdeal : NSObject

@property (nonatomic, copy) NSString *objectKey;
@property (nonatomic, copy) NSString *unitName;
@property (nonatomic, copy) NSString *userName;
@property (nonatomic, copy) NSString *cNName;
@property (nonatomic, copy) NSString *arrivedDate;
@property (nonatomic, copy) NSString *factApprovalDate;
@property (nonatomic, copy) NSString *approvalTime;
@property (nonatomic, copy) NSString *approvalIdea;
@property (nonatomic, copy) NSString *isAbandon;
@property (nonatomic, copy) NSString *isReturn;
@property (nonatomic, copy) NSString *isPass;
@property (nonatomic, copy) NSString *isSeal;
@property (nonatomic, copy) NSString *sequenceNo;

-(void)setData:(NSDictionary *)nsd;

@end
