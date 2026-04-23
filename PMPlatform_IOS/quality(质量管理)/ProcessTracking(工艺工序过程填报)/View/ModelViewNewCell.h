//
//  ModelViewNewCell.h
//  HBConstructionApp
//
//  Created by 末末班车 on 2018/5/18.
//  Copyright © 2018年 atide. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ModelViewModel.h"

@interface ModelViewNewCell : UITableViewCell

@property (nonatomic, copy) NSString *pid;

@property (nonatomic, copy) void (^block)(ModelViewModel *model);

@property (nonatomic, copy) void (^delBlock)(ModelViewModel *model);

- (void)setDataModel:(ModelViewModel *)model withIndex:(NSInteger)index;

@end
