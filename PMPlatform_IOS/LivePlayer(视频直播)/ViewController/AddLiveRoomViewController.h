//
//  AddLiveRoomViewController.h
//  ycxm
//
//  Created by 高小伟 on 2021/7/15.
//  Copyright © 2021 末末班车. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TLHomeViewModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface AddLiveRoomViewController : BaseViewController

@property (nonatomic, copy) void (^callBack)(BOOL reload);

@property (nonatomic, strong)TLHomeViewModel *viewModel;
@end

NS_ASSUME_NONNULL_END
