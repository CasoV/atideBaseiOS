//
//  ProjectSectPopController.h
//  PMPlatform_IOS
//
//  Created by vxg on 2017/09/08.
//  Copyright © 2017年 com.atide. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^CallBack)(NSArray *);
@interface ProjectSectPopController : UIViewController
@property (nonatomic, strong) CallBack callback;
@property (nonatomic, strong) NSMutableArray *mSectsData;
@end
