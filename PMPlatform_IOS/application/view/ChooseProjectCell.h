//
//  ChooseProjectCell.h
//  PMPlatform_IOS
//
//  Created by 末末班车 on 2022/6/13.
//  Copyright © 2022 com.atide. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RATreeView.h"

NS_ASSUME_NONNULL_BEGIN

@interface ChooseProjectCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *expandImg;
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (nonatomic, strong) ProjectInfo *model;

@property (nonatomic, copy) void (^callBack)(ProjectInfo *item);

//赋值
- (void)setCellBasicInfoWith:(ProjectInfo *)model level:(NSInteger)level children:(NSInteger )children;

+ (instancetype)treeViewCellWith:(RATreeView *)treeView;

@end

NS_ASSUME_NONNULL_END
