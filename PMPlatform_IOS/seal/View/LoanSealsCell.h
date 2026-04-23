//
//  LoanSealsCell.h
//  PMPlatform_IOS
//
//  Created by 高小伟 on 2018/11/9.
//  Copyright © 2018 com.atide. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoanSealModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface LoanSealsCell : UITableViewCell
- (void)loadDataModel:(LoanSealModel *)model;
@end

NS_ASSUME_NONNULL_END
