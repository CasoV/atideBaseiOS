//
//  UpdateCommentCell.h
//  PMPlatform_IOS
//
//  Created by 末末班车 on 2017/9/15.
//  Copyright © 2017年 com.atide. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ApprovalCommentModel.h"

@class UpdateCommentCell;

@protocol UpdateCommentCellDelegate <NSObject>

- (void)updateCommentCellPointButtonClicked:(UpdateCommentCell *)cell;

@end

@interface UpdateCommentCell : UITableViewCell

@property (nonatomic, strong) ApprovalCommentModel *model;
@property (nonatomic, weak) id<UpdateCommentCellDelegate> delegate;

- (void)loadDataModel:(ApprovalCommentModel *)model;

- (void)hideTop:(BOOL)hide;

- (void)hideBottom:(BOOL)hide;

@end
