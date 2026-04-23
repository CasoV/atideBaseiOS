//
//  SectionInfo.m
//  ConstructionApp
//
//  Created by mac on 2017/11/15.
//  Copyright © 2017年 atide. All rights reserved.
//

#import "SectionInfo.h"

@implementation SectionInfo

- (NSString *)sectionId {
    if (!_sectionId) {
        return @"";
    }
    return _sectionId;
}

- (CGFloat)gpsRanger {
    return 400;
}

@end
