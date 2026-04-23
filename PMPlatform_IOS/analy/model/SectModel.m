//
//  SectModel.m
//  PMPlatform_IOS
//
//  Created by 末末班车 on 2017/10/10.
//  Copyright © 2017年 com.atide. All rights reserved.
//

#import "SectModel.h"

@implementation SectModel

- (void) setData:(NSDictionary*)nsd{
    self.userCode = [nsd objectForKey:@"userCode"];
    self.bussinessFlag = [nsd objectForKey:@"bussinessFlag"];
    self.childBussinessFlag = [nsd objectForKey:@"childBussinessFlag"];
    self.sectNo = [nsd objectForKey:@"sectNo"];
    self.sectName = [nsd objectForKey:@"sectName"];
    self.sessionCode = [nsd objectForKey:@"sessionCode"];
}

@end
