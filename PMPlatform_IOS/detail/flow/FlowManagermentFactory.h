//
//  FlowManagermentFactory.h
//  PMPlatform_IOS
//
//  Created by 末末班车 on 2017/9/13.
//  Copyright © 2017年 com.atide. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Panel.h"

@interface FlowManagermentFactory : NSObject

+ (void)config:(UINavigationController *)navigatorController symbol:(NSString *)symbol update:(void (^)(void))update;

+ (void)factory:(Panel *)item bizPk:(NSString *)bizPk instanceId:(NSString *)instanceId bizUrl:(NSString *)bizUrl;

@end
