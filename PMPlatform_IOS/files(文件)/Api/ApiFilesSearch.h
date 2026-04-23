//
//  ApiFilesSearch.h
//  ConstructionApp
//
//  Created by mac on 2017/11/14.
//  Copyright © 2017年 atide. All rights reserved.
//

#import <YTKNetwork/YTKNetwork.h>

@interface ApiFilesSearch : YTKRequest

- (id)initWithFormId:(NSString *)formId;

- (instancetype)initWithRequestParams:(id)requestParams;

@end
