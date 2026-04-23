//
//  ProjectInvest.m
//  PMPlatform_IOS
//
//  Created by vxg on 2017/09/06.
//  Copyright © 2017年 com.atide. All rights reserved.
//

#import "ProjectInvest.h"
#import "NSString+trim.h"

@implementation ProjectInvest
- (instancetype)trim{
    self.contractamt = self.contractamt.trim;
    self.designamt = self.designamt.trim;
    self.bargainamt = self.bargainamt.trim;
    self.changeamt = self.changeamt.trim;
    self.accountamt = self.accountamt.trim;
    self.compamt = self.compamt.trim;
    self.finishedamt = self.finishedamt.trim;
    self.payamt = self.payamt.trim;
    return self;
}

-(id) objectForKeyedSubscript:(id)key {
    return [self valueForKey:key];
}
@end
