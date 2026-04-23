//
//  ProAndSectChoosePopView.h
//  ycxm
//
//  Created by 末末班车 on 2022/3/8.
//  Copyright © 2022 末末班车. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PermissionModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ProAndSectChoosePopView : UIButton

@property (nonatomic, copy) void (^callBack)(void);

- (instancetype)initWithPermission:(PermissionModel *)permission;

/**
 *  显示
 */
- (void)show;

/**
 *  移除
 */
- (void)remove;

@end

NS_ASSUME_NONNULL_END
