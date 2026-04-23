//
//  SysConfig.h
//  PMPlatform_IOS
//
//  Created by vxg on 2017/09/06.
//  Copyright © 2017年 com.atide. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SysConfig : NSObject
@property (nonatomic, strong) NSArray *projectInfos;
@property (nonatomic, strong) NSArray *sectInfos;
@property (nonatomic, copy) NSString *projectId;
@property (nonatomic, copy) NSString *projectCode;
+ (SysConfig *)getInstance;

@end
