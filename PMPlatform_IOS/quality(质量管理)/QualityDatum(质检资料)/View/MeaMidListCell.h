//
//  MeaMidListCell.h
//  ycxm
//
//  Created by 末末班车 on 2019/2/26.
//  Copyright © 2019 末末班车. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MeaMidListModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface MeaMidListCell : UITableViewCell

@property (nonatomic, strong) MeaMidListModel *model;

@property (nonatomic, copy) void (^callBack)(void);

@end

NS_ASSUME_NONNULL_END
