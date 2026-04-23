//
//  PassViewController.h
//  PMPlatform_IOS
//
//  Created by 末末班车 on 2017/9/14.
//  Copyright © 2017年 com.atide. All rights reserved.
//

#import "FDBaseViewController.h"

@interface PassViewController : FDBaseViewController

@property (nonatomic, assign) BOOL useJsonParams;

@property (nonatomic, copy) NSString *bizKey;

@property (nonatomic, copy) NSString *bizUrl;

@property (nonatomic, copy) NSString *instanceId;

@property (nonatomic, copy) NSString *completeInfo;

@property (nonatomic, copy) NSString *taskId;

@property (nonatomic, copy) NSString *url;

@property (nonatomic, copy) NSString *finalUrl;

@property (nonatomic, copy) NSString *checkTitle;

@property (nonatomic, copy) void (^callBack)(BOOL success);

@end
