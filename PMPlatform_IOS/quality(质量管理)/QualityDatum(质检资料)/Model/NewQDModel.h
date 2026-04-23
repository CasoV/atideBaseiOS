//
//  NewQDModel.h
//  ycxm
//
//  Created by 末末班车 on 2020/3/16.
//  Copyright © 2020 末末班车. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NewQDObjectModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface NewQDModel : NSObject

@property (nonatomic, assign) BOOL checked;
@property (nonatomic, assign) BOOL selected;
@property (nonatomic, assign) BOOL isExpanded;

//@property (nonatomic, copy) NSString * parentId;
//@property (nonatomic, copy) NSString * id;
//@property (nonatomic, copy) NSString * text;
//@property (nonatomic, copy) NSString * leaf;
//@property (nonatomic, copy) NSString * state;
@property (nonatomic, copy) NSArray <NewQDModel *>* children;
//@property (nonatomic, strong) NewQDObjectModel * object;

@property (nonatomic, copy) NSString * numId;
@property (nonatomic, copy) NSString * name;
@property (nonatomic, copy) NSString * orderNum;
@property (nonatomic, copy) NSString * storageType;
@property (nonatomic, copy) NSString * pid;
@property (nonatomic, copy) NSString * templateCode;
@property (nonatomic, copy) NSString * partType;
@property (nonatomic, copy) NSString * tid;
@property (nonatomic, copy) NSString * excelId;

@property (nonatomic, copy) NSString * id;
@property (nonatomic, copy) NSString * instId;
@property (nonatomic, copy) NSString * pname;
@property (nonatomic, copy) NSString * testStatus;
@property (nonatomic, copy) NSString * processCode;
@property (nonatomic, copy) NewQDObjectModel * object;

@end

NS_ASSUME_NONNULL_END
