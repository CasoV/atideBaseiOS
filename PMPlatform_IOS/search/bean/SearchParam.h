//
//  SearchParam.h
//  PMPlatform_IOS
//
//  Created by 末末班车 on 2017/9/6.
//  Copyright © 2017年 com.atide. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SearchModel.h"

@interface SearchParam : NSObject

@property (nonatomic, copy) NSString *startDate;
@property (nonatomic, copy) NSString *endDate;
@property (nonatomic, copy) NSString *proId;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *drafter;
@property (nonatomic, copy) NSString *orderKey;
@property (nonatomic, copy) NSString *orderFormat;
@property (nonatomic, copy) NSString *orderValue;

@property (nonatomic, copy) NSArray <SearchModel *>*models;

@end
