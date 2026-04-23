//
//  SPItemTreeCell.h
//  ycxm
//
//  Created by 末末班车 on 2020/3/20.
//  Copyright © 2020 末末班车. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RATreeView.h"
#import "PartModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface SPItemTreeCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *expandImg;
@property (weak, nonatomic) IBOutlet UIImageView *fileImg;
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (nonatomic, strong) PartModel *model;

@property (nonatomic, copy) void (^callBack)(PartModel *item);

//赋值
- (void)setCellBasicInfoWith:(PartModel *)model level:(NSInteger)level children:(NSInteger )children;

+ (instancetype)treeViewCellWith:(RATreeView *)treeView;

@end

NS_ASSUME_NONNULL_END
