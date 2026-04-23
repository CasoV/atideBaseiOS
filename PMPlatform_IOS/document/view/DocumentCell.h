//
//  DocumentCell.h
//  PMPlatform_IOS
//
//  Created by 末末班车 on 2017/9/7.
//  Copyright © 2017年 com.atide. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DocumentRcvModel.h"
#import "DocumentModel.h"

@interface DocumentCell : UITableViewCell

@property (nonatomic, assign) NSInteger searchType;

- (void)loadDataModel:(DocumentModel *)model;

- (void)loadDataRcvModel:(DocumentRcvModel *)model;

@end
