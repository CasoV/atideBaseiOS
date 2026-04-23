//
//  QDPdfController.h
//  ycxm
//
//  Created by 末末班车 on 2020/3/17.
//  Copyright © 2020 末末班车. All rights reserved.
//

#import "BaseViewController.h"
#import "NewQDKeyModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface QDPdfController : BaseViewController

@property (nonatomic, strong) NewQDKeyModel *model;

@property (nonatomic, copy) NSString *bizPk;
- (void)setTaskId:(NSString *)taskId;

- (void)refresh;

@end

NS_ASSUME_NONNULL_END
