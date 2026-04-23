//
//  LogCategoryTreeCell.h
//  ycxm
//
//  Created by 高小伟 on 2021/7/5.
//  Copyright © 2021 末末班车. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LogTreeModel.h"
#import "RATreeView.h"

NS_ASSUME_NONNULL_BEGIN

@interface LogCategoryTreeCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *expandImg;
@property (weak, nonatomic) IBOutlet UIImageView *fileImg;

@property (nonatomic, strong) LogTreeModel *model;

@property (nonatomic, copy) void (^callBack)(LogTreeModel *item);

//赋值
- (void)setCellBasicInfoWith:(LogTreeModel *)model level:(NSInteger)level children:(NSInteger )children;

+ (instancetype)treeViewCellWith:(RATreeView *)treeView;

@end
NS_ASSUME_NONNULL_END
