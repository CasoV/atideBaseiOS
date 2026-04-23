//
//  BussinessFlow.m
//  TrafficMs
//
//  Created by apple on 2015/11/19.
//  Copyright © 2015年 com. All rights reserved.
//

#import "BussinessFlow.h"

@implementation BussinessFlow

-(void)setData:(NSDictionary *)nsd{
    self.flowID = [nsd objectForKey:@"flowID"];
    self.approvalUnitId = [nsd objectForKey:@"approvalUnitId"];
    self.unitName = [nsd objectForKey:@"unitName"];
    self.unitStepSerialNo = [nsd objectForKey:@"unitStepSerialNo"];
    self.approvalGrpId = [nsd objectForKey:@"approvalGrpId"];
    self.cnname = [nsd objectForKey:@"cnname"];
    self.grpStepSerialNo = [nsd objectForKey:@"grpStepSerialNo"];
    self.sequenceNo = [nsd objectForKey:@"sequenceNo"];
    self.defaultApprovalIdea = [nsd objectForKey:@"defaultApprovalIdea"];
    self.defaultReturnIdea = [nsd objectForKey:@"defaultReturnIdea"];
    self.isCurrStatus = [nsd objectForKey:@"isCurrStatus"];
}

@end
