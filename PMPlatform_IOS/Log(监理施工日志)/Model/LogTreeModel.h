//
//  LogTreeModel.h
//  ycxm
//
//  Created by 高小伟 on 2021/7/5.
//  Copyright © 2021 末末班车. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LogTreeModel : NSObject

@property (nonatomic, copy) NSString *code;
@property (nonatomic, copy) NSString *id;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *pid;
@property (nonatomic, copy) NSString *projectId;
@property (nonatomic, copy) NSString *sectionId;
@property (nonatomic, assign) int sn;
@property (nonatomic, strong) NSArray <LogTreeModel *>*children;
@property (nonatomic, assign) BOOL isExpanded;
@property (nonatomic, assign) BOOL loaded;

@end

NS_ASSUME_NONNULL_END
