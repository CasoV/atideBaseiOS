//
//  ApiQualityDatumSelectPartDetail.m
//  HBConstructionApp
//
//  Created by 末末班车 on 2018/4/13.
//  Copyright © 2018年 atide. All rights reserved.
//

#import "ApiQualityDatumSelectPartDetail.h"

@implementation ApiQualityDatumSelectPartDetail

- (NSString *)requestUrl {
    if (self.isType) {
        return @"processapprovalnew/qualityDatum/prjTypeTotals";
    } else {
       return @"processapprovalnew/qualityDatum/selectPartDetail";
    }
}

@end
