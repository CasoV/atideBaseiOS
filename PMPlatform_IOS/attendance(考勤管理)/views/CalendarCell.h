//
//  CalendarCell.h
//  ycxm
//
//  Created by 高小伟 on 2020/6/11.
//  Copyright © 2020 末末班车. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MonthModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface CalendarCell : UICollectionViewCell
@property (weak, nonatomic) UILabel *dayLabel;
@property (strong, nonatomic) MonthModel *monthModel;
@property (weak, nonatomic) UIImageView *image1;
@property (weak, nonatomic) UIImageView *image2;
@property (weak, nonatomic) UIView *tagView;
@end

NS_ASSUME_NONNULL_END
