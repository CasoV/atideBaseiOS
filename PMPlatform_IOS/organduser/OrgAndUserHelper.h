//
//  OrgAndUserHelper.h
//  circlViewText
//
//  Created by 末末班车 on 2017/9/7.
//  Copyright © 2017年 atide. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FlowPicLocation.h"
#import "TreeNode.h"

@interface OrgAndUserHelper : NSObject

+ (void)skipController:(UIViewController *)controller callback:(void (^)(NSArray <TreeNode *>*nodes))callback;

+ (void)skipController:(UIViewController *)controller flowPicLocation:(FlowPicLocation *)flowPicLocation callback:(void (^)(NSArray <TreeNode *>*nodes))callback;

@end
