//
//  IFlyHelper.h
//  HBConstructionApp
//
//  Created by 末末班车 on 2018/4/8.
//  Copyright © 2018年 atide. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import <iflyMSC/iflyMSC.h>
//#import "iflyMSC/IFlyMSC.h"

@interface IFlyHelper : NSObject

//- (instancetype)initWithView:(UIView *)view delegate:(id<IFlyRecognizerViewDelegate>)delegate;
//
//- (void)onResult:(NSArray *)resultArray isLast:(BOOL) isLast;
//
//- (NSString *)onError: (IFlySpeechError *) error;

- (void)speech;

- (void)destory;

@end
