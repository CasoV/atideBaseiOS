//
//  OrgAndUserLeftController.h
//  circlViewText
//
//  Created by 末末班车 on 2017/9/8.
//  Copyright © 2017年 atide. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TreeNode.h"

@interface OrgAndUserLeftController : UIViewController

- (NSArray <TreeNode *>*)getNodes;

- (void)reloadData:(NSString *)url nodes:(NSArray <TreeNode *>*)tmps;

- (void)loadNodes:(NSArray <TreeNode *>*)datas callback:(void (^)(NSArray<TreeNode *> *))callback;

@end
