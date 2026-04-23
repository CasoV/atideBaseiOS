//
//  QDOriginalRecordController.h
//  HBConstructionApp
//
//  Created by 末末班车 on 2018/4/12.
//  Copyright © 2018年 atide. All rights reserved.
//

#import "BaseViewController.h"
#import "BIMFile.h"

@interface QDOriginalRecordController : BaseViewController

@property (nonatomic, copy) NSString *formTitle;

@property (nonatomic, copy) NSString *partCode;

@property (nonatomic, copy) NSString *formType;

@property (nonatomic, copy) NSString *bizUrl;

@property (nonatomic, copy) NSString *bizKey;

@property (nonatomic, copy) NSString *status;

@property (nonatomic, copy) NSString *bizPk;

@property (nonatomic, copy) NSString *numId;

@property (nonatomic, copy) NSString *code;

@property (nonatomic, assign) BOOL newFormFlag;

@property (nonatomic, copy) void (^callBack)(void);

- (void)save:(NSArray <BIMFile *>*)files;

- (void)reload;

@end
