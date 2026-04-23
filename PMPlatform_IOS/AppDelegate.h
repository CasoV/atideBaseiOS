//
//  AppDelegate.h
//  PMPlatform_IOS
//
//  Created by vxg on 2017/09/04.
//  Copyright © 2017年 com.atide. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (nonatomic, assign) BOOL blockRotation;

@property (nonatomic, copy) NSString * doUrl;

+(void)voipRegistration;

@end

