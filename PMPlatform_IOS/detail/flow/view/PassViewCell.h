//
//  PassViewCell.h
//  PMPlatform_IOS
//
//  Created by 末末班车 on 2017/9/14.
//  Copyright © 2017年 com.atide. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FlowPicLocation.h"

@class PassViewCell;

@protocol PassViewCellDelegate <NSObject>

- (void)passViewCellPointButtonClicked:(PassViewCell *)cell;

@end

@interface PassViewCell : UITableViewCell

@property (nonatomic, strong) FlowPicLocation *flowPicLocation;

@property (nonatomic, weak) id<PassViewCellDelegate> delegate;

- (void)loadDataModel:(FlowPicLocation *)model;

- (void)showLeft:(BOOL)isShow;

- (void)cutLine:(BOOL)iscut;

@end
