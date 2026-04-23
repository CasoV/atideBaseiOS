//
//  DataItem.m
//  XCMultiSortTableDemo
//
//  Created by vxg on 2017/09/04.
//  Copyright © 2017年 Kingiol. All rights reserved.
//

#import "DataItem.h"

@implementation DataItem

- (instancetype)initWith:(NSString *)keyId keyName:(NSString *)keyName tag:(NSObject *)tag
{
    self = [super init];
    if (self) {
        self.keyId = keyId;
        self.keyName = keyName;
        self.tag = tag;
    }
    return self;
}
@end
