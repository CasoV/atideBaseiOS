//
//  SupervisionPunishmentDetailController.h
//  ycxm
//
//  Created by 末末班车 on 2020/3/19.
//  Copyright © 2020 末末班车. All rights reserved.
//

#import "FDBaseViewController.h"
#import "SupervisionPunishmentModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface SupervisionPunishmentDetailController : FDBaseViewController

@property (nonatomic, strong) SupervisionPunishmentModel *model;

@property (nonatomic, copy) NSString *bizKey;

@property (nonatomic, assign) BOOL canEdit;

@property (nonatomic, copy) void (^pushBlock)(void);

- (BOOL)verify;

- (NSDictionary *)params;

@end

NS_ASSUME_NONNULL_END
