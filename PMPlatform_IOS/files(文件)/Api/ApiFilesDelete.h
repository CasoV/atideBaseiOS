//
//  ApiFilesDelete.h
//  ConstructionApp
//
//  Created by mac on 2017/11/14.
//  Copyright © 2017年 atide. All rights reserved.
//

#import <YTKNetwork/YTKNetwork.h>

@interface ApiFilesDelete : YTKRequest

- (id)initWithFileId:(NSString *)fileId;

@end
