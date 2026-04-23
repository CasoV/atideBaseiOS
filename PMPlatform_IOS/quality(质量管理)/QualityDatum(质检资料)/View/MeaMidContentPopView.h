//
//  MeaMidContentPopView.h
//  ycxm
//
//  Created by 末末班车 on 2019/2/26.
//  Copyright © 2019 末末班车. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MeaMidContentPopView : UIButton

/** 字体，default is nil (system font 17 plain) */
@property (nonatomic, strong) UIFont   *fontName;
/** 按钮边框颜色颜色，default is RGB(205, 205, 205) */
@property (nonatomic, strong) UIColor  *borderButtonColor;
/** 内容的高度，default is (ScreenHeight / 2) */
@property (nonatomic, assign)CGFloat heightContent;

@property (nonatomic, copy) NSArray <NSDictionary *>*list;

@property (nonatomic, copy) NSString *partCode;

@property (nonatomic, copy) NSString *content1;

@property (nonatomic, copy) NSString *content2;

@property (nonatomic, copy) NSString *content3;

@property (nonatomic, copy) void (^callBack)(NSString *content1, NSString *content2, NSString *content3, NSArray <NSDictionary *>*list);

/**
 *  显示
 */
- (void)show;

/**
 *  移除
 */
- (void)remove;

@end

NS_ASSUME_NONNULL_END
