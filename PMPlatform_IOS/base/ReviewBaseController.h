//
//  ReviewBaseController.h
//  HBConstructionApp
//
//  Created by 末末班车 on 2018/3/29.
//  Copyright © 2018年 atide. All rights reserved.
//

#import "BaseViewController.h"
#import "DocumentToolView.h"

@interface ReviewBaseController : BaseViewController

@property (nonatomic, strong) DocumentToolView *toolView;

@property (nonatomic, copy) NSString *id;

@property (nonatomic, copy) NSString *numId;

@property (nonatomic, copy) NSString *bizPk;

@property (nonatomic, copy) NSString *bizKey;

@property (nonatomic, copy) NSString *bizUrl;

@property (nonatomic, copy) NSString *partCode;

@property (nonatomic, copy) NSString *status;

@property (nonatomic, assign) FunctionType type;

@property (nonatomic, assign) BOOL isUserXY;

@property (nonatomic, assign) BOOL showSaveBtn;

@property (nonatomic, assign) BOOL showVideoMaterial;

@property (nonatomic, strong) UIViewController *firstVC;

@property (nonatomic, strong) UIViewController *secondVC;

@property (nonatomic, strong) UIViewController *thirdVC;

@property (nonatomic, strong) UIViewController *fourthVC;

@property (nonatomic, assign) BOOL isMatter;

@property (nonatomic, assign) BOOL newFormFlag;

@property (nonatomic, assign) BOOL hiddenTool;

@property (nonatomic, assign) BOOL handleCallBack;

@property (nonatomic, copy) void (^callBack)(void);

- (void)updateUI;

- (void)loadToolBar;

- (void)setupMidView;

- (void)setupHandleView;

- (void)updateAnnexView;

- (void)setTaskId:(NSString *)taskId;

- (void)setupUI;

- (void)setupContentView;

- (void)flowCallBack:(BOOL)isRevoke;

@end
