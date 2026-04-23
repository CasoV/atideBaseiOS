//
//  YTKBaseRequest+ApiResult.h
//  Community
//
//  Created by Arthur Wang on 15/2/11.
//  Copyright (c) 2015年 speed. All rights reserved.
//

#import "YTKBaseRequest.h"

@interface YTKBaseRequest (ApiResult)


- (BOOL)resultIsSuccess;

- (NSString *)resultMsg;

- (id)responseJSON;

- (NSString *)responsePrintJsonString;

- (NSDictionary *)resultData;

- (NSArray *)resultDataArray;

- (NSArray *)resultRows;




@end
