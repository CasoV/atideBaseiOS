//
//  BIMPostRequest.h
//  erm
//
//  Created by mac on 2017/10/23.
//  Copyright © 2017年 atide. All rights reserved.
//

#import <YTKNetwork/YTKNetwork.h>
#import "YTKBaseRequest+ApiResult.h"

@interface BIMPostRequest : YTKRequest

@property (nonatomic, strong) NSMutableDictionary *requestParams;

- (id)initWithRequestParams:(id)requestParams;

@property (nonatomic, copy) NSString *requestUrl;
@property (nonatomic, copy) NSString *baseUrl;

@end
