//
//  TLNavigationController.m
//  ZegoRoomkitDemo
//
//  Created by Larry on 2020/6/19.
//  Copyright © 2020 zego. All rights reserved.
//

#import "TLNavigationController.h"

@interface TLNavigationController ()<UIGestureRecognizerDelegate>

@end

@implementation TLNavigationController

- (instancetype)initWithRootViewController:(UIViewController *)rootViewController {
    self = [super initWithRootViewController:rootViewController];
    if (self) {
        [self configNavigation];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    __weak TLNavigationController *weakSelf = self;
    if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.interactivePopGestureRecognizer.delegate = weakSelf;
    }
}

- (void)configNavigation {
    UINavigationBar *navigationBar = self.navigationBar;
    //设置导航栏背景颜色
//    [navigationBar setBackgroundImage:[UIImage new] forBarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];// 设置navigationBar的颜色为透明的
    
    [navigationBar setShadowImage:[UIImage new]];
    navigationBar.barTintColor = [UIColor whiteColor];
    navigationBar.tintColor = [UIColor colorWithHexString:@"040404"];
    navigationBar.titleTextAttributes = @{NSFontAttributeName : MEDIUM_FONT(17), NSForegroundColorAttributeName : [UIColor colorWithHexString:@"040404"]};
}


#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
  if (self.childViewControllers.count == 1 ||
      self.visibleViewController == [self.viewControllers objectAtIndex:0]) {
      return NO;
  }
  return YES;
}

- (BOOL)shouldAutorotate {
    return YES;
}
//返回直接支持的方向
- (UIInterfaceOrientationMask)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskPortrait;
}

//返回最优先显示的屏幕方向
- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return UIInterfaceOrientationPortrait;
}

@end
