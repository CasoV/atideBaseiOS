//
//  SupervisionPunishmentFlowController.h
//  ycxm
//
//  Created by 末末班车 on 2020/3/19.
//  Copyright © 2020 末末班车. All rights reserved.
//

#import "BaseViewController.h"
#import "SupervisionPunishmentModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface SupervisionPunishmentFlowController : BaseViewController

@property (nonatomic, assign) BOOL isAnnexPush;

@property (nonatomic, assign) BOOL newFormFlag;

@property (nonatomic, strong) SupervisionPunishmentModel *model;

@end

NS_ASSUME_NONNULL_END
