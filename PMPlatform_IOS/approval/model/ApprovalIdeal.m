//
//  ApprovalIdeal.m
//  TrafficMs
//
//  Created by apple on 2015/11/19.
//  Copyright © 2015年 com. All rights reserved.
//

#import "ApprovalIdeal.h"

@implementation ApprovalIdeal

-(void)setData:(NSDictionary *)nsd{
    self.objectKey = [nsd objectForKey:@"objectKey"];
    self.unitName = [nsd objectForKey:@"unitName"];
    self.userName = [nsd objectForKey:@"userName"];
    self.cNName = [nsd objectForKey:@"cNName"];
    self.arrivedDate = [nsd objectForKey:@"arrivedDate"];
    self.factApprovalDate = [nsd objectForKey:@"factApprovalDate"];
    self.approvalTime = [nsd objectForKey:@"approvalTime"];
    self.approvalIdea = [nsd objectForKey:@"approvalIdea"];
    self.isAbandon = [nsd objectForKey:@"isAbandon"];
    self.isReturn = [nsd objectForKey:@"isReturn"];
    self.isPass = [nsd objectForKey:@"isPass"];
    self.isSeal = [nsd objectForKey:@"isSeal"];
    self.sequenceNo = [nsd objectForKey:@"sequenceNo"];
}

@end
