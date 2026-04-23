//
//  AnnexView.h
//  PMPlatform_IOS
//
//  Created by 末末班车 on 2017/9/11.
//  Copyright © 2017年 com.atide. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AnnexModel.h"

@interface AnnexView : UIView

@property (nonatomic, strong) AnnexModel *model;

- (void)loadDataModel:(AnnexModel *)model;

@end
