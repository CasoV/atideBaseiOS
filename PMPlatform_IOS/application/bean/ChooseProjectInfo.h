//
//  ChooseProjectInfo.h
//  ycxm
//
//  Created by 末末班车 on 2022/3/9.
//  Copyright © 2022 末末班车. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ProjectInfo.h"

NS_ASSUME_NONNULL_BEGIN

@interface ChooseProjectInfo : NSObject

- (instancetype)initWithTitle:(NSString *)title;

- (instancetype)initWithProjectInfo:(ProjectInfo *)projectInfo;

@property (nonatomic, assign) Boolean selected;
@property (nonatomic, copy) NSString * title;
@property (nonatomic, strong) ProjectInfo * projectInfo;
@property (nonatomic, strong) NSMutableArray <ChooseProjectInfo *>* children;

@end

NS_ASSUME_NONNULL_END
