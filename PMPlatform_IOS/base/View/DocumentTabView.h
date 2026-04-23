//
//  DocumentTabView.h
//  YXConstructionApp
//
//  Created by 末末班车 on 2018/3/22.
//  Copyright © 2018年 atide. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DocumentTabView : UIView

@property (nonatomic, strong) UIFont *font;

@property (nonatomic, assign, readonly) NSInteger titleCount;

@property (nonatomic, copy) void (^callBack)(NSInteger selectIndex);

@property (nonatomic, assign, readonly) NSInteger currentIndex;

- (instancetype)initWithFrame:(CGRect)frame titles:(NSArray *)titles;

- (void)selectBtn:(NSInteger)index;

@end
