//
//  MultipleModel.h
//  ycxm
//
//  Created by 末末班车 on 2023/4/6.
//  Copyright © 2023 末末班车. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MultipleModel : NSObject

@property (nonatomic, copy) NSString *orgId;
@property (nonatomic, copy) NSString *orgName;
@property (nonatomic, copy) NSString *userId;
@property (nonatomic, copy) NSString *userName;
@property (nonatomic, assign) BOOL checked;

@end

NS_ASSUME_NONNULL_END
