//
//  ApprovalPopView.h
//  HBConstructionApp
//
//  Created by 末末班车 on 2018/4/14.
//  Copyright © 2018年 atide. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WaitCheckBean.h"

@interface ApprovalPopView : UIButton

/** 1.标题，default is nil */
@property(nullable, nonatomic,copy) NSString          *title;
/** 2.字体，default is nil (system font 17 plain) */
@property(null_resettable, nonatomic,strong) UIFont   *fontName;
/** 3.字体颜色，default is nil (text draws black) */
@property(null_resettable, nonatomic,strong) UIColor  *titleColor;
/** 4.按钮边框颜色颜色，default is RGB(205, 205, 205) */
@property(null_resettable, nonatomic,strong) UIColor  *borderButtonColor;
/** 5.内容的高度，default is 240 */
@property (nonatomic, assign)CGFloat heightContent;


@property (nonatomic, copy) NSArray <WaitCheckBean *>*beans;

@property (nonatomic, copy) NSString *bizPk;
@property (nonatomic, copy) NSString *numIdAndPartCode;

@property (nonatomic, copy) void (^block)(void);

/**
 *  显示
 */
- (void)show;

/**
 *  移除
 */
- (void)remove;

@end
