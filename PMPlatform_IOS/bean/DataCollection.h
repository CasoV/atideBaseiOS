//
//  DataCollection.h
//  YNXYJTXXPT
//
//  Created by 末末班车 on 2017/6/28.
//  Copyright © 2017年 末末班车. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataCollection : NSObject

@property (copy, nonatomic) NSString *total;
@property (copy, nonatomic) NSString *pageCount;
@property (copy, nonatomic) NSString *endPageIndex;
@property (copy, nonatomic) NSString *numPerPage;
@property (copy, nonatomic) NSString *beginPageIndex;
@property (copy, nonatomic) NSString *currentPage;
@property (copy, nonatomic) NSString *countResultMap;

@property (copy, nonatomic) NSArray *rows;

@end
