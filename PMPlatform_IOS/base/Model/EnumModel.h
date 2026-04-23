//
//  EnumModel.h
//  ycxm
//
//  Created by 末末班车 on 2020/3/19.
//  Copyright © 2020 末末班车. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface EnumModel : NSObject

@property (nonatomic, assign) NSInteger sortNo;
@property (nonatomic, copy) NSString * parentId;
@property (nonatomic, copy) NSString * id;
@property (nonatomic, copy) NSString * childNum;
@property (nonatomic, copy) NSString * code;
@property (nonatomic, copy) NSString * extProperty;
@property (nonatomic, copy) NSString * page;
@property (nonatomic, copy) NSString * name;
@property (nonatomic, copy) NSString * key;

@end

NS_ASSUME_NONNULL_END
