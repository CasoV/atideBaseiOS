//
//  ApplicationCell.h
//  PMPlatform_IOS
//
//  Created by 末末班车 on 2017/9/5.
//  Copyright © 2017年 com.atide. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ApplicationModel.h"

@interface ApplicationCell : UICollectionViewCell

- (void)loadDataModel:(ApplicationModel *)model section:(NSInteger)section ishome:(BOOL)ishome;

@end
