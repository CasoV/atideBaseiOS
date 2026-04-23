//
//  RightTreePentaViewController.h
//  ycxm
//
//  Created by 高小伟 on 2021/8/18.
//  Copyright © 2021 末末班车. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DatumModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface RightTreePentaViewController : UIViewController

@property (nonatomic, strong) NSArray<DatumModel *> *dataSource;
@property (nonatomic, copy) void (^callBack)(DatumModel *model);


@end

NS_ASSUME_NONNULL_END
