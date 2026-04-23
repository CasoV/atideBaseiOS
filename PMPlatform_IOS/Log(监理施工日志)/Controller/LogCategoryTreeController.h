//
//  LogCategoryTreeController.h
//  ycxm
//
//  Created by 高小伟 on 2021/7/5.
//  Copyright © 2021 末末班车. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LogTreeModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface LogCategoryTreeController : BaseViewController

@property (nonatomic, copy) NSString *functionCode;

@property (nonatomic, copy) void (^callBack)(LogTreeModel *item);

@end

NS_ASSUME_NONNULL_END
