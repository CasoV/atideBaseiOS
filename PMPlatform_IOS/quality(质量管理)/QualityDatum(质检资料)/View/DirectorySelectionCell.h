//
//  DirectorySelectionCell.h
//  ycxm
//
//  Created by 高小伟 on 2020/7/9.
//  Copyright © 2020 末末班车. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DatumModel.h"
#import "RATreeView.h"

NS_ASSUME_NONNULL_BEGIN

@interface DirectorySelectionCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *expandImg;
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (nonatomic, strong) DatumModel *model;

@property (nonatomic, copy) void (^callBack)(DatumModel *item);

//赋值
- (void)setCellBasicInfoWith:(DatumModel *)model level:(NSInteger)level children:(NSInteger )children;

+ (instancetype)treeViewCellWith:(RATreeView *)treeView;
@end

NS_ASSUME_NONNULL_END
