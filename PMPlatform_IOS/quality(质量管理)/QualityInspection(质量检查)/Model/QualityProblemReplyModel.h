//
//  QualityProblemReplyModel.h
//  ycxm
//
//  Created by 末末班车 on 2018/9/30.
//  Copyright © 2018年 末末班车. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QualityProblemReplyModel : NSObject

@property (nonatomic, copy) NSString * status;
@property (nonatomic, copy) NSString * content;
@property (nonatomic, copy) NSString * problemId;
@property (nonatomic, copy) NSString * id;
@property (nonatomic, copy) NSString * userId;
@property (nonatomic, copy) NSString * userName;
@property (nonatomic, copy) NSString * orgId;
@property (nonatomic, copy) NSString * orgName;
@property (nonatomic, copy) NSString * createTime;

@property (nonatomic, strong) NSMutableArray <NSString *>*fileIds;
@property (nonatomic, assign) CGFloat rowHeight;

@end
