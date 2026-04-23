//
//  ApprovalCommentModel.h
//  PMPlatform_IOS
//
//  Created by 末末班车 on 2017/9/11.
//  Copyright © 2017年 com.atide. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ApprovalCommentModel : NSObject

@property (nonatomic, copy) NSString *taskId;
@property (nonatomic, copy) NSString *ownerId;
@property (nonatomic, copy) NSString *orgName;
@property (nonatomic, copy) NSString *doRet;
@property (nonatomic, copy) NSString *ID;
@property (nonatomic, copy) NSString *message;
@property (nonatomic, copy) NSString *time;
@property (nonatomic, copy) NSString *duration;
@property (nonatomic, copy) NSString *activeId;
@property (nonatomic, copy) NSString *signet;
@property (nonatomic, copy) NSString *userId;
@property (nonatomic, copy) NSString *activeName;
@property (nonatomic, copy) NSString *userName;

@property (nonatomic, strong) NSArray <NSDictionary *>*opinions;

@property (nonatomic, assign) BOOL isNotRoot;

@property (nonatomic, assign) BOOL selected;

@property (nonatomic, assign) CGFloat rowHeight;

@end
