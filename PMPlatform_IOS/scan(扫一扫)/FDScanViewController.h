//
//  FDScanViewController.h
//  YXConstructionApp
//
//  Created by 末末班车 on 2018/3/28.
//  Copyright © 2018年 atide. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FDScanViewController : UIViewController

@property(nonatomic, copy) void(^scanResult)(NSString *result);

@end
