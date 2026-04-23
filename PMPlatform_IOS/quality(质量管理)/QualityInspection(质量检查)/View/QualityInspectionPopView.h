//
//  QualityInspectionPopView.h
//  ycxm
//
//  Created by 末末班车 on 2018/9/21.
//  Copyright © 2018年 末末班车. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QualityInspectionPopView : UIButton

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

@property (nonatomic, copy) NSString *id;
@property (nonatomic, assign) FunctionType type;
@property (nonatomic, weak) UIViewController *controller;

@property (nonatomic, copy) void (^block)(BOOL reviewSuccess);

@property(nonatomic, copy) NSString *resourceTitle;
/**
 *  显示
 */
- (void)show;

/**
 *  移除
 */
- (void)remove;

@end
