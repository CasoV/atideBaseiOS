//
//  TreeChooserMaterialViewController.h
//  ycxm
//
//  Created by 高小伟 on 2020/7/9.
//  Copyright © 2020 末末班车. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PartModel.h"
#import "DatumModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface TreeChooserMaterialViewController : BaseViewController

@property (nonatomic, strong) PartModel *partModel;

@property (nonatomic, copy) void (^callBack)(DatumModel *model);

@end

NS_ASSUME_NONNULL_END
