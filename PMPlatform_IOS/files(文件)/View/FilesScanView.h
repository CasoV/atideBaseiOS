//
//  FilesScanView.h
//  ycxm
//
//  Created by 末末班车 on 2018/10/16.
//  Copyright © 2018年 末末班车. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BIMFile.h"

@interface FilesScanView : UIView

@property (nonatomic, copy) void (^block)(CGFloat oldHeight, CGFloat newHeight);

@property (nonatomic, copy) void (^choosePhotoBlock)(BOOL choosePhoto);

@property (nonatomic, copy) void (^annexPushBlock)(void);

@property (nonatomic, copy) void (^choosedBlock)(void);
@property (nonatomic, copy) void (^deletedBlock)(void);

@property (nonatomic, copy) NSArray <UnUploadFile *>*unUploadFiles;

@property (nonatomic, strong) NSMutableArray <BIMFile *>*dataSource;

@property (nonatomic, copy) NSString *markId;

@property (nonatomic, copy) NSString *fileType;

@property (nonatomic, copy) NSString *partCode;

@property (nonatomic, assign) BOOL isUserXY;

@property (nonatomic, assign) BOOL isHandle;

@property (nonatomic, assign) BOOL hiddenAddBtn;

@property (nonatomic, weak) UIViewController *controller;

- (instancetype)initWithFrame:(CGRect)frame isHandle:(BOOL)isHandle;

- (void)updateData;

- (void)setDefault;

- (NSArray <BIMFile *>*)addFiles;

@end
