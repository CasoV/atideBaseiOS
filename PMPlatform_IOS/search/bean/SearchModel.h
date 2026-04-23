//
//  SearchModel.h
//  PMPlatform_IOS
//
//  Created by 末末班车 on 2017/9/6.
//  Copyright © 2017年 com.atide. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SearchDetail.h"

@interface SearchModel : NSObject

@property (nonatomic, copy) NSString *headerTitle;
@property (nonatomic, copy) NSString *ID;
@property (nonatomic, copy) NSArray <SearchDetail *>*details;

@end
