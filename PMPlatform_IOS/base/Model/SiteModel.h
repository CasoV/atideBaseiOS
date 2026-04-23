//
//  SiteModel.h
//  ConstructionApp
//
//  Created by 末末班车 on 2017/12/26.
//  Copyright © 2017年 atide. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SiteModel : NSObject

@property (nonatomic, assign) BOOL checked;
@property (nonatomic, copy) NSString * parentId;
@property (nonatomic, copy) NSString * id;
@property (nonatomic, strong) NSArray * children;
@property (nonatomic, copy) NSString * projectTypeCode;
@property (nonatomic, copy) NSString * sedId;
@property (nonatomic, copy) NSString * text;
@property (nonatomic, copy) NSString * type;
@property (nonatomic, copy) NSString * attributes;
@property (nonatomic, copy) NSString * state;
@property (nonatomic, copy) NSString * parentType;
@property (nonatomic, assign) NSInteger doc;
@property (nonatomic, assign) NSInteger docself;
@property (nonatomic, strong) NSDictionary *otherInfo; //{projectType:''}

@end
