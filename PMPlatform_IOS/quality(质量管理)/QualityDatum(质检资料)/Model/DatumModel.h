//
//  DatumModel.h
//  ycxm
//
//  Created by 高小伟 on 2020/7/9.
//  Copyright © 2020 末末班车. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DatumModel : NSObject

@property (nonatomic, copy) NSString * id;
@property (nonatomic, copy) NSString * type;
@property (nonatomic, copy) NSString * text;
@property (nonatomic, copy) NSString * state;
@property (nonatomic, assign) BOOL  checked;
@property (nonatomic, strong) NSDictionary * attributes;
@property (nonatomic, strong) NSArray <DatumModel*>  *children;
@property (nonatomic, strong) NSDictionary * object;
@property (nonatomic, copy) NSString * leaf;
@property (nonatomic, copy) NSString * sedId;
@property (nonatomic, copy) NSString * parentId;

@property (nonatomic, assign) BOOL isExpanded;

@property (nonatomic, copy) NSString * name;
@property (nonatomic, copy) NSString * url;

@end

NS_ASSUME_NONNULL_END
