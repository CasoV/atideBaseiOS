//
//  DataItem.h
//  XCMultiSortTableDemo
//
//  Created by vxg on 2017/09/04.
//  Copyright © 2017年 Kingiol. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataItem : NSObject
@property (nonatomic, copy) NSString *keyId;
@property (nonatomic, copy) NSString *keyName;
@property (nonatomic, strong) NSObject *tag;
- (instancetype)initWith:(NSString *)keyId keyName:(NSString *)keyName tag:(NSObject *)tag;
@end
