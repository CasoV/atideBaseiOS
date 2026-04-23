//
//  MidMeasureInfo.m
//  TrafficMs
//
//  Created by apple on 2015/11/14.
//  Copyright © 2015年 com. All rights reserved.
//

#import "MidMeasureInfo.h"

@implementation MidMeasureInfo

-(void)setData:(NSDictionary *)nsd{
    self.compId = [nsd objectForKey:@"compId"];
    self.codeNo = [nsd objectForKey:@"codeNo"];
    self.flowID = [nsd objectForKey:@"flowID"];
    self.flowName = [nsd objectForKey:@"flowName"];
    self.approvalStatus = [nsd objectForKey:@"approvalStatus"];
    self.approvalStatusDesc = [nsd objectForKey:@"approvalStatusDesc"];
    self.approvalUnitId = [nsd objectForKey:@"approvalUnitId"];
    self.approvalUnitStep = [nsd objectForKey:@"approvalUnitStep"];
    self.approvalGrpId = [nsd objectForKey:@"approvalGrpId"];
    self.approvalGrpStep = [nsd objectForKey:@"approvalGrpStep"];
    self.listCode = [nsd objectForKey:@"listCode"];
    self.listName = [nsd objectForKey:@"listName"];
    self.monitPicket = [nsd objectForKey:@"monitPicket"];
    self.compPile = [nsd objectForKey:@"compPile"];
    self.partName = [nsd objectForKey:@"partName"];
    self.itemUnit = [nsd objectForKey:@"itemUnit"];
    self.compDate = [nsd objectForKey:@"compDate"];
    self.confirmQuantity = [nsd objectForKey:@"confirmQuantity"];
    self.bargainQuantity = [nsd objectForKey:@"bargainQuantity"];
    self.altQuantity = [nsd objectForKey:@"altQuantity"];
    self.abandonQuantity = [nsd objectForKey:@"abandonQuantity"];
    self.waterDestroyQuantity = [nsd objectForKey:@"waterDestroyQuantity"];
    self.totalQuantity = [nsd objectForKey:@"totalQuantity"];
    self.compQuantity = [nsd objectForKey:@"compQuantity"];
    self.totalCompQuantity = [nsd objectForKey:@"totalCompQuantity"];
    self.remainQuantity = [nsd objectForKey:@"remainQuantity"];
    self.formula = [nsd objectForKey:@"formula"];
}

@end
