//
//  UIViewController+Util.h
//  GDProperty
//
//  Created by 丶柯黑穆肯 on 16/8/11.
//  Copyright © 2016年 Tony. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (Util)

/**
 * 设置导航栏返回按钮
 */
- (void)setNavigationBarForLeftBtn;

/**
 *  push 到某个页面 传入 SB 名， 要跳转的类名
 */
- (void)pushToStoryBoardName:(NSString *)StoryBoardName withViewControllerName:(NSString *)viewControllerName;

/**
 * model 模态视图到某个页面。 需要传入 SB 名，及要跳转的类名
 **/
- (void)modelToStoryBoardName:(NSString *)StoryBoardName withViewControllerName:(NSString *)viewControllerName;
/**
 * 设置导航栏右侧按钮
 */
- (void)setNavigationBarForRightBtn;

@end
