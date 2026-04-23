//
//  WeakScriptMessageDelegate.h
//  YXConstructionApp
//
//  Created by 末末班车 on 2018/8/15.
//  Copyright © 2018年 atide. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <WebKit/WebKit.h>

@interface WeakScriptMessageDelegate : NSObject<WKScriptMessageHandler>

@property (nonatomic, assign) id<WKScriptMessageHandler> scriptDelegate;

- (instancetype)initWithDelegate:(id<WKScriptMessageHandler>)scriptDelegate;

@end
