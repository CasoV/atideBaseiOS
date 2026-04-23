//
//  VStepView.h
//  PMPlatform_IOS
//
//  Created by 末末班车 on 2017/9/11.
//  Copyright © 2017年 com.atide. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DefaultVStepViewCell.h"

@interface VStepView : UITableView

- (void)setDataAndView:(NSArray *)data itemClick:(void (^)(id))itemClick callback:(void(^)(id, DefaultVStepViewCell *cell))callback;

@end
