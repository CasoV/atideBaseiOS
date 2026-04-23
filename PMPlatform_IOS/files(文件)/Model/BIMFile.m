//
//  BIMFile.m
//  ConstructionApp
//
//  Created by mac on 2017/11/14.
//  Copyright © 2017年 atide. All rights reserved.
//

#import "BIMFile.h"

@implementation BIMFile

- (NSString *)extName {
    if (!_extName) {
        return @"";
    }
    return _extName.lowercaseString;
}

- (BOOL)isDownload {
    NSFileManager *fm = [NSFileManager defaultManager];
    for (NSString *temp in [fm subpathsAtPath:[NSString stringWithFormat:@"%@/Documents", NSHomeDirectory()]]) {
        if (self.unUploadFile) {
            if ([self.filePath isEqualToString:temp]) {
                return YES;
            }
        } else {
            if ([self.filename isEqualToString:temp]) {
                self.filePath = temp;
                return YES;
            }
        }
    }
    
    return NO;
}

- (BOOL)isImageOrVideo {
    if ([self.extName isEqualToString:@"jpeg"] || [self.extName isEqualToString:@"jpg"] || [self.extName isEqualToString:@"png"] || [self.extName isEqualToString:@"mp4"] || [self.extName isEqualToString:@"mov"]) {
        return YES;
    } else {
        return NO;
    }
}

- (BOOL)isImage {
    if ([self.extName isEqualToString:@"jpeg"] || [self.extName isEqualToString:@"jpg"] || [self.extName isEqualToString:@"png"]) {
        return YES;
    } else {
        return NO;
    }
}

@end
