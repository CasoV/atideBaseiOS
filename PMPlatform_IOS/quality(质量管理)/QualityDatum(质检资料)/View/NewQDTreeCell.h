//
//  NewQDTreeCell.h
//  ycxm
//
//  Created by 末末班车 on 2020/3/16.
//  Copyright © 2020 末末班车. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NewQDModel.h"
#import "RATreeView.h"

NS_ASSUME_NONNULL_BEGIN

@interface NewQDTreeCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *expandImg;

@property (nonatomic, strong) NewQDModel *model;

@property (nonatomic, copy) void (^callBack)(NewQDModel *selectModel);
@property (nonatomic, copy) void (^attCallBack)(NewQDModel *selectModel);

//赋值
- (void)setCellBasicInfoWith:(NewQDModel *)model level:(NSInteger)level children:(NSInteger )children;

+ (instancetype)treeViewCellWith:(RATreeView *)treeView;

@end

NS_ASSUME_NONNULL_END
