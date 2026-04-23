//
//  ListTabView.h
//  ycxm
//
//  Created by 末末班车 on 2018/12/11.
//  Copyright © 2018 末末班车. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ListTabView : UIView

@property (nonatomic, strong) UIFont *font;

@property (nonatomic, copy) void (^callBack)(NSInteger selectIndex);

- (instancetype)initWithFrame:(CGRect)frame titles:(NSArray *)titles;

- (void)selectBtn:(NSInteger)index;

- (void)setNum:(NSArray *)nums;

@end

NS_ASSUME_NONNULL_END
