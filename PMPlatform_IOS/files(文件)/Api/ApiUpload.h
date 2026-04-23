//
//  ApiUpload.h
//  ycxm
//
//  Created by 末末班车 on 2018/10/16.
//  Copyright © 2018年 末末班车. All rights reserved.
//

#import <YTKNetwork/YTKNetwork.h>
#import "BIMFile.h"

@interface ApiUpload : YTKRequest

- (instancetype)initWithFile:(BIMFile *)file params:(NSDictionary *)params;

@property (nonatomic, copy) NSString *url;

@end
