//
//  NewFileScanView.h
//  HBConstructionApp
//
//  Created by 末末班车 on 2018/6/6.
//  Copyright © 2018年 atide. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BIMFile.h"

typedef NS_ENUM(NSInteger, FileScanType) {
    FileScanTypeImage,  //照片
    FileScanTypeAnnex   //附件
};

@interface NewFileScanView : UIView

@property (nonatomic, copy) void (^block)(CGFloat oldHeight, CGFloat newHeight);

@property (nonatomic, copy) void (^choosePhotoBlock)(BOOL choosePhoto);

@property (nonatomic, weak) UIViewController *controller;

@property (nonatomic, copy) NSArray <UnUploadFile *>*unUploadFiles;

@property (nonatomic, strong) NSMutableArray <BIMFile *>*dataSource;

@property (nonatomic, copy) NSString *markId;

@property (nonatomic, assign) BOOL isHandle;

- (instancetype)initWithFrame:(CGRect)frame type:(FileScanType)type;

- (instancetype)initWithFrame:(CGRect)frame type:(FileScanType)type isHandle:(BOOL)isHandle;

- (void)updateData;

- (void)setDefault;

- (NSArray <BIMFile *>*)addFiles;

@end
