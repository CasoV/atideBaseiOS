//
//  EnumDictionary.m
//  circlViewText
//
//  Created by 末末班车 on 2017/9/8.
//  Copyright © 2017年 atide. All rights reserved.
//

#import "EnumDictionary.h"
#import "Org.h"

@implementation EnumDictionary

+ (void)getEasyUiTree:(NSString *)orgId async:(NSString *)async isSelf:(NSString *)isSelf callback:(void (^)(NSString *, NSArray<TreeNode *> *))callback {
    [[HttpManager manager] post:[UrlConfig URL:getEasyuiTree] param:@{@"orgId":orgId,@"async":async,@"self":isSelf} success:^(NSData *data) {
        [Org mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
            return @{@"ID":@"id"};
        }];
        [Org mj_setupObjectClassInArray:^NSDictionary *{
            return @{@"children":@"Org"};
        }];
        
        NSArray <Org *>*json = [Org mj_objectArrayWithKeyValuesArray:data];
        
        NSMutableArray <TreeNode *>*result = [NSMutableArray array];
        
        if (json) {
            [EnumDictionary initUnit:json result:result];
        }
        if (callback) {
            callback(nil, result);
        }

    } faild:^(NSString *msg) {
        if (callback) {
            callback(nil, @[]);
        }
    }];
}

+ (void)initUnit:(NSArray <Org *>*)data result:(NSMutableArray <TreeNode *>*)result {
    for (Org *item in data) {
        TreeNode *node = [[TreeNode alloc] initWith:@"" ID:item.ID pId:item.superId name:item.text];
        node.isNext = YES;
        [result addObject:node];
        if (item.children != nil && item.children.count != 0) {
            [EnumDictionary initUnit:item.children result:result];
        }
    }
}

+ (void)getOrgUsers:(NSString *)orgId callback:(void (^)(NSString *, NSArray<TreeNode *> *))callback {
    [[HttpManager manager] post:[UrlConfig URL:userEasyuiCombobox] param:@{@"orgId":orgId, @"deep":@"1"} success:^(NSData *data) {
        [Org mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
            return @{@"ID":@"id"};
        }];
        NSArray <Org *>*result = [Org mj_objectArrayWithKeyValuesArray:data];
        
        NSMutableArray <TreeNode *>*nodes = [NSMutableArray array];
        if (result) {
            for (Org *item in result) {
                TreeNode *node = [[TreeNode alloc] initWith:@"" ID:item.ID pId:@"0" name:item.text];
                [nodes addObject:node];
            }
        }
        if (callback) {
            callback(nil, nodes);
        }
    } faild:^(NSString *msg) {
        if (callback) {
            callback(msg, @[]);
        }
    }];
}

@end
