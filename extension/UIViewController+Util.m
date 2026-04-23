//
//  UIViewController+Util.m
//  GDProperty
//
//  Created by 丶柯黑穆肯 on 16/8/11.
//  Copyright © 2016年 Tony. All rights reserved.
//

#import "UIViewController+Util.h"

static const NSInteger zero = 0;
static const NSInteger navBtnHeight = 20;
static NSString *navImageName = @"nav_back";
static NSString *navImageName2 = @"app_img_more";

@implementation UIViewController (Util)

#pragma mark 设置导航栏返回按钮
- (void)setNavigationBarForLeftBtn {
    UIButton *leftButton = [[UIButton alloc] initWithFrame:CGRectMake(zero, zero, navBtnHeight, navBtnHeight)];
    [leftButton setImage:[UIImage imageNamed:navImageName] forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(leftBtnAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    self.navigationItem.backBarButtonItem = backItem;
}

- (void)leftBtnAction {
    [self.navigationController popViewControllerAnimated:YES];
}
//控制器跳转通用方法
- (void)pushToStoryBoardName:(NSString *)StoryBoardName withViewControllerName:(NSString *)viewControllerName{
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:StoryBoardName bundle:[NSBundle mainBundle]];
    UIViewController *vc = [storyBoard instantiateViewControllerWithIdentifier:viewControllerName];
    [self.navigationController pushViewController:vc animated:YES];
}


//控制器跳转通用方法
- (void)modelToStoryBoardName:(NSString *)StoryBoardName withViewControllerName:(NSString *)viewControllerName{
   
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:StoryBoardName bundle:[NSBundle mainBundle]];
    UIViewController *vc = [storyBoard instantiateViewControllerWithIdentifier:viewControllerName];

    [self presentViewController:vc animated:YES completion:^{
        
    }];
    
}

#pragma mark - 设置导航栏右侧按钮
- (void)setNavigationBarForRightBtn {
    UIButton *rightButton = [[UIButton alloc] initWithFrame:CGRectMake(zero, zero, navBtnHeight, navBtnHeight)];
    [rightButton setImage:[UIImage imageNamed:navImageName2] forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(rightBtnAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem = rightItem;
}

- (void)rightBtnAction {
}

@end
