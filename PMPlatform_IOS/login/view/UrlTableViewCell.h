//
//  UrlTableViewCell.h
//  PMPlatform_IOS
//
//  Created by 末末班车 on 2024/8/22.
//  Copyright © 2024 com.atide. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UrlTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *checkIV;
@property (weak, nonatomic) IBOutlet UILabel *urlLabel;
@property (weak, nonatomic) IBOutlet UIImageView *delIV;

@end

NS_ASSUME_NONNULL_END
