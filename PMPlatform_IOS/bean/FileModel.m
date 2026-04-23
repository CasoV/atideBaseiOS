//
//  FileModel.m
//  PMPlatform_IOS
//
//  Created by 末末班车 on 2022/6/30.
//  Copyright © 2022 com.atide. All rights reserved.
//

#import "FileModel.h"
#import "NSDate+Timestamp.h"

@implementation FileModel

- (NSString *)name {
    if (self.originalName) {
        return self.originalName;
    } else if (self.filename) {
        return self.filename;
    } else {
        return [NSDate nowDateStringYYMMddHHmmss];
    }
}

@end
