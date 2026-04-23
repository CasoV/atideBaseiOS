//
//  FileModel.h
//  PMPlatform_IOS
//
//  Created by 末末班车 on 2022/6/30.
//  Copyright © 2022 com.atide. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FileModel : NSObject

@property (nonatomic, copy) NSString * id;
@property (nonatomic, copy) NSString * filename;
@property (nonatomic, copy) NSString * originalName;
@property (nonatomic, copy) NSString * extName;

- (NSString *)name;

@end

NS_ASSUME_NONNULL_END
