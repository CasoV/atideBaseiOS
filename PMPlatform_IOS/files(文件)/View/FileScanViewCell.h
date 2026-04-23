//
//  FileScanViewCell.h
//  ConstructionApp
//
//  Created by 末末班车 on 2017/12/25.
//  Copyright © 2017年 atide. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BIMFile.h"

@interface FileScanViewCell : UICollectionViewCell

@property (nonatomic, copy) void (^block)(BIMFile *file);

- (void)loadDataModel:(BIMFile *)model isImage:(BOOL)isImage;

- (void)loadDataModel:(BIMFile *)model;

- (void)hiddenDeleteBtn;

@end
