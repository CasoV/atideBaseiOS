//
//  EnumDictionary.h
//  circlViewText
//
//  Created by 末末班车 on 2017/9/8.
//  Copyright © 2017年 atide. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TreeNode.h"

@interface EnumDictionary : NSObject
//MARK: 获取组织树
/**
 *orgId:100, async:1为同步，其他为异步
 */
+ (void)getEasyUiTree:(NSString *)orgId async:(NSString *)async isSelf:(NSString *)isSelf callback:(void (^)(NSString *str, NSArray <TreeNode *>*nodes))callback;

//MARK: 获取督办人
/**
 *orgId:, deep:1
 */
+ (void)getOrgUsers:(NSString *)orgId callback:(void (^)(NSString *str, NSArray <TreeNode *>*))callback;

@end
