//
//  TreeTableView.h
//  circlViewText
//
//  Created by 末末班车 on 2017/9/7.
//  Copyright © 2017年 atide. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TreeNodeHelper.h"
#import "TreeNode.h"

typedef NS_ENUM(NSInteger, TreeNodePickerMode) {
    TreeNodePickerModeSINGLE,
    TreeNodePickerModeMULTIPLUS
};

@interface TreeTableView : UITableView

@property (nonatomic, copy) void (^callback)(NSInteger count, TreeNode *node);

- (instancetype)initWithFrame:(CGRect)frame data:(NSArray <TreeNode *>*)data pickerMode:(TreeNodePickerMode)pickerMode;

- (void)refresh:(NSArray <TreeNode *>*)data mode:(TreeNodePickerMode)mode;

- (NSArray <TreeNode *>*)getSelectedNodes;

@end
