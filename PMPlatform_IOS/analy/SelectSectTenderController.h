//
//  SelectSectTenderController.h
//  PMPlatform_IOS
//
//  Created by 末末班车 on 2017/10/11.
//  Copyright © 2017年 com.atide. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SectModel.h"

@protocol SectDelegate <NSObject>

-(void)getSect:(SectModel *)data;

@end

@interface SelectSectTenderController : UIViewController

@property (nonatomic, copy) NSString *childBussinessFlag;

@property (nonatomic, weak) id<SectDelegate> delegate;

@end
