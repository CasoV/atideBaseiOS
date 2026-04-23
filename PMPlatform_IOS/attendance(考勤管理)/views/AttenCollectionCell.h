//
//  AttenCollectionCell.h
//  ycxm
//
//  Created by 高小伟 on 2020/6/11.
//  Copyright © 2020 末末班车. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface AttenCollectionCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLb;
@property (weak, nonatomic) IBOutlet UIImageView *iconImgView;
@property (weak, nonatomic) IBOutlet UILabel *adressLb;
@property (weak, nonatomic) IBOutlet UILabel *timeLb;

@end

NS_ASSUME_NONNULL_END
