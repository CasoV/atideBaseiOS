//
//  OrgAndUserMainController.h
//  circlViewText
//
//  Created by 末末班车 on 2017/9/8.
//  Copyright © 2017年 atide. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TreeTableView.h"

@interface OrgAndUserMainController : UIViewController <SlideMenuControllerDelegate>

@property (nonatomic, assign) TreeNodePickerMode pickerMode;
@property (nonatomic, copy) NSString *orgId;
@property (nonatomic, copy) NSArray <TreeNode *>*dataSource;
@property (nonatomic, copy) void (^callback)(NSArray <TreeNode *>* nodes);

@end
