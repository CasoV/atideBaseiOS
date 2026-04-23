//
//  HandleModel.h
//  ConstructionApp
//
//  Created by RedLi on 2018/1/22.
//  Copyright © 2018年 atide. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TaskAssignees :NSObject
@property (nonatomic , copy) NSString              * instId;
@property (nonatomic , copy) NSString              * userId;
@property (nonatomic , copy) NSString              * userName;
@property (nonatomic , copy) NSString              * id;
@property (nonatomic , assign) NSInteger              checked;
@property (nonatomic , copy) NSString              * orgId;
@property (nonatomic , copy) NSString              * taskKeys;
@property (nonatomic , copy) NSString              * orgName;
@property (nonatomic , copy) NSString              * taskKey;

@end

@interface UnFinishTaskAssignees :NSObject
@property (nonatomic , copy) NSString              * instId;
@property (nonatomic , copy) NSString              * userId;
@property (nonatomic , copy) NSString              * userName;
@property (nonatomic , copy) NSString              * id;
@property (nonatomic , assign) NSInteger              checked;
@property (nonatomic , copy) NSString              * orgId;
@property (nonatomic , copy) NSString              * taskKeys;
@property (nonatomic , copy) NSString              * orgName;
@property (nonatomic , copy) NSString              * taskKey;

@end

@interface Opinions :NSObject
@property (nonatomic , copy) NSString              * id;
@property (nonatomic , copy) NSString              * activeId;
@property (nonatomic , copy) NSString              * message;
@property (nonatomic , copy) NSString              * time;
@property (nonatomic , copy) NSString              * doRet;
@property (nonatomic , copy) NSString              * ownerId;
@property (nonatomic , copy) NSString              * taskTitle;
@property (nonatomic , copy) NSString              * userId;
@property (nonatomic , copy) NSString              * userName;
@property (nonatomic , copy) NSString              * signature;
@property (nonatomic , copy) NSString              * taskId;
@property (nonatomic , copy) NSString              * signet;
@property (nonatomic , copy) NSString              * groupName;
@property (nonatomic , assign) NSInteger              duration;
@property (nonatomic , copy) NSString              * orgName;
@property (nonatomic , copy) NSString              * groupId;
@property (nonatomic , copy) NSString              * activeName;

@end

@interface HandleModel : NSObject

@property (nonatomic , assign) NSInteger selectScope;
@property (nonatomic , assign) NSInteger status;
@property (nonatomic , copy) NSArray<TaskAssignees *> * taskAssignees;
@property (nonatomic , assign) NSInteger pointy;
@property (nonatomic , assign) NSInteger forwardStatus;
@property (nonatomic , assign) NSInteger parallelMulti;
@property (nonatomic , copy) NSString * procdefId;
@property (nonatomic , copy) NSString * assigneeNames;
@property (nonatomic , assign) NSInteger selectUser;
@property (nonatomic , copy) NSString * name;
@property (nonatomic , copy) NSArray<UnFinishTaskAssignees *> *unFinishTaskAssignees;
@property (nonatomic , copy) NSString * type;
@property (nonatomic , copy) NSString * forwardOpinions;
@property (nonatomic , copy) NSString * id;
@property (nonatomic , assign) NSInteger pointx;
@property (nonatomic , copy) NSString * jsonTaskAssignees;
@property (nonatomic , assign) NSInteger height;
@property (nonatomic , copy) NSArray<Opinions *> * opinions;
@property (nonatomic , assign) NSInteger width;
@property (nonatomic , assign) NSInteger skip;
@property (nonatomic , assign) NSInteger order;
@property (nonatomic , assign) BOOL isExpand;

@end
