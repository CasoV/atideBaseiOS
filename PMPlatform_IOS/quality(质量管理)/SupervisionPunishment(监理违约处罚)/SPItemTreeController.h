//
//  SPItemTreeController.h
//  ycxm
//
//  Created by 末末班车 on 2020/3/20.
//  Copyright © 2020 末末班车. All rights reserved.
//

#import "BaseViewController.h"
#import "PartModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface SPItemTreeController : BaseViewController

@property (nonatomic, copy) NSString *ruleId;

@property (nonatomic, copy) void (^callBack)(PartModel *item);

@end

NS_ASSUME_NONNULL_END
